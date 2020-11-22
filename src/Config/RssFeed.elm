module Config.RssFeed exposing (build)

import Metadata exposing (Metadata(..))
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Rss


build :
    { siteTagline : String, siteUrl : String }
    -> List { path : PagePath Pages.PathKey, frontmatter : Metadata, body : String }
    -> { path : List String, content : String }
build config siteMetadata =
    { path = [ "blog", "feed.xml" ]
    , content = toString config siteMetadata
    }


toString :
    { siteTagline : String, siteUrl : String }
    -> List { path : PagePath Pages.PathKey, frontmatter : Metadata, body : String }
    -> String
toString { siteTagline, siteUrl } siteMetadata =
    Rss.generate
        { title = "elm-pages Blog"
        , description = siteTagline
        , url = "https://elm-pages.com/blog"
        , lastBuildTime = Pages.builtAt
        , generator = Just "elm-pages"
        , items = siteMetadata |> List.filterMap metadataToRssItem
        , siteUrl = siteUrl
        }


metadataToRssItem : { path : PagePath Pages.PathKey, frontmatter : Metadata, body : String } -> Maybe Rss.Item
metadataToRssItem page =
    case page.frontmatter of
        Article article ->
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
