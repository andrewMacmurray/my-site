module Page.BlogIndex exposing (view)

import Date
import Element exposing (..)
import Element.Border
import Element.Font
import Element.Scale as Scale
import Frontmatter exposing (Frontmatter)
import Page.Article as Article
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Site


type alias PostEntry =
    ( Site.Path, Article.Frontmatter )


view : Site.Metadata -> { title : String, body : List (Element msg) }
view meta =
    { title = Site.titleFor "blog"
    , body = [ column [ centerX ] [ view_ meta ] ]
    }


view_ : Site.Metadata -> Element msg
view_ posts =
    Element.column [ spacing Scale.medium ]
        (posts
            |> List.filterMap
                (\( path, metadata ) ->
                    case metadata of
                        Frontmatter.Article meta ->
                            Just ( path, meta )

                        _ ->
                            Nothing
                )
            |> List.sortWith postPublishDateDescending
            |> List.map postSummary
        )


postPublishDateDescending : PostEntry -> PostEntry -> Order
postPublishDateDescending ( _, metadata1 ) ( _, metadata2 ) =
    Date.compare metadata2.published metadata1.published


postSummary : PostEntry -> Element msg
postSummary ( postPath, post ) =
    articleIndex post |> linkToPost postPath


linkToPost : PagePath Pages.PathKey -> Element msg -> Element msg
linkToPost postPath content =
    Element.link [ Element.width Element.fill ]
        { url = PagePath.toString postPath
        , label = content
        }


title : String -> Element msg
title text =
    [ Element.text text ]
        |> Element.paragraph
            [ Element.Font.size 36
            , Element.Font.center
            , Element.Font.semiBold
            , Element.padding 16
            ]


articleIndex : Article.Frontmatter -> Element msg
articleIndex metadata =
    Element.el
        [ Element.centerX
        , Element.width (Element.maximum 800 Element.fill)
        , Element.padding 40
        , Element.spacing 10
        , Element.Border.width 1
        , Element.Border.color (Element.rgba255 0 0 0 0.1)
        , Element.mouseOver
            [ Element.Border.color (Element.rgba255 0 0 0 1)
            ]
        ]
        (postPreview metadata)


readMoreLink : Element msg
readMoreLink =
    Element.text "Continue reading >>"
        |> Element.el
            [ Element.centerX
            , Element.Font.size 18
            , Element.alpha 0.6
            , Element.mouseOver [ Element.alpha 1 ]
            , Element.Font.underline
            , Element.Font.center
            ]


postPreview : Article.Frontmatter -> Element msg
postPreview post =
    Element.textColumn
        [ Element.centerX
        , Element.width Element.fill
        , Element.spacing 30
        , Element.Font.size 18
        ]
        [ title post.title
        , Element.row [ Element.spacing 10, Element.centerX ]
            [ Element.text "•"
            , Element.text (Date.format "MMMM ddd, yyyy" post.published)
            ]
        , post.description
            |> Element.text
            |> List.singleton
            |> Element.paragraph
                [ Element.Font.size 22
                , Element.Font.center
                ]
        , readMoreLink
        ]
