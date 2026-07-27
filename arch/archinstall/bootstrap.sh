#!/usr/bin/env bash
# Runs inside the installed system (archinstall custom_commands / arch-chroot).
# Usage: bash arch/archinstall/bootstrap.sh [dotfiles_repo_root]
set -euo pipefail

SRC="${1:-}"
log()  { printf '\n\033[1;35m==>\033[0m %s\n' "$*"; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }
die()  { printf '  \033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

[[ "$(id -u)" -eq 0 ]] || die "bootstrap.sh must run as root (archinstall chroot)"

USERNAME="$(getent passwd | awk -F: '$3>=1000 && $1!="nobody"{print $1; exit}')"
[[ -n "$USERNAME" ]] || die "no regular user found"
HOME_DIR="$(getent passwd "$USERNAME" | cut -d: -f6)"
[[ -d "$HOME_DIR" ]] || die "missing home: $HOME_DIR"
ok "user $USERNAME ($HOME_DIR)"

log "LightDM → niri session"
if [[ -f /etc/lightdm/lightdm.conf ]]; then
  sed -i 's/^#\?user-session=.*/user-session=niri/' /etc/lightdm/lightdm.conf
  grep -q '^user-session=niri' /etc/lightdm/lightdm.conf \
    || printf '\n[Seat:*]\nuser-session=niri\n' >> /etc/lightdm/lightdm.conf
fi

usermod -s /bin/zsh "$USERNAME" || true
usermod -aG docker "$USERNAME" 2>/dev/null || true

DEST="$HOME_DIR/dotfiles"
if [[ -n "$SRC" && -d "$SRC" ]]; then
  log "Installing dotfiles from $SRC"
  rm -rf "$DEST"
  cp -a "$SRC" "$DEST"
elif [[ -d "$DEST/.git" || -f "$DEST/arch/setup.sh" ]]; then
  ok "dotfiles already at $DEST"
else
  die "No dotfiles source. Pass repo checkout path: bootstrap.sh /path/to/dotfiles"
fi

chown -R "$USERNAME:$USERNAME" "$DEST"
chmod +x "$DEST/arch/setup.sh" "$DEST"/arch/.config/niri/*.sh 2>/dev/null || true

log "Running arch/setup.sh for $USERNAME"
export HOME="$HOME_DIR"
export USER="$USERNAME"
export LOGNAME="$USERNAME"
bash "$DEST/arch/setup.sh"

chown -R "$USERNAME:$USERNAME" "$HOME_DIR"
ok "bootstrap complete — reboot into LightDM / Niri"
