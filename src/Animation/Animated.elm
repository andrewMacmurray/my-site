module Animation.Animated exposing
    ( div
    , el
    , g
    , row
    , svg
    )

import Animation as Animation exposing (Animation)
import Element exposing (Element)
import Html exposing (Html)
import Html.Attributes
import Svg exposing (Svg)
import Svg.Attributes



-- Elm UI


el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el anim attrs =
    Element.el ([ className anim, Element.behindContent (stylesheet anim) ] ++ attrs)


row : Animation -> List (Element.Attribute msg) -> List (Element msg) -> Element msg
row anim attrs =
    Element.row ([ className anim, Element.behindContent (stylesheet anim) ] ++ attrs)



-- Svg


svg : Animation -> (List (Svg.Attribute msg) -> List (Svg a) -> b) -> List (Svg.Attribute msg) -> List (Svg a) -> b
svg anim node_ attrs els =
    node_ (Svg.Attributes.class (Animation.name anim) :: attrs) (stylesheet_ anim :: els)


g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
g anim =
    svg anim Svg.g



-- Html


div : Animation -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
div anim attrs els =
    Html.div (className_ anim :: attrs) (stylesheet_ anim :: els)



-- Helpers


className : Animation -> Element.Attribute msg
className =
    Element.htmlAttribute << className_


className_ : Animation -> Html.Attribute msg
className_ anim =
    Html.Attributes.class (Animation.name anim)


stylesheet : Animation -> Element msg
stylesheet =
    Element.html << stylesheet_


stylesheet_ : Animation -> Html msg
stylesheet_ =
    Animation.stylesheet
