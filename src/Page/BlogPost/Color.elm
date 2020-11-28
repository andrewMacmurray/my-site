module Page.BlogPost.Color exposing
    ( Color
    , color
    , defaultColor
    , fromIndex
    )

import Element
import Element.Palette as Palette



-- Color


type Color
    = Color Int



-- Construct


fromIndex : Int -> Color
fromIndex =
    Color



-- To Color


color : Color -> Element.Color
color (Color i) =
    case modBy 3 i of
        0 ->
            Palette.secondary

        1 ->
            Palette.tertiary

        _ ->
            Palette.primary


defaultColor : Color
defaultColor =
    Color 0
