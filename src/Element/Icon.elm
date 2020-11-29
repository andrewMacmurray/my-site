module Element.Icon exposing
    ( large
    , small
    )

import Element exposing (el, html, px, width)
import Element.Scale as Scale
import Svg exposing (Svg)


large : Svg msg -> Element.Element msg
large =
    html >> el [ width (px 50) ]


small : Svg msg -> Element.Element msg
small =
    html >> el [ width (px Scale.large) ]
