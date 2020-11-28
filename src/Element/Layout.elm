module Element.Layout exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Palette as Palette
import Element.Region as Region
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Html exposing (Html)
import Page exposing (Page)
import Pages
import Pages.Directory as Directory exposing (Directory)
import Pages.PagePath as PagePath exposing (PagePath)
import Utils.Element exposing (style)


view :
    { title : String, body : List (Element msg) }
    -> { path : PagePath Pages.PathKey, frontmatter : Page }
    -> { title : String, body : Html msg }
view document page =
    { title = document.title
    , body = layout document page
    }


layout : { a | body : List (Element msg) } -> { b | path : PagePath Pages.PathKey } -> Html msg
layout document page =
    layoutWrapper
        (column
            [ width fill, spacing Scale.large ]
            [ header page.path
            , column
                [ paddingEach { edges | left = Scale.medium, right = Scale.medium, bottom = Scale.extraLarge }
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
        , Text.bodyFont
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
                [ highlightableLink currentPath Pages.pages.blog.directory "blog"
                , highlightableLink_ currentPath Pages.pages.contact "contact"
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
        , label = Text.subtitle [ Font.color Palette.black ] label
        }


highlightableLink : PagePath Pages.PathKey -> Directory Pages.PathKey Directory.WithIndex -> String -> Element msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            Directory.includes linkDirectory currentPath
    in
    withHighlight isHighlighted
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Text.subtitle [ Font.color Palette.black ] displayName
        }


withHighlight : Bool -> { url : String, label : Element msg } -> Element msg
withHighlight isHighlight =
    if isHighlight then
        link [ Font.underline, mouseOver [ Font.color Palette.grey ] ]

    else
        link [ mouseOver [ Font.color Palette.grey ] ]
