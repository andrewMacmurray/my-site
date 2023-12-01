module Utils.Animated exposing
    ( el
    , g
    , path
    )

import Element exposing (Element)
import Simple.Animation exposing (Animation)
import Simple.Animation.Animated as Animated
import Svg exposing (Svg)
import Svg.Attributes



-- Elm UI


el : Animation -> List (Element.Attribute msg) -> Element msg -> Element msg
el =
    ui Element.el


ui :
    (List (Element.Attribute msg) -> children -> Element msg)
    -> Animation
    -> List (Element.Attribute msg)
    -> children
    -> Element msg
ui =
    Animated.ui
        { html = Element.html
        , htmlAttribute = Element.htmlAttribute
        , behindContent = Element.behindContent
        }



-- Svg


g : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
g =
    svg Svg.g


path : Animation -> List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
path =
    svg Svg.path


svg :
    (List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg)
    -> Animation
    -> List (Svg.Attribute msg)
    -> List (Svg msg)
    -> Svg msg
svg =
    Animated.svg { class = Svg.Attributes.class }
