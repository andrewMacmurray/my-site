module Layout exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Palette as Palette
import Element.Region as Region
import Element.Scale as Scale
import Element.Text as Text
import Html exposing (Html)
import Metadata exposing (Metadata)
import Pages
import Pages.Directory as Directory exposing (Directory)
import Pages.PagePath as PagePath exposing (PagePath)
import Utils.Element exposing (style)


view :
    { title : String, body : List (Element msg) }
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> { title : String, body : Html msg }
view document page =
    { title = document.title
    , body = layout document page
    }


layout : { a | body : List (Element msg) } -> { b | path : PagePath Pages.PathKey } -> Html msg
layout document page =
    layoutWrapper
        (column
            [ width fill ]
            [ header page.path
            , column
                [ paddingXY Scale.small 0
                , spacing Scale.large
                , Region.mainContent
                , width (fill |> maximum 800)
                , centerX
                ]
                document.body
            ]
        )


layoutWrapper : Element msg -> Html msg
layoutWrapper =
    Element.layout
        [ width fill
        , Font.family
            [ Font.typeface "Roboto Mono"
            , Font.typeface "monospace"
            ]
        , Font.color (rgba255 0 0 0 0.8)
        ]


header : PagePath Pages.PathKey -> Element msg
header currentPath =
    column [ width fill ]
        [ row
            [ padding Scale.medium
            , spaceEvenly
            , width fill
            , Region.navigation
            ]
            [ link [] { url = "/", label = dot }
            , row [ spacing Scale.medium ]
                [ highlightableLink_ currentPath Pages.pages.about "about"
                , highlightableLink currentPath Pages.pages.blog.directory "blog"
                ]
            ]
        ]


dot : Element msg
dot =
    row [ spacing Scale.extraSmall ]
        [ el [] (text "a")
        , el [ inFront (el [ style "animation" "2s expand-fade infinite" ] dot_) ] dot_
        ]


dot_ : Element msg
dot_ =
    el
        [ Background.color Palette.black
        , Border.rounded 1000
        , width (px Scale.medium)
        , height (px Scale.medium)
        ]
        none


highlightableLink_ : PagePath a -> PagePath b -> String -> Element msg
highlightableLink_ current path label =
    withHighlight (PagePath.toString path == PagePath.toString current)
        { url = PagePath.toString path
        , label = Text.subtitle [] label
        }


highlightableLink : PagePath Pages.PathKey -> Directory Pages.PathKey Directory.WithIndex -> String -> Element msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            Directory.includes linkDirectory currentPath
    in
    withHighlight isHighlighted
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Text.subtitle [] displayName
        }


withHighlight : Bool -> { url : String, label : Element msg } -> Element msg
withHighlight isHighlight =
    if isHighlight then
        link [ Font.underline, mouseOver [ Font.color Palette.grey ] ]

    else
        link [ mouseOver [ Font.color Palette.grey ] ]
