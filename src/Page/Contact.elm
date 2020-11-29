module Page.Contact exposing (view)

import Element exposing (..)
import Element.Icon.Github as Github
import Element.Icon.Mail as Mail
import Element.Scale as Scale
import Element.Text as Text
import Site
import Site.Contact as Contact


view : Mail.Animation -> { title : String, body : List (Element msg) }
view timeline =
    { title = Site.titleFor "contact"
    , body = view_ timeline
    }


view_ : Mail.Animation -> List (Element msg)
view_ timeline =
    [ Text.headline [ centerX ] "Say Hi"
    , column [ centerX, spacing Scale.extraLarge ]
        [ link [ centerX ]
            { url = Contact.mailTo { subject = "Hi" }
            , label =
                column [ centerX, spacing Scale.medium ]
                    [ el [ centerX ] (Mail.icon timeline)
                    , Text.tertiaryTitle [ centerX ] "Send me an email"
                    , Text.link_ Contact.email
                    ]
            }
        , newTabLink [ centerX ]
            { url = Contact.github.url
            , label =
                column [ centerX, spacing Scale.medium ]
                    [ el [ centerX ] Github.icon
                    , Text.tertiaryTitle [ centerX ] "Follow me on Github"
                    , el [ centerX ] (Text.link_ Contact.github.handle)
                    ]
            }
        ]
    ]
