# dotfiles

Cross-platform configs for **macOS** (yabai / Ember) and **Arch Linux** (niri / God-King).

```
macos/     Apple Silicon desktop (yabai, sketchybar, borders, Ember theme)
arch/      Arch + niri Wayland (God-King theme, archinstall)
common/    Shared editors & tooling (nvim, cursor, zed, neofetch, tmux, git)
```

Removed from the old flat layout: **i3**, **i3status**, **picom**.

## Quick start

### Arch

```bash
git clone https://github.com/0xr3ngar/dotfiles.git ~/dotfiles
bash ~/dotfiles/arch/setup.sh
```

Fresh install via archinstall: see [`arch/archinstall/README.md`](arch/archinstall/README.md).

Smoke-test the installer in Docker:

```bash
bash ~/dotfiles/arch/test-in-docker.sh
```

### macOS

```bash
git clone https://github.com/0xr3ngar/dotfiles.git ~/dotfiles
bash ~/dotfiles/macos/setup.sh
```

## Layout notes

| Path | What |
|------|------|
| `common/home` | `.gitconfig`, `.tmux.conf` |
| `common/config` | nvim, cursor, zed, neofetch, scripts, shared opencode |
| `macos/home` | Ember `.zshrc` |
| `macos/config` | alacritty, yabai, sketchybar, borders, lazygit |
| `arch/home` | God-King `.zshrc` |
| `arch/config` | niri, fuzzel, sway*, gtk, theme, alacritty, lazygit, opencode |
| `arch/archinstall` | Guided install JSON + bootstrap |

Arch `opencode` includes the shared themes plus a God-King `opencode.jsonc`.
