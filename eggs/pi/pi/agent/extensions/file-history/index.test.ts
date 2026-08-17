import assert from "node:assert/strict";
import test from "node:test";
import {
  diffCounts,
  historyWindow,
  newDeletionItems,
  removedKnownItems,
  summarizeChange,
  type HistoryItem,
} from "./index.ts";

test("summarizes new, deleted, added, removed, and mixed edits", () => {
  assert.deepEqual(summarizeChange("/repo/src/new.ts", null, "one\ntwo\n", "/repo"), {
    kind: "N", count: 2, path: "src/new.ts",
  });
  assert.deepEqual(summarizeChange("/repo/src/old.ts", "one\ntwo\n", null, "/repo"), {
    kind: "D", count: 2, path: "src/old.ts",
  });
  assert.deepEqual(diffCounts("a\nc\n", "a\nb\nc\n"), { additions: 1, removals: 0 });
  assert.deepEqual(diffCounts("a\nb\nc\n", "a\nc\n"), { additions: 0, removals: 1 });
  assert.deepEqual(summarizeChange("/repo/src/file.ts", "a\nb\n", "a\nc\n", "/repo"), {
    kind: "+/-", count: 2, path: "src/file.ts",
  });
  assert.deepEqual(
    newDeletionItems(
      new Map([["already-gone.ts", 3]]),
      new Map([["already-gone.ts", 3], ["src/removed.ts", 12]]),
    ),
    [{ kind: "D", count: 12, path: "src/removed.ts" }],
  );
  assert.deepEqual(
    removedKnownItems(
      new Map([["src/untracked.ts", 7]]),
      new Map(),
    ),
    [{ kind: "D", count: 7, path: "src/untracked.ts" }],
  );
});

test("windows history ten entries at a time with boundary indicators", () => {
  const history: HistoryItem[] = Array.from({ length: 12 }, (_, count) => ({
    kind: "+",
    count,
    path: `${count}.ts`,
  }));
  const latest = historyWindow(history, 0);
  assert.deepEqual(latest.items.map(({ count }) => count), [11, 10, 9, 8, 7, 6, 5, 4, 3, 2]);
  assert.equal(latest.hasAbove, false);
  assert.equal(latest.hasBelow, true);

  const oldest = historyWindow(history, 99);
  assert.deepEqual(oldest.items.map(({ count }) => count), [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
  assert.equal(oldest.offset, 2);
  assert.equal(oldest.hasAbove, true);
  assert.equal(oldest.hasBelow, false);
});
