import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import header from "./header.ts";
import footer from "./footer.ts";
import highlighting from "./highlighting.ts";

export default function (pi: ExtensionAPI) {
  header(pi);
  footer(pi);
  highlighting(pi);
}
