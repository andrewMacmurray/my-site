module Element.Text exposing
    ( bodyFont
    , bold
    , date
    , headline
    , link
    , paragraph
    , subtitle
    , tertiaryTitle
    , text
    , title
    )

import Date exposing (Date)
import Element exposing (Attribute, Element)
import Element.Font as Font
import Element.Palette as Palette
import Element.Region as Region
import Utils.Element exposing (class)


headline : List (Attribute msg) -> String -> Element msg
headline attrs content =
    Element.el
        (List.append
            [ class "f1"
            , headlineFont
            , Region.heading 1
            , Font.color Palette.grey
            ]
            attrs
        )
        (Element.text content)


title : List (Attribute msg) -> String -> Element msg
title attrs content =
    Element.el
        (List.append
            [ class "f2"
            , headlineFont
            , Region.heading 2
            ]
            attrs
        )
        (Element.text content)


subtitle : List (Attribute msg) -> String -> Element msg
subtitle attrs content =
    Element.el
        (List.append
            [ class "f3"
            , headlineFont
            , Region.heading 3
            ]
            attrs
        )
        (Element.text content)


tertiaryTitle : List (Attribute msg) -> String -> Element msg
tertiaryTitle attrs content =
    Element.el
        (List.append
            [ class "f4"
            , headlineFont
            , Font.color Palette.grey
            ]
            attrs
        )
        (Element.text content)


text : List (Attribute msg) -> String -> Element msg
text attrs content =
    Element.el
        (List.append
            [ class "f4"
            , bodyFont
            , Font.color Palette.black
            ]
            attrs
        )
        (Element.text content)


link : { a | url : String, text : String } -> Element msg
link options =
    Element.link
        [ Font.bold
        , Font.underline
        ]
        { url = options.url
        , label = tertiaryTitle [ Font.color Palette.black ] options.text
        }


bold : List (Element.Attr () msg)
bold =
    [ Font.color Palette.black
    , Font.bold
    ]


date : List (Element.Attribute msg) -> Date -> Element msg
date attrs d =
    subtitle
        (List.append
            [ headlineFont
            , Font.color Palette.black
            ]
            attrs
        )
        (formatDate d)


formatDate : Date -> String
formatDate =
    Date.format "MMM dd . yyyy" >> String.toUpper


paragraph : List (Attribute msg) -> List (Element msg) -> Element msg
paragraph attrs =
    Element.paragraph (List.append [ spaced ] attrs)


spaced : Attribute msg
spaced =
    class "spacing-override"


headlineFont : Attribute msg
headlineFont =
    Font.family
        [ Font.typeface "Roboto Mono"
        , Font.typeface "monospace"
        ]


bodyFont : Attribute msg
bodyFont =
    Font.family
        [ Font.typeface "Open sans"
        , Font.typeface "helvetica"
        ]
