module FleetBuilder exposing (..)

import ShipData exposing (Faction, ShipData)


type Eff
    = EffNone


type alias Model =
    { name : String
    , faction : Faction
    , ships : List ShipData
    }


init : String -> Faction -> Model
init name faction =
    { name = name
    , faction = faction
    , ships = []
    }
