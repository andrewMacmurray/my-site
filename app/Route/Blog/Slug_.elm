module Route.Blog.Slug_ exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Config.Contact as Contact
import Config.Site
import Content.BlogPost as BlogPost exposing (BlogPost)
import Element exposing (..)
import Element.BlogPost.Color as BlogPost
import Element.Font as Font
import Element.Icon.Mail as Mail
import Element.Markdown
import Element.Spacing as Spacing exposing (edges)
import Element.Text as Text
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import String.Extra
import Utils.Element
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : BackendTask FatalError (List RouteParams)
pages =
    BlogPost.all |> BackendTask.map (List.map (\post -> { slug = post.metadata.slug }))


type alias Data =
    { post : BlogPost
    }


type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data params =
    BackendTask.map Data (BlogPost.blogpostFromSlug params.slug)


head : App Data ActionData RouteParams -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Config.Site.name
        , image = Config.Site.image
        , description = app.data.post.metadata.description
        , locale = Nothing
        , title = app.data.post.metadata.title
        }
        |> Seo.website


view : App Data ActionData RouteParams -> Shared.Model -> View (PagesMsg Msg)
view app _ =
    let
        meta : BlogPost.Metadata
        meta =
            app.data.post.metadata
    in
    { title = meta.title
    , body =
        [ column
            [ spacing Spacing.large
            , paddingEach { edges | top = Spacing.small, bottom = Spacing.extraSmall }
            ]
            [ title meta
            , Text.published [ Font.color (BlogPost.color meta.color) ] meta.status
            , paragraph [ spacing Spacing.small ] [ Text.subtitle [ Font.color (BlogPost.color meta.color) ] meta.description ]
            ]
        , Element.Markdown.view app.data.post.body
        , getInTouch meta
        , previousAndNext app.data.post
        ]
    }


title : BlogPost.Metadata -> Element msg
title meta =
    paragraph [ spacing Spacing.large ]
        [ Text.headline [ Font.color (BlogPost.color meta.color) ] (String.Extra.toTitleCase meta.title)
        ]


getInTouch : BlogPost.Metadata -> Element msg
getInTouch meta =
    newTabLink []
        { url = Contact.mailTo { subject = meta.title }
        , label =
            column [ spacing Spacing.medium ]
                [ Text.tertiaryTitle [ Font.color (BlogPost.color meta.color) ] "Have some thoughts? "
                , Text.tertiaryTitle [ Font.color (BlogPost.color meta.color), Font.underline ] "Let me know in an email"
                , el [] Mail.icon
                ]
        }


previousAndNext : BlogPost -> Element msg
previousAndNext post =
    row [ width fill ]
        [ Utils.Element.maybe (linkToPost post "< Previous Post" [ alignLeft ]) post.previousPost
        , Utils.Element.maybe (linkToPost post "Next Post >" [ alignRight ]) post.nextPost
        ]


linkToPost : BlogPost -> String -> List (Attribute msg) -> BlogPost.Metadata -> Element msg
linkToPost post name attrs meta =
    link attrs
        { url = BlogPost.url meta
        , label = Text.tertiaryTitle [ Font.color (BlogPost.color post.metadata.color) ] name
        }
