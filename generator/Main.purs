module Main (main) where

import Prelude
import BlogPost as BlogPost
import Data.Either (either)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (logShow)
import Files as Files

main :: Effect Unit
main = do
  launchAff_ (BlogPost.getAll >>= either logShow Files.generate)
