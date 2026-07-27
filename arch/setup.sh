#!/usr/bin/env bash
# Bootstrap this machine to match the God-King / niri Arch setup.
# Usage (from a fresh Arch install):
#   git clone https://github.com/0xr3ngar/dotfiles.git ~/dotfiles
#   bash ~/dotfiles/arch/setup.sh
#
# Env flags:
#   WITH_NVIDIA=1     force NVIDIA packages
#   SKIP_SERVICES=1   skip systemctl / docker group (auto in containers)
#   SMOKE_TEST=1      smaller package set for Docker/CI smoke tests
set -euo pipefail

ARCH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$ARCH/.." && pwd)"
COMMON="$ROOT/common"
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

log()  { printf '\n\033[1;35m==>\033[0m %s\n' "$*"; }
ok()   { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[1;33m!\033[0m %s\n' "$*"; }
die()  { printf '  \033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

in_container() {
  [[ -f /.dockerenv ]] && return 0
  grep -zqaE 'docker|containerd|podman|lxc' /proc/1/cgroup 2>/dev/null && return 0
  return 1
}

# Run as root when needed; use sudo if available and not root.
run_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    die "Need root (or sudo) to run: $*"
  fi
}

# -----------------------------------------------------------------------------
# Preflight
# -----------------------------------------------------------------------------

log "Preflight"
need_cmd pacman
[[ -f /etc/arch-release ]] || warn "This script targets Arch Linux; continuing anyway…"

if in_container; then
  warn "Container detected — services will be skipped"
  SKIP_SERVICES="${SKIP_SERVICES:-1}"
fi

ok "dotfiles at $ROOT (arch=$ARCH)"

# -----------------------------------------------------------------------------
# Packages
# -----------------------------------------------------------------------------

PACKAGES=(
  base-devel
  git
  zsh
  zoxide
  unzip
  wget
  wl-clipboard
  curl

  niri
  xorg-xwayland
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-gnome
  xdg-user-dirs
  lightdm
  lightdm-gtk-greeter
  seatd

  alacritty
  fuzzel
  swaylock
  swaybg
  swaync
  firefox
  neovim
  nautilus
  grim
  slurp
  networkmanager
  network-manager-applet

  pipewire
  pipewire-pulse
  pipewire-alsa
  pipewire-jack
  wireplumber

  ttf-jetbrains-mono-nerd
  otf-font-awesome
  papirus-icon-theme

  github-cli
  lazygit
  docker
  docker-compose
  nodejs
  npm

  ethtool
  zram-generator
)

# Lean set for container/CI validation of the installer itself.
SMOKE_PACKAGES=(
  base-devel
  git
  zsh
  zoxide
  curl
  unzip
  wget
  neovim
  github-cli
  lazygit
  nodejs
  npm
  ttf-jetbrains-mono-nerd
  otf-font-awesome
  papirus-icon-theme
  # Keep a couple desktop bits so config links are meaningful
  alacritty
  fuzzel
  swaylock
  swaybg
  swaync
)

NVIDIA_PACKAGES=(
  nvidia-open
  libva-nvidia-driver
  nvidia-container-toolkit
  nvtop
)

install_packages() {
  log "Installing packages"

  local pkgs=("${PACKAGES[@]}")
  if [[ "${SMOKE_TEST:-}" == "1" ]]; then
    warn "SMOKE_TEST=1 — installing reduced package set"
    pkgs=("${SMOKE_PACKAGES[@]}")
  fi

  run_root pacman -Syu --needed --noconfirm "${pkgs[@]}"
  ok "packages installed"

  if [[ "${SMOKE_TEST:-}" == "1" ]]; then
    warn "Skipping NVIDIA / microcode in smoke test"
    return
  fi

  if [[ "${WITH_NVIDIA:-}" == "1" ]] || lspci 2>/dev/null | grep -qi 'nvidia'; then
    log "NVIDIA hardware detected (or WITH_NVIDIA=1) — installing NVIDIA packages"
    run_root pacman -S --needed --noconfirm "${NVIDIA_PACKAGES[@]}" || warn "NVIDIA package install had issues"
  else
    warn "No NVIDIA GPU detected — skipping nvidia packages (set WITH_NVIDIA=1 to force)"
  fi

  if grep -qi authenticamd /proc/cpuinfo 2>/dev/null; then
    run_root pacman -S --needed --noconfirm amd-ucode || true
  elif grep -qi genuineintel /proc/cpuinfo 2>/dev/null; then
    run_root pacman -S --needed --noconfirm intel-ucode || true
  fi
}

# -----------------------------------------------------------------------------
# Link helpers
# -----------------------------------------------------------------------------

backup_then_link() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local current target
    current="$(readlink -f "$dest" 2>/dev/null || true)"
    target="$(readlink -f "$src")"
    if [[ "$current" == "$target" ]]; then
      ok "already linked $dest"
      return
    fi
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    warn "backed up $dest → $BACKUP_DIR/"
  fi

  ln -s "$src" "$dest"
  ok "linked $dest → $src"
}

link_configs() {
  log "Linking configs"

  # Shared home files
  backup_then_link "$COMMON/home/.gitconfig" "$HOME/.gitconfig"
  backup_then_link "$COMMON/home/.tmux.conf" "$HOME/.tmux.conf"

  # Arch home
  backup_then_link "$ARCH/home/.zshrc" "$HOME/.zshrc"

  # Shared ~/.config (editors, etc.)
  local dir
  for dir in nvim cursor zed neofetch scripts; do
    [[ -d "$COMMON/config/$dir" ]] || continue
    backup_then_link "$COMMON/config/$dir" "$HOME/.config/$dir"
  done

  # Arch desktop + God-King theme configs
  for dir in alacritty fuzzel niri swaylock swaync theme lazygit gtk-3.0 gtk-4.0 opencode; do
    [[ -d "$ARCH/config/$dir" ]] || continue
    backup_then_link "$ARCH/config/$dir" "$HOME/.config/$dir"
  done

  mkdir -p "$HOME/.local/share/applications"
  local f
  for f in "$ARCH"/applications/*.desktop; do
    [[ -f "$f" ]] || continue
    backup_then_link "$f" "$HOME/.local/share/applications/$(basename "$f")"
  done

  if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
  fi
}

# -----------------------------------------------------------------------------
# Wallpaper + dirs
# -----------------------------------------------------------------------------

setup_dirs_and_wallpaper() {
  log "User dirs + wallpaper"
  mkdir -p \
    "$HOME/Pictures/Wallpapers" \
    "$HOME/Pictures/Screenshots" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/applications"

  if [[ -f "$ARCH/wallpapers/foggy-city.png" ]]; then
    cp -f "$ARCH/wallpapers/foggy-city.png" "$HOME/Pictures/Wallpapers/foggy-city.png"
    ok "wallpaper installed"
  else
    warn "wallpaper missing from repo"
  fi

  chmod +x "$ARCH"/config/niri/*.sh 2>/dev/null || true
}

# -----------------------------------------------------------------------------
# Shell
# -----------------------------------------------------------------------------

setup_shell() {
  log "Default shell → zsh"
  local zsh_path
  zsh_path="$(command -v zsh)"

  if [[ "$(id -u)" -eq 0 ]]; then
    warn "Running as root — skipping chsh (set shell on your user account instead)"
    return
  fi

  if [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$zsh_path" ]]; then
    ok "login shell already zsh"
  else
    run_root chsh -s "$zsh_path" "$USER"
    ok "login shell set to $zsh_path (re-login to apply)"
  fi
}

# -----------------------------------------------------------------------------
# Services
# -----------------------------------------------------------------------------

setup_lightdm_niri() {
  local conf=/etc/lightdm/lightdm.conf
  [[ -f "$conf" ]] || return 0

  log "LightDM default session → niri"
  run_root sed -i 's/^#\?user-session=.*/user-session=niri/' "$conf"
  if ! grep -q '^user-session=niri' "$conf"; then
    printf '\n[Seat:*]\nuser-session=niri\n' | run_root tee -a "$conf" >/dev/null
  fi
  ok "user-session=niri"
}

setup_services() {
  if [[ "${SKIP_SERVICES:-}" == "1" ]]; then
    warn "SKIP_SERVICES=1 — not enabling systemctl units"
    return
  fi

  setup_lightdm_niri

  log "Enabling services"
  run_root systemctl enable --now NetworkManager.service 2>/dev/null || warn "NetworkManager enable failed"
  run_root systemctl enable --now docker.service 2>/dev/null || warn "docker enable failed"
  run_root systemctl enable seatd.service 2>/dev/null || true
  run_root systemctl enable lightdm.service 2>/dev/null || warn "lightdm enable failed (ok if using another greeter)"

  if getent group docker >/dev/null 2>&1; then
    run_root usermod -aG docker "$USER" || true
    ok "added $USER to docker group"
  fi

  systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service 2>/dev/null || true
  ok "pipewire user services enabled"
}

# -----------------------------------------------------------------------------
# Node globals + bun
# -----------------------------------------------------------------------------

setup_node_tools() {
  log "npm globals (pi, opencode) → ~/.local"
  mkdir -p "$HOME/.local"
  npm install -g --prefix "$HOME/.local" --allow-scripts=opencode-ai \
    opencode-ai \
    @earendil-works/pi-coding-agent
  ok "pi + opencode installed"

  # bun's installer expects a normal user HOME; skip under root smoke if needed
  if ! command -v bun >/dev/null 2>&1; then
    log "Installing bun"
    curl -fsSL https://bun.sh/install | bash
    ok "bun installed"
  else
    ok "bun already present"
  fi
}

# -----------------------------------------------------------------------------
# Post-checks (used by Docker smoke test)
# -----------------------------------------------------------------------------

verify_setup() {
  log "Verifying setup"
  local failed=0

  check() {
    if "$@"; then
      ok "$*"
    else
      warn "FAILED: $*"
      failed=1
    fi
  }

  check test -L "$HOME/.zshrc"
  check test -L "$HOME/.config/alacritty"
  check test -L "$HOME/.config/niri"
  check test -L "$HOME/.config/fuzzel"
  check test -f "$HOME/Pictures/Wallpapers/foggy-city.png"
  check test -x "$HOME/.local/bin/opencode"
  check test -x "$HOME/.local/bin/pi"
  check command -v zsh
  check command -v nvim
  check command -v lazygit
  check command -v node
  check command -v zoxide

  # zshrc should load
  check zsh -ic 'echo ok' 

  if [[ "$failed" -ne 0 ]]; then
    die "Verification failed"
  fi
  ok "all checks passed"
}

# -----------------------------------------------------------------------------
# Done
# -----------------------------------------------------------------------------

main() {
  install_packages
  setup_dirs_and_wallpaper
  link_configs
  setup_shell
  setup_services
  setup_node_tools

  if [[ "${SMOKE_TEST:-}" == "1" ]] || [[ "${VERIFY:-}" == "1" ]]; then
    verify_setup
  fi

  log "Done"
  cat <<EOF

  Setup complete. Next:
    1. Log out / reboot (shell + docker group)
    2. Start a niri session
    3. Open Alacritty — zsh + God-King theme

  Optional:
    WITH_NVIDIA=1 bash arch/setup.sh
    SMOKE_TEST=1 bash arch/setup.sh
    VERIFY=1 bash arch/setup.sh

  Backups of replaced files (if any):
    ${BACKUP_DIR}

EOF
}

main "$@"
