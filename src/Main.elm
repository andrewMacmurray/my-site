module Main exposing (main)

import Browser.Dom as Dom exposing (Viewport)
import Browser.Events
import Color
import Data.Author as Author
import Date
import Element exposing (..)
import Element.Font as Font
import Element.Text as Text
import Feed
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Json.Decode
import Layout
import Markdown.Parser
import Markdown.Renderer
import Metadata exposing (Metadata)
import MySitemap
import Page.Article
import Page.BlogIndex as BlogIndex
import Page.Home as Home
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Task


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "elm-pages-starter - A statically typed site generator."
    , iarcRatingId = Nothing
    , name = "elm-pages-starter"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "elm-pages-starter"
    , sourceIcon = images.iconPng
    , icons = []
    }


type alias Rendered =
    Element Msg


main : Pages.Platform.Program Model Msg Metadata Rendered Pages.PathKey
main =
    Pages.Platform.init
        { init = always init
        , view = view
        , update = update
        , subscriptions = always (always subscriptions)
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = Nothing
        , internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator generateFiles
        |> Pages.Platform.toProgram


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    -> StaticHttp.Request (List (Result String { path : List String, content : String }))
generateFiles siteMetadata =
    StaticHttp.succeed
        (List.map Ok
            [ Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata
            , MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata
            ]
        )


markdownDocument : { extension : String, metadata : Json.Decode.Decoder Metadata, body : String -> Result error (Element msg) }
markdownDocument =
    { extension = "md"
    , metadata = Metadata.decoder
    , body =
        \markdownBody ->
            Markdown.Parser.parse markdownBody
                |> Result.withDefault []
                |> Markdown.Renderer.render Markdown.Renderer.defaultHtmlRenderer
                |> Result.withDefault [ Html.text "" ]
                |> Html.div []
                |> html
                |> List.singleton
                |> paragraph [ width fill ]
                |> Ok
    }


type alias Model =
    { screenHeight : Float }


init : ( Model, Cmd Msg )
init =
    ( initialModel
    , Task.perform ViewportReceived Dom.getViewport
    )


initialModel : Model
initialModel =
    { screenHeight = 0
    }


type Msg
    = ViewportReceived Viewport
    | ScreenResized Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ViewportReceived vp ->
            ( { model | screenHeight = vp.viewport.height }, Cmd.none )

        ScreenResized h ->
            ( { model | screenHeight = toFloat h }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize (always ScreenResized)


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
        Metadata.Page metadata ->
            { title = metadata.title
            , body = [ viewForPage ]
            }

        Metadata.Article metadata ->
            Page.Article.view metadata viewForPage

        Metadata.Author author ->
            { title = author.name
            , body =
                [ Text.headline author.name
                , Author.view [] author
                , paragraph [ centerX, Font.center ] [ viewForPage ]
                ]
            }

        Metadata.BlogIndex ->
            { title = "elm-pages blog"
            , body = [ column [ centerX ] [ BlogIndex.view siteMetadata ] ]
            }

        Metadata.Home meta ->
            { title = "elm-pages"
            , body = [ column [ centerX ] [ Home.view model.screenHeight meta ] ]
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
                Metadata.Page meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages-starter"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.Article meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages starter"
                        , image =
                            { url = meta.image
                            , alt = meta.description
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.description
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.article
                            { tags = []
                            , section = Nothing
                            , publishedTime = Just (Date.toIsoString meta.published)
                            , modifiedTime = Nothing
                            , expirationTime = Nothing
                            }

                Metadata.Author meta ->
                    let
                        ( firstName, lastName ) =
                            case meta.name |> String.split " " of
                                [ first, last ] ->
                                    ( first, last )

                                [ first, middle, last ] ->
                                    ( first ++ " " ++ middle, last )

                                [] ->
                                    ( "", "" )

                                _ ->
                                    ( meta.name, "" )
                    in
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages-starter"
                        , image =
                            { url = meta.avatar
                            , alt = meta.name ++ "'s elm-pages articles."
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.bio
                        , locale = Nothing
                        , title = meta.name ++ "'s elm-pages articles."
                        }
                        |> Seo.profile
                            { firstName = firstName
                            , lastName = lastName
                            , username = Nothing
                            }

                Metadata.Home _ ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = "elm-pages"
                        }
                        |> Seo.website

                Metadata.BlogIndex ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = "elm-pages blog"
                        }
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://elm-pages-starter.netlify.com"


siteTagline : String
siteTagline =
    "Starter blog for elm-pages"
