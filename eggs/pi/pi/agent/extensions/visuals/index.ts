import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import header from "./header.ts";
import footer from "./footer.ts";

export default function (pi: ExtensionAPI) {
  header(pi);
  footer(pi);
}
