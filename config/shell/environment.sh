# Managed tool locations; home-folder cleanup, 2026-09-12.
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export BUN_INSTALL="$HOME/.local/share/bun"
export BUN_INSTALL_CACHE_DIR="$HOME/.cache/bun"
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
export ANDROID_USER_HOME="$HOME/.local/share/android"
export ANDROID_EMULATOR_HOME="$HOME/.local/share/android"
export ANDROID_AVD_HOME="$HOME/.local/share/android/avd"
export GRADLE_USER_HOME="$HOME/.cache/gradle"
export DOCKER_CONFIG="$HOME/.config/docker"
export GROK_HOME="$HOME/.local/share/grok"
export npm_config_cache="$HOME/.cache/npm"
export CUDA_CACHE_PATH="$HOME/.cache/nvidia/ComputeCache"
export __UNSAFE_EXPO_HOME_DIRECTORY="$HOME/.local/share/expo"

# Preserve the existing PATH, adding relocated tool commands without duplicates.
for _home_tool_bin in "$CARGO_HOME/bin" "$BUN_INSTALL/bin" "$GROK_HOME/bin" "$HOME/.local/bin"; do
    case ":${PATH:-}:" in
        *":$_home_tool_bin:"*) ;;
        *) PATH="$_home_tool_bin${PATH:+:$PATH}" ;;
    esac
done
export PATH
unset _home_tool_bin
