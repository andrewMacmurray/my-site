module Page.BlogPost exposing
    ( Frontmatter
    , decoder
    , view
    )

import Date exposing (Date)
import Element exposing (Element)
import Element.Font as Font
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
view frontmatter viewForPage =
    { title = frontmatter.title
    , body =
        [ publishedDateView frontmatter |> Element.el [ Font.size 16, Font.color (Element.rgba255 0 0 0 0.6) ]
        , Text.headline [] frontmatter.title
        , viewForPage
        ]
    }


publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    Element.text (Date.format "MMMM ddd, yyyy" metadata.published)
