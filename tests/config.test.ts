import { expect, test } from "bun:test";
import { readFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { format } from "prettier";

const root = resolve(import.meta.dir, "..");

test("app JSON/JSONC and terminal TOML parse", async () => {
  const files = new Bun.Glob("config/**/*.json");

  for (const name of files.scanSync(root)) {
    const source = readFileSync(join(root, name), "utf8");
    const isEditorConfig =
      name.startsWith("config/zed/") || name.startsWith("config/cursor/");

    if (isEditorConfig) {
      await format(source, { parser: "json" });
      continue;
    }

    expect(() => JSON.parse(source), name).not.toThrow();
  }

  const terminal = readFileSync(
    join(root, "config/alacritty/alacritty.toml"),
    "utf8",
  );
  expect(() => Bun.TOML.parse(terminal)).not.toThrow();
});
