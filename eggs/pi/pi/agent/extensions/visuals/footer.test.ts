import assert from "node:assert/strict";
import test from "node:test";
import { visibleWidth } from "@earendil-works/pi-tui";
import { rightAlign } from "./footer.ts";

test("right-aligns model details without overflowing footer statuses", () => {
  assert.equal(rightAlign("plan", "image", 12), "plan   image");
  assert.match(rightAlign("status", "reasoning", 5), /^reaso/);
  assert.equal(visibleWidth(rightAlign("status", "image", 8)), 8);
});
