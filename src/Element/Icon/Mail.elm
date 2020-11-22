module Element.Icon.Mail exposing
    ( State(..)
    , icon
    , init
    )

import Animator
import Element exposing (Element)
import Element.Icon as Icon
import Svg
import Svg.Attributes exposing (..)



-- State


type State
    = Packing
    | Packed
    | Sending


init : Animator.Timeline State
init =
    sequence (Animator.init Packed)


sequence : Animator.Timeline State -> Animator.Timeline State
sequence =
    Animator.queue
        [ Animator.event (Animator.seconds 0) Packed
        , Animator.wait (Animator.millis 300)
        , Animator.event (Animator.millis 1000) Packing
        , Animator.wait (Animator.millis 800)
        , Animator.event (Animator.millis 1000) Packed
        ]


movement : State -> { letterOffset : Animator.Movement, envelopeScale : Animator.Movement }
movement state =
    case state of
        Packing ->
            { letterOffset = Animator.at 0
            , envelopeScale = Animator.at 1 |> Animator.leaveLate 0.2
            }

        Packed ->
            { letterOffset = Animator.at 60
            , envelopeScale = Animator.at 0
            }

        Sending ->
            { letterOffset = Animator.at 0
            , envelopeScale = Animator.at 1
            }


type alias Options =
    { letterOffset : Float
    , envelopeScale : Float
    }


icon : Animator.Timeline State -> Element msg
icon timeline =
    let
        letterOffset =
            Animator.move timeline (movement >> .letterOffset)

        envelopeScale =
            Animator.move timeline (movement >> .envelopeScale)
    in
    Icon.large
        (Svg.svg [ viewBox "0 -10 82 91", width "100%" ]
            [ Svg.g []
                [ Svg.path
                    [ d "M41 55s28.8-20.63 38.5-27.51A4.94 4.94 0 0075.9 26H6.1c-1.44 0-2.7.56-3.6 1.49L41 55z"
                    , fill "#3F3DC2"
                    , fillRule "nonzero"
                    ]
                    []
                , Svg.path
                    [ d "M41 0s28.8 20.63 38.5 27.51A4.94 4.94 0 0175.9 29H6.1c-1.44 0-2.7-.56-3.6-1.49L41 0z"
                    , fill "#3F3DC2"
                    , fillRule "nonzero"
                    , style ("transform-origin: 41px 27px; transform: scale(1, " ++ String.fromFloat envelopeScale ++ ")")
                    ]
                    []
                , Svg.rect
                    [ stroke "#D4AB42"
                    , strokeWidth "3"
                    , fill "#FFFBF1"
                    , x "13.01"
                    , y (String.fromFloat letterOffset)
                    , width "58"
                    , height "66"
                    , rx "3"
                    ]
                    []
                , Svg.path
                    [ d "M2.85 27C1.77 27.89.5 29.66.5 31.26V75.5C.5 78.51 3.02 81 6.08 81h69.83c1.44 0 2.52-.53 3.6-1.24C73.93 76.03 2.85 27 2.85 27z"
                    , fill "#9671EE"
                    , fillRule "nonzero"
                    ]
                    []
                , Svg.path
                    [ d "M79.5 27c-9.84 6.63-39 26.5-39 26.5.37.18 33.17 22.74 38.82 26.5 1.27-1.07 2.19-2.5 2.19-4.12V31.12a6.83 6.83 0 00-2-4.12z"
                    , fill "#FB7474"
                    , fillRule "nonzero"
                    ]
                    []
                ]
            ]
        )
