module Page.BlogIndex exposing (view)

import Date
import Element exposing (..)
import Element.Animation as Animation
import Element.Border as Border
import Element.Font as Font
import Element.Palette as Palette
import Element.Scale as Scale
import Element.Text as Text
import Page exposing (Page)
import Page.BlogPost as BlogPost
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Site



-- View


view : Site.Metadata -> { title : String, body : List (Element msg) }
view meta =
    { title = Site.titleFor "blog"
    , body = [ column [ centerX, width fill ] [ view_ meta ] ]
    }


view_ : Site.Metadata -> Element msg
view_ posts =
    column
        [ Animation.fadeIn
        , width fill
        , spacing Scale.medium
        ]
        (posts
            |> List.filterMap getPost
            |> List.sortWith dateDescending
            |> List.map toSummary
        )


type alias BlogPost =
    ( Site.Path, BlogPost.Frontmatter )


getPost : ( Site.Path, Page ) -> Maybe BlogPost
getPost ( path, frontmatter ) =
    case frontmatter of
        Page.BlogPost meta ->
            Just ( path, meta )

        _ ->
            Nothing


dateDescending : BlogPost -> BlogPost -> Order
dateDescending ( _, metadata1 ) ( _, metadata2 ) =
    Date.compare metadata2.published metadata1.published


toSummary : BlogPost -> Element msg
toSummary ( postPath, post ) =
    postIndex post |> linkToPost postPath


linkToPost : PagePath Pages.PathKey -> Element msg -> Element msg
linkToPost postPath content =
    link [ width fill ]
        { url = PagePath.toString postPath
        , label = content
        }


title : String -> Element msg
title text =
    paragraph [] [ Text.title [ Font.color Palette.grey ] text ]


postIndex : BlogPost.Frontmatter -> Element msg
postIndex metadata =
    el
        [ centerX
        , width (maximum 800 fill)
        , padding Scale.medium
        , spacing Scale.medium
        , Border.width 1
        , Border.color (rgba255 0 0 0 0.1)
        , mouseOver [ Border.color (rgba255 0 0 0 1) ]
        ]
        (postPreview metadata)


readMoreLink : Element msg
readMoreLink =
    Text.tertiaryTitle [] "Continue reading >>"


postPreview : BlogPost.Frontmatter -> Element msg
postPreview post =
    textColumn
        [ centerX
        , width fill
        , spacing Scale.medium
        ]
        [ title post.title
        , Text.date post.published
        , paragraph [] [ Text.tertiaryTitle [] post.description ]
        , readMoreLink
        ]
