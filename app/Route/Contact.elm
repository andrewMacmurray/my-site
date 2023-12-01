module Route.Contact exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Config.Contact as Contact
import Config.Site
import Element exposing (..)
import Element.Icon.Github as Github
import Element.Icon.Mail as Mail
import Element.Spacing as Spacing
import Element.Text as Text
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    {}


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.succeed {}


head : App Data ActionData RouteParams -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Config.Site.name
        , image = Config.Site.image
        , description = seoDescription
        , locale = Nothing
        , title = "Contact"
        }
        |> Seo.website


seoDescription : String
seoDescription =
    "Say hi, send me an email or follow me on Github"


view : App Data ActionData RouteParams -> Shared.Model -> View (PagesMsg Msg)
view _ _ =
    { title = Config.Site.withTitle "Contact"
    , body =
        [ Text.headline [ centerX ] "Say Hi"
        , column [ centerX, spacing Spacing.extraLarge ]
            [ link [ centerX ]
                { url = Contact.mailTo { subject = "Hi" }
                , label =
                    column [ centerX, spacing Spacing.medium ]
                        [ el [ centerX, moveUp 2 ] Mail.icon
                        , Text.tertiaryTitle [ centerX ] "Send me an email"
                        , Text.link_ Contact.email
                        ]
                }
            , newTabLink [ centerX ]
                { url = Contact.github.url
                , label =
                    column [ centerX, spacing Spacing.medium ]
                        [ el [ centerX ] Github.large
                        , Text.tertiaryTitle [ centerX ] "Follow me on Github"
                        , el [ centerX ] (Text.link_ Contact.github.handle)
                        ]
                }
            ]
        ]
    }
