module Element.Animation exposing (fadeIn)

import Element
import Utils.Element exposing (style)


fadeIn : Element.Attribute msg
fadeIn =
    style "animation" "fade-in 0.3s both"
