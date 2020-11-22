module Site.Manifest exposing (build)

import Color
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category


build : Manifest.Config Pages.PathKey
build =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.custom "technology" ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "elm-pages-starter - A statically typed site generator."
    , iarcRatingId = Nothing
    , name = "andrew-macmurray"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "elm-pages-starter"
    , sourceIcon = images.siteLogo
    , icons = []
    }
