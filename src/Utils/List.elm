module Utils.List exposing (asArray)

import Array exposing (Array)


asArray : (Array a -> Array b) -> List a -> List b
asArray f =
    Array.fromList >> f >> Array.toList
