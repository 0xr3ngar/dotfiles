import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import {
  mkdtempSync,
  readFileSync,
  readdirSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { apply } from "../config/niri/bindings/apply";
import { render } from "../config/niri/bindings/render";

const settings = () => ({
  ambxst: {
    assistant: { key: "A", modifiers: ["SUPER", "SHIFT"] },
  },
});

test("renderer rejects duplicate and unrecognized modifiers", () => {
  const data = settings();
  data.ambxst.assistant.modifiers = ["SUPER", "SUPER"];
  expect(() => render(data)).toThrow("Repeated shortcut modifier");

  data.ambxst.assistant.modifiers = ["__proto__"];
  expect(() => render(data)).toThrow("Unsupported shortcut modifier");
});

describe.skipIf(!Bun.which("niri"))("Niri shortcut integration", () => {
  let directory: string;
  let previous: string;

  beforeEach(() => {
    directory = mkdtempSync(join(tmpdir(), "dotfiles-binds-test-"));
    writeFileSync(
      join(directory, "config.kdl"),
      'include "ambxst-binds.kdl"\nbinds {\n    Mod+Q { close-window; }\n    Print { screenshot; }\n}\n',
    );
    apply(settings(), directory);
    previous = readFileSync(join(directory, "ambxst-binds.kdl"), "utf8");
  });

  afterEach(() => {
    rmSync(directory, { recursive: true, force: true });
  });

  test("rebind updates the included configuration", () => {
    const data = settings();
    data.ambxst.assistant.key = "B";
    apply(data, directory);

    const result = readFileSync(join(directory, "ambxst-binds.kdl"), "utf8");
    expect(result).toContain("Mod+Shift+B ");
    expect(result).not.toContain("Mod+Shift+A ");
  });

  test.each([
    { key: "Q", modifiers: ["SUPER"] },
    { key: "Print", modifiers: [] },
    { key: "not_a_real_keysym", modifiers: ["SUPER"] },
  ])("rejected shortcut preserves working bindings: $key", (binding) => {
    expect(() =>
      apply({ ambxst: { assistant: binding } }, directory),
    ).toThrow();
    expect(readFileSync(join(directory, "ambxst-binds.kdl"), "utf8")).toBe(
      previous,
    );
    expect(
      readdirSync(directory).some((name) =>
        name.startsWith(".ambxst-validate-"),
      ),
    ).toBe(false);
  });

  test("duplicate shell bindings preserve working bindings", () => {
    const data = settings();
    const duplicate = {
      ambxst: { ...data.ambxst, dashboard: data.ambxst.assistant },
    };

    expect(() => apply(duplicate, directory)).toThrow(
      "Duplicate Ambxst shortcut",
    );
    expect(readFileSync(join(directory, "ambxst-binds.kdl"), "utf8")).toBe(
      previous,
    );
  });
});
