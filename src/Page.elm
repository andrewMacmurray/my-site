module Page exposing
    ( Page(..)
    , document
    , isPublished
    )

import Element exposing (Element)
import Element.Markdown as Markdown
import Json.Decode as Decode exposing (Decoder)
import Page.BlogPost as BlogPost



-- Page


type Page
    = BlogPost BlogPost.Frontmatter
    | BlogIndex
    | Home
    | Contact


isPublished : Page -> Bool
isPublished page =
    case page of
        BlogPost post ->
            not post.draft

        _ ->
            True



-- Markdown Document


document : { extension : String, metadata : Decoder Page, body : String -> Result error (Element msg) }
document =
    { extension = "md"
    , metadata = decoder
    , body = Markdown.view >> Ok
    }


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
