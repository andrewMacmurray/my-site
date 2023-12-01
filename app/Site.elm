module Site exposing (config)

import BackendTask exposing (BackendTask)
import Config.Site
import FatalError exposing (FatalError)
import Head
import MimeType
import Pages.Url
import SiteConfig exposing (SiteConfig)


config : SiteConfig
config =
    { canonicalUrl = Config.Site.url
    , head = head
    }


head : BackendTask FatalError (List Head.Tag)
head =
    BackendTask.succeed
        (List.concat
            [ [ Head.metaName "viewport" (Head.raw "width=device-width,initial-scale=1")
              , Head.sitemapLink "/sitemap.xml"
              ]
            , realFaviconGeneratorTags
            ]
        )


realFaviconGeneratorTags : List Head.Tag
realFaviconGeneratorTags =
    [ Head.appleTouchIcon (Just 180) (Pages.Url.external "/apple-touch-icon.png")
    , Head.icon [ ( 32, 32 ) ] MimeType.Png (Pages.Url.external "/favicon-32x32.png")
    , Head.icon [ ( 16, 16 ) ] MimeType.Png (Pages.Url.external "/favicon-16x16.png")
    , Head.manifestLink "/site.webmanifest"
    , Head.metaName "msapplication-TileColor" (Head.raw "#2d89ef")
    , Head.metaName "theme-color" (Head.raw "#ffffff")
    ]
