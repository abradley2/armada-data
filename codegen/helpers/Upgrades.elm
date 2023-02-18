module Upgrades exposing (..)

import Json.Decode as Decode exposing (Decoder)
import ShipData exposing (Faction, UpgradeSlot)


type alias Upgrade =
    { name : String
    , unique : Bool
    , text : String
    , faction : Maybe Faction
    , slots : List UpgradeSlot
    , points : Int
    }


upgradeDecoder : Decoder Upgrade
upgradeDecoder =
    Decode.map6
        Upgrade
        (Decode.field "name" Decode.string)
        (Decode.oneOf
            [ Decode.field "unique" Decode.bool
            , Decode.succeed False
            ]
        )
        (Decode.field "text" Decode.string)
        (Decode.field "faction" ShipData.factionDecoder |> Decode.maybe)
        (Decode.field "slots" (Decode.list ShipData.upgradeSlotDecoder))
        (Decode.field "points" Decode.int)
