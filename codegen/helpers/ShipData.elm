module ShipData exposing (..)

import Json.Decode as Decode exposing (Decoder)


type Size
    = Small
    | Medium
    | Large
    | Huge


sizeDecoder : Decoder Size
sizeDecoder =
    Decode.oneOf
        [ tokenDecoder "small" Small
        , tokenDecoder "medium" Medium
        , tokenDecoder "large" Large
        , tokenDecoder "huge" Huge
        ]


type Faction
    = GalacticEmpire
    | RebelAlliance


factionDecoder : Decoder Faction
factionDecoder =
    Decode.oneOf
        [ tokenDecoder "Rebel Alliance" RebelAlliance
        , tokenDecoder "Galactic Empire" GalacticEmpire
        ]


type alias AttackProfile =
    { red : Int
    , blue : Int
    , black : Int
    }


attackProfileDecoder : Decoder AttackProfile
attackProfileDecoder =
    Decode.map3 AttackProfile
        (Decode.field "0" Decode.int)
        (Decode.field "1" Decode.int)
        (Decode.field "2" Decode.int)


type alias Attack =
    { front : AttackProfile
    , right : AttackProfile
    , left : AttackProfile
    , rear : AttackProfile
    }


attackDecoder : Decoder Attack
attackDecoder =
    Decode.map4
        Attack
        (Decode.field "front" attackProfileDecoder)
        (Decode.field "right" attackProfileDecoder)
        (Decode.field "left" attackProfileDecoder)
        (Decode.field "rear" attackProfileDecoder)


type alias Shield =
    { front : Int
    , right : Int
    , left : Int
    , rear : Int
    }


shieldDecoder : Decoder Shield
shieldDecoder =
    Decode.map4
        Shield
        (Decode.field "front" Decode.int)
        (Decode.field "right" Decode.int)
        (Decode.field "left" Decode.int)
        (Decode.field "rear" Decode.int)


type DefenseToken
    = Evade
    | Redirect
    | Contain
    | Brace
    | Scatter
    | Salvo


defenseTokenDecoder : Decoder DefenseToken
defenseTokenDecoder =
    Decode.oneOf
        [ tokenDecoder "Evade" Evade
        , tokenDecoder "Redirect" Redirect
        , tokenDecoder "Contain" Contain
        , tokenDecoder "Brace" Brace
        , tokenDecoder "Scatter" Scatter
        , tokenDecoder "Salvo" Salvo
        ]


type Yaw
    = YawZero
    | YawOne
    | YawTwo


yawDecoder : Decoder Yaw
yawDecoder =
    Decode.oneOf
        [ tokenDecoder "-" YawZero
        , tokenDecoder "|" YawOne
        , tokenDecoder "||" YawTwo
        ]


type alias SpeedChart =
    { one : List Yaw
    , two : Maybe (List Yaw)
    , three : Maybe (List Yaw)
    , four : Maybe (List Yaw)
    }


speedChartDecoder : Decoder SpeedChart
speedChartDecoder =
    Decode.map4
        SpeedChart
        (Decode.field "1" (Decode.list yawDecoder))
        (Decode.maybe << Decode.field "2" <| Decode.list yawDecoder)
        (Decode.maybe << Decode.field "3" <| Decode.list yawDecoder)
        (Decode.maybe << Decode.field "4" <| Decode.list yawDecoder)


type UpgradeSlot
    = Officer
    | SupportTeam
    | DefensiveRetrofit
    | OffensiveRetrofit
    | Turbolasers
    | Ordnance
    | FleetCommand
    | WeaponsTeam
    | IonCannons
    | FleetSupport
    | ExperimentalRetrofit
    | Superweapon


upgradeSlotDecoder : Decoder UpgradeSlot
upgradeSlotDecoder =
    Decode.oneOf
        [ tokenDecoder "Officer" Officer
        , tokenDecoder "Support Team" SupportTeam
        , tokenDecoder "Defensive Retrofit" DefensiveRetrofit
        , tokenDecoder "Turbolasers" Turbolasers
        , tokenDecoder "Weapons Team" WeaponsTeam
        , tokenDecoder "Ordnance" Ordnance
        , tokenDecoder "Fleet Command" FleetCommand
        , tokenDecoder "Offensive Retrofit" OffensiveRetrofit
        , tokenDecoder "Ion Cannons" IonCannons
        , tokenDecoder "Fleet Support" FleetSupport
        , tokenDecoder "Experimental Retrofit" ExperimentalRetrofit
        , tokenDecoder "Superweapon" Superweapon
        ]


type alias ShipData =
    { name : String
    , size : Size
    , faction : Faction
    , hull : Int
    , squadronAttack : AttackProfile
    , command : Int
    , squadron : Int
    , engineering : Int
    , attack : Attack
    , shield : Shield
    , defenseTokens : List DefenseToken
    , speedChart : SpeedChart
    , slots : List UpgradeSlot
    , points : Int
    , shipImage : Maybe String
    , image : Maybe String
    }


shipDataDecoder : Decoder ShipData
shipDataDecoder =
    let
        andMap : Decoder a -> Decoder (a -> b) -> Decoder b
        andMap d acc =
            Decode.map2 (\a f -> f a) d acc
    in
    Decode.succeed ShipData
        |> andMap (Decode.field "name" Decode.string)
        |> andMap (Decode.field "size" sizeDecoder)
        |> andMap (Decode.field "faction" factionDecoder)
        |> andMap (Decode.field "hull" Decode.int)
        |> andMap (Decode.field "squadron-attack" attackProfileDecoder)
        |> andMap (Decode.field "command" Decode.int)
        |> andMap (Decode.field "squadron" Decode.int)
        |> andMap (Decode.field "engineering" Decode.int)
        |> andMap (Decode.field "attack" attackDecoder)
        |> andMap (Decode.field "shield" shieldDecoder)
        |> andMap (Decode.field "defense-tokens" (Decode.list defenseTokenDecoder))
        |> andMap (Decode.field "speed-chart" speedChartDecoder)
        |> andMap (Decode.field "slots" (Decode.list upgradeSlotDecoder))
        |> andMap (Decode.field "points" Decode.int)
        |> andMap (Decode.maybe <| Decode.field "ship-image" Decode.string)
        |> andMap (Decode.maybe <| Decode.field "image" Decode.string)


tokenDecoder : String -> a -> Decoder a
tokenDecoder token rep =
    Decode.string
        |> Decode.andThen
            (\value ->
                if value == token then
                    Decode.succeed rep

                else
                    Decode.fail ("Invalid token: " ++ value)
            )
