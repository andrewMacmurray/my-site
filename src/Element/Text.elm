module Element.Text exposing
    ( bodyFont
    , bold
    , headline
    , headlineFont
    , label
    , link
    , link_
    , logoFont
    , paragraph
    , published
    , subtitle
    , tertiaryTitle
    , text
    , title
    )

import Content.BlogPost as Blogpost
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
            [ class "f4"
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
            [ class "f5"
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
            [ class "f5"
            , bodyFont
            , Font.color Palette.black
            ]
            attrs
        )
        (Element.text content)


label : List (Attribute msg) -> String -> Element msg
label attrs content =
    Element.el
        (List.append
            [ logoFont
            , Font.size 14
            ]
            attrs
        )
        (Element.text content)


link_ : String -> Element msg
link_ =
    tertiaryTitle [ Font.bold, Font.underline, Font.color Palette.black ]


link : { a | url : String, text : String } -> Element msg
link options =
    Element.newTabLink []
        { url = options.url
        , label = link_ options.text
        }


bold : List (Element.Attr () msg)
bold =
    [ Font.color Palette.black
    , Font.bold
    ]


published : List (Element.Attribute msg) -> Blogpost.Status -> Element msg
published attrs status =
    case status of
        Blogpost.Published d ->
            subtitle
                (List.append
                    [ headlineFont
                    , Font.color Palette.black
                    ]
                    attrs
                )
                (formatDate d)

        Blogpost.Draft ->
            text attrs "Draft"


formatDate : Date -> String
formatDate =
    Date.format "MMM-dd-yyyy" >> String.toUpper


paragraph : List (Attribute msg) -> List (Element msg) -> Element msg
paragraph attrs =
    Element.paragraph (List.append [ spaced ] attrs)


spaced : Attribute msg
spaced =
    class "spacing-override"


headlineFont : Attribute msg
headlineFont =
    Font.family
        [ Font.typeface "Source code pro"
        , Font.monospace
        ]


logoFont : Attribute msg
logoFont =
    Font.family
        [ Font.monospace
        ]


bodyFont : Attribute msg
bodyFont =
    Font.family
        [ Font.typeface "serif"
        , Font.typeface "times"
        , Font.typeface "system-ui"
        ]
