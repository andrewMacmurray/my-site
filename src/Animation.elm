module Animation exposing
    ( Animation
    , Millis
    , Option
    , cubic
    , delay
    , frame
    , frames
    , fromTo
    , linear
    , loop
    , name
    , step
    , steps
    , stylesheet
    , wait
    , zippy
    )

import Animation.Property as P exposing (Property)
import Html exposing (Html)



-- From To Animation


fromTo : Millis -> List Option -> List Property -> List Property -> Animation
fromTo duration options from_ to_ =
    Steps options from_ [ step duration to_ ] |> stepsToAnimation



-- Stepped Animation


type Steps
    = Steps (List Option) (List Property) (List Step)


type Step
    = Step Millis (List Property)
    | Wait Millis


steps options firstFrame steps_ =
    Steps options firstFrame steps_ |> stepsToAnimation


step =
    Step


wait =
    Wait


stepsToAnimation : Steps -> Animation
stepsToAnimation (Steps opts firstFrame nextFrames) =
    Animation (totalDuration nextFrames) (toStepFrames firstFrame nextFrames :: opts)


totalDuration =
    List.map stepDuration >> List.sum


stepDuration step_ =
    case step_ of
        Step d _ ->
            d

        Wait d ->
            d


toStepFrames : List Property -> List Step -> Option
toStepFrames firstFrame nextFrames =
    Frames (toFrames firstFrame nextFrames)


toFrames : List Property -> List Step -> List Frame
toFrames firstFrame fx =
    let
        percentPerMs =
            100 / toFloat (totalDuration fx)

        getFrame f ( n, xs, cur ) =
            case f of
                Step d props ->
                    ( n + d, xs ++ [ cur ], Frame (percentPerMs * toFloat (n + d)) props )

                Wait d ->
                    ( n + d, xs ++ [ cur ], Frame (percentPerMs * toFloat (n + d)) (frameProps cur) )
    in
    List.foldl getFrame ( 0, [], Frame 0 firstFrame ) fx
        |> (\( _, xs, curr ) -> xs ++ [ curr ])


frameProps (Frame _ props) =
    props



-- Animation


type Animation
    = Animation Millis (List Option)


type Option
    = Frames (List Frame)
    | Iteration Iteration
    | Delay Millis
    | Ease Ease


type Frame
    = Frame Percent (List Property)


type Ease
    = Cubic Float Float Float Float
    | Linear


type Iteration
    = Loop


type alias Percent =
    Float


type alias Millis =
    Int



-- Construct


animation : Millis -> List Option -> Animation
animation =
    Animation



-- Options


delay : Millis -> Option
delay =
    Delay


frames : List Frame -> Option
frames =
    Frames


frame : Percent -> List Property -> Frame
frame =
    Frame


loop : Option
loop =
    Iteration Loop



-- Eases


zippy : Option
zippy =
    cubic 0.3 0.66 0 1.18


cubic : Float -> Float -> Float -> Float -> Option
cubic a b c d =
    Ease (Cubic a b c d)


linear : Option
linear =
    Ease Linear



-- Render


stylesheet : Animation -> Html msg
stylesheet anim =
    Html.node "style" [] [ Html.text (renderStylesheet anim) ]


renderStylesheet : Animation -> String
renderStylesheet anim =
    keyframes_ anim ++ "\n" ++ classDefinition_ anim


keyframes_ : Animation -> String
keyframes_ anim =
    "@keyframes " ++ name anim ++ "{" ++ renderFrames anim ++ "}"


classDefinition_ : Animation -> String
classDefinition_ anim =
    "." ++ name anim ++ "{\n" ++ classProperties anim ++ "\n};"


classProperties : Animation -> String
classProperties anim =
    String.join ";\n"
        (List.append
            [ "animation-name: " ++ name anim
            , "animation-duration: " ++ animationDuration anim
            , "animation-fill-mode: both"
            ]
            (renderOptions anim)
        )


renderFrames : Animation -> String
renderFrames =
    frames_
        >> List.map renderFrame
        >> String.join "\n"


renderFrame : Frame -> String
renderFrame (Frame percent properties) =
    pc percent ++ "{" ++ P.render properties ++ ";}"


renderOptions : Animation -> List String
renderOptions =
    options_ >> List.concatMap renderOption


animationDuration : Animation -> String
animationDuration anim =
    ms (duration_ anim)


ms : Int -> String
ms n =
    String.fromInt n ++ "ms"


pc : Float -> String
pc n =
    String.fromFloat n ++ "%"


renderOption : Option -> List String
renderOption o =
    case o of
        Delay n ->
            [ "animation-delay: " ++ ms n ]

        Ease e ->
            [ "animation-timing-function: " ++ renderEase e ]

        Iteration i ->
            [ "animation-iteration-count: " ++ renderIteration i ]

        Frames _ ->
            []


renderEase : Ease -> String
renderEase e =
    case e of
        Cubic a b c d ->
            "cubic-bezier("
                ++ String.join ","
                    [ String.fromFloat a
                    , String.fromFloat b
                    , String.fromFloat c
                    , String.fromFloat d
                    ]
                ++ ")"

        Linear ->
            "linear"


renderIteration : Iteration -> String
renderIteration i =
    case i of
        Loop ->
            "infinite"



-- Name


name : Animation -> String
name (Animation d options) =
    "anim-" ++ String.fromInt d ++ optionNames options


optionNames : List Option -> String
optionNames =
    joinWith optionName


optionName : Option -> String
optionName o =
    case o of
        Delay n ->
            "d" ++ String.fromInt n

        Frames f ->
            joinWith frameName f

        Ease ease ->
            easeName ease

        Iteration i ->
            iterationName i


frameName : Frame -> String
frameName (Frame dur props) =
    "f" ++ String.fromInt (round dur) ++ joinWith P.name props


joinWith : (a -> String) -> List a -> String
joinWith f =
    List.map f >> String.concat


easeName : Ease -> String
easeName e =
    case e of
        Cubic a b c d ->
            "cubic" ++ String.fromInt (round (a + b + c + d))

        Linear ->
            "linear"


iterationName : Iteration -> String
iterationName i =
    case i of
        Loop ->
            "infinite"



-- Helpers


options_ : Animation -> List Option
options_ (Animation _ o) =
    o


duration_ : Animation -> Millis
duration_ (Animation d _) =
    d


frames_ : Animation -> List Frame
frames_ =
    options_
        >> List.filterMap getFrames
        >> List.head
        >> Maybe.withDefault []


getFrames : Option -> Maybe (List Frame)
getFrames o =
    case o of
        Frames f ->
            Just f

        _ ->
            Nothing
