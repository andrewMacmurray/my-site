module Document.Markdown exposing (document)

import Element exposing (Element)
import Element.Markdown as Markdown
import Json.Decode exposing (Decoder)
import Page exposing (Page)


document : { extension : String, metadata : Decoder Page, body : String -> Result error (Element msg) }
document =
    { extension = "md"
    , metadata = Page.decoder
    , body = Markdown.view >> Ok
    }
