module Page.Home exposing (view)

import Element exposing (..)
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Metadata exposing (HomeMetadata)
import Utils.Element as Element exposing (style)


view : Maybe Float -> HomeMetadata -> Element msg
view screen meta =
    Element.maybe (view_ meta) screen


view_ : HomeMetadata -> Float -> Element msg
view_ meta screenHeight =
    column
        [ height (px (round screenHeight - 72))
        , style "animation" "fade-in 0.3s both"
        ]
        [ column
            [ paddingEach { edges | top = (round screenHeight // 5) - Scale.medium }
            , spacing Scale.extraLarge
            ]
            [ Text.headline "Hi I'm Andrew"
            , paragraph [ spacing Scale.small ] [ Text.text [] meta.blurb ]
            ]
        ]
