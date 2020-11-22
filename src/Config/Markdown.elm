module Config.Markdown exposing (document)

import Element exposing (Element)
import Element.Markdown as Markdown
import Frontmatter exposing (Frontmatter)
import Json.Decode exposing (Decoder)


document : { extension : String, metadata : Decoder Frontmatter, body : String -> Result error (Element msg) }
document =
    { extension = "md"
    , metadata = Frontmatter.decoder
    , body = Markdown.view >> Ok
    }
