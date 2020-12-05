---
type: blog
title: Elm Hacks - Port relays
published: 2020-11-28
description: A low fuss global effects pattern
---

You're working on an Elm app, and implementing a feature in a `page` module (one with it's own `model`, `update`, `view`). It's a bubble of calm 💆‍♀️, you don't need to think about any state from the outside world, and developing is mostly a back and forth with the compiler.

Then you get to a point where you need to show a success or error message to the user:

![success](/images/success-banner.png)

You've done this on so many pages before, and it feels kind of annoying to have to manually include it in every page model and page view. There must be a nicer way of doing this?

This is where  `global effects` can be useful.

## What are Global Effects?

It's a very fancy word for describing `updates to state shared across pages`.

A common pattern in Elm single page apps is to hold this shared state in one data structure - the cannonical elm-spa-example app uses a type called `Session` that holds onto things like the logged in user data or an api token. I often call this `Context`. Imagine a model a bit like this:

```
type alias Model =
    { context : Context
    , page : Page
    }


type alias Context =
    { user : User
    , flash : Flash
    }


type Flash
    = Success String
    | Error String
```



The tricky thing with shared structures like `Context` or `Session` is that once you're working in a page (or "child component") updating things outside the page is a bit more challenging.

## A few ways to update the Context

There are a few ways to update shared state. The ones I've come across broadly fall into two categories.

### Including it at the Page level

One way (used in `elm-spa-example`) is to include the shared state in each page (for example [here](https://github.com/rtfeldman/elm-spa-example/blob/master/src/Page/Article.elm)). The page can then change that state freely. When the page changes the current page provides a function for getting the `Session` and handing it to the next page.

This is a great pattern and very flexible and pretty low fuss. There are a couple of drawbacks I find with it however

1. The `Context` has to be passed around a lot when quite often a lot of pages don't need it and can get a bit boilerplatey.
2. Unless the `Context` is made opaque any page can update anything in the shared state (I've never found this a problem in practice but still maybe something to watch out for)
3. If there are any requests or `Cmd`s  involved with an update then they have to be included in the page (think something like refreshing notifications for a logged in user)

### The OutMsg or Effect pattern

Another way to do this is to return a piece of data out of a page `update` and `init` that describes "What should happen". The update or init higher up can then choose what to do with it. You could have something like

```
BreadResponseReceived (Ok bread) ->
    ( { model | bread = bread }, Cmd.none, ShowSuccess "Success!✨🍞🎉" )

BreadResponseReceived (Err bread) ->
    ( model, Cmd.none, ShowError "No Bread 😭" )
```

You can even specialise this pattern further by replacing `Cmd` alltogether with a custom type - [this thread](https://discourse.elm-lang.org/t/realworld-example-app-architected-with-the-effect-pattern/5753) goes into detail about how the `Effect` pattern works.

This is also a really great pattern and has some surprising benefits (a huge one being able to unit test pages using `elm-program-test` a lot more easily).

However I've found in practice quite a few annoyances with this:

1. Replacing `Cmd` with `Effect` can be a pretty invasive change
2. Can be quite confusing for newcomers (a lot of indirection)
3. Using `Effect` for http requests means defining each one up front - this can sometimes result in defining typealises in weird places (say I wanted to fetch a few different resources for a page - I can't define that type in the page anymore as you'd have a cyclic dependency between `Effect` and the page)

## An escape port?

This is something I tried recently - it feels a bit hacky but I quite like how low maintenance it's been. What if we could do something like:

```
({ model | bread = bread }, Flash.success "Success!✨🍞🎉")
```

And the success message shows up? If we define some ports we can:

```
port module Flash exposing
    ( onSuccess
    , success
    )


port success : String -> Cmd msg


port onSuccess : (String -> msg) -> Sub msg
```

Then on the JS side we send the suceess message `String` straight back into the app:

```
app.ports.success.subscribe(message => {
    app.ports.onSuccess.send(message);
});
```

Then in `Main` we can subscribe to that message and update the `Context`

```
subscriptions : Model -> Sub Msg
subscriptions model =
    Flash.onSuccess SuccessTriggered
```

```
--- In Update

SuccessTriggered message ->
    ( { model | context = updateSuccess message model.context }, Cmd.none )
```

It's a cheeky escape hatch! I like to call it a `port  relay`

There are definitely some drawbacks to this I can think of:

1. It's unconventional (newcomers may find this quite odd and definitely indirect)
2. You have to remember to subscribe to the output higher up
3. Using ports mean you lose type safety and you can't relay custom types (unless you encode / decode to and from JSON)

BUT! For simple use cases like this:

1. The api at the page level is really nice
2. There are no invasive changes to the types
3. There's a very clear separation of responsibilities between the page and the shared state

What do you think? Cheap magic or madness? 😜