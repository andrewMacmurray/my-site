module Element.Palette exposing
    ( black
    , grey
    , lightGrey
    , midGrey
    , primary
    , primaryLight
    , secondary
    , secondaryLight
    , tertiary
    , toString
    , white
    )

import Element exposing (rgb255, toRgb)


grey : Element.Color
grey =
    rgb255 115 121 115


midGrey : Element.Color
midGrey =
    rgb255 76 80 76


lightGrey : Element.Color
lightGrey =
    rgb255 242 242 242


black : Element.Color
black =
    rgb255 25 25 25


white : Element.Color
white =
    rgb255 255 255 255


primary : Element.Color
primary =
    rgb255 35 116 219


primaryLight : Element.Color
primaryLight =
    rgb255 97 164 246


secondary : Element.Color
secondary =
    rgb255 217 22 89


secondaryLight : Element.Color
secondaryLight =
    rgb255 236 81 135


tertiary : Element.Color
tertiary =
    rgb255 109 20 230



-- To RGB String


toString : Element.Color -> String
toString color =
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
