module Element.Markdown exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Element.Palette as Palette
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Html
import Markdown.Block as Block exposing (ListItem(..), Task(..))
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Utils.Element exposing (class, style)


view : String -> Element msg
view =
    Markdown.Parser.parse
        >> Result.mapError (List.map Markdown.Parser.deadEndToString >> String.join "\n")
        >> Result.andThen (Markdown.Renderer.render renderer)
        >> Result.withDefault []
        >> column
            [ width fill
            , spacingXY 0 Scale.extraLarge
            ]


renderer : Markdown.Renderer.Renderer (Element msg)
renderer =
    { heading = heading
    , paragraph = paragraph [ spacing Scale.medium ]
    , thematicBreak = none
    , text = Text.text []
    , strong = row [ class "bold-override" ]
    , emphasis = row [ Font.italic ]
    , codeSpan = code
    , link = toLink
    , hardLineBreak = html (Html.br [] [])
    , image = toImage
    , blockQuote = blockQuote
    , unorderedList = unorderedList
    , orderedList = orderedList
    , codeBlock = codeBlock
    , table = column [ width fill ]
    , tableHeader = column [ Font.bold, width fill, Font.center ]
    , tableBody = column [ width fill ]
    , tableRow = row [ height fill, width fill ]
    , tableHeaderCell = \_ -> paragraph tableBorder
    , tableCell = \_ -> paragraph tableBorder
    , html = Markdown.Html.oneOf []
    }


blockQuote : List (Element msg) -> Element msg
blockQuote =
    paragraph
        [ Border.widthEach { edges | left = Scale.small }
        , padding Scale.medium
        , Border.color Palette.black
        , Background.color Palette.grey
        ]


toLink : { a | destination : String } -> List (Element msg) -> Element msg
toLink { destination } body =
    row []
        [ newTabLink []
            { url = destination
            , label =
                paragraph
                    [ Font.color Palette.black
                    , style "overflow-wrap" "break-word"
                    , style "word-break" "break-word"
                    , class "link-override"
                    ]
                    body
            }
        ]


toImage : { title : Maybe String, src : String, alt : String } -> Element msg
toImage img =
    case img.title of
        Just _ ->
            image [ width fill ] { src = img.src, description = img.alt }

        Nothing ->
            image [ width fill ] { src = img.src, description = img.alt }


orderedList : Int -> List (List (Element msg)) -> Element msg
orderedList i items =
    column [ spacing Scale.medium ] (List.indexedMap (orderedItem i) items)


orderedItem : Int -> Int -> List (Element msg) -> Element msg
orderedItem start i blocks =
    paragraph [ spacing Scale.medium, width fill ]
        [ paragraph [ alignTop ] (text (String.fromInt (i + start) ++ " ") :: blocks) ]


unorderedList : List (ListItem (Element msg)) -> Element msg
unorderedList items =
    column [ spacing Scale.small ] (List.map unorderedItem items)


unorderedItem : ListItem (Element msg) -> Element msg
unorderedItem (ListItem task children) =
    paragraph [ spacing Scale.small, width fill ]
        [ row [ alignTop, width fill ]
            ((case task of
                IncompleteTask ->
                    Element.Input.defaultCheckbox False

                CompletedTask ->
                    Element.Input.defaultCheckbox True

                NoTask ->
                    text "•"
             )
                :: text " "
                :: children
            )
        ]


tableBorder : List (Element.Attr () msg)
tableBorder =
    [ Border.color Palette.grey
    , paddingXY Scale.small Scale.medium
    , Border.width 1
    , Border.solid
    , height fill
    , Background.color Palette.black
    , width fill
    ]


heading : { level : Block.HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    paragraph [ spacing Scale.medium ]
        [ case level of
            Block.H1 ->
                Text.headline [] rawText

            Block.H2 ->
                Text.title [] rawText

            Block.H3 ->
                Text.subtitle [ Font.bold ] rawText

            Block.H4 ->
                Text.subtitle [] rawText

            _ ->
                Text.text [ Font.bold ] rawText
        ]


code : String -> Element msg
code snippet =
    Element.el
        [ Background.color (rgba 0 0 0 0.04)
        , Border.rounded 2
        , paddingXY 5 3
        ]
        (Element.text snippet)


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    paragraph
        [ Background.color (Element.rgba 0 0 0 0.03)
        , style "white-space" "pre-wrap"
        , style "overflow-wrap" "break-word"
        , style "word-break" "break-word"
        , padding Scale.medium
        ]
        [ html (Html.code [] [ Html.text details.body ]) ]
