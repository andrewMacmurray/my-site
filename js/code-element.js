import hljs from "highlight.js/lib/core";
import "../node_modules/highlight.js/styles/a11y-dark.css";

// Register Languages

registerLanguage("elm");
registerLanguage("javascript");
registerLanguage("sql");
registerLanguage("kotlin");

function registerLanguage(lang) {
  hljs.registerLanguage(lang, require(`highlight.js/lib/languages/${lang}`));
}

// Custom Element

class CodeElement extends HTMLElement {
  connectedCallback() {
    hljs.highlightBlock(this);
  }
}

export function register() {
  if (window.customElements) {
    window.customElements.define("hljs-el", CodeElement);
  }
}
