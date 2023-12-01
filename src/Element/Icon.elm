module Element.Icon exposing
    ( large
    , small
    )

import Element exposing (el, html, px, width)
import Element.Spacing as Spacing
import Svg exposing (Svg)


large : Svg msg -> Element.Element msg
large =
    html >> el [ width (px 50) ]


small : Svg msg -> Element.Element msg
small =
    html >> el [ width (px Spacing.large) ]
