module Generate exposing (main)

{-| -}

import Elm
import Gen.CodeGen.Generate as Generate
import Gen.ShipData as ShipData
import GenerateShipData
import I18NextGen
import Json.Decode as Decode exposing (Decoder, Value)
import ShipData exposing (ShipData)


type Flags
    = Translations I18NextGen.Flags
    | Ships (List ShipData)


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.oneOf
        [ Decode.field "ships" (Decode.list GenerateShipData.shipDataDecoder.decoder)
            |> Decode.map Ships
        , Decode.map2
            (\_ translations -> Translations translations)
            (Decode.field "lang" Decode.value)
            I18NextGen.flagsDecoder
        ]


a =
    Elm.withType


main : Program Value () ()
main =
    Generate.fromJson
        flagsDecoder
        (\flags ->
            case flags of
                Translations translations ->
                    I18NextGen.files translations

                Ships ships ->
                    [ Elm.file [ "ShipCards" ]
                        [ Elm.declaration
                            "allShips"
                            (Elm.list
                                (List.map
                                    GenerateShipData.shipDataDecoder.expression
                                    ships
                                )
                            )
                        ]
                    ]
        )
