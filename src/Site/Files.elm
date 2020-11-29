module Site.Files exposing (generate)

import Pages.StaticHttp as StaticHttp
import Site exposing (Page_)
import Site.Files.RssFeed as RssFeed
import Site.Files.Sitemap as Sitemap


type alias Generated =
    Result String { path : List String, content : String }


generate : List Page_ -> StaticHttp.Request (List Generated)
generate meta =
    StaticHttp.succeed
        (List.map Ok
            [ RssFeed.build meta
            , Sitemap.build meta
            ]
        )
