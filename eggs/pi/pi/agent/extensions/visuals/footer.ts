import {
  FooterComponent,
  type AgentSession,
  type ExtensionAPI,
  type ReadonlyFooterDataProvider,
} from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

export function rightAlign(left: string, right: string, width: number): string {
  const clippedRight = truncateToWidth(right, width, "");
  const clippedLeft = truncateToWidth(
    left,
    Math.max(0, width - visibleWidth(clippedRight) - 2),
    "",
  );
  return (
    clippedLeft +
    " ".repeat(width - visibleWidth(clippedLeft) - visibleWidth(clippedRight)) +
    clippedRight
  );
}

export default function (pi: ExtensionAPI) {
  const closestJJBookmark = async (cwd: string) => {
    try {
      const result = await pi.exec(
        "jj",
        [
          "--ignore-working-copy",
          "log",
          "--no-graph",
          "-r",
          "heads(::@ & bookmarks())",
          "-T",
          'local_bookmarks.map(|b| b.name()).join(", ") ++ "\\n"',
        ],
        { cwd, timeout: 2000 },
      );
      return result.code === 0
        ? result.stdout.trim().replace(/\r?\n/g, ", ") || undefined
        : undefined;
    } catch {
      return undefined;
    }
  };

  pi.on("session_start", (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    const cwd = ctx.cwd;
    let jjBookmark: string | undefined;

    ctx.ui.setFooter((tui, theme, footerData) => {
      const data: ReadonlyFooterDataProvider = {
        getGitBranch: () => jjBookmark ?? footerData.getGitBranch(),
        getExtensionStatuses: () => footerData.getExtensionStatuses(),
        getAvailableProviderCount: () => footerData.getAvailableProviderCount(),
        onBranchChange: (callback) => footerData.onBranchChange(callback),
      };
      // FooterComponent expects an AgentSession, but only reads these public values.
      const session: AgentSession = {
        get state() {
          return { model: ctx.model, thinkingLevel: ctx.thinkingLevel };
        },
        sessionManager: ctx.sessionManager,
        getContextUsage: () => ctx.getContextUsage(),
        modelRuntime: {
          isUsingSubscription(providerId: string) {
            const model = ctx.model;
            return Boolean(
              model &&
              model.provider === providerId &&
              ctx.modelRegistry.isUsingOAuth(model) &&
              ctx.modelRegistry.getProvider(providerId)?.auth.oauth
                ?.isSubscription,
            );
          },
        },
      } as unknown as AgentSession;

      const footer = new FooterComponent(session, data);
      const refreshJJBookmark = async () => {
        jjBookmark =
          footerData.getGitBranch() === "detached"
            ? await closestJJBookmark(cwd)
            : undefined;
        tui.requestRender();
      };
      const unsubscribe = footerData.onBranchChange(() => {
        void refreshJJBookmark();
      });
      void refreshJJBookmark();

      return {
        invalidate: () => footer.invalidate(),
        dispose() {
          unsubscribe();
          footer.dispose();
        },
        render(width: number) {
          const lines = footer.render(width);

          // Customize here. By default this is identical to pi's built-in footer:
          // lines[0] = working directory, git branch, and session name
          // lines[1] = token usage, cost, context, model, and thinking level
          // lines[2] = extension statuses, when present; model details added below
          const stats = lines[1].replace(/^.*(\$)/, "$1");
          const padding = " ".repeat(Math.max(0, width - visibleWidth(stats)));
          lines[1] = theme.fg(
            "dim",
            stats.replace(/ {2,}/, (spaces) => spaces + padding),
          );

          const model = ctx.model;
          const modelDetails = model
            ? [
                `↑$${model.cost.input} ↓$${model.cost.output}`,
                ...model.input,
                ...(model.reasoning ? ["reasoning"] : []),
              ].join(" • ")
            : "";
          if (modelDetails) {
            lines[2] = rightAlign(
              lines[2] ?? "",
              theme.fg("dim", modelDetails),
              width,
            );
          }
          return lines;
        },
      };
    });
  });
}
