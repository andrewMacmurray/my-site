module BlogPost (getAll, BlogPost) where

import Contentful (Entry)
import Contentful as Contentful
import Data.String (joinWith)
import Data.Symbol (SProxy(..))
import Files (class File)
import Record as Record
import Simple.JSON (writeJSON)

-- Blog Post
newtype BlogPost
  = BlogPost
  { type :: String
  , title :: String
  , description :: String
  , published :: String
  , body :: String
  }

instance blogPostFile :: File BlogPost where
  name (BlogPost x) = x.title
  contents = contents
  path _ = [ "blog" ]

contents :: BlogPost -> String
contents (BlogPost x) =
  joinWith "\n"
    [ "---"
    , writeJSON (Record.delete body_ x)
    , "---"
    , x.body
    ]
  where
  body_ :: SProxy "body"
  body_ = SProxy

-- Get Blog Posts
getAll :: Contentful.Response (Array BlogPost)
getAll = Contentful.entries toBlogPost

toBlogPost :: Entry { title :: String, body :: String } -> BlogPost
toBlogPost { sys, fields } =
  BlogPost
    { type: "blog"
    , title: fields.title
    , description: "foo"
    , published: sys.createdAt
    , body: fields.body
    }
