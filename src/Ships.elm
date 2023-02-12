module Ships exposing (..)


type alias ShipConfig =
    { upgrades : List Upgrade
    , size : Size
    , points : Int
    , title : String
    , shipType : String
    , faction : Faction
    }


shipsExample : List ShipConfig
shipsExample =
    [ { title = "Assault Frigate Mark II"
      , upgrades = [ Commander, Officer, WeaponsTeam, OffensiveRetrofit, DefensiveRetrofit, Turbolasers, Title ]
      , shipType = "assault-frigate"
      , points = 81
      , faction = Rebel
      , size = Medium
      }
    , { title = "CR90 Corvette (A)"
      , upgrades = [ Commander, Officer, WeaponsTeam, OffensiveRetrofit, DefensiveRetrofit, Turbolasers, Title ]
      , shipType = "cr90"
      , points = 59
      , faction = Rebel
      , size = Medium
      }
    ]


type Size
    = Small
    | Medium
    | Large


type Faction
    = Rebel
    | Separatist
    | Empire
    | Republic


type Upgrade
    = Commander
    | DefensiveRetrofit
    | ExperimentalRetrofit
    | FleetCommand
    | FleetSupport
    | IonCannons
    | OffensiveRetrofit
    | Officer
    | Ordnance
    | Superweapon
    | SupportTeam
    | Title
    | Turbolasers
    | WeaponsTeam
    | WeaponsTeamAndOffensiveRetrofit
