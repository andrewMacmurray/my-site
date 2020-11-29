{ name = "my-project"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "node-fs"
  , "psci-support"
  , "simple-ajax"
  , "simple-json"
  ]
, packages = ./packages.dhall
, sources = [ "generator/**/*.purs" ]
}
