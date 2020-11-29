module Element.Icon.SmallMail exposing (icon)

import Element exposing (Element)
import Element.Icon as Icon
import Svg
import Svg.Attributes exposing (..)


icon : Element msg
icon =
    Icon.small
        (Svg.svg [ viewBox "0 0 82 55", width "100%" ]
            [ Svg.g [ fill "none" ]
                [ Svg.path
                    [ fill "rgb(193 193 193)"
                    , d "M41 29S69.8 8.37 79.5 1.49A4.94 4.94 0 0075.9 0H6.1C4.66 0 3.4.56 2.5 1.49L41 29z"
                    ]
                    []
                , Svg.path
                    [ fill "rgb(0 0 0)"
                    , d "M2.85 1C1.77 1.89.5 3.66.5 5.26V49.5C.5 52.51 3.02 55 6.08 55h69.83c1.44 0 2.52-.53 3.6-1.24C73.93 50.03 2.85 1 2.85 1z"
                    ]
                    []
                , Svg.path
                    [ fill "rgb(144 144 144)"
                    , d "M79.5 1c-9.84 6.63-39 26.5-39 26.5.37.18 33.17 22.74 38.82 26.5 1.27-1.07 2.19-2.5 2.19-4.12V5.12a6.83 6.83 0 00-2-4.12z"
                    ]
                    []
                ]
            ]
        )
