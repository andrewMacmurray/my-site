module Utils.List exposing (findFirst)


findFirst : (a -> Bool) -> List a -> Maybe a
findFirst matching =
    List.filter matching >> List.head
