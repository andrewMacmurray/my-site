module Frontmatter exposing
    ( Frontmatter(..)
    , decoder
    )

import Json.Decode as Decode exposing (Decoder)
import Page.Article as Article



-- Frontmatter


type Frontmatter
    = Article Article.Frontmatter
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
            Decode.map Article Article.decoder

        _ ->
            Decode.fail ("Unexpected page type " ++ pageType)
