module Page exposing
    ( Page(..)
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Page.BlogPost as BlogPost



-- Page


type Page
    = BlogPost BlogPost.Frontmatter
    | BlogIndex
    | Home
    | Contact



-- Decoder


decoder : Decoder Page
decoder =
    Decode.string
        |> Decode.field "type"
        |> Decode.andThen toPage


toPage : String -> Decoder Page
toPage pageType =
    case pageType of
        "home" ->
            Decode.succeed Home

        "contact" ->
            Decode.succeed Contact

        "blog-index" ->
            Decode.succeed BlogIndex

        "blog" ->
            Decode.map BlogPost BlogPost.decoder

        _ ->
            Decode.fail ("Unexpected page type " ++ pageType)
