module Element.Text exposing
    ( headline
    , subtitle
    , text
    , title
    )

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
            , Region.heading 3
            ]
            attrs
        )
        (Element.text content)


text : List (Attribute msg) -> String -> Element msg
text attrs content =
    Element.el
        (List.append
            [ class "f4"
            , Font.color Palette.grey
            ]
            attrs
        )
        (Element.text content)
