module Files
  ( class File
  , name
  , path
  , body
  , fields
  , generate
  ) where

import Prelude
import Data.String (Pattern(..), Replacement(..), joinWith, replace, split, toLower)
import Effect (Effect, foreachE)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console (log)
import Foreign (Foreign)
import Node.Encoding as Encoding
import Node.FS.Sync as FS
import Simple.JSON (writeJSON)



-- File


class File a where
  name :: a -> String
  body :: a -> String
  fields :: a -> Foreign
  path :: a -> Array String



-- Generate


generate :: forall m a. File a => MonadEffect m => Array a -> m Unit
generate files =
  liftEffect do
    log "Generating files"
    foreachE files (generateFile)
    log "Done ✨"

generateFile :: forall a. File a => a -> Effect Unit
generateFile file = do
  log ("- " <> name file)
  FS.writeTextFile Encoding.UTF8 (filePath file) (contents file)

contents :: forall a. File a => a -> String
contents file =
  joinWith "\n"
    [ "---"
    , writeJSON (fields file)
    , "---"
    , body file
    ]



-- Helpers


filePath :: forall a. File a => a -> String
filePath file = "./content/" <> joinWith "/" (path file) <> "/" <> fileName file

fileName :: forall a. File a => a -> String
fileName file = slugify (name file) <> ".md"

slugify :: String -> String
slugify =
  toLower
    >>> replace (Pattern " - ") (Replacement " ")
    >>> split (Pattern " ")
    >>> joinWith "-"
