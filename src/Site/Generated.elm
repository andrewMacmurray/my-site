module Site.Generated exposing (files)

import Pages.StaticHttp as StaticHttp
import Site
import Site.Generated.RssFeed as RssFeed
import Site.Generated.Sitemap as Sitemap


type alias Generated =
    Result String { path : List String, content : String }


files : List Site.Page_ -> StaticHttp.Request (List Generated)
files meta =
    StaticHttp.succeed
        (List.map Ok
            [ RssFeed.build meta
            , Sitemap.build meta
            ]
        )
