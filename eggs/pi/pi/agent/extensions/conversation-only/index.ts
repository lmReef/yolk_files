import {
  ToolExecutionComponent,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

type ExpandableRow = {
  setExpanded(expanded: boolean): void;
  render(width: number): string[];
};

function hideCollapsedRows(prototype: ExpandableRow): () => void {
  const originalSetExpanded = prototype.setExpanded;
  const originalRender = prototype.render;
  const expanded = new WeakMap<object, boolean>();

  prototype.setExpanded = function (this: ExpandableRow, value) {
    expanded.set(this, value);
    originalSetExpanded.call(this, value);
  };
  prototype.render = function (this: ExpandableRow, width) {
    return expanded.get(this) === false ? [] : originalRender.call(this, width);
  };

  return () => {
    prototype.setExpanded = originalSetExpanded;
    prototype.render = originalRender;
  };
}

export default function (pi: ExtensionAPI) {
  // const restoreToolRows = hideCollapsedRows(ToolExecutionComponent.prototype);
  // pi.on("session_shutdown", (_event, ctx) => {
  //   restoreToolRows();
  //   if (ctx.mode === "tui") ctx.ui.setHiddenThinkingLabel();
  // });
}
