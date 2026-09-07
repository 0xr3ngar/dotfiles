# Caesar desktop

Ambxst supplies the bar, notch, launcher, dashboard and notifications on Niri.
The palette uses smoky plum surfaces, parchment text and yellow accents.

## Controls

| Shortcut | Action |
| --- | --- |
| Super+Space | Launcher |
| Super+N | Dashboard and notification history |
| Super+Shift+A | Assistant sidebar |
| Super+E | Files |
| Super+Shift+C | Settings |
| Super+Tab | Overview |
| Super+Ctrl+V | Clipboard |
| Super+Alt+Period | Emoji |
| Super+Alt+N | Notes |
| Super+T | tmux |
| Super+Alt+Comma | Wallpapers |
| Super+Shift+Escape | Power menu |
| Super+S | Tools |
| Super+Shift+S | Region screenshot |
| Super+Alt+R | Recording panel |
| Super+Alt+L / Super+Ctrl+Q | Lock screen |
| Super+Ctrl+Alt+A | Lens |
| Super+Ctrl+Alt+B | Quit Ambxst |

Ambxst's **Binds → Ambxst** tab updates the core shell shortcuts. A Bun process
validates and writes the included `config/niri/ambxst-binds.kdl`. Invalid or
conflicting shortcuts leave the previous bindings active. Custom window actions
remain in `config/niri/config.kdl`.

## Saved settings

`config/ambxst/config/` contains the live settings. The saved **Caesar** layout
is in `config/ambxst/presets/Caesar/` and includes the 16 px screen frame,
bottom bar and notch, disabled dock, 620 ms animations, and your theme,
overview, lockscreen and performance preferences.

Restore that layout, the smoky palette and wallpaper tint:

```bash
bun scripts/ambxst/restore-caesar.ts
```

The restore keeps AI settings and keyboard shortcuts. Its layout snapshot is
separate from the live settings, so experimenting in Settings does not overwrite
your restore point. Both palette variants under `colors/Caesar/` are dark.

## Maintenance

Niri starts Ambxst, the Bun shortcut bridge and the GTK theme settings.
Alacritty, Zsh and Neovim retain their own configuration. GTK apps pick up CSS
changes when reopened.

If a notch or launcher layout gets stuck after changing settings, apply any
pending settings, then restart the shell:

```bash
~/.local/bin/ambxst quit
~/.local/bin/ambxst
```

The integration is pinned to tested upstream revisions. Its source patches are
under `scripts/ambxst/`; the review checkouts remain in `~/projects/Ambxst` and
`~/projects/axctl`. After changing a patch, rebuild with:

```bash
bun scripts/ambxst/install.ts
```

Builds finish before the old shell is stopped. Previous source installs are
saved under `~/.local/state/dotfiles/backups/`. The active source is exposed at
`~/.local/share/ambxst` and `~/.local/src/ambxst`; binaries are in `~/.local/bin`.

The patches support Niri focus/workspaces, replace the Hyprland layout selector
with a Files button, fix dark-field text contrast and keep Ambxst from rewriting
application themes. Some upstream compositor settings still target Hyprland;
use Niri's KDL for window behavior. The GPU path in Niri's `debug` section is
specific to this machine.

## What belongs outside this repo

Accounts, AI credentials, generated caches, screenshots, session history,
display-manager setup and graphics drivers are machine state. The installer
backs up replaced config files, but does not uninstall packages or change
system services. Zed, Cursor and OpenCode are retained as the macOS editor profile.
