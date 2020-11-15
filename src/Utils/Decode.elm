module Utils.Decode exposing
    ( date
    , image
    )

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import List.Extra as List
import Pages
import Pages.ImagePath as ImagePath exposing (ImagePath)



-- Date


date : Decoder Date
date =
    fromString
        (\iso ->
            case Date.fromIsoString iso of
                Ok date_ ->
                    Decode.succeed date_

                Err error ->
                    Decode.fail error
        )



-- Image


image : Decoder (ImagePath Pages.PathKey)
image =
    fromString
        (\path ->
            case findPath path of
                Nothing ->
                    "I couldn't find that. Available images are:\n"
                        :: List.map ((\x -> "\t\"" ++ x ++ "\"") << ImagePath.toString) Pages.allImages
                        |> String.join "\n"
                        |> Decode.fail

                Just path_ ->
                    Decode.succeed path_
        )


findPath : String -> Maybe (ImagePath Pages.PathKey)
findPath path =
    List.find (\i -> ImagePath.toString i == path) Pages.allImages



-- Helpers


fromString : (String -> Decoder val) -> Decoder val
fromString decode =
    Decode.string |> Decode.andThen decode
