import hljs from "highlight.js/lib/core";
import elm from "highlight.js/lib/languages/elm";
import javascript from "highlight.js/lib/languages/javascript";
import sql from "highlight.js/lib/languages/sql";
import kotlin from "highlight.js/lib/languages/kotlin";
import "highlight.js/styles/monokai.css";

// Register Languages

hljs.registerLanguage("elm", elm);
hljs.registerLanguage("javascript", javascript);
hljs.registerLanguage("sql", sql);
hljs.registerLanguage("kotlin", kotlin);

// Custom Element

class CodeElement extends HTMLElement {
  connectedCallback() {
    const code = this.querySelector("pre code") as HTMLElement;
    if (code) {
      hljs.highlightElement(code);
    }
  }
}

export function register() {
  if (window.customElements) {
    window.customElements.define("hljs-el", CodeElement);
  }
}
