module Utils.Element exposing
    ( class
    , style
    )

import Element exposing (htmlAttribute)
import Html.Attributes


style : String -> String -> Element.Attribute msg
style a b =
    htmlAttribute (Html.Attributes.style a b)


class : String -> Element.Attribute msg
class =
    htmlAttribute << Html.Attributes.class
