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
    animateFlyOff
        (Element.el [ Element.scale 1.2 ]
            (Icon.large
                (Svg.svg [ viewBox "0 0 50 50" ]
                    [ Svg.path
                        [ fill (Palette.toString Palette.secondaryLight)
                        , fillRule "nonzero"
                        , d "M25.5 34.6l19.3-15.3c-.5-.5-1.1-.9-1.8-.9H8c-.7 0-1.3.4-1.7.9l19.2 15.3z"
                        ]
                        []
                    , Animated.svg openCloseEnvelope
                        Svg.path
                        [ fill (Palette.toString Palette.secondaryLight)
                        , fillRule "nonzero"
                        , d "M25.5 4l19.3 15.3c-.5.5-1.1.8-1.8.8H8c-.7 0-1.3-.3-1.7-.8L25.5 4z"
                        , style "transform-origin: 25px 19px"
                        ]
                        []
                    , Animated.g letterUpDown
                        []
                        [ Svg.g [ transform "translate(10.5 8.4)" ]
                            (Svg.rect [ width "28.5", height "36.3", x "1", y "1", fill "#FFFBF1", stroke "#D4AB42", strokeWidth "2", rx "2" ] []
                                :: List.indexedMap (\i el -> Animated.g (fadeInLine i) [ transform "translate(0, 1)" ] [ el ])
                                    [ Svg.path [ fill (Palette.toString Palette.primary), d "M6 5.6h18.5v1.7H6z" ] []
                                    , Svg.path [ fill (Palette.toString Palette.primary), d "M6 10h18.5v1.7H6z" ] []
                                    , Svg.path [ fill (Palette.toString Palette.primary), d "M6 14.4h18.5v1.7H6z" ] []
                                    ]
                            )
                        ]
                    , Svg.path
                        [ fill (Palette.toString Palette.tertiary)
                        , fillRule "nonzero"
                        , d "M6.4 19c-.5.5-1.1 1.5-1.1 2.4v24.5C5.3 47.6 6.5 49 8 49h35a3 3 0 001.8-.7C42 46.3 6.4 19 6.4 19z"
                        ]
                        []
                    , Svg.path
                        [ fill (Palette.toString Palette.secondaryLight)
                        , fillRule "nonzero"
                        , d "M44.8 19A388.5 388.5 0 0125 33.3c.2 0 16.8 13 19.7 15.1.6-.6 1-1.3 1-2.2v-25c0-.5-.3-1.3-1-2.2z"
                        ]
                        []
                    , Svg.rect [ y "49", fill "#fff", width "50", height "2" ] []
                    ]
                )
            )
        )


animateFlyOff : Element msg -> Element msg
animateFlyOff =
    Animated.el flyOff []


flyOff : Animation
flyOff =
    Animation.steps
        [ Animation.loop
        , Animation.zippy
        ]
        [ P.x 0, P.opacity 0 ]
        [ Animation.step 500 [ P.opacity 1, P.x 0 ]
        , Animation.wait 3000
        , Animation.step 200 [ P.y -3 ]
        , Animation.step 200 [ P.y 0 ]
        , Animation.step 300 [ P.x -2, P.opacity 1 ]
        , Animation.step 500 [ P.x 100, P.opacity 0 ]
        , Animation.wait 1000
        ]


fadeInLine : Animation.Millis -> Animation
fadeInLine delay =
    Animation.steps
        [ Animation.loop
        , Animation.delay (delay * 200)
        ]
        [ P.opacity 0 ]
        [ Animation.wait 700
        , Animation.step 200 [ P.opacity 1 ]
        , Animation.wait 2800
        , Animation.set [ P.opacity 0 ]
        , Animation.waitTillComplete flyOff
        ]


letterUpDown : Animation
letterUpDown =
    Animation.steps [ Animation.loop, Animation.zippy ]
        [ P.y 50 ]
        [ Animation.wait 200
        , Animation.step 800 [ P.y 0 ]
        , Animation.wait 1800
        , Animation.step 1200 [ P.y 50 ]
        , Animation.waitTillComplete flyOff
        ]


openCloseEnvelope : Animation
openCloseEnvelope =
    Animation.steps [ Animation.loop, Animation.zippy ]
        [ P.scaleXY 1 0 ]
        [ Animation.step 1000 [ P.scaleXY 1 1 ]
        , Animation.wait 2000
        , Animation.step 1000 [ P.scaleXY 1 0 ]
        , Animation.waitTillComplete flyOff
        ]
