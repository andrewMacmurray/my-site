module Main exposing (main)

import Animator exposing (Animator)
import Config.Generated as Generated
import Config.Manifest as Manifest
import Config.Markdown as Markdown
import Date
import Element exposing (..)
import Element.Icon.Mail as Mail
import Element.Layout as Layout
import Frontmatter exposing (Frontmatter)
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Page.Article
import Page.BlogIndex as BlogIndex
import Page.Contact as Contact
import Page.Home as Home
import Pages exposing (PathKey, images)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Site exposing (..)
import Time



-- Program


main : Pages.Platform.Program Model Msg Frontmatter Rendered Pages.PathKey
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
        |> Pages.Platform.withFileGenerator Generated.files
        |> Pages.Platform.toProgram



-- Model


type alias Model =
    { mail : Animator.Timeline Mail.State
    }


type Msg
    = Tick Time.Posix


type alias Rendered =
    Element Msg



-- Init


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Cmd.none
    )


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
    Animator.animator
        |> Animator.watching .mail (\v model -> { model | mail = v })



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
        Frontmatter.Article frontmatter ->
            Page.Article.view frontmatter rendered

        Frontmatter.BlogIndex ->
            BlogIndex.view meta

        Frontmatter.Contact ->
            Contact.view model.mail

        Frontmatter.Home ->
            Home.view rendered


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]


head : Frontmatter -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Frontmatter.Article meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = siteLogo
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

                Frontmatter.Home ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = siteLogo
                        , description = Site.tagline
                        , locale = Nothing
                        , title = Site.tagline
                        }
                        |> Seo.website

                Frontmatter.Contact ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = siteLogo
                        , description = Site.tagline
                        , locale = Nothing
                        , title = Site.titleFor "contact"
                        }
                        |> Seo.website

                Frontmatter.BlogIndex ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = Site.name
                        , image = siteLogo
                        , description = Site.tagline
                        , locale = Nothing
                        , title = Site.titleFor "blog"
                        }
                        |> Seo.website
           )


siteLogo : Seo.Image PathKey
siteLogo =
    { url = images.siteLogo
    , alt = "Andrew MacMurray logo"
    , dimensions = Nothing
    , mimeType = Nothing
    }
