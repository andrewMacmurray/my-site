module Metadata exposing
    ( ArticleMetadata
    , Metadata(..)
    , PageMetadata
    , decoder
    )

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Utils.Decode as Decode


type Metadata
    = Article ArticleMetadata
    | BlogIndex
    | Home
    | Contact


type alias ArticleMetadata =
    { title : String
    , description : String
    , published : Date
    }


type alias PageMetadata =
    { title : String }


decoder : Decoder Metadata
decoder =
    Decode.field "type" Decode.string |> Decode.andThen toMetadata


toMetadata : String -> Decoder Metadata
toMetadata pageType =
    case pageType of
        "home" ->
            Decode.succeed Home

        "contact" ->
            Decode.succeed Contact

        "blog-index" ->
            Decode.succeed BlogIndex

        "blog" ->
            Decode.succeed ArticleMetadata
                |> Decode.required "title" Decode.string
                |> Decode.required "description" Decode.string
                |> Decode.required "published" Decode.date
                |> Decode.map Article

        _ ->
            Decode.fail ("Unexpected page type " ++ pageType)
