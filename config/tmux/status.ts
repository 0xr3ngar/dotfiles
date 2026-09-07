import { cpus } from "node:os";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";

function output(command: string[]): string {
  const result = Bun.spawnSync(command, { stdout: "pipe", stderr: "ignore" });
  return result.stdout.toString().trim();
}

function cpu(): string {
  const values = output(["ps", "-eo", "pcpu="]).split(/\s+/).map(Number);
  const total = values.reduce((sum, value) => sum + value, 0);
  return `${Math.round(total / cpus().length)}%`;
}

function memory(): string {
  if (process.platform === "darwin") {
    const match = output(["memory_pressure"]).match(/free percentage:\s*(\d+)/);
    return match ? `${100 - Number(match[1])}%` : "--";
  }

  const content = readFileSync("/proc/meminfo", "utf8");
  const total = Number(content.match(/^MemTotal:\s*(\d+)/m)?.[1]);
  const available = Number(content.match(/^MemAvailable:\s*(\d+)/m)?.[1]);

  if (!total) {
    return "--";
  }

  return `${Math.round((100 * (total - available)) / total)}%`;
}

function volume(): string {
  if (process.platform === "darwin") {
    return `${output(["osascript", "-e", "output volume of (get volume settings)"])}%`;
  }

  const value = output(["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]);

  if (value.includes("MUTED")) {
    return "muted";
  }

  const match = value.match(/Volume:\s*([\d.]+)/);
  return match ? `${Math.round(Number(match[1]) * 100)}%` : "--";
}

function battery(): string {
  if (process.platform === "darwin") {
    return output(["pmset", "-g", "batt"]).match(/\d+%/)?.[0] ?? "--";
  }

  for (const name of readdirSync("/sys/class/power_supply")) {
    const path = join("/sys/class/power_supply", name, "capacity");

    if (existsSync(path)) {
      return `${readFileSync(path, "utf8").trim()}%`;
    }
  }

  return "--";
}

const metrics: Record<string, () => string> = { cpu, memory, volume, battery };
const metric = Bun.argv[2];

if (!metric || !Object.hasOwn(metrics, metric)) {
  throw new Error("Choose cpu, memory, volume or battery");
}

process.stdout.write(metrics[metric]!());
