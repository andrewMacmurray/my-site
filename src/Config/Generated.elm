module Config.Generated exposing (files)

import Config.Generated.RssFeed as RssFeed
import Config.Generated.Sitemap as Sitemap
import Frontmatter exposing (Frontmatter)
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp
import Site


type alias Generated =
    Result String { path : List String, content : String }


files : List { path : PagePath Pages.PathKey, frontmatter : Frontmatter, body : String } -> StaticHttp.Request (List Generated)
files siteMetadata =
    StaticHttp.succeed
        (List.map Ok
            [ RssFeed.build { siteTagline = Site.tagline, siteUrl = Site.url } siteMetadata
            , Sitemap.build { siteUrl = Site.url } siteMetadata
            ]
        )
