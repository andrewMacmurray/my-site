module Page.Contact exposing (view)

import Animator
import Element exposing (..)
import Element.Icon.Github as Github
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
    , column [ centerX, spacing Scale.extraLarge ]
        [ link [ centerX ]
            { url = "mailto:a.macmurray@icloud.com?subject=Hi"
            , label =
                column [ centerX, spacing Scale.medium ]
                    [ el [ centerX ] (Mail.icon timeline)
                    , Text.tertiaryTitle [ centerX ] "Send me an email"
                    , Text.link_ "a.macmurray@icloud.com"
                    ]
            }
        , newTabLink [ centerX ]
            { url = "https://github.com/andrewMacmurray"
            , label =
                column [ centerX, spacing Scale.medium ]
                    [ el [ centerX ] Github.icon
                    , Text.tertiaryTitle [ centerX ] "Follow me on Github"
                    , el [ centerX ] (Text.link_ "@andrewMacmurray")
                    ]
            }
        ]
    ]
