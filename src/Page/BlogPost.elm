module Page.BlogPost exposing
    ( Frontmatter
    , decoder
    , view
    )

import Date exposing (Date)
import Element exposing (Element, column, spacing)
import Element.Font as Font
import Element.Scale as Scale
import Element.Text as Text
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import String.Extra as String
import Utils.Decode as Decode



-- Page


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
        [ title frontmatter.title
        , column [ spacing Scale.large ]
            [ Text.date frontmatter.published
            , content
            ]
        ]
    }


title : String -> Element msg
title t =
    Text.paragraph [ Font.center ] [ Text.headline [] (String.toTitleCase t) ]
