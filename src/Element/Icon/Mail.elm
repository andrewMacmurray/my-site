module Element.Icon.Mail exposing (icon)

import Element exposing (Element)
import Element.Icon as Icon
import Svg
import Svg.Attributes exposing (..)


icon : Element msg
icon =
    Icon.large
        (Svg.svg [ viewBox "0 0 82 81", width "100%" ]
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
                    ]
                    []
                , Svg.rect
                    [ stroke "#D4AB42"
                    , strokeWidth "3"
                    , fill "#FFF3D5"
                    , x "13.01"
                    , y "9.5"
                    , width "58"
                    , height "66"
                    , rx "8"
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
