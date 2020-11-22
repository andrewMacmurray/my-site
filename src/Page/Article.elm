module Page.Article exposing (view)

import Date exposing (Date)
import Element exposing (Element)
import Element.Font as Font
import Element.Text as Text
import Metadata exposing (ArticleMetadata)


view : ArticleMetadata -> Element msg -> { title : String, body : List (Element msg) }
view metadata viewForPage =
    { title = metadata.title
    , body =
        [ publishedDateView metadata |> Element.el [ Font.size 16, Font.color (Element.rgba255 0 0 0 0.6) ]
        , Text.headline [] metadata.title
        , viewForPage
        ]
    }


publishedDateView : { a | published : Date } -> Element msg
publishedDateView metadata =
    Element.text (Date.format "MMMM ddd, yyyy" metadata.published)
