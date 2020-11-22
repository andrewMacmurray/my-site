module Page.Contact exposing (view)

import Animator
import Element exposing (..)
import Element.Animation as Animation
import Element.Font as Font
import Element.Icon.Mail as Mail
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Site


view : Animator.Timeline Mail.State -> { title : String, body : List (Element msg) }
view timeline =
    { title = Site.titleFor "contact"
    , body = [ column [ centerX ] [ view_ timeline ] ]
    }


view_ : Animator.Timeline Mail.State -> Element msg
view_ timeline =
    column
        [ paddingEach { edges | top = Scale.large + Scale.extraSmall }
        , spacing Scale.extraLarge
        ]
        [ Text.headline [ centerX ] "Say Hi"
        , column [ centerX, Animation.fadeIn, spacing Scale.medium ]
            [ Text.subtitle [ Font.center ] "Send me an email"
            , el [ centerX ] (Mail.icon timeline)
            ]
        ]
