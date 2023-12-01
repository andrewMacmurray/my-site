module Api exposing (routes)

import ApiRoute exposing (ApiRoute)
import BackendTask exposing (BackendTask)
import Config.Site
import FatalError exposing (FatalError)
import Head
import Html exposing (Html)
import MimeType
import Pages.Manifest as Manifest
import Route exposing (Route)
import Sitemap



-- Routes


routes :
    BackendTask FatalError (List Route)
    -> (Maybe { indent : Int, newLines : Bool } -> Html Never -> String)
    -> List (ApiRoute ApiRoute.Response)
routes getStaticRoutes htmlToString =
    [ sitemapRoute getStaticRoutes
    ]



-- Sitemap


sitemapRoute : BackendTask FatalError (List Route) -> ApiRoute ApiRoute.Response
sitemapRoute =
    BackendTask.map buildSitemap
        >> ApiRoute.succeed
        >> ApiRoute.literal "sitemap.xml"
        >> ApiRoute.single
        >> ApiRoute.withGlobalHeadTags (BackendTask.succeed [ Head.sitemapLink "/sitemap.xml" ])


buildSitemap : List Route -> String
buildSitemap =
    List.map toSitemapEntry >> Sitemap.build { siteUrl = Config.Site.url }


toSitemapEntry : Route -> Sitemap.Entry
toSitemapEntry route =
    { path = String.join "/" (Route.routeToPath route)
    , lastMod = Nothing
    }
