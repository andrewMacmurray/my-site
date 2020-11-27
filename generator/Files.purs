module Files
  ( class File
  , name
  , path
  , contents
  , generate
  ) where

import Prelude
import Data.String (Pattern(..), joinWith, split, toLower)
import Effect (Effect, foreachE)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Class.Console (log)
import Node.Encoding as Encoding
import Node.FS.Sync as FS

-- File
class File a where
  name :: a -> String
  contents :: a -> String
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

-- Helpers
filePath :: forall a. File a => a -> String
filePath file = "./content/" <> joinWith "/" (path file) <> "/" <> fileName file

fileName :: forall a. File a => a -> String
fileName file = slugify (name file) <> ".md"

slugify :: String -> String
slugify = toLower >>> split (Pattern " ") >>> joinWith "-"
