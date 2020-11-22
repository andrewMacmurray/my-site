module Element.Icon exposing (large)

import Element exposing (el, html, px, width)
import Svg exposing (Svg)


large : Svg msg -> Element.Element msg
large =
    html >> el [ width (px 65) ]
