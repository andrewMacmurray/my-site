module Page.Contact exposing (view)

import Element exposing (..)
import Element.Icon.Mail as Mail
import Element.Scale as Scale exposing (edges)
import Element.Text as Text


view : Element msg
view =
    column
        [ paddingEach { edges | top = Scale.large + Scale.extraSmall }
        , spacing Scale.extraLarge
        ]
        [ Text.headline [] "Get in touch"
        , el [ centerX ] Mail.icon
        ]
