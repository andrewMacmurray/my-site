module Element.Layout exposing (view)

import Config.Contact as Contact
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Icon.Github as Github
import Element.Icon.SmallMail as SmallMail
import Element.Palette as Palette
import Element.Region as Region
import Element.Spacing as Spacing exposing (edges)
import Element.Text as Text
import Html exposing (Html)
import Route
import Simple.Animation as Animation exposing (Animation)
import Simple.Animation.Property as P
import Time
import Utils.Animated as Animated


view : Time.Posix -> { title : String, body : List (Element msg) } -> { title : String, body : List (Html msg) }
view time document =
    { title = document.title
    , body = [ layout time document ]
    }


layout : Time.Posix -> { a | body : List (Element msg) } -> Html msg
layout time document =
    layoutWrapper
        (column
            [ width fill, height fill, spacing Spacing.large ]
            [ header
            , column
                [ paddingEach { edges | left = Spacing.medium, right = Spacing.medium, bottom = Spacing.extraLarge }
                , spacing Spacing.large
                , Region.mainContent
                , width (fill |> maximum 800)
                , height fill
                , centerX
                ]
                [ pageWrapper document.body ]
            , footer time
            ]
        )


footer : Time.Posix -> Element msg
footer time =
    row [ width fill, paddingXY Spacing.medium Spacing.small ]
        [ Text.label [ Font.color Palette.grey ] (viewCopyright time)
        , row
            [ spacing Spacing.medium
            , alignRight
            , alignBottom
            ]
            [ newTabLink [] { label = Github.small, url = Contact.github.url }
            , link [] { label = SmallMail.icon, url = Contact.mailTo { subject = "Hi" } }
            ]
        ]


viewCopyright : Time.Posix -> String
viewCopyright time =
    "© Andrew MacMurray " ++ viewYear time


viewYear : Time.Posix -> String
viewYear =
    Time.toYear Time.utc >> String.fromInt


pageWrapper : List (Element msg) -> Element msg
pageWrapper =
    column
        [ spacing Spacing.extraLarge
        , centerX
        ]


layoutWrapper : Element msg -> Html msg
layoutWrapper =
    Element.layout
        [ width fill
        , Text.bodyFont
        , Font.color (rgba255 0 0 0 0.8)
        ]


header : Element msg
header =
    column [ width fill ]
        [ row
            [ padding Spacing.medium
            , spaceEvenly
            , width fill
            , Region.navigation
            ]
            [ link [] { url = "/", label = dot }
            , row [ spacing Spacing.medium ]
                [ withHighlight False
                    { url = Route.toString Route.Blog
                    , label = Text.subtitle [] "Blog"
                    }
                , withHighlight False
                    { url = Route.toString Route.Contact
                    , label = Text.subtitle [] "Contact"
                    }
                ]
            ]
        ]


dot : Element msg
dot =
    row [ spacing Spacing.extraSmall ]
        [ el [ Text.logoFont ] (text "a")
        , el [ inFront (Animated.el expandFade [] dot_) ] dot_
        ]


expandFade : Animation
expandFade =
    Animation.fromTo
        { duration = 2000
        , options = [ Animation.loop ]
        }
        [ P.scale 1, P.opacity 1 ]
        [ P.scale 2, P.opacity 0 ]


dot_ : Element msg
dot_ =
    el
        [ Background.color Palette.black
        , Border.rounded 1000
        , width (px Spacing.medium)
        , height (px Spacing.medium)
        ]
        none



--highlightableLink_ : PagePath a -> PagePath b -> String -> Element msg
--highlightableLink_ current path label =
--    withHighlight (PagePath.toString path == PagePath.toString current)
--        { url = PagePath.toString path
--        , label = Text.subtitle [ Font.color Palette.black ] label
--        }
--
--
--highlightableLink : PagePath Pages.PathKey -> Directory Pages.PathKey Directory.WithIndex -> String -> Element msg
--highlightableLink currentPath linkDirectory displayName =
--    let
--        isHighlighted =
--            Directory.includes linkDirectory currentPath
--    in
--    withHighlight isHighlighted
--        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
--        , label = Text.subtitle [ Font.color Palette.black ] displayName
--        }
--


withHighlight : Bool -> { url : String, label : Element msg } -> Element msg
withHighlight isHighlight =
    if isHighlight then
        link [ Font.underline, mouseOver [ Font.color Palette.grey ] ]

    else
        link [ mouseOver [ Font.color Palette.grey ] ]
