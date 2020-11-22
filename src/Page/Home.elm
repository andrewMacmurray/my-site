module Page.Home exposing (view)

import Element exposing (..)
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Site
import Utils.Element exposing (style)


view : Element msg -> { title : String, body : List (Element msg) }
view content =
    { title = Site.name
    , body = [ column [ centerX ] [ view_ content ] ]
    }


view_ : Element msg -> Element msg
view_ content =
    column
        [ style "animation" "fade-in 0.3s both"
        ]
        [ column
            [ paddingEach { edges | top = Scale.large + Scale.extraSmall }
            , spacing Scale.extraLarge
            ]
            [ Text.headline [ centerX ] "Hi I'm Andrew"
            , paragraph [ spacing Scale.small ] [ content ]
            ]
        ]
