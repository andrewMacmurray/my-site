module Content.BlogPost exposing
    ( BlogPost
    , Metadata
    , Status(..)
    , all
    , blogpostFromSlug
    , url
    )

import Array exposing (Array)
import BackendTask exposing (BackendTask)
import BackendTask.Env
import BackendTask.File as File
import BackendTask.Glob as Glob
import Date exposing (Date)
import Dict exposing (Dict)
import Element.BlogPost.Color as BlogpostColor
import FatalError exposing (FatalError)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
import Route
import String.Normalize
import Utils.List



-- BlogPost


type alias BlogPost =
    { metadata : Metadata
    , body : String
    , previousPost : Maybe Metadata
    , nextPost : Maybe Metadata
    }


type Status
    = Draft
    | Published Date


type alias Metadata =
    { title : String
    , slug : String
    , image : Maybe String
    , description : String
    , status : Status
    , color : BlogpostColor.Color
    }


type alias RawFile =
    { filePath : String
    , path : List String
    , slug : String
    }



-- Metadata


url : Metadata -> String
url meta =
    Route.toString (Route.Blog__Slug_ { slug = meta.slug })


publishedDate : Metadata -> Date
publishedDate { status } =
    case status of
        Published date ->
            date

        _ ->
            Date.fromRataDie 1



-- Load BlogPosts


all : BackendTask FatalError (List BlogPost)
all =
    blogpostFiles
        |> BackendTask.map (List.map parseFile)
        |> BackendTask.resolve
        |> BackendTask.andThen filterDrafts
        |> BackendTask.map (sortByDate >> Utils.List.asArray applyOrderedUpdates)


parseFile : RawFile -> BackendTask FatalError BlogPost
parseFile file =
    file.filePath
        |> File.bodyWithFrontmatter
            (\markdown ->
                Decode.map2 (\metadata body -> BlogPost metadata body Nothing Nothing)
                    (metadataDecoder file.slug)
                    (Decode.succeed markdown)
            )
        |> BackendTask.allowFatal


applyOrderedUpdates : Array BlogPost -> Array BlogPost
applyOrderedUpdates posts =
    Array.indexedMap
        (\index blogpost ->
            { blogpost
                | nextPost = Array.get (index + 1) posts |> Maybe.map .metadata
                , metadata = withColor index blogpost.metadata
                , previousPost = Array.get (index - 1) posts |> Maybe.map .metadata
            }
        )
        posts


sortByDate : List BlogPost -> List BlogPost
sortByDate =
    List.sortBy
        (.metadata
            >> publishedDate
            >> Date.toRataDie
        )
        >> List.reverse


filterDrafts : List BlogPost -> BackendTask error (List BlogPost)
filterDrafts blogposts =
    BackendTask.Env.get "INCLUDE_DRAFTS"
        |> BackendTask.map
            (\includeDrafts ->
                case includeDrafts of
                    Just "true" ->
                        blogposts

                    _ ->
                        List.filter (\post -> post.metadata.status /= Draft) blogposts
            )


withColor : Int -> Metadata -> Metadata
withColor i meta =
    { meta | color = BlogpostColor.fromIndex i }


blogpostFiles : BackendTask FatalError (List RawFile)
blogpostFiles =
    Glob.succeed
        (\filePath path fileName ->
            { filePath = filePath
            , path = path
            , slug = fileName
            }
        )
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.recursiveWildcard
        |> Glob.match (Glob.literal "/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toBackendTask


blogpostFromSlug : String -> BackendTask FatalError BlogPost
blogpostFromSlug slug =
    all
        |> BackendTask.map keyedBySlug
        |> BackendTask.andThen
            (Dict.get slug
                >> Maybe.map BackendTask.succeed
                >> Maybe.withDefault
                    (("Unable to find post with slug " ++ slug)
                        |> FatalError.fromString
                        |> BackendTask.fail
                    )
            )


keyedBySlug : List BlogPost -> Dict String BlogPost
keyedBySlug =
    List.map (\blogpost -> ( blogpost.metadata.slug, blogpost )) >> Dict.fromList



-- Decode


metadataDecoder : String -> Decoder Metadata
metadataDecoder slug =
    Decode.succeed Metadata
        |> Decode.andMap (Decode.field "title" Decode.string)
        |> Decode.andMap
            (Decode.map
                (Maybe.withDefault slug >> String.Normalize.slug)
                (Decode.maybe (Decode.field "slug" Decode.string))
            )
        |> Decode.andMap (Decode.maybe (Decode.field "image" Decode.string))
        |> Decode.andMap (Decode.field "description" Decode.string)
        |> Decode.andMap statusDecoder
        |> Decode.andMap (Decode.succeed BlogpostColor.default)


statusDecoder : Decoder Status
statusDecoder =
    Decode.map2
        (\published status_ ->
            case ( published, status_ ) of
                ( _, Just "draft" ) ->
                    Draft

                ( date, _ ) ->
                    Published date
        )
        (Decode.field "published"
            (Decode.map
                (Result.withDefault (Date.fromRataDie 1)
                    << Date.fromIsoString
                    << String.left 10
                )
                Decode.string
            )
        )
        (Decode.maybe (Decode.field "status" Decode.string))
