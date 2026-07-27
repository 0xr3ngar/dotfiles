#!/usr/bin/env bash
# Run arch/setup.sh inside a disposable Arch container (smoke test).
# Usage: bash arch/test-in-docker.sh
set -euo pipefail

ARCH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$ARCH/.." && pwd)"
IMAGE="${IMAGE:-archlinux:latest}"
NAME="dotfiles-smoke-$$"

log() { printf '\n\033[1;36m==>\033[0m %s\n' "$*"; }

cleanup() {
  docker rm -f "$NAME" >/dev/null 2>&1 || true
}
trap cleanup EXIT

log "Pulling $IMAGE"
docker pull "$IMAGE"

log "Starting container $NAME"
docker run -d --name "$NAME" \
  -v "$ROOT:/dotfiles:ro" \
  "$IMAGE" \
  sleep infinity

log "Bootstrapping pacman + copying writable dotfiles tree"
docker exec "$NAME" bash -lc '
  set -euo pipefail
  pacman-key --init
  pacman-key --populate archlinux
  pacman -Syu --noconfirm
  pacman -S --needed --noconfirm sed awk grep which
  cp -a /dotfiles /root/dotfiles
'

log "Running arch/setup.sh (SMOKE_TEST=1)"
docker exec -e SMOKE_TEST=1 -e SKIP_SERVICES=1 -e VERIFY=1 "$NAME" \
  bash /root/dotfiles/arch/setup.sh

log "Smoke test passed"
