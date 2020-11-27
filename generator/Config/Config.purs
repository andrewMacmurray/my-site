module Config where

type Env =
  { spaceId :: String
  , accessToken :: String
  }

foreign import env :: Env
