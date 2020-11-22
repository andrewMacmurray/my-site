module Main exposing (main)

import Animator exposing (Animator)
import Browser.Dom as Dom exposing (Viewport)
import Browser.Events
import Config.Manifest as Manifest
import Config.RssFeed as RssFeed
import Config.Sitemap as Sitemap
import Date
import Element exposing (..)
import Element.Icon.Mail as Mail
import Element.Layout as Layout
import Element.Markdown as Markdown
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Json.Decode
import Metadata exposing (Metadata)
import Page.Article
import Page.BlogIndex as BlogIndex
import Page.Contact as Contact
import Page.Home as Home
import Pages exposing (PathKey, images)
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Task
import Time



-- Program


main : Pages.Platform.Program Model Msg Metadata Rendered Pages.PathKey
main =
    Pages.Platform.init
        { init = always init
        , view = view
        , update = update
        , subscriptions = always (always subscriptions)
        , documents = [ markdownDocument ]
        , manifest = Manifest.build
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = Nothing
        , internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator generateFiles
        |> Pages.Platform.toProgram


generateFiles :
    List { path : PagePath Pages.PathKey, frontmatter : Metadata, body : String }
    -> StaticHttp.Request (List (Result String { path : List String, content : String }))
generateFiles siteMetadata =
    StaticHttp.succeed
        (List.map Ok
            [ RssFeed.build { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata
            , Sitemap.build { siteUrl = canonicalSiteUrl } siteMetadata
            ]
        )


markdownDocument : { extension : String, metadata : Json.Decode.Decoder Metadata, body : String -> Result error (Element msg) }
markdownDocument =
    { extension = "md"
    , metadata = Metadata.decoder
    , body = Markdown.view >> Ok
    }



-- Model


type alias Model =
    { screenHeight : Maybe Float
    , mail : Animator.Timeline Mail.State
    }


type Msg
    = ViewportReceived Viewport
    | ScreenResized Int
    | Tick Time.Posix


type alias Rendered =
    Element Msg



-- Init


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Task.perform ViewportReceived Dom.getViewport
    )


initialModel : Model
initialModel =
    { screenHeight = Nothing
    , mail = Animator.init Mail.Packing |> Mail.sequence
    }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ViewportReceived vp ->
            ( { model | screenHeight = Just vp.viewport.height }, Cmd.none )

        ScreenResized h ->
            ( { model | screenHeight = Just (toFloat h) }, Cmd.none )

        Tick time ->
            ( Animator.update time animator model, Cmd.none )



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Browser.Events.onResize (always ScreenResized)
        , Animator.toSubscription Tick model animator
        ]


animator : Animator Model
animator =
    Animator.animator
        |> Animator.watching .mail (\v model -> { model | mail = v })



-- View


view :
    List ( PagePath Pages.PathKey, Metadata )
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    StaticHttp.succeed
        { view = \model viewForPage -> Layout.view (pageView model siteMetadata page viewForPage) page
        , head = head page.frontmatter
        }


pageView :
    Model
    -> List ( PagePath Pages.PathKey, Metadata )
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> Rendered
    -> { title : String, body : List (Element Msg) }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Article metadata ->
            Page.Article.view metadata viewForPage

        Metadata.BlogIndex ->
            { title = "andrew-macmurray blog"
            , body = [ column [ centerX ] [ BlogIndex.view siteMetadata ] ]
            }

        Metadata.Contact ->
            { title = "andrew-macmurray contact"
            , body = [ column [ centerX ] [ Contact.view model.mail ] ]
            }

        Metadata.Home ->
            { title = "andrew-macmurray"
            , body = [ column [ centerX ] [ Home.view viewForPage model.screenHeight ] ]
            }


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]


head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Article meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = siteName
                        , image = siteLogo
                        , description = meta.description
                        , locale = Nothing
                        , title = seoTitle meta.title
                        }
                        |> Seo.article
                            { tags = []
                            , section = Nothing
                            , publishedTime = Just (Date.toIsoString meta.published)
                            , modifiedTime = Nothing
                            , expirationTime = Nothing
                            }

                Metadata.Home ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = siteName
                        , image = siteLogo
                        , description = siteTagline
                        , locale = Nothing
                        , title = siteTagline
                        }
                        |> Seo.website

                Metadata.Contact ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = siteName
                        , image = siteLogo
                        , description = siteTagline
                        , locale = Nothing
                        , title = seoTitle "contact"
                        }
                        |> Seo.website

                Metadata.BlogIndex ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = siteName
                        , image = siteLogo
                        , description = siteTagline
                        , locale = Nothing
                        , title = seoTitle "blog"
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


seoTitle : String -> String
seoTitle page =
    siteName ++ " - " ++ page


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://inspiring-swirles-26bb31.netlify.app/"


siteTagline : String
siteTagline =
    "Andrew MacMurray"


siteName : String
siteName =
    "andrew-macmurray"
