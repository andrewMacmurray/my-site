import "./style.css";
import "./node_modules/highlight.js/styles/solarized-light.css";
import hljs from "highlight.js";

const { Elm } = require("./src/Main.elm");
const pagesInit = require("elm-pages");

class CodeElement extends HTMLElement {
  connectedCallback() {
    hljs.highlightBlock(this);
  }
}

window.customElements.define("hljs-el", CodeElement);

pagesInit({
  mainElmModule: Elm.Main,
});
