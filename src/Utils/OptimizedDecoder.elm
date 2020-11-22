module Utils.OptimizedDecoder exposing (date)

import Date exposing (Date)
import OptimizedDecoder as Decode exposing (Decoder)


date : Decoder Date
date =
    Decode.string
        |> Decode.andThen
            (\iso ->
                case Date.fromIsoString (String.left 10 iso) of
                    Ok date_ ->
                        Decode.succeed date_

                    Err error ->
                        Decode.fail error
            )
