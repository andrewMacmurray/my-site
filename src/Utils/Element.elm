module Utils.Element exposing
    ( class
    , maybe
    , style
    )

import Element exposing (Element, htmlAttribute)
import Html.Attributes


style : String -> String -> Element.Attribute msg
style a b =
    htmlAttribute (Html.Attributes.style a b)


class : String -> Element.Attribute msg
class =
    htmlAttribute << Html.Attributes.class


maybe : (a -> Element msg) -> Maybe a -> Element msg
maybe toElement =
    Maybe.map toElement >> Maybe.withDefault Element.none
