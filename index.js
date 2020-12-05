import "./css/style.css";
import { Elm } from "./src/Main.elm";
import pagesInit from "elm-pages";
import * as CodeElement from "./js/code-element";

CodeElement.register();

pagesInit({
  mainElmModule: Elm.Main,
});
