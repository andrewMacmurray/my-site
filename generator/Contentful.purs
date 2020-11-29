module Contentful
  ( Entries
  , Entry
  , Meta
  , entries
  , Response
  ) where

import Prelude
import Config (env)
import Data.Either (Either)
import Effect.Aff (Aff)
import Simple.Ajax (AjaxError)
import Simple.Ajax as Ajax
import Simple.JSON (class ReadForeign)



-- Entries


type Entries fields
  = { items :: Array (Entry fields) }

type Entry fields
  = { sys :: Meta
    , fields :: fields
    }

type Meta
  = { id :: String
    , createdAt :: String
    }



-- Response


type Response a
  = Aff (Either AjaxError a)



-- Get Entries


entries :: forall fields a. ReadForeign fields => (Entry fields -> a) -> Response (Array a)
entries f = entries' (_.items >>> map f)

entries' :: forall fields a. ReadForeign fields => (Entries fields -> a) -> Response a
entries' f = do
  res <- Ajax.get url
  pure (f <$> res)

url :: String
url =
  "https://cdn.contentful.com/spaces/"
    <> env.spaceId
    <> "/environments/master/entries?access_token="
    <> env.accessToken
