interface CommandOptions {
  cwd?: string;
  allowFailure?: boolean;
}

export async function run(
  command: string[],
  options: CommandOptions = {},
): Promise<number> {
  const child = Bun.spawn(command, {
    cwd: options.cwd,
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  });

  const code = await child.exited;

  if (code !== 0 && !options.allowFailure) {
    throw new Error(`Command failed (${code}): ${command.join(" ")}`);
  }

  return code;
}
