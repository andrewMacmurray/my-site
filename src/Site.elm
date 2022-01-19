module Site exposing
    ( HeadTag
    , Metadata
    , Page
    , Page_
    , Path
    , description
    , logo
    , name
    , pageIsPublished
    , tagline
    , titleFor
    , url
    )

import Head
import Head.Seo as Seo
import Page
import Pages exposing (PathKey, images)
import Pages.PagePath exposing (PagePath)
import String.Extra as String



-- Types


type alias Page =
    { path : Path
    , frontmatter : Page.Page
    }


type alias Page_ =
    { path : Path
    , frontmatter : Page.Page
    , body : String
    }


type alias Metadata =
    List ( Path, Page.Page )


type alias Path =
    PagePath Pages.PathKey


type alias HeadTag =
    Head.Tag Pages.PathKey



-- Helpers


titleFor : String -> String
titleFor page =
    String.toTitleCase (name ++ " - " ++ page)


pageIsPublished : Page_ -> Bool
pageIsPublished =
    .frontmatter >> Page.isPublished



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
    "https://amacmurray.dev"


tagline : String
tagline =
    "Andrew MacMurray"


name : String
name =
    "Andrew MacMurray"


description : String
description =
    "Personal blog and website for Andrew MacMurray"
