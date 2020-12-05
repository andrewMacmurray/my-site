module Element.Icon.Mail exposing (icon)

import Animation exposing (Animation)
import Animation.Animated as Animated
import Animation.Property as P
import Element exposing (Element)
import Element.Icon as Icon
import Element.Palette as Palette
import Svg
import Svg.Attributes exposing (..)


icon : Element msg
icon =
    Icon.large
        (Svg.svg [ viewBox "0 -10 82 91", width "100%" ]
            [ Svg.g []
                [ Svg.path
                    [ d "M41 55s28.8-20.63 38.5-27.51A4.94 4.94 0 0075.9 26H6.1c-1.44 0-2.7.56-3.6 1.49L41 55z"
                    , fill (Palette.toRgbString Palette.secondaryLight)
                    , fillRule "nonzero"
                    ]
                    []
                , Animated.svg openCloseEnvelope
                    Svg.path
                    [ d "M41 0s28.8 20.63 38.5 27.51A4.94 4.94 0 0175.9 29H6.1c-1.44 0-2.7-.56-3.6-1.49L41 0z"
                    , fill (Palette.toRgbString Palette.secondaryLight)
                    , fillRule "nonzero"
                    , style "transform-origin: 41px 27px"
                    ]
                    []
                , Animated.svg letterUpDown
                    Svg.rect
                    [ stroke "#D4AB42"
                    , strokeWidth "3"
                    , fill "#FFFBF1"
                    , x "13.01"
                    , width "58"
                    , height "66"
                    , rx "3"
                    ]
                    []
                , Svg.path
                    [ d "M2.85 27C1.77 27.89.5 29.66.5 31.26V75.5C.5 78.51 3.02 81 6.08 81h69.83c1.44 0 2.52-.53 3.6-1.24C73.93 76.03 2.85 27 2.85 27z"
                    , fill (Palette.toRgbString Palette.tertiary)
                    , fillRule "nonzero"
                    ]
                    []
                , Svg.path
                    [ d "M79.5 27c-9.84 6.63-39 26.5-39 26.5.37.18 33.17 22.74 38.82 26.5 1.27-1.07 2.19-2.5 2.19-4.12V31.12a6.83 6.83 0 00-2-4.12z"
                    , fill (Palette.toRgbString Palette.secondaryLight)
                    , fillRule "nonzero"
                    ]
                    []
                ]
            ]
        )


letterUpDown : Animation
letterUpDown =
    Animation.steps [ Animation.loop, Animation.zippy ]
        [ P.property "y" "60" ]
        [ Animation.wait 200
        , Animation.step 800 [ P.property "y" "0" ]
        , Animation.wait 800
        , Animation.step 1200 [ P.property "y" "60" ]
        ]


openCloseEnvelope : Animation
openCloseEnvelope =
    Animation.steps [ Animation.loop, Animation.zippy ]
        [ P.scaleXY 1 0 ]
        [ Animation.step 1000 [ P.scaleXY 1 1 ]
        , Animation.wait 1000
        , Animation.step 1000 [ P.scaleXY 1 0 ]
        ]
