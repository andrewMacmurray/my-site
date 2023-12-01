module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import Config.Site
import Element exposing (..)
import Element.Spacing as Spacing exposing (edges)
import Element.Text as Text
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Utils.Description
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    {}


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.succeed {}


head : App Data ActionData RouteParams -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = Config.Site.name
        , image = Config.Site.image
        , description = Utils.Description.format seoDescription
        , locale = Nothing
        , title = Config.Site.name
        }
        |> Seo.website


seoDescription : String
seoDescription =
    """
    Hi I'm Andrew, I'm a senior software engineer.
    I love programming, especially functional programming.
    I'm passionate about good design and building software that makes people feel happy or less stressed.
    """


view : App Data ActionData RouteParams -> Shared.Model -> View (PagesMsg Msg)
view _ _ =
    { title = "Andrew MacMurray"
    , body =
        [ Text.headline [ centerX, paddingEach { edges | top = Spacing.large + Spacing.extraSmall } ] "Hi I'm Andrew"
        , Text.paragraph []
            [ Text.tertiaryTitle [] "I'm a senior software engineer. "
            , Text.tertiaryTitle [] "I love programming, especially "
            , Text.tertiaryTitle Text.bold "functional programming"
            , Text.tertiaryTitle [] ". I'm passionate about "
            , Text.tertiaryTitle Text.bold "good design "
            , Text.tertiaryTitle [] "and building software that makes people feel happy or less stressed."
            ]
        ]
    }
