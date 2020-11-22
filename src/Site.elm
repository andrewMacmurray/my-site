module Site exposing
    ( HeadTag
    , Metadata
    , Page
    , Path
    , name
    , tagline
    , titleFor
    , url
    )

import Frontmatter exposing (Frontmatter)
import Head
import Pages
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


url : String
url =
    "https://inspiring-swirles-26bb31.netlify.app/"


tagline : String
tagline =
    "Andrew MacMurray"


name : String
name =
    "andrew-macmurray"
