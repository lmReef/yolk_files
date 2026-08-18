import {
  createBashToolDefinition,
  createEditToolDefinition,
  createFindToolDefinition,
  createGrepToolDefinition,
  createLsToolDefinition,
  createReadToolDefinition,
  createWriteToolDefinition,
  type ExtensionAPI,
  type Theme,
  type ToolDefinition,
} from "@earendil-works/pi-coding-agent";
import { Container, type Component } from "@earendil-works/pi-tui";

const BLOCK = Symbol("highlight-block");
const CALL = Symbol("highlight-call");
const RESULT = Symbol("highlight-result");
const EMPTY = Symbol("highlight-empty");
const BG_RESET = "\x1b[49m";

type AnyTool = ToolDefinition<any, any, any>;
type HighlightState = Record<PropertyKey, unknown> & {
  [BLOCK]?: HighlightBlock;
  [CALL]?: Component;
  [RESULT]?: Component;
  [EMPTY]?: Container;
};

export function addLeftBar(
  lines: string[],
  width: number,
  bar: string,
  backgrounds: string[],
): string[] {
  return lines.map((line) => {
    for (const background of [...backgrounds, BG_RESET]) {
      line = line.replaceAll(background, "");
    }
    return width <= 2 ? `${bar}${width === 2 ? " " : ""}` : `${bar} ${line}`;
  });
}

class HighlightBlock implements Component {
  call?: Component;
  result?: Component;
  private bar = "│";
  private backgrounds: string[] = [];

  update(theme: Theme, isPartial: boolean, isError: boolean) {
    this.bar = theme.fg(
      isPartial ? "muted" : isError ? "error" : "success",
      "│",
    );
    this.backgrounds = [
      theme.getBgAnsi("toolPendingBg"),
      theme.getBgAnsi("toolSuccessBg"),
      theme.getBgAnsi("toolErrorBg"),
    ];
  }

  invalidate() {
    this.call?.invalidate();
    if (this.result !== this.call) this.result?.invalidate();
  }

  render(width: number): string[] {
    if (width < 1) return [];
    const contentWidth = Math.max(1, width - 2);
    const lines = [this.call, this.result].flatMap((component) =>
      component ? component.render(contentWidth) : [],
    );
    return addLeftBar(lines, width, this.bar, this.backgrounds);
  }
}

function withLeftBar(tool: AnyTool): AnyTool {
  const renderCall = tool.renderCall;
  const renderResult = tool.renderResult;

  return {
    ...tool,
    renderShell: "self",
    renderCall(args, theme, context) {
      const state = context.state as HighlightState;
      const block = (state[BLOCK] ??= new HighlightBlock());
      block.call = renderCall?.(args, theme, {
        ...context,
        lastComponent: state[CALL],
      });
      state[CALL] = block.call;
      block.update(theme, context.isPartial, context.isError);
      return block;
    },
    renderResult(result, options, theme, context) {
      const state = context.state as HighlightState;
      const block = (state[BLOCK] ??= new HighlightBlock());
      block.result = renderResult?.(result, options, theme, {
        ...context,
        lastComponent: state[RESULT],
      });
      state[RESULT] = block.result;
      block.update(theme, context.isPartial, context.isError);
      return (state[EMPTY] ??= new Container());
    },
  };
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    const tools: AnyTool[] = [
      createReadToolDefinition(ctx.cwd),
      createBashToolDefinition(ctx.cwd),
      createEditToolDefinition(ctx.cwd),
      createWriteToolDefinition(ctx.cwd),
      createGrepToolDefinition(ctx.cwd),
      createFindToolDefinition(ctx.cwd),
      createLsToolDefinition(ctx.cwd),
    ];

    for (const tool of tools) pi.registerTool(withLeftBar(tool));
  });
}
