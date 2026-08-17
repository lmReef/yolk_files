import {
  VERSION,
  keyHint,
  keyText,
  rawKeyHint,
  type ExtensionAPI,
} from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

class StartupHeader extends Text {
  constructor(
    private readonly collapsed: () => string,
    private readonly expanded: () => string,
  ) {
    super("", 1, 0);
  }

  setExpanded(expanded: boolean) {
    this.setText(expanded ? this.expanded() : this.collapsed());
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setHeader((_tui, theme) => {
      const logo =
        theme.bold(theme.fg("accent", "pi")) + theme.fg("dim", ` v${VERSION}`);
      const hint = (
        keybinding: Parameters<typeof keyHint>[0],
        description: string,
      ) => keyHint(keybinding, description);

      const expandedInstructions = [
        hint("app.interrupt", "to interrupt"),
        hint("app.clear", "to clear"),
        rawKeyHint(`${keyText("app.clear")} twice`, "to exit"),
        hint("app.exit", "to exit (empty)"),
        hint("app.suspend", "to suspend"),
        keyHint("tui.editor.deleteToLineEnd", "to delete to end"),
        hint("app.thinking.cycle", "to cycle thinking level"),
        rawKeyHint(
          `${keyText("app.model.cycleForward")}/${keyText("app.model.cycleBackward")}`,
          "to cycle models",
        ),
        hint("app.model.select", "to select model"),
        hint("app.tools.expand", "to expand tools"),
        hint("app.thinking.toggle", "to expand thinking"),
        hint("app.editor.external", "for external editor"),
        rawKeyHint("/", "for commands"),
        rawKeyHint("!", "to run bash"),
        rawKeyHint("!!", "to run bash (no context)"),
        hint("app.message.followUp", "to queue follow-up"),
        hint("app.message.dequeue", "to edit all queued messages"),
        hint("app.clipboard.pasteImage", "to paste image (with text fallback)"),
        rawKeyHint("drop files", "to attach"),
      ].join("\n");

      const compactInstructions = [
        hint("app.interrupt", "interrupt"),
        rawKeyHint(
          `${keyText("app.clear")}/${keyText("app.exit")}`,
          "clear/exit",
        ),
        rawKeyHint("/", "commands"),
        rawKeyHint("!", "bash"),
        hint("app.tools.expand", "more"),
      ].join(theme.fg("muted", " · "));

      return new StartupHeader(
        () => `${logo}\n${compactInstructions}\n`,
        () => `${logo}\n${expandedInstructions}\n`,
      );
    });
  });
}
