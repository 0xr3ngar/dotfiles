# dotfiles

My Arch desktop runs **Niri**, with the Caesar theme. Zed, Cursor and
OpenCode configs are also kept here for macOS.

```text
config/     App configs, grouped by application
assets/     Caesar wallpaper and Phosphor icons
scripts/    Linking, package list and checks
docs/       Desktop controls and recovery
tests/      Installer and shortcut regression checks
install.ts  Bun setup entry point
```

## Arch / Niri

With Bun installed, link configs, fonts and wallpaper into your home:

```bash
bun install.ts --dry-run
bun install.ts
```

Existing files are backed up under `~/.local/state/dotfiles/backups/`. Re-running
the installer leaves correct links alone. Window bindings are in `config/niri/`.

On an existing Arch installation, install the listed packages as well:

```bash
bun install.ts --full
```

Run this as your normal desktop user. It uses `sudo` for pacman. Graphics drivers,
the login manager and system services belong to the machine's Arch setup;
the installer does not repartition disks or choose them for you. The package
list lives in [`scripts/packages.txt`](scripts/packages.txt).

## macOS editors

```bash
bun install.ts --editors --dry-run
bun install.ts --editors
```

This links Zed and OpenCode under `~/.config/`, and Cursor settings/keybindings
under `~/Library/Application Support/Cursor/User/`. Install the applications
separately. The same command works on Linux using Cursor's Linux config path.
Editor accounts, tokens, extensions and session data remain outside the repo.

## Daily use

Window shortcuts live in `config/niri/config.kdl`.

[Desktop notes](docs/desktop.md)

Configs are linked, so edits here apply to the installed files. Put private shell settings in `~/.zshrc.local`.

## Check changes

```bash
bun install
bun run check
```

Checks use temporary directories and do not reload the desktop or install packages.
