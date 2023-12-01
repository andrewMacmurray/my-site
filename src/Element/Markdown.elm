module Element.Markdown exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Element.Palette as Palette
import Element.Spacing as Spacing exposing (edges)
import Element.Text as Text
import Html
import Html.Attributes as Attribute
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
            , spacingXY 0 Spacing.large
            ]


renderer : Markdown.Renderer.Renderer (Element msg)
renderer =
    { heading = heading
    , paragraph = Text.paragraph []
    , blockQuote = blockQuote
    , html = Markdown.Html.oneOf []
    , text = Text.text [ Font.color Palette.midGrey ]
    , codeSpan = code
    , strong = row [ class "bold-override" ]
    , emphasis = row [ Font.italic ]
    , strikethrough = row []
    , thematicBreak = none
    , link = toLink
    , hardLineBreak = html (Html.br [] [])
    , image = toImage
    , unorderedList = unorderedList
    , orderedList = orderedList
    , codeBlock = codeBlock
    , table = column [ width fill ]
    , tableHeader = column [ Font.bold, width fill, Font.center ]
    , tableBody = column [ width fill ]
    , tableRow = row [ height fill, width fill ]
    , tableHeaderCell = \_ -> paragraph tableBorder
    , tableCell = \_ -> paragraph tableBorder
    }


blockQuote : List (Element msg) -> Element msg
blockQuote =
    paragraph
        [ Border.widthEach { edges | left = Spacing.small }
        , padding Spacing.medium
        , Border.color Palette.black
        , Background.color Palette.lightGrey
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
    column [ spacing Spacing.small, paddingEach { edges | left = Spacing.small } ] (List.indexedMap (orderedItem i) items)


orderedItem : Int -> Int -> List (Element msg) -> Element msg
orderedItem start i blocks =
    Text.paragraph [ alignTop ] (Text.tertiaryTitle [ Font.color Palette.secondary, Font.bold ] (String.fromInt (i + start) ++ ". ") :: blocks)


unorderedList : List (ListItem (Element msg)) -> Element msg
unorderedList items =
    column [ spacing Spacing.small ] (List.map unorderedItem items)


unorderedItem : ListItem (Element msg) -> Element msg
unorderedItem (ListItem task children) =
    paragraph [ spacing Spacing.small, width fill ]
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
    [ Border.color Palette.white
    , paddingXY Spacing.small Spacing.medium
    , Border.width 1
    , Border.solid
    , height fill
    , Background.color Palette.lightGrey
    , width fill
    ]


heading : { level : Block.HeadingLevel, rawText : String, children : List (Element msg) } -> Element msg
heading { level, rawText, children } =
    Text.paragraph []
        [ case level of
            Block.H1 ->
                Text.headline [ Font.medium ] rawText

            Block.H2 ->
                Text.title [ Font.medium ] rawText

            Block.H3 ->
                Text.subtitle [ Font.bold ] rawText

            _ ->
                Text.tertiaryTitle [ Font.bold ] rawText
        ]


code : String -> Element msg
code snippet =
    Text.text
        [ Background.color (rgba 0 0 0 0.04)
        , Font.color Palette.secondary
        , Border.rounded 2
        , paddingXY 5 3
        ]
        snippet


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock details =
    el
        [ class "f6"
        , width fill
        , Text.headlineFont
        ]
        (html
            (Html.node "hljs-el"
                []
                [ Html.pre
                    [ Attribute.style "white-space" "pre-wrap"
                    , Attribute.style "overflow-wrap" "break-word"
                    , Attribute.style "word-break" "break-word"
                    ]
                    [ Html.code
                        [ Attribute.style "padding" "24px"
                        , Attribute.style "border-radius" "7px"
                        ]
                        [ Html.text details.body ]
                    ]
                ]
            )
        )
