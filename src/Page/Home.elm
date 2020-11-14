module Page.Home exposing (view)

import Element exposing (..)
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Utils.Element as Element exposing (style)


view : Element msg -> Maybe Float -> Element msg
view content =
    Element.maybe (view_ content)


view_ : Element msg -> Float -> Element msg
view_ content screenHeight =
    column
        [ height (px (round screenHeight - 72 - Scale.medium))
        , style "animation" "fade-in 0.3s both"
        ]
        [ column
            [ paddingEach { edges | top = Scale.large + Scale.extraSmall }
            , spacing Scale.extraLarge
            ]
            [ Text.headline [] "Hi I'm Andrew"
            , paragraph [ spacing Scale.small ] [ content ]
            ]
        ]
