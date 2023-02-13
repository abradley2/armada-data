module ShipData exposing (..)


type Size
    = Small
    | Medium
    | Large
    | Huge


type Faction
    = GalacticEmpire
    | RebelAlliance


type alias AttackProfile =
    { red : Int
    , blue : Int
    , black : Int
    }


type alias Attack =
    { front : AttackProfile
    , right : AttackProfile
    , left : AttackProfile
    , rear : AttackProfile
    }


type alias Shield =
    { front : Int
    , right : Int
    , left : Int
    , rear : Int
    }


type DefenseToken
    = Evade
    | Redirect
    | Contain
    | Brace
    | Scatter
    | Salvo


type Yaw
    = YawZero
    | YawOne
    | YawTwo


type alias SpeedChart =
    { one : List Yaw
    , two : Maybe (List Yaw)
    , three : Maybe (List Yaw)
    , four : Maybe (List Yaw)
    }


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
