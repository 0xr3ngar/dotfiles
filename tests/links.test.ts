import { afterEach, beforeEach, describe, expect, test } from "bun:test";
import {
  existsSync,
  lstatSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  readlinkSync,
  realpathSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { installLinks, linksFor, repository } from "../scripts/link-configs";

describe("config installation", () => {
  let temporary: string;
  let home: string;

  beforeEach(() => {
    temporary = mkdtempSync(join(tmpdir(), "dotfiles-links-test-"));
    home = join(temporary, "home with spaces");
  });

  afterEach(() => {
    rmSync(temporary, { recursive: true, force: true });
  });

  const quiet = () => {};

  test("backs up existing files and is idempotent", () => {
    const niri = join(home, ".config/niri");
    mkdirSync(niri, { recursive: true });
    writeFileSync(join(niri, "config.kdl"), "old desktop");
    writeFileSync(join(home, ".zshrc"), "old shell");

    const backup = installLinks({ home, log: quiet })!;

    expect(readFileSync(join(backup, ".config/niri/config.kdl"), "utf8")).toBe(
      "old desktop",
    );
    expect(readFileSync(join(backup, ".zshrc"), "utf8")).toBe("old shell");
    expect(installLinks({ home, log: quiet })).toBeUndefined();

    for (const [source, destination] of linksFor("arch")) {
      const installed = join(home, destination);
      expect(lstatSync(installed).isSymbolicLink()).toBe(true);
      expect(realpathSync(installed)).toBe(
        realpathSync(resolve(repository, source)),
      );
    }

    expect(existsSync(join(home, ".config/opencode"))).toBe(false);
  });

  test("links macOS editors without replacing Cursor session data", () => {
    const user = join(home, "Library/Application Support/Cursor/User");
    mkdirSync(join(user, "workspaceStorage"), { recursive: true });
    writeFileSync(join(user, "settings.json"), "previous settings");

    installLinks({ home, profile: "editors", platform: "darwin", log: quiet });

    expect(existsSync(join(user, "workspaceStorage"))).toBe(true);
    expect(realpathSync(join(user, "settings.json"))).toBe(
      join(repository, "config/cursor/settings.json"),
    );
    expect(existsSync(join(home, ".config/niri"))).toBe(false);
  });

  test("backs up broken symlinks without following them", () => {
    mkdirSync(home);
    symlinkSync("missing-zshrc", join(home, ".zshrc"));

    const backup = installLinks({ home, log: quiet })!;

    expect(readlinkSync(join(backup, ".zshrc"))).toBe("missing-zshrc");
    expect(existsSync(join(home, ".zshrc"))).toBe(true);
  });

  test("dry run does not create the destination home", () => {
    installLinks({ home, dryRun: true, log: quiet });
    expect(existsSync(home)).toBe(false);
  });

  test("missing sources fail before any files change", () => {
    expect(() =>
      installLinks({ root: join(temporary, "missing"), home, log: quiet }),
    ).toThrow("Missing source");
    expect(existsSync(home)).toBe(false);
  });
});
