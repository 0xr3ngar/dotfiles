import {
  chmodSync,
  copyFileSync,
  cpSync,
  existsSync,
  lstatSync,
  mkdirSync,
  mkdtempSync,
  renameSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from "node:fs";
import { homedir, tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { run } from "../process";

const integration = import.meta.dir;
const repository = resolve(integration, "../..");
const revisions = {
  ambxst: "b862ffaa80a1a555a9943291b0f836db9d09166b",
  axctl: "dff27eccd45b41eda6aeedc196cb9a43dd53b930",
};

function checkDependencies(): void {
  for (const command of ["git", "go", "qs"]) {
    if (!Bun.which(command)) {
      throw new Error(`Missing dependency: ${command}`);
    }
  }
}

async function checkout(
  url: string,
  revision: string,
  destination: string,
): Promise<void> {
  await run(["git", "init", "-q", destination]);
  await run(["git", "-C", destination, "remote", "add", "origin", url]);
  await run([
    "git",
    "-C",
    destination,
    "fetch",
    "--depth=1",
    "origin",
    revision,
  ]);
  await run([
    "git",
    "-C",
    destination,
    "checkout",
    "-q",
    "--detach",
    "FETCH_HEAD",
  ]);
}

async function build(directory: string): Promise<void> {
  const shell = join(directory, "ambxst");
  const axctl = join(directory, "axctl");

  await checkout(
    "https://github.com/Axenide/Ambxst.git",
    revisions.ambxst,
    shell,
  );
  await checkout(
    "https://github.com/Axenide/axctl.git",
    revisions.axctl,
    axctl,
  );
  await run([
    "git",
    "-C",
    shell,
    "apply",
    join(integration, "niri-shell.patch"),
  ]);
  await run([
    "git",
    "-C",
    axctl,
    "apply",
    join(integration, "niri-axctl.patch"),
  ]);
  await run(["go", "test", "./pkg/ipc/niri"], { cwd: axctl });
  await run(["go", "build", "-o", join(directory, "axctl-bin"), "."], {
    cwd: axctl,
  });
  await run(
    ["go", "build", "-o", join(directory, "ambxst-bin"), "./cmd/ambxst"],
    {
      cwd: join(shell, "backend"),
    },
  );
}

function archiveExisting(path: string, destination: string): void {
  if (!lstatSync(path, { throwIfNoEntry: false })) {
    return;
  }

  renameSync(path, destination);
}

function installBinary(source: string, destination: string): void {
  const temporary = `${destination}.new`;
  copyFileSync(source, temporary);
  chmodSync(temporary, 0o755);
  renameSync(temporary, destination);
}

function seedColors(home: string): void {
  const cache = join(home, ".cache/ambxst");
  const colors = join(cache, "colors.json");
  mkdirSync(cache, { recursive: true });

  if (existsSync(colors)) {
    return;
  }

  copyFileSync(
    join(repository, "config/ambxst/colors/Caesar/dark.json"),
    colors,
  );
}

function seedWallpaper(home: string): void {
  const path = join(home, ".cache/ambxst/wallpapers.json");

  if (existsSync(path)) {
    return;
  }

  const settings = {
    currentWall: join(home, "pictures/Wallpapers/wall.jpg"),
    wallPath: join(home, "pictures/Wallpapers"),
    activeColorPreset: "Caesar",
    tintEnabled: true,
  };

  writeFileSync(path, JSON.stringify(settings, null, 2) + "\n");
}

async function installBuild(directory: string): Promise<void> {
  const home = homedir();
  const bin = join(home, ".local/bin");
  const share = join(home, ".local/share");
  const source = join(home, ".local/src");
  const backups = join(home, ".local/state/dotfiles/backups");

  for (const path of [bin, share, source, backups]) {
    mkdirSync(path, { recursive: true });
  }

  const prepared = mkdtempSync(join(share, ".ambxst-install-"));

  try {
    cpSync(join(directory, "ambxst"), join(prepared, "source"), {
      recursive: true,
    });

    if (existsSync(join(bin, "ambxst"))) {
      await run([join(bin, "ambxst"), "quit"], { allowFailure: true });
    }

    const backup = mkdtempSync(join(backups, "ambxst-"));
    archiveExisting(join(share, "ambxst"), join(backup, "share"));
    archiveExisting(join(source, "ambxst"), join(backup, "src"));
    renameSync(join(prepared, "source"), join(share, "ambxst"));
    symlinkSync(join(share, "ambxst"), join(source, "ambxst"));
    installBinary(join(directory, "axctl-bin"), join(bin, "axctl"));
    installBinary(join(directory, "ambxst-bin"), join(bin, "ambxst"));
    console.log(`Previous installation: ${backup}`);
  } finally {
    rmSync(prepared, { recursive: true, force: true });
  }

  seedColors(home);
  seedWallpaper(home);
}

async function main(): Promise<void> {
  checkDependencies();
  const directory = mkdtempSync(join(tmpdir(), "ambxst-build-"));

  try {
    await build(directory);
    await installBuild(directory);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }

  console.log("Ambxst installed. Start with: ~/.local/bin/ambxst");
}

await main();
