module Element.Text exposing
    ( headline
    , subtitle
    , text
    )

import Element exposing (Attribute, Element, centerX)
import Element.Font as Font
import Element.Palette as Palette
import Element.Region as Region
import Utils.Element exposing (class)


headline : String -> Element msg
headline content =
    Element.el
        [ class "f1"
        , centerX
        , Region.heading 1
        , Font.color Palette.grey
        ]
        (Element.text content)


subtitle : List (Attribute msg) -> String -> Element msg
subtitle attrs content =
    Element.el (List.append [ class "f3", Region.heading 3 ] attrs) (Element.text content)


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
