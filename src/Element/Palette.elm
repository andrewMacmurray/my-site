module Element.Palette exposing
    ( black
    , color
    , grey
    )

import Element exposing (..)


grey : Element.Color
grey =
    rgb255 115 121 115


black : Element.Color
black =
    rgb255 25 25 25


color :
    { primary : Element.Color
    , secondary : Element.Color
    }
color =
    { primary = rgb255 5 117 230
    , secondary = rgb255 0 242 96
    }
