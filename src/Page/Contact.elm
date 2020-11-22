module Page.Contact exposing (view)

import Animator
import Element exposing (..)
import Element.Icon.Mail as Mail
import Element.Scale as Scale exposing (edges)
import Element.Text as Text


view : Animator.Timeline Mail.State -> Element msg
view timeline =
    column
        [ paddingEach { edges | top = Scale.large + Scale.extraSmall }
        , spacing Scale.extraLarge
        ]
        [ Text.headline [ centerX ] "Get in touch"
        , el [ centerX ] (Mail.icon timeline)
        ]
