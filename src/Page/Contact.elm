module Page.Contact exposing (view)

import Animator
import Element exposing (..)
import Element.Animation as Animation
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
        [ Text.headline [ centerX ] "Get in touch"
        , el [ centerX, Animation.fadeIn ] (Mail.icon timeline)
        ]
