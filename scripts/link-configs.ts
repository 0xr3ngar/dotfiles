import {
  existsSync,
  lstatSync,
  mkdirSync,
  mkdtempSync,
  realpathSync,
  renameSync,
  symlinkSync,
} from "node:fs";
import { homedir } from "node:os";
import { dirname, join, resolve } from "node:path";

export type Profile = "arch" | "editors";
export type Link = [source: string, destination: string];

interface PlannedLink {
  source: string;
  destination: string;
  relativeDestination: string;
}

interface InstallOptions {
  root?: string;
  home?: string;
  profile?: Profile;
  platform?: NodeJS.Platform;
  dryRun?: boolean;
  log?: (message: string) => void;
}

export const repository = resolve(import.meta.dir, "..");

const archApps = [
  "alacritty",
  "ambxst",
  "gtk-3.0",
  "gtk-4.0",
  "lazygit",
  "niri",
  "nvim",
  "swaylock",
  "theme",
  "tmux",
];

function editorLinks(platform: NodeJS.Platform): Link[] {
  const cursorDirectory =
    platform === "darwin"
      ? "Library/Application Support/Cursor/User"
      : ".config/Cursor/User";

  return [
    ["config/zed", ".config/zed"],
    ["config/opencode", ".config/opencode"],
    ["config/cursor/settings.json", `${cursorDirectory}/settings.json`],
    ["config/cursor/keybindings.json", `${cursorDirectory}/keybindings.json`],
  ];
}

export function linksFor(
  profile: Profile,
  platform = process.platform,
): Link[] {
  if (profile === "editors") {
    return editorLinks(platform);
  }

  const appLinks = archApps.map((name): Link => [
    `config/${name}`,
    `.config/${name}`,
  ]);

  return [
    ...appLinks,
    ["config/git/config", ".gitconfig"],
    ["config/zsh/zshrc", ".zshrc"],
    ["config/tmux/tmux.conf", ".tmux.conf"],
    [
      "config/autostart/nm-applet.desktop",
      ".config/autostart/nm-applet.desktop",
    ],
    ["config/btop/themes/caesar.theme", ".config/btop/themes/caesar.theme"],
    ["assets/fonts/phosphor", ".local/share/fonts/phosphor"],
    ["assets/wallpapers/caesar.jpg", "pictures/Wallpapers/wall.jpg"],
    // Niri starts before interactive shell PATH configuration is loaded.
    [process.execPath, ".local/bin/bun"],
  ];
}

function pathExists(path: string): boolean {
  return lstatSync(path, { throwIfNoEntry: false }) !== undefined;
}

function isLinked({ source, destination }: PlannedLink): boolean {
  const stat = lstatSync(destination, { throwIfNoEntry: false });

  if (!stat?.isSymbolicLink() || !existsSync(destination)) {
    return false;
  }

  return realpathSync(destination) === realpathSync(source);
}

function planLinks(options: InstallOptions): PlannedLink[] {
  const root = resolve(options.root ?? repository);
  const home = resolve(options.home ?? homedir());
  const links = linksFor(options.profile ?? "arch", options.platform);

  return links.map(([source, relativeDestination]) => {
    const sourcePath = resolve(root, source);

    if (!existsSync(sourcePath)) {
      throw new Error(`Missing source: ${sourcePath}`);
    }

    return {
      source: sourcePath,
      destination: join(home, relativeDestination),
      relativeDestination,
    };
  });
}

function createBackup(home: string): string {
  const parent = join(home, ".local/state/dotfiles/backups");
  const timestamp = new Date().toISOString().replaceAll(":", "-");

  mkdirSync(parent, { recursive: true });
  return mkdtempSync(join(parent, `links-${timestamp}-`));
}

function saveExisting(link: PlannedLink, backup: string | undefined): void {
  if (!pathExists(link.destination)) {
    return;
  }

  if (!backup) {
    throw new Error(`Backup required for ${link.destination}`);
  }

  const saved = join(backup, link.relativeDestination);
  mkdirSync(dirname(saved), { recursive: true });
  renameSync(link.destination, saved);
}

export function installLinks(options: InstallOptions = {}): string | undefined {
  // Resolve and validate the complete plan before changing any destination.
  const pending = planLinks(options).filter((link) => !isLinked(link));
  const log = options.log ?? console.log;

  if (options.dryRun) {
    for (const link of pending) {
      log(`Would link ${link.destination} -> ${link.source}`);
    }
    return;
  }

  const needsBackup = pending.some((link) => pathExists(link.destination));
  const backup = needsBackup
    ? createBackup(options.home ?? homedir())
    : undefined;

  for (const link of pending) {
    saveExisting(link, backup);
    mkdirSync(dirname(link.destination), { recursive: true });
    symlinkSync(link.source, link.destination);
    log(`Linked ${link.destination} -> ${link.source}`);
  }

  log(`${pending.length} link(s) updated`);
  if (backup) {
    log(`Previous files: ${backup}`);
  }

  return backup;
}
