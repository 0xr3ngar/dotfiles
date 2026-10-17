# Desktop

Niri is the Wayland compositor. Window behavior and shortcuts are in
`config/niri/config.kdl`.

Alacritty, Zsh and Neovim keep their own configuration. GTK apps pick up CSS
changes when reopened. The GPU path in Niri's `debug` section is specific to
this machine.

## What belongs outside this repo

Accounts, AI credentials, generated caches, screenshots, session history,
display-manager setup and graphics drivers are machine state. The installer
backs up replaced config files. It does not uninstall packages or change
system-wide services. Zed, Cursor and OpenCode are retained as the macOS
editor profile.
