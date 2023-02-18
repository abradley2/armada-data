module Generate exposing (main)

{-| -}

import Elm
import Gen.CodeGen.Generate as Generate
import GenerateShipData
import GenerateUpgradeCards
import I18NextGen
import Json.Decode as Decode exposing (Decoder, Value)
import ShipData exposing (ShipData)
import Upgrades exposing (Upgrade)


type Flags
    = Translations I18NextGen.Flags
    | Ships (List ShipData)
    | Upgrades (List Upgrade)


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.oneOf
        [ Decode.field "ships" (Decode.list ShipData.shipDataDecoder)
            |> Decode.map Ships
        , Decode.map2
            (\_ translations -> Translations translations)
            (Decode.field "lang" Decode.value)
            I18NextGen.flagsDecoder
        , Decode.field "upgrades" (Decode.list Upgrades.upgradeDecoder)
            |> Decode.map Upgrades
        ]


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
                                    GenerateShipData.makeShipData
                                    ships
                                )
                            )
                        ]
                    ]

                Upgrades upgrades ->
                    [ Elm.file [ "UpgradeCards" ]
                        [ Elm.declaration
                            "allUpgrades"
                            (Elm.list
                                (List.map
                                    GenerateUpgradeCards.makeUpgrade
                                    upgrades
                                )
                            )
                        ]
                    ]
        )
