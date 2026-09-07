import { join } from "node:path";
import { run } from "./process";

const root = join(import.meta.dir, "..");

async function main(): Promise<void> {
  await run([process.execPath, "run", "typecheck"], { cwd: root });
  await run([process.execPath, "run", "format:check"], { cwd: root });
  await run([process.execPath, "test", "./tests"], { cwd: root });

  if (Bun.which("zsh")) {
    await run(["zsh", "-n", join(root, "config/zsh/zshrc")]);
  }

  if (Bun.which("niri")) {
    await run(["niri", "validate", "-c", join(root, "config/niri/config.kdl")]);
  }

  console.log("Configuration checks passed.");
}

await main();
