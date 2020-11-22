module Config.Generated.RssFeed exposing (build)

import Frontmatter exposing (Frontmatter(..))
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Rss
import Site


build : List Site.Page_ -> { path : List String, content : String }
build pages =
    { path = [ "blog", "feed.xml" ]
    , content = toString pages
    }


toString : List Site.Page_ -> String
toString pages =
    Rss.generate
        { title = Site.titleFor "blog"
        , description = Site.tagline
        , url = Site.url ++ "/blog"
        , lastBuildTime = Pages.builtAt
        , generator = Just Site.name
        , items = List.filterMap metadataToRssItem pages
        , siteUrl = Site.url
        }


metadataToRssItem : Site.Page_ -> Maybe Rss.Item
metadataToRssItem page =
    case page.frontmatter of
        BlogPost article ->
            Just
                { title = article.title
                , description = article.description
                , url = PagePath.toString page.path
                , categories = []
                , author = "Andrew MacMuray"
                , pubDate = Rss.Date article.published
                , content = Nothing
                }

        _ ->
            Nothing
