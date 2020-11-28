module Generated exposing (files)

import Generated.RssFeed as RssFeed
import Generated.Sitemap as Sitemap
import Pages.StaticHttp as StaticHttp
import Site


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
