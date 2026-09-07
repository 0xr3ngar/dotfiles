type Modifier = "SUPER" | "SHIFT" | "CTRL" | "ALT";
type Settings = Record<string, unknown>;

const modifierNames: Record<Modifier, string> = {
  SUPER: "Mod",
  SHIFT: "Shift",
  CTRL: "Ctrl",
  ALT: "Alt",
};

const keyNames: Record<string, string> = {
  SPACE: "Space",
  PERIOD: "Period",
  COMMA: "Comma",
  TAB: "Tab",
  ESCAPE: "Escape",
  RETURN: "Return",
};

const shellActions = [
  "launcher",
  "dashboard",
  "assistant",
  "clipboard",
  "emoji",
  "notes",
  "tmux",
  "wallpapers",
  "overview",
  "powermenu",
  "config",
  "tools",
  "screenrecord",
  "lens",
];

const commands: Record<string, string[]> = {
  ...Object.fromEntries(
    shellActions.map((name) => [
      name,
      ["$HOME/.local/bin/ambxst", "run", name],
    ]),
  ),
  lockscreen: ["$HOME/.local/bin/bun", "$HOME/.config/niri/actions.ts", "lock"],
  screenshot: [
    "$HOME/.local/bin/bun",
    "$HOME/.config/niri/actions.ts",
    "screenshot-region",
  ],
  reload: ["$HOME/.local/bin/ambxst", "reload"],
  quit: ["$HOME/.local/bin/ambxst", "quit"],
};

function asSettings(value: unknown): Settings {
  if (value === null || typeof value !== "object" || Array.isArray(value)) {
    throw new Error("Invalid shortcut settings");
  }

  return value as Settings;
}

function getBindings(data: unknown): Settings {
  const settings = asSettings(data);
  const core = asSettings(settings.ambxst);
  const system = asSettings(core.system ?? {});

  return { ...core, ...system };
}

function readKey(binding: Settings): string | undefined {
  const key = binding.key ?? "";

  if (key === "") {
    return;
  }

  if (typeof key !== "string" || !/^[A-Za-z0-9_]+$/.test(key)) {
    throw new Error("Unsupported shortcut key");
  }

  return key;
}

function isModifier(value: unknown): value is Modifier {
  return typeof value === "string" && Object.hasOwn(modifierNames, value);
}

function readModifiers(binding: Settings): Modifier[] {
  const modifiers = binding.modifiers ?? [];

  if (!Array.isArray(modifiers) || !modifiers.every(isModifier)) {
    throw new Error("Unsupported shortcut modifier");
  }

  if (modifiers.length !== new Set(modifiers).size) {
    throw new Error("Repeated shortcut modifier");
  }

  return modifiers;
}

export function shortcutIdentity(modifiers: string[], key: string): string {
  const normalized = modifiers
    .map((modifier) => (modifier === "SUPER" ? "MOD" : modifier))
    .sort();

  return [...normalized, key.toUpperCase()].join("+");
}

function renderCommand(command: string[]): string {
  const arguments_ = command.map((argument) => {
    if (argument.startsWith("$HOME/")) {
      return `"${argument}"`;
    }

    return argument;
  });

  return JSON.stringify(`exec ${arguments_.join(" ")}`);
}

export function render(data: unknown): string {
  const bindings = getBindings(data);
  const seen = new Set<string>();
  const lines = [
    "// Generated from Ambxst's core shortcuts; edit them in Ambxst Settings.",
    "binds {",
  ];

  for (const [name, command] of Object.entries(commands)) {
    const binding = asSettings(bindings[name] ?? {});
    const key = readKey(binding);

    if (!key) {
      continue;
    }

    const modifiers = readModifiers(binding);
    const identity = shortcutIdentity(modifiers, key);

    if (seen.has(identity)) {
      throw new Error(`Duplicate Ambxst shortcut: ${identity}`);
    }

    seen.add(identity);

    const combo = [
      ...modifiers.map((modifier) => modifierNames[modifier]),
      keyNames[key.toUpperCase()] ?? key,
    ].join("+");

    lines.push(
      `    ${combo} repeat=false hotkey-overlay-title="Ambxst: ${name}" { spawn-sh ${renderCommand(command)}; }`,
    );
  }

  return [...lines, "}", ""].join("\n");
}

export function shortcutKeys(content: string): Set<string> {
  const result = new Set<string>();
  const declaration = /^\s*(?:"([A-Za-z0-9_+]+)"|([A-Za-z0-9_+]+))\s+[^\n{]*\{/;

  for (const line of content.split("\n")) {
    const match = line.match(declaration);
    const name = match?.[1] ?? match?.[2];

    if (!name || !/^[A-Z]/.test(name)) {
      continue;
    }

    const parts = name.toUpperCase().split("+");
    const key = parts.pop()!;
    result.add(shortcutIdentity(parts, key));
  }

  return result;
}
