module Utils.Element exposing (style)

import Element exposing (htmlAttribute)
import Html.Attributes


style : String -> String -> Element.Attribute msg
style a b =
    htmlAttribute (Html.Attributes.style a b)
