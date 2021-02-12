---
type: blog
title: Stylish Robot Buttons from Mars
published: 2021-01-12
description: An alternative builder pattern for Elm
---

2 Years ago at [Elm in the Spring conference](https://elminthespring.org/), Brian Hicks gave a fantastic talk about building Buttons ([Robot Buttons from Mars](https://www.youtube.com/watch?v=PDyWP-0H4Zo)).

The idea was that with something extremely configurable like a button (imagine how many valid combinations of colour, size, icon, fills, hovers you can make for buttons!), a really nice way of controlling that complexity is to build up an opaque data structure to represent those options and write small functions to change some options. Once you configure that data structure you can render the button from it.

It's a simple and surprisingly powerful solution - it balances flexibility to customise the button but helps clients configure buttons correctly by restricting what they can do. All with very fashionable pipelines ​💅

```elm
aButton : Html Msg
aButton =
    Button.button ButtonClicked "Click Me!"
        |> Button.blue
        |> Button.solid
        |> Button.toHtml


dangerButton : Html Msg
dangerButton =
    Button.button DangerClicked "Danger!"
        |> Button.red
        |> Button.withIcon Lightning
        |> Button.toHtml
```

And under the hood:

```elm
module Button exposing
    ( Button
    , Icon(..)
    , blue
    , button
    , red
    , solid
    , toHtml
    , withIcon
    )

-- Opaque Button Type


type Button msg
    = Button (Options msg)


type alias Options msg =
    { onClick : msg
    , text : String
    , colour : Colour
    , fill : Fill
    , icon : Maybe Icon
    }


type Colour
    = Green
    | Red
    | Blue


type Icon
    = Lightning
    | Cat


type Fill
    = Solid
    | Hollow



-- Defaults


defaultOptions : msg -> String -> Options msg
defaultOptions msg text =
    { onClick = msg
    , text = text
    , colour = Green
    , fill = Hollow
    , icon = Nothing
    }



-- Create The Button


button : msg -> String -> Button msg
button msg text =
    Button (defaultOptions msg text)



-- Configure The Button


red : Button msg -> Button msg
red (Button options) =
    Button { options | colour = Red }


blue : Button msg -> Button msg
blue (Button options) =
    Button { options | colour = Blue }


solid : Button msg -> Button msg
solid (Button options) =
    Button { options | fill = Solid }


withIcon : Icon -> Button msg -> Button msg
withIcon icon (Button options) =
    Button { options | icon = Just icon }



-- View The Button


toHtml : Button msg -> Html msg
toHtml (Button options) =
    renderHtmlFromOptions options

```

This is the Haute Couture of view code - REFACTOR EVERYTHING!

![fashion](/images/fashion.png)

I've found this pattern extremely effective in practice (although don't get too lazy with the internal option types as they can get pretty wild over time!). Even Brian has some [misgivings a few years on though](https://discourse.elm-lang.org/t/discussion-how-much-to-pipeline/6305/3) - is it too much pipelining?

One argument is that people are more familiar with the `Html` style of view code - e.g. a function with a list of options and contents

```elm
div [ class "button" ] [ text "click me" ]
```

Another very minor gripe I have is that default values perhaps look a bit noisy with the extra `toHtml` at the end:

```elm
Button.button DefaultClicked "Click Me!" |> Button.toHtml
```

But what if we could keep the safety of the pipeline api but make it look a bit more `Html`ish?

```elm
aButton : Html Msg
aButton =
    Button.button [ Button.blue ] ButtonClicked "Click Me!"
```

A slight re-jig of the types lets us do this:

```elm
module Button exposing
    ( Icon(..)
    , Option
    , blue
    , button
    , icon
    , red
    , solid
    )

-- Opaque Option


type Option
    = Colour Colour
    | Fill Fill
    | Icon Icon


type Colour
    = Green
    | Red
    | Blue


type Icon
    = Lightning
    | Cat


type Fill
    = Solid
    | Hollow



-- User Constructed Options


red : Option
red =
    Colour Red


blue : Option
blue =
    Colour Blue


solid : Option
solid =
    Fill Solid


icon : Icon -> Option
icon =
    Icon



-- Internal Options


type alias Options =
    { colour : Colour
    , fill : Fill
    , icon : Maybe Icon
    }


defaults : Options
defaults =
    { colour = Green
    , fill = Hollow
    , icon = Nothing
    }


toOptions : List Option -> Options
toOptions =
    List.foldl applyOption defaults


applyOption : Option -> Options -> Options
applyOption option options =
    case option of
        Fill fill_ ->
            { options | fill = fill_ }

        Colour colour_ ->
            { options | colour = colour_ }

        Icon icon_ ->
            { options | icon = Just icon_ }



-- View Button


button : List Option -> msg -> String -> Html msg
button options msg text =
    viewButtonFromOptions (toOptions options) msg text
```

The trick here is instead of using pipelines we can fold over a list of `Option`s where each one customises the defaults.

It's a subtle change, but I find it visually closer to the `Html` api which is quite pleasant.

What do you think? Fashion fad or Martian button paradise?



