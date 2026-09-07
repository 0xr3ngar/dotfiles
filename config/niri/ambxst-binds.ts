import { readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { parseArgs } from "node:util";
import { apply } from "./bindings/apply";

const source = join(homedir(), ".config/ambxst/binds.json");

function reportInvalidShortcut(error: unknown): void {
  console.error(`Ambxst shortcuts: ${error}`);

  if (!Bun.which("notify-send")) {
    return;
  }

  Bun.spawnSync([
    "notify-send",
    "-a",
    "Ambxst",
    "Shortcut not applied",
    "That key conflicts with Niri or is invalid. The previous shortcuts remain active.",
  ]);
}

function updateBindings(previous: string | undefined): string | undefined {
  const current = readFileSync(source, "utf8");

  if (current === previous) {
    return previous;
  }

  // A partial JSON write is retried; a rejected binding is reported only once.
  const settings: unknown = JSON.parse(current);

  try {
    apply(settings);
  } catch (error) {
    reportInvalidShortcut(error);
  }

  return current;
}

async function watch(): Promise<void> {
  let previous: string | undefined;

  for (;;) {
    try {
      previous = updateBindings(previous);
    } catch (error) {
      console.error(`Ambxst shortcuts: ${error}`);
    }

    await Bun.sleep(500);
  }
}

async function startWatcher(): Promise<void> {
  const runtime = process.env.XDG_RUNTIME_DIR ?? "/tmp";
  const lock = join(runtime, `ambxst-niri-binds-${process.getuid?.()}.lock`);
  const child = Bun.spawn(
    [
      "flock",
      "-n",
      "-F",
      lock,
      process.execPath,
      import.meta.path,
      "--watch",
      "--locked",
    ],
    { stdin: "ignore", stdout: "inherit", stderr: "inherit" },
  );

  process.on("SIGTERM", () => child.kill("SIGTERM"));
  process.on("SIGINT", () => child.kill("SIGINT"));

  const code = await child.exited;
  process.exitCode = code === 1 ? 0 : code;
}

async function main(): Promise<void> {
  const { values } = parseArgs({
    args: Bun.argv.slice(2),
    options: {
      watch: { type: "boolean" },
      locked: { type: "boolean" },
    },
  });

  if (!values.watch) {
    apply(JSON.parse(readFileSync(source, "utf8")));
    return;
  }

  if (values.locked) {
    await watch();
    return;
  }

  await startWatcher();
}

await main();
