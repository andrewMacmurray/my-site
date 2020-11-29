module BlogPost (getAll, BlogPost) where

import Contentful (Entry)
import Contentful as Contentful
import Files (class File)
import Simple.JSON (write)



-- Blog Post


newtype BlogPost
  = BlogPost
  { fields ::
      { type :: String
      , title :: String
      , description :: String
      , published :: String
      }
  , body :: String
  }

instance blogPostFile :: File BlogPost where
  name (BlogPost x) = x.fields.title
  body (BlogPost x) = x.body
  fields (BlogPost x) = write x.fields
  path _ = [ "blog" ]



-- Get Blog Posts


getAll :: Contentful.Response (Array BlogPost)
getAll = Contentful.entries toBlogPost

toBlogPost :: Entry { title :: String, description :: String, body :: String } -> BlogPost
toBlogPost { sys, fields } =
  BlogPost
    { body: fields.body
    , fields:
        { type: "blog"
        , title: fields.title
        , description: fields.description
        , published: sys.createdAt
        }
    }
