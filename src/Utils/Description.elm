module Utils.Description exposing (format)


format : String -> String
format =
    String.split "."
        >> List.map String.trim
        >> List.filter (String.isEmpty >> not)
        >> String.join ". "
