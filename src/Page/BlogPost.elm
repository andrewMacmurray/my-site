module Page.BlogPost exposing
    ( Frontmatter
    , decoder
    , view
    )

import Date exposing (Date)
import Element exposing (Element, column, paragraph, spacing)
import Element.Font as Font
import Element.Scale as Scale
import Element.Text as Text
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Page.BlogPost.Color as BlogPost
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


view : BlogPost.Color -> Frontmatter -> Element msg -> { title : String, body : List (Element msg) }
view color frontmatter content =
    { title = frontmatter.title
    , body =
        [ column [ spacing Scale.large ]
            [ title color frontmatter.title
            , Text.date [ Font.color (BlogPost.color color) ] frontmatter.published
            , paragraph [ spacing Scale.small ] [ Text.text [ Font.color (BlogPost.color color) ] frontmatter.description ]
            ]
        , content
        ]
    }


title : BlogPost.Color -> String -> Element msg
title color t =
    paragraph [ spacing Scale.large ] [ Text.headline [ Font.color (BlogPost.color color) ] (String.toTitleCase t) ]
