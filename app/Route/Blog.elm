module Route.Blog exposing (ActionData, Data, Model, Msg, RouteParams, route)

import BackendTask exposing (BackendTask)
import Config.Site
import Content.BlogPost as BlogPost
import Element exposing (..)
import Element.BlogPost.Color as BlogPostColor
import Element.Font as Font
import Element.Palette as Palette
import Element.Spacing as Spacing exposing (edges)
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
    { posts : List BlogPost.Metadata
    }


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
    BlogPost.all
        |> BackendTask.map (List.map .metadata)
        |> BackendTask.map Data


head : App Data ActionData RouteParams -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Config.Site.name
        , image = Config.Site.image
        , description = seoDescription
        , locale = Nothing
        , title = "Blog"
        }
        |> Seo.website


seoDescription : String
seoDescription =
    "Blog posts by Andrew MacMurray"



-- View


view : App Data ActionData RouteParams -> Shared.Model -> View (PagesMsg Msg)
view app _ =
    { title = Config.Site.withTitle "Blog"
    , body = [ view_ app.data ]
    }


view_ : Data -> Element msg
view_ posts =
    column
        [ width fill
        , spacing (Spacing.extraLarge + Spacing.medium)
        , paddingEach { edges | top = Spacing.small }
        ]
        (List.map viewPost posts.posts)


viewPost : BlogPost.Metadata -> Element msg
viewPost post =
    link [ width fill ]
        { url = BlogPost.url post
        , label = viewPost_ post
        }


viewPost_ : BlogPost.Metadata -> Element msg
viewPost_ post =
    column
        [ centerX
        , width fill
        , spacing Spacing.medium
        ]
        [ title post
        , Text.published [] post.status
        , Text.paragraph [] [ Text.tertiaryTitle [ Font.color Palette.grey ] (post.description ++ ".") ]
        ]


title : BlogPost.Metadata -> Element msg
title post =
    paragraph [ spacing Spacing.medium ]
        [ Text.title [ Font.color (BlogPostColor.color post.color) ] post.title
        ]
