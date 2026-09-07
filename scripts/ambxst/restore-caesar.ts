import {
  copyFileSync,
  existsSync,
  mkdirSync,
  readFileSync,
  renameSync,
  writeFileSync,
} from "node:fs";
import { homedir } from "node:os";
import { join, resolve } from "node:path";
import { run } from "../process";

export const configNames = [
  "theme",
  "bar",
  "notch",
  "dock",
  "desktop",
  "workspaces",
  "compositor",
  "overview",
  "lockscreen",
  "performance",
  "general",
];

const root = resolve(import.meta.dir, "../../config/ambxst");

function validatePreset(): void {
  for (const name of configNames) {
    JSON.parse(
      readFileSync(join(root, "presets/Caesar", `${name}.json`), "utf8"),
    );
  }

  JSON.parse(readFileSync(join(root, "colors/Caesar/dark.json"), "utf8"));
}

function restoreWallpaper(cache: string): void {
  const path = join(cache, "wallpapers.json");
  const state = existsSync(path) ? JSON.parse(readFileSync(path, "utf8")) : {};
  const updated = { ...state, activeColorPreset: "Caesar", tintEnabled: true };
  const temporary = `${path}.new`;

  writeFileSync(temporary, JSON.stringify(updated, null, 2) + "\n");
  renameSync(temporary, path);
}

async function restore(): Promise<void> {
  validatePreset();
  const home = homedir();
  const ambxst = join(home, ".local/bin/ambxst");

  await run([ambxst, "quit"], { allowFailure: true });

  for (const name of configNames) {
    copyFileSync(
      join(root, "presets/Caesar", `${name}.json`),
      join(root, "config", `${name}.json`),
    );
  }

  const cache = join(home, ".cache/ambxst");
  mkdirSync(cache, { recursive: true });
  copyFileSync(
    join(root, "colors/Caesar/dark.json"),
    join(cache, "colors.json"),
  );
  restoreWallpaper(cache);
  writeFileSync(join(root, "presets/active_preset"), "Caesar\n");
  await run([
    process.execPath,
    join(home, ".config/niri/actions.ts"),
    "ambxst",
  ]);
}

if (import.meta.main) {
  await restore();
}
