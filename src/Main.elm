module Main exposing (main)

import Animator exposing (Animator)
import Date
import Document.Markdown as Markdown
import Element exposing (..)
import Element.Icon.Mail as Mail
import Element.Layout as Layout
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Page exposing (Page)
import Page.BlogIndex as BlogIndex
import Page.BlogPost as BlogPost
import Page.Contact as Contact
import Page.Home as Home
import Pages exposing (PathKey)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Site
import Site.Files as Files
import Site.Manifest as Manifest
import Time



-- Program


main : Pages.Platform.Program Model Msg Page Rendered Pages.PathKey
main =
    Pages.Platform.init
        { init = always init
        , view = view
        , update = update
        , subscriptions = always (always subscriptions)
        , documents = [ Markdown.document ]
        , manifest = Manifest.build
        , canonicalSiteUrl = Site.url
        , onPageChange = Nothing
        , internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator Files.generate
        |> Pages.Platform.toProgram



-- Model


type alias Model =
    { mail : Mail.Animation
    }


type Msg
    = Tick Time.Posix


type alias Rendered =
    Element Msg



-- Init


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )


initialModel : Model
initialModel =
    { mail = Mail.init
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( Animator.update time animator model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Animator.toSubscription Tick model animator


animator : Animator Model
animator =
    Animator.animator |> Animator.watching .mail (\v model -> { model | mail = v })



-- View


type alias View =
    { view : Model -> Rendered -> { title : String, body : Html Msg }
    , head : List Site.HeadTag
    }


view : Site.Metadata -> Site.Page -> StaticHttp.Request View
view meta page =
    StaticHttp.succeed
        { view = \model rendered -> Layout.view (pageView model meta page rendered) page
        , head = head page.frontmatter
        }


pageView : Model -> Site.Metadata -> Site.Page -> Rendered -> { title : String, body : List (Element Msg) }
pageView model meta page rendered =
    case page.frontmatter of
        Page.BlogPost page_ ->
            BlogPost.view model.mail (BlogIndex.findColor meta page_) page_ rendered

        Page.BlogIndex ->
            BlogIndex.view meta

        Page.Contact ->
            Contact.view model.mail

        Page.Home ->
            Home.view



-- Head


head : Page -> List Site.HeadTag
head metadata =
    commonHeadTags
        ++ (case metadata of
                Page.BlogPost meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = Site.logo
                        , description = meta.description
                        , locale = Nothing
                        , title = Site.titleFor meta.title
                        }
                        |> Seo.article
                            { tags = []
                            , section = Nothing
                            , publishedTime = Just (Date.toIsoString meta.published)
                            , modifiedTime = Nothing
                            , expirationTime = Nothing
                            }

                Page.Home ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = Site.logo
                        , description = Site.tagline
                        , locale = Nothing
                        , title = Site.tagline
                        }
                        |> Seo.website

                Page.Contact ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = Site.logo
                        , description = Site.tagline
                        , locale = Nothing
                        , title = Site.titleFor "contact"
                        }
                        |> Seo.website

                Page.BlogIndex ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = Site.logo
                        , description = Site.tagline
                        , locale = Nothing
                        , title = Site.titleFor "blog"
                        }
                        |> Seo.website
           )


commonHeadTags : List Site.HeadTag
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]
