module Element.Palette exposing
    ( black
    , grey
    , primary
    , secondary
    , secondaryLight
    , tertiary
    , tertiaryLight
    , toRgbString
    )

import Element exposing (..)


grey : Element.Color
grey =
    rgb255 115 121 115


black : Element.Color
black =
    rgb255 25 25 25


primary : Element.Color
primary =
    rgb255 69 35 219


secondary : Element.Color
secondary =
    rgb255 217 22 89


secondaryLight : Element.Color
secondaryLight =
    rgb255 236 81 135


tertiary : Element.Color
tertiary =
    rgb255 136 57 245


tertiaryLight : Element.Color
tertiaryLight =
    rgb255 161 92 255



-- To RGB String


toRgbString : Color -> String
toRgbString color =
    let
        c =
            toRgb color
    in
    String.concat
        [ "rgb("
        , String.fromInt (to255RgbValue c.red)
        , ", "
        , String.fromInt (to255RgbValue c.green)
        , ", "
        , String.fromInt (to255RgbValue c.blue)
        , ")"
        ]


to255RgbValue : Float -> Int
to255RgbValue value =
    if value <= 1 then
        round (value * 255)

    else
        round value
