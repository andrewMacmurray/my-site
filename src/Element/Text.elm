module Element.Text exposing
    ( headline
    , subtitle
    , text
    )

import Element exposing (Attribute, Element)
import Element.Font as Font
import Element.Palette as Palette
import Element.Region as Region


headline : String -> Element msg
headline content =
    Element.el
        [ Font.size extraLarge
        , Region.heading 1
        , Font.color Palette.grey
        ]
        (Element.text content)


subtitle : List (Attribute msg) -> String -> Element msg
subtitle attrs content =
    Element.el (List.append [ Font.size medium ] attrs) (Element.text content)


text : List (Attribute msg) -> String -> Element msg
text attrs content =
    Element.el
        (List.append
            [ Font.size small
            , Font.color Palette.grey
            ]
            attrs
        )
        (Element.text content)


extraLarge : number
extraLarge =
    50


large : number
large =
    32


medium : number
medium =
    20


small : number
small =
    16


extraSmall : number
extraSmall =
    10
