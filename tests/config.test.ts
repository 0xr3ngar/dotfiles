import { expect, test } from "bun:test";
import { existsSync, readFileSync } from "node:fs";
import { join, resolve } from "node:path";
import { format } from "prettier";
import { configNames } from "../scripts/ambxst/restore-caesar";

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

test.each(["dark", "light"])(
  "Caesar %s palette keeps the yellow accent",
  (mode) => {
    const path = join(root, `config/ambxst/colors/Caesar/${mode}.json`);
    const colors = JSON.parse(readFileSync(path, "utf8")) as Record<
      string,
      string
    >;

    expect(colors.primary).toBe("#d8b574");

    for (const value of Object.values(colors)) {
      expect(value).toMatch(/^#[0-9a-fA-F]{6}$/);
    }

    for (const role of [
      "surface",
      "background",
      "overSurface",
      "overPrimary",
    ]) {
      expect(colors).toHaveProperty(role);
    }
  },
);

test("restore script has all of its saved settings files", () => {
  for (const name of configNames) {
    expect(
      existsSync(join(root, `config/ambxst/presets/Caesar/${name}.json`)),
    ).toBe(true);
  }
});
