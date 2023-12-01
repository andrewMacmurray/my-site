module Config.Site exposing
    ( description
    , image
    , logoUrl
    , name
    , url
    , withTitle
    )

import Head.Seo as Seo
import MimeType
import Pages.Url
import UrlPath


image : Seo.Image
image =
    { url = logoUrl
    , alt = "Andrew MacMurray Logo"
    , dimensions = Nothing
    , mimeType = Just (MimeType.Image (MimeType.OtherImage "image/svg+xml"))
    }


url : String
url =
    "https://amacmurray.dev"


logoUrl : Pages.Url.Url
logoUrl =
    [ "images", "site-logo.svg" ]
        |> UrlPath.join
        |> Pages.Url.fromPath


withTitle : String -> String
withTitle title =
    name ++ " - " ++ title


name : String
name =
    "Andrew MacMurray"


description : String
description =
    "Personal blog and website for Andrew MacMurray"
