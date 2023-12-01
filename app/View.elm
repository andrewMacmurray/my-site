module View exposing
    ( View, map
    , placeholder
    )

{-|

@docs View, map

-}

import Element exposing (Element)
import Element.Text as Text


{-| -}
type alias View msg =
    { title : String
    , body : List (Element msg)
    }


{-| -}
map : (a -> b) -> View a -> View b
map fn doc =
    { title = doc.title
    , body = List.map (Element.map fn) doc.body
    }


placeholder : String -> View msg
placeholder title =
    { title = title
    , body = [ Text.headline [] title ]
    }
