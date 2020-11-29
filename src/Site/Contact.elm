module Site.Contact exposing
    ( email
    , github
    , mailTo
    )


github : { url : String, handle : String }
github =
    { url = "https://github.com/andrewMacmurray"
    , handle = "@andrewMacmurray"
    }


mailTo : { subject : String } -> String
mailTo { subject } =
    "mailto:" ++ email ++ "?subject=" ++ subject


email : String
email =
    "a.macmurray@icloud.com"
