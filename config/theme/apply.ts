const settings: Record<string, string> = {
  "gtk-theme": "Adwaita-dark",
  "color-scheme": "prefer-dark",
  "icon-theme": "Papirus-Dark",
  "font-name": "Noto Sans 11",
  "monospace-font-name": "JetBrainsMono Nerd Font 11",
  "cursor-theme": "Adwaita",
  "cursor-size": "24",
};

function applyTheme(): void {
  if (!process.env.DBUS_SESSION_BUS_ADDRESS || !Bun.which("gsettings")) {
    return;
  }

  for (const [key, value] of Object.entries(settings)) {
    const result = Bun.spawnSync(
      ["gsettings", "set", "org.gnome.desktop.interface", key, value],
      { stdout: "ignore", stderr: "pipe" },
    );

    if (result.exitCode !== 0) {
      throw new Error(`Could not set ${key}: ${result.stderr.toString()}`);
    }
  }
}

applyTheme();
