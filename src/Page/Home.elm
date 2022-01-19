module Page.Home exposing (view)

import Element exposing (..)
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Site


view : { title : String, body : List (Element msg) }
view =
    { title = Site.name
    , body = view_
    }


view_ : List (Element msg)
view_ =
    [ Text.headline [ centerX, paddingEach { edges | top = Scale.large + Scale.extraSmall } ] "Hi I'm Andrew"
    , Text.paragraph []
        [ Text.tertiaryTitle [] "I'm a freelance software engineer. "
        , Text.tertiaryTitle [] "I love programming, especially "
        , Text.tertiaryTitle Text.bold "functional programming"
        , Text.tertiaryTitle [] ". I'm passionate about "
        , Text.tertiaryTitle Text.bold "clean code "
        , Text.tertiaryTitle [] "and building software that makes people feel happy or less stressed."
        ]
    ]
