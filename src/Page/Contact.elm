module Page.Contact exposing (view)

import Animator
import Element exposing (..)
import Element.Font as Font
import Element.Icon.Mail as Mail
import Element.Scale as Scale
import Element.Text as Text
import Site


view : Animator.Timeline Mail.State -> { title : String, body : List (Element msg) }
view timeline =
    { title = Site.titleFor "contact"
    , body = view_ timeline
    }


view_ : Animator.Timeline Mail.State -> List (Element msg)
view_ timeline =
    [ Text.headline [ centerX ] "Say Hi"
    , column [ centerX, spacing Scale.medium ]
        [ Text.subtitle [ Font.center ] "Send me an email"
        , el [ centerX ] (Mail.icon timeline)
        ]
    ]
