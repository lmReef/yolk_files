import { readFile } from "node:fs/promises";
import { basename, isAbsolute, relative, resolve } from "node:path";
import {
  isEditToolResult,
  isToolCallEventType,
  isWriteToolResult,
  type ExtensionAPI,
  type Theme,
} from "@earendil-works/pi-coding-agent";
import {
  truncateToWidth,
  visibleWidth,
  type OverlayHandle,
} from "@earendil-works/pi-tui";

export type ChangeKind = "+" | "-" | "+/-" | "N" | "D";
export type HistoryItem = { kind: ChangeKind; count: number; path: string };

type Snapshot = { absolutePath: string; before: string | null | undefined };
type DeletionSnapshot = {
  git: Map<string, number> | undefined;
  knownFiles: Map<string, number>;
};

const STATE_KEY = "piEditHistory";
const PAGE_SIZE = 7;

function lines(content: string): string[] {
  const normalized = content.replace(/\r\n?/g, "\n");
  if (!normalized) return [];
  return (
    normalized.endsWith("\n") ? normalized.slice(0, -1) : normalized
  ).split("\n");
}

export function diffCounts(before: string, after: string) {
  const oldLines = lines(before);
  const newLines = lines(after);
  let start = 0;
  let oldEnd = oldLines.length;
  let newEnd = newLines.length;

  while (
    start < oldEnd &&
    start < newEnd &&
    oldLines[start] === newLines[start]
  )
    start++;
  while (
    oldEnd > start &&
    newEnd > start &&
    oldLines[oldEnd - 1] === newLines[newEnd - 1]
  ) {
    oldEnd--;
    newEnd--;
  }

  const oldMiddle = oldLines.slice(start, oldEnd);
  const newMiddle = newLines.slice(start, newEnd);

  // ponytail: quadratic only below 2M cells; swap in Myers if huge-rewrite precision matters.
  if (oldMiddle.length * newMiddle.length > 2_000_000) {
    return { additions: newMiddle.length, removals: oldMiddle.length };
  }

  let previous = new Uint32Array(newMiddle.length + 1);
  for (const oldLine of oldMiddle) {
    const current = new Uint32Array(newMiddle.length + 1);
    for (let j = 1; j <= newMiddle.length; j++) {
      current[j] =
        oldLine === newMiddle[j - 1]
          ? previous[j - 1]! + 1
          : Math.max(previous[j]!, current[j - 1]!);
    }
    previous = current;
  }

  const common = previous[newMiddle.length]!;
  return {
    additions: newMiddle.length - common,
    removals: oldMiddle.length - common,
  };
}

function relativePath(path: string, cwd: string): string {
  return relative(cwd, path) || basename(path);
}

function itemFromCounts(
  path: string,
  additions: number,
  removals: number,
  cwd: string,
): HistoryItem | undefined {
  if (!additions && !removals) return;
  return {
    kind: additions && removals ? "+/-" : additions ? "+" : "-",
    count: additions + removals,
    path: relativePath(path, cwd),
  };
}

export function summarizeChange(
  path: string,
  before: string | null | undefined,
  after: string | null,
  cwd: string,
): HistoryItem | undefined {
  if (before === undefined) return;
  if (before === null) {
    return after === null
      ? undefined
      : {
          kind: "N",
          count: lines(after).length,
          path: relativePath(path, cwd),
        };
  }
  if (after === null)
    return {
      kind: "D",
      count: lines(before).length,
      path: relativePath(path, cwd),
    };
  const { additions, removals } = diffCounts(before, after);
  return itemFromCounts(path, additions, removals, cwd);
}

function countsFromDisplayDiff(diff: string) {
  let additions = 0;
  let removals = 0;
  for (const line of diff.split("\n")) {
    if (line.startsWith("+")) additions++;
    else if (line.startsWith("-")) removals++;
  }
  return { additions, removals };
}

function isHistoryItem(value: unknown): value is HistoryItem {
  if (!value || typeof value !== "object") return false;
  const item = value as Partial<HistoryItem>;
  return (
    ["+", "-", "+/-", "N", "D"].includes(item.kind ?? "") &&
    typeof item.count === "number" &&
    typeof item.path === "string"
  );
}

function storedItems(value: unknown): HistoryItem[] {
  if (isHistoryItem(value)) return [value];
  return Array.isArray(value) ? value.filter(isHistoryItem) : [];
}

export function newDeletionItems(
  before: Map<string, number>,
  after: Map<string, number>,
): HistoryItem[] {
  return [...after]
    .filter(([path]) => !before.has(path))
    .map(([path, count]) => ({ kind: "D", count, path }));
}

export function removedKnownItems(
  before: Map<string, number>,
  after: Map<string, number>,
): HistoryItem[] {
  return [...before]
    .filter(([path]) => !after.has(path))
    .map(([path, count]) => ({ kind: "D", count, path }));
}

export function historyWindow(
  history: HistoryItem[],
  offset: number,
  limit = PAGE_SIZE,
) {
  const ordered = [...history].reverse();
  const clampedOffset = Math.max(
    0,
    Math.min(offset, Math.max(0, ordered.length - limit)),
  );
  return {
    items: ordered.slice(clampedOffset, clampedOffset + limit),
    offset: clampedOffset,
    hasAbove: clampedOffset > 0,
    hasBelow: clampedOffset + limit < ordered.length,
  };
}

class FileHistoryPanel {
  private readonly history: HistoryItem[];
  private readonly theme: Theme;
  private offset = 0;

  constructor(history: HistoryItem[], theme: Theme) {
    this.history = history;
    this.theme = theme;
  }

  scroll(delta: number): boolean {
    const next = historyWindow(this.history, this.offset + delta).offset;
    if (next === this.offset) return false;
    this.offset = next;
    return true;
  }

  entriesAdded(count: number): void {
    if (this.offset > 0) this.offset += count;
  }

  render(width: number): string[] {
    const innerWidth = Math.max(1, width - 1);
    const border = (text: string) => this.theme.fg("borderMuted", text);
    const row = (content: string, trailing = "") => {
      const contentWidth = innerWidth - visibleWidth(trailing);
      const clipped = truncateToWidth(content, contentWidth, "…");
      return (
        border("│") +
        clipped +
        " ".repeat(Math.max(0, contentWidth - visibleWidth(clipped))) +
        trailing
      );
    };
    const output: string[] = [];

    // placeholder text before edits are made
    if (!this.history.length) output.push(row(this.theme.fg("dim", "")));
    const window = historyWindow(this.history, this.offset);
    this.offset = window.offset;
    const labelWidth = Math.max(
      0,
      ...this.history.map((item) =>
        visibleWidth(`${item.kind === "+/-" ? "~" : item.kind}${item.count}`),
      ),
    );
    for (const [index, item] of window.items.entries()) {
      const label = `${item.kind === "+/-" ? "~" : item.kind}${item.count}`;
      const color =
        item.kind === "+" || item.kind === "N"
          ? "success"
          : item.kind === "-" || item.kind === "D"
            ? "error"
            : "mdHeading";
      const padding = " ".repeat(labelWidth - visibleWidth(label));
      const indicator =
        index === 0 && window.hasAbove
          ? this.theme.fg("dim", "↑")
          : index === window.items.length - 1 && window.hasBelow
            ? this.theme.fg("dim", "↓")
            : "";
      output.push(
        row(
          ` ${this.theme.fg(color, label)}${padding} ${item.path}`,
          indicator,
        ),
      );
    }

    output.push(border(`╰${"─".repeat(innerWidth)}`));
    return output;
  }

  invalidate(): void {}
}

export default function (pi: ExtensionAPI) {
  let history: HistoryItem[] = [];
  let pending = new Map<string, Snapshot>();
  let pendingDeletions = new Map<string, DeletionSnapshot>();
  let requestRender = () => {};
  let panel: FileHistoryPanel | undefined;
  let overlay: OverlayHandle | undefined;
  let cwd = "";

  const absolutePath = (path: string) => {
    const clean = path.startsWith("@") ? path.slice(1) : path;
    return isAbsolute(clean) ? clean : resolve(cwd, clean);
  };
  const deletedFiles = async () => {
    try {
      const result = await pi.exec(
        "git",
        [
          "diff",
          "HEAD",
          "--relative",
          "--numstat",
          "--diff-filter=D",
          "--no-renames",
          "-z",
          "--",
        ],
        { cwd, timeout: 5000 },
      );
      if (result.code !== 0) return;
      const deleted = new Map<string, number>();
      for (const row of result.stdout.split("\0")) {
        const match = row.match(/^[-\d]+\t([-\d]+)\t([\s\S]+)$/);
        if (match)
          deleted.set(match[2]!, match[1] === "-" ? 0 : Number(match[1]));
      }
      return deleted;
    } catch {
      return;
    }
  };
  const knownFiles = async () => {
    const current = new Set<string>();
    for (const item of history) {
      if (item.kind === "D") current.delete(item.path);
      else current.add(item.path);
    }
    const counts = new Map<string, number>();
    await Promise.all(
      [...current].map(async (path) => {
        try {
          counts.set(
            path,
            lines(await readFile(resolve(cwd, path), "utf8")).length,
          );
        } catch {
          // Missing files are omitted.
        }
      }),
    );
    return counts;
  };

  pi.on("session_start", (_event, ctx) => {
    cwd = ctx.cwd;
    pending = new Map();
    pendingDeletions = new Map();
    history = ctx.sessionManager.getBranch().flatMap((entry) => {
      if (entry.type !== "message" || entry.message.role !== "toolResult")
        return [];
      const details = entry.message.details;
      if (!details || typeof details !== "object") return [];
      return storedItems((details as Record<string, unknown>)[STATE_KEY]);
    });

    if (ctx.mode !== "tui") return;
    void ctx.ui.custom<void>(
      (tui, theme) => {
        requestRender = () => tui.requestRender();
        panel = new FileHistoryPanel(history, theme);
        return panel;
      },
      {
        overlay: true,
        overlayOptions: {
          anchor: "top-right",
          width: 30,
          minWidth: 24,
          maxHeight: "80%",
          margin: { top: 0, right: 0 },
          nonCapturing: true,
        },
        onHandle: (handle) => {
          overlay = handle;
        },
      },
    );
  });

  pi.on("session_shutdown", () => {
    overlay?.hide();
    overlay = undefined;
    panel = undefined;
    requestRender = () => {};
  });

  pi.registerShortcut("alt+j", {
    description: "Scroll file history down",
    handler: () => {
      if (panel?.scroll(1)) requestRender();
    },
  });

  pi.registerShortcut("alt+k", {
    description: "Scroll file history up",
    handler: () => {
      if (panel?.scroll(-1)) requestRender();
    },
  });

  pi.on("tool_call", async (event) => {
    if (isToolCallEventType("bash", event)) {
      if (/\brm(?:\s|$)/.test(event.input.command)) {
        const [git, knownFilesBefore] = await Promise.all([
          deletedFiles(),
          knownFiles(),
        ]);
        pendingDeletions.set(event.toolCallId, {
          git,
          knownFiles: knownFilesBefore,
        });
      }
      return;
    }
    if (
      !isToolCallEventType("edit", event) &&
      !isToolCallEventType("write", event)
    )
      return;
    const path = event.input.path;
    if (typeof path !== "string") return;
    const resolved = absolutePath(path);
    let before: string | null | undefined;
    try {
      before = await readFile(resolved, "utf8");
    } catch (error) {
      before =
        error &&
        typeof error === "object" &&
        "code" in error &&
        error.code === "ENOENT"
          ? null
          : undefined;
    }
    pending.set(event.toolCallId, { absolutePath: resolved, before });
  });

  pi.on("tool_result", async (event) => {
    if (event.toolName === "bash") {
      const before = pendingDeletions.get(event.toolCallId);
      pendingDeletions.delete(event.toolCallId);
      if (!before) return;
      const [gitAfter, knownFilesAfter] = await Promise.all([
        deletedFiles(),
        knownFiles(),
      ]);
      const byPath = new Map<string, HistoryItem>();
      if (before.git && gitAfter) {
        for (const item of newDeletionItems(before.git, gitAfter))
          byPath.set(item.path, item);
      }
      for (const item of removedKnownItems(before.knownFiles, knownFilesAfter))
        byPath.set(item.path, item);
      const items = [...byPath.values()];
      if (!items.length) return;
      panel?.entriesAdded(items.length);
      history.push(...items);
      requestRender();
      const details =
        event.details && typeof event.details === "object" ? event.details : {};
      return { details: { ...details, [STATE_KEY]: items } };
    }
    if (!isEditToolResult(event) && !isWriteToolResult(event)) return;
    const snapshot = pending.get(event.toolCallId);
    pending.delete(event.toolCallId);
    if (event.isError || !snapshot) return;

    let item: HistoryItem | undefined;
    if (isWriteToolResult(event)) {
      const content = event.input.content;
      if (typeof content === "string")
        item = summarizeChange(
          snapshot.absolutePath,
          snapshot.before,
          content,
          cwd,
        );
    } else if (event.details?.diff) {
      const { additions, removals } = countsFromDisplayDiff(event.details.diff);
      item = itemFromCounts(snapshot.absolutePath, additions, removals, cwd);
    }
    if (!item) return;

    panel?.entriesAdded(1);
    history.push(item);
    requestRender();
    const details =
      event.details && typeof event.details === "object" ? event.details : {};
    return { details: { ...details, [STATE_KEY]: item } };
  });
}
