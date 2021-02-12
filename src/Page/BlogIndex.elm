module Page.BlogIndex exposing (findColor, view)

import Date
import Element exposing (..)
import Element.Font as Font
import Element.Palette as Palette
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Page exposing (Page)
import Page.BlogPost as BlogPost
import Page.BlogPost.Color as BlogPost
import Pages.PagePath as PagePath exposing (PagePath)
import Site
import Utils.List as List



-- Color


findColor : Site.Metadata -> BlogPost.Frontmatter -> BlogPost.Color
findColor meta post =
    sortPosts meta
        |> List.indexedMap (\i p -> ( BlogPost.fromIndex i, p ))
        |> List.findFirst (\( _, p ) -> p.post.title == post.title)
        |> Maybe.map Tuple.first
        |> Maybe.withDefault BlogPost.defaultColor



-- View


view : Site.Metadata -> { title : String, body : List (Element msg) }
view meta =
    { title = Site.titleFor "blog"
    , body = [ view_ meta ]
    }


view_ : Site.Metadata -> Element msg
view_ posts =
    column
        [ width fill
        , spacing (Scale.extraLarge + Scale.medium)
        , paddingEach { edges | top = Scale.small }
        ]
        (posts
            |> sortPosts
            |> List.indexedMap viewPost
        )


sortPosts : Site.Metadata -> List BlogPost
sortPosts =
    List.filterMap getPost
        >> List.sortWith dateDescending
        >> List.filter (.post >> .draft >> not)


type alias BlogPost =
    { path : Site.Path
    , post : BlogPost.Frontmatter
    }


getPost : ( Site.Path, Page ) -> Maybe BlogPost
getPost ( path, frontmatter ) =
    case frontmatter of
        Page.BlogPost meta ->
            Just { path = path, post = meta }

        _ ->
            Nothing


dateDescending : BlogPost -> BlogPost -> Order
dateDescending p1 p2 =
    Date.compare p2.post.published p1.post.published


viewPost : Int -> BlogPost -> Element msg
viewPost i { path, post } =
    link [ width fill ]
        { url = PagePath.toString path
        , label = viewPost_ (BlogPost.fromIndex i) post
        }


viewPost_ : BlogPost.Color -> BlogPost.Frontmatter -> Element msg
viewPost_ color post =
    column
        [ centerX
        , width fill
        , spacing Scale.medium
        ]
        [ title color post.title
        , Text.date [] post.published
        , Text.paragraph [] [ Text.text [ Font.color Palette.grey ] post.description ]
        ]


title : BlogPost.Color -> String -> Element msg
title color text =
    paragraph [ spacing Scale.medium ] [ Text.title [ Font.color (BlogPost.color color) ] text ]
