import {
  existsSync,
  readFileSync,
  renameSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { render, shortcutKeys } from "./render";

const include = 'include "ambxst-binds.kdl"';

function validateBindings(content: string, main: string): void {
  if (!main.includes(include)) {
    throw new Error("The Niri config is missing the Ambxst shortcuts include");
  }

  const existing = shortcutKeys(main);
  const conflict = [...shortcutKeys(content)].some((key) => existing.has(key));

  if (conflict) {
    throw new Error("Shortcut already used by the main Niri configuration");
  }
}

function validateConfig(path: string): void {
  const result = Bun.spawnSync(["niri", "validate", "-c", path], {
    stdout: "pipe",
    stderr: "pipe",
  });

  if (result.exitCode !== 0) {
    throw new Error(
      `Invalid Niri shortcut configuration:\n${result.stderr.toString()}`,
    );
  }
}

function replaceBindings(config: string, content: string, main: string): void {
  // Sibling files preserve resolution of other relative Niri includes.
  const candidate = join(config, `.ambxst-validate-${crypto.randomUUID()}.kdl`);
  const combined = join(config, `.ambxst-validate-${crypto.randomUUID()}.kdl`);

  try {
    writeFileSync(candidate, content, { flag: "wx", mode: 0o600 });
    writeFileSync(
      combined,
      main.replace(include, `include ${JSON.stringify(candidate)}`),
      { flag: "wx", mode: 0o600 },
    );

    validateConfig(combined);
    renameSync(candidate, join(config, "ambxst-binds.kdl"));
  } finally {
    rmSync(candidate, { force: true });
    rmSync(combined, { force: true });
  }
}

export function apply(
  data: unknown,
  config = join(homedir(), ".config/niri"),
): void {
  const content = render(data);
  const destination = join(config, "ambxst-binds.kdl");

  if (
    existsSync(destination) &&
    readFileSync(destination, "utf8") === content
  ) {
    return;
  }

  const main = readFileSync(join(config, "config.kdl"), "utf8");
  validateBindings(content, main);
  replaceBindings(config, content, main);
}
