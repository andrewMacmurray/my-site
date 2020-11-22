module Config.Generated.Sitemap exposing (build)

import Frontmatter exposing (Frontmatter(..))
import Pages
import Pages.PagePath as PagePath exposing (PagePath)
import Sitemap


build :
    { siteUrl : String }
    -> List { path : PagePath Pages.PathKey, frontmatter : Frontmatter, body : String }
    -> { path : List String, content : String }
build config siteMetadata =
    { path = [ "sitemap.xml" ]
    , content = Sitemap.build config (siteMetadata |> List.map (\page -> { path = PagePath.toString page.path, lastMod = Nothing }))
    }
