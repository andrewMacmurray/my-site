module Frontmatter exposing
    ( Frontmatter(..)
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Page.BlogPost as BlogPost



-- Frontmatter


type Frontmatter
    = BlogPost BlogPost.Frontmatter
    | BlogIndex
    | Home
    | Contact



-- Decoder


decoder : Decoder Frontmatter
decoder =
    Decode.string
        |> Decode.field "type"
        |> Decode.andThen toMetadata


toMetadata : String -> Decoder Frontmatter
toMetadata pageType =
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
