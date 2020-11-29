module Site.Manifest exposing (build)

import Color
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Site


build : Manifest.Config Pages.PathKey
build =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.custom "technology" ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = Site.description
    , iarcRatingId = Nothing
    , name = Site.name
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just Site.name
    , sourceIcon = images.siteLogo
    , icons = []
    }
