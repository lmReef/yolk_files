import assert from "node:assert/strict";
import test from "node:test";
import { diffCounts, newDeletionItems, removedKnownItems, summarizeChange } from "./index.ts";

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
