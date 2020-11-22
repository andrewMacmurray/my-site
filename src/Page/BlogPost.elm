module Page.BlogPost exposing
    ( Frontmatter
    , decoder
    , view
    )

import Date exposing (Date)
import Element exposing (Element, paragraph)
import Element.Text as Text
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Utils.Decode as Decode



-- Frontmatter


type alias Frontmatter =
    { title : String
    , description : String
    , published : Date
    }


decoder : Decode.Decoder Frontmatter
decoder =
    Decode.succeed Frontmatter
        |> Decode.required "title" Decode.string
        |> Decode.required "description" Decode.string
        |> Decode.required "published" Decode.date



-- View


view : Frontmatter -> Element msg -> { title : String, body : List (Element msg) }
view frontmatter content =
    { title = frontmatter.title
    , body =
        [ Text.date frontmatter.published
        , paragraph [] [ Text.title [] frontmatter.title ]
        , content
        ]
    }
