import {
  copyFileSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
} from "node:fs";
import { homedir, tmpdir } from "node:os";
import { join } from "node:path";

const home = homedir();

function capture(command: string[], allowFailure = false): string {
  const result = Bun.spawnSync(command, { stdout: "pipe", stderr: "pipe" });

  if (result.exitCode !== 0 && !allowFailure) {
    throw new Error(result.stderr.toString());
  }

  return result.stdout.toString().trim();
}

async function launch(command: string[]): Promise<void> {
  const child = Bun.spawn(command, {
    env: {
      ...process.env,
      PATH: `${home}/.local/bin:${process.env.PATH ?? ""}`,
    },
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  });

  process.on("SIGTERM", () => child.kill("SIGTERM"));
  process.on("SIGINT", () => child.kill("SIGINT"));
  process.exitCode = await child.exited;
}

async function lock(): Promise<void> {
  const wallpaper = join(home, "pictures/Wallpapers/wall.jpg");

  if (!existsSync(wallpaper)) {
    await launch(["swaylock"]);
    return;
  }

  await launch(["swaylock", "--image", wallpaper, "--scaling", "fill"]);
}

function maximize(): void {
  const focused = capture(["niri", "msg", "-j", "focused-window"], true);
  const window = JSON.parse(focused || "null") as { id: number } | null;

  capture(["niri", "msg", "action", "maximize-column"]);

  // Preserve the existing viewport realignment workaround.
  for (const action of [
    "focus-column-left",
    "focus-column-right",
    "focus-column-left",
  ]) {
    capture(["niri", "msg", "action", action], true);
  }

  if (!window) {
    return;
  }

  capture(
    ["niri", "msg", "action", "focus-window", "--id", String(window.id)],
    true,
  );
}

function overviewAction(arguments_: string[]): void {
  const [inOverview, normal] = arguments_;

  if (!inOverview || !normal) {
    throw new Error("overview requires actions for overview and normal mode");
  }

  const state = JSON.parse(
    capture(["niri", "msg", "-j", "overview-state"]),
  ) as { is_open: boolean };
  const action = state.is_open ? inOverview : normal;
  capture(["niri", "msg", "action", action]);
}

function selectRegion(): string {
  const palettePath = join(home, ".config/theme/colors.json");
  const colors = JSON.parse(readFileSync(palettePath, "utf8")) as Record<
    string,
    string
  >;

  return capture(
    [
      "slurp",
      "-d",
      "-b",
      `${colors.bg}66`,
      "-c",
      `${colors.accent}ff`,
      "-s",
      `${colors.accent_dim}88`,
      "-w",
      "2",
    ],
    true,
  );
}

function copyScreenshot(path: string): void {
  const result = Bun.spawnSync(["wl-copy", "-t", "image/png"], {
    stdin: readFileSync(path),
    stdout: "ignore",
    stderr: "pipe",
  });

  if (result.exitCode !== 0) {
    throw new Error(result.stderr.toString());
  }
}

function saveScreenshot(path: string): string {
  const directory = join(home, "pictures/Screenshots");
  const timestamp = new Date().toISOString().replaceAll(":", "-");
  const destination = join(directory, `Screenshot ${timestamp}.png`);

  mkdirSync(directory, { recursive: true });
  copyFileSync(path, destination);

  return `Saved + copied\n${destination}`;
}

function screenshot(regionOnly: boolean, save: boolean): void {
  const region = regionOnly ? selectRegion() : undefined;

  if (regionOnly && !region) {
    return;
  }

  const temporary = mkdtempSync(join(tmpdir(), "screenshot-"));
  const path = join(temporary, "capture.png");
  const command = region ? ["grim", "-g", region, path] : ["grim", path];

  try {
    capture(command);
    copyScreenshot(path);

    const message = save ? saveScreenshot(path) : "Copied to clipboard";
    capture(
      [
        "notify-send",
        "-a",
        "screenshot",
        "-i",
        "camera-photo",
        "Screenshot",
        message,
      ],
      true,
    );
  } finally {
    rmSync(temporary, { recursive: true, force: true });
  }
}

async function main(): Promise<void> {
  const [name, ...arguments_] = Bun.argv.slice(2);
  const actions: Record<string, () => void | Promise<void>> = {
    lock,
    maximize,
    overview: () => overviewAction(arguments_),
    "screenshot-region": () => screenshot(true, arguments_.includes("--save")),
    "screenshot-screen": () => screenshot(false, arguments_.includes("--save")),
  };

  if (!name || !Object.hasOwn(actions, name)) {
    throw new Error(`Choose an action: ${Object.keys(actions).join(", ")}`);
  }

  await actions[name]!();
}

await main();
