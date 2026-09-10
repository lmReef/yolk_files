import assert from "node:assert/strict";
import test from "node:test";
import { hideCollapsedRows } from "./index.ts";

class Row {
  setExpanded(_expanded: boolean): void {}
  render(_width: number): string[] {
    return ["tool call", "tool output"];
  }
}

test("hides collapsed rows and restores their renderer", () => {
  const restore = hideCollapsedRows(Row.prototype);
  const row = new Row();

  row.setExpanded(false);
  assert.deepEqual(row.render(80), []);
  row.setExpanded(true);
  assert.deepEqual(row.render(80), ["tool call", "tool output"]);

  restore();
  row.setExpanded(false);
  assert.deepEqual(row.render(80), ["tool call", "tool output"]);
});
