module Page.Home exposing (view)

import Element exposing (..)
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Metadata exposing (HomeMetadata)


view : Float -> HomeMetadata -> Element msg
view screenHeight meta =
    column [ height (px (round screenHeight - 72)) ]
        [ column
            [ paddingEach { edges | top = round screenHeight // 5 }
            , spacing Scale.extraLarge
            ]
            [ el [ centerX ] (Text.headline "Hi I'm Andrew")
            , paragraph [ spacing Scale.small ] [ Text.text [] meta.blurb ]
            ]
        ]
