import hljs from "highlight.js";
import "../node_modules/highlight.js/styles/solarized-light.css";

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
