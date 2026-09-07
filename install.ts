import { existsSync, mkdirSync, readFileSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { parseArgs } from "node:util";
import { installLinks, repository } from "./scripts/link-configs";
import { run } from "./scripts/process";

interface Options {
  full: boolean;
  editors: boolean;
  dryRun: boolean;
  help: boolean;
}

function readOptions(): Options {
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      full: { type: "boolean", default: false },
      editors: { type: "boolean", default: false },
      "dry-run": { type: "boolean", default: false },
      help: { type: "boolean", short: "h", default: false },
    },
  });

  return {
    full: values.full,
    editors: values.editors,
    dryRun: values["dry-run"],
    help: values.help,
  };
}

function showHelp(): void {
  console.log(`Usage: bun install.ts [--full | --editors] [--dry-run]

Default: link Arch/Niri configs, fonts and wallpaper.
--full: also install Arch packages and build the pinned Ambxst integration.
--editors: link Zed, Cursor and OpenCode only (macOS or Linux).
--dry-run: show planned links without changing files.

Existing files are backed up under ~/.local/state/dotfiles/backups/.`);
}

function validateOptions(options: Options): void {
  if (options.full && (options.editors || options.dryRun)) {
    throw new Error("--full cannot be combined with --editors or --dry-run");
  }

  if (!options.editors && process.platform !== "linux") {
    throw new Error("Use --editors for the macOS editor configuration");
  }
}

async function installPackages(): Promise<void> {
  if (!existsSync("/etc/arch-release")) {
    throw new Error("--full requires Arch Linux");
  }

  if (process.getuid?.() === 0) {
    throw new Error("Run as your desktop user; sudo is used for packages");
  }

  const content = readFileSync(
    join(repository, "scripts/packages.txt"),
    "utf8",
  );
  const packages = content
    .split("\n")
    .map((line) => line.trim())
    .filter((line) => line.length > 0 && !line.startsWith("#"));

  await run(["sudo", "pacman", "-Syu", "--needed", ...packages]);
}

async function finishDesktopSetup(): Promise<void> {
  const home = homedir();
  const btopConfig = join(home, ".config/btop/btop.conf");

  mkdirSync(join(home, "pictures/Screenshots"), { recursive: true });

  if (!existsSync(btopConfig)) {
    writeFileSync(btopConfig, 'color_theme = "caesar"\n');
  }

  if (Bun.which("fc-cache")) {
    await run(["fc-cache", "-f", join(home, ".local/share/fonts/phosphor")]);
  }

  await run([process.execPath, join(repository, "config/theme/apply.ts")]);
}

async function main(): Promise<void> {
  const options = readOptions();

  if (options.help) {
    showHelp();
    return;
  }

  validateOptions(options);

  if (options.full) {
    await installPackages();
  }

  installLinks({
    profile: options.editors ? "editors" : "arch",
    dryRun: options.dryRun,
  });

  if (options.dryRun || options.editors) {
    return;
  }

  await finishDesktopSetup();

  if (options.full) {
    await run([
      process.execPath,
      join(repository, "scripts/ambxst/install.ts"),
    ]);
  }

  console.log(`Configured. Desktop guide: ${repository}/docs/desktop.md`);
}

await main();
