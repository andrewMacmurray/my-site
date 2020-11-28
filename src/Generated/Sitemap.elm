module Generated.Sitemap exposing (build)

import Pages.PagePath as PagePath exposing (PagePath)
import Site
import Sitemap


build : List Site.Page_ -> { path : List String, content : String }
build pages =
    { path = [ "sitemap.xml" ]
    , content = Sitemap.build { siteUrl = Site.url } (List.map toEntry pages)
    }


toEntry : Site.Page_ -> Sitemap.Entry
toEntry page =
    { path = PagePath.toString page.path
    , lastMod = Nothing
    }
