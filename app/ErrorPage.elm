module ErrorPage exposing (ErrorPage(..), Model, Msg, head, init, internalError, notFound, statusCode, update, view)

import Effect exposing (Effect)
import Head
import View exposing (View)


type alias Msg =
    ()


type alias Model =
    {}


init : ErrorPage -> ( Model, Effect Msg )
init _ =
    ( {}, Effect.none )


update : ErrorPage -> Msg -> Model -> ( Model, Effect Msg )
update _ _ model =
    ( model, Effect.none )


head : ErrorPage -> List Head.Tag
head _ =
    []


type ErrorPage
    = NotFound
    | InternalError String


notFound : ErrorPage
notFound =
    NotFound


internalError : String -> ErrorPage
internalError =
    InternalError


view : ErrorPage -> Model -> View Msg
view page _ =
    case page of
        NotFound ->
            View.placeholder "Not Found"

        InternalError err ->
            View.placeholder ("Internal Error - " ++ err)


statusCode : ErrorPage -> number
statusCode error =
    case error of
        NotFound ->
            404

        InternalError _ ->
            500
