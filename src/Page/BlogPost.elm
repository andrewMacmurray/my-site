module Page.BlogPost exposing
    ( Frontmatter
    , decoder
    , view
    )

import Date exposing (Date)
import Element exposing (..)
import Element.Font as Font
import Element.Icon.Mail as Mail
import Element.Scale as Scale exposing (edges)
import Element.Text as Text
import Json.Decode as Decode
import Json.Decode.Pipeline as Decode
import Page.BlogPost.Color as BlogPost
import Site.Contact as Contact
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
        [ column [ spacing Scale.large, paddingEach { edges | top = Scale.small } ]
            [ title color frontmatter.title
            , Text.date [ Font.color (BlogPost.color color) ] frontmatter.published
            , paragraph [ spacing Scale.small ] [ Text.text [ Font.color (BlogPost.color color) ] frontmatter.description ]
            ]
        , content
        , getInTouch color frontmatter.title
        ]
    }


title : BlogPost.Color -> String -> Element msg
title color t =
    paragraph [ spacing Scale.large ] [ Text.headline [ Font.color (BlogPost.color color) ] (String.toTitleCase t) ]


getInTouch : BlogPost.Color -> String -> Element msg
getInTouch color title_ =
    newTabLink []
        { url = Contact.mailTo { subject = title_ }
        , label =
            column [ spacing Scale.medium ]
                [ Text.text [ Font.color (BlogPost.color color) ] "Have some thoughts? "
                , Text.text [ Font.color (BlogPost.color color) ] "Let me know in an email."
                , Mail.icon
                ]
        }
