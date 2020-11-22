module Site exposing
    ( HeadTag
    , Metadata
    , Page
    , Path
    , logo
    , name
    , tagline
    , titleFor
    , url
    )

import Frontmatter exposing (Frontmatter)
import Head
import Head.Seo as Seo
import Pages exposing (PathKey, images)
import Pages.PagePath exposing (PagePath)



-- Types


type alias Page =
    { path : Path
    , frontmatter : Frontmatter
    }


type alias Metadata =
    List ( Path, Frontmatter )


type alias Path =
    PagePath Pages.PathKey


type alias HeadTag =
    Head.Tag Pages.PathKey



-- Helpers


titleFor : String -> String
titleFor page =
    name ++ " - " ++ page



-- Constants


logo : Seo.Image PathKey
logo =
    { url = images.siteLogo
    , alt = "Andrew MacMurray logo"
    , dimensions = Nothing
    , mimeType = Nothing
    }


url : String
url =
    "https://inspiring-swirles-26bb31.netlify.app/"


tagline : String
tagline =
    "Andrew MacMurray"


name : String
name =
    "andrew-macmurray"
