module GenerateShipData exposing (..)

import Elm exposing (Expression)
import Gen.ShipData
import Json.Decode as Decode exposing (Decoder)
import ShipData
    exposing
        ( Attack
        , AttackProfile
        , DefenseToken(..)
        , Faction(..)
        , Shield
        , ShipData
        , Size(..)
        , SpeedChart
        , UpgradeSlot(..)
        , Yaw(..)
        )


makeFaction : Faction -> Expression
makeFaction faction =
    case faction of
        RebelAlliance ->
            Gen.ShipData.make_.rebelAlliance

        GalacticEmpire ->
            Gen.ShipData.make_.galacticEmpire


makeShipSize : Size -> Expression
makeShipSize shipSize =
    case shipSize of
        ShipData.Small ->
            Gen.ShipData.make_.small

        ShipData.Medium ->
            Gen.ShipData.make_.medium

        ShipData.Large ->
            Gen.ShipData.make_.large

        ShipData.Huge ->
            Gen.ShipData.make_.huge


makeAttackProfile : AttackProfile -> Expression
makeAttackProfile attackProfile =
    Gen.ShipData.make_.attackProfile
        { red = Elm.int attackProfile.red
        , blue = Elm.int attackProfile.blue
        , black = Elm.int attackProfile.black
        }


makeAttack : Attack -> Expression
makeAttack attack =
    Gen.ShipData.make_.attack
        { front = makeAttackProfile attack.front
        , right = makeAttackProfile attack.right
        , left = makeAttackProfile attack.left
        , rear = makeAttackProfile attack.rear
        }


makeShield : Shield -> Expression
makeShield shield =
    Gen.ShipData.make_.shield
        { front = Elm.int shield.front
        , right = Elm.int shield.right
        , left = Elm.int shield.left
        , rear = Elm.int shield.rear
        }


makeDefenseToken : DefenseToken -> Expression
makeDefenseToken defenseToken =
    case defenseToken of
        Evade ->
            Gen.ShipData.make_.evade

        Redirect ->
            Gen.ShipData.make_.redirect

        Contain ->
            Gen.ShipData.make_.contain

        Brace ->
            Gen.ShipData.make_.brace

        Scatter ->
            Gen.ShipData.make_.scatter

        Salvo ->
            Gen.ShipData.make_.salvo


makeYaw : Yaw -> Expression
makeYaw yaw =
    case yaw of
        YawZero ->
            Gen.ShipData.make_.yawZero

        YawOne ->
            Gen.ShipData.make_.yawOne

        YawTwo ->
            Gen.ShipData.make_.yawTwo


makeSpeedChart : SpeedChart -> Expression
makeSpeedChart speedChart =
    Gen.ShipData.make_.speedChart
        { one = Elm.list <| List.map makeYaw speedChart.one
        , two =
            Elm.maybe <|
                Maybe.map (Elm.list << List.map makeYaw)
                    speedChart.two
        , three =
            Elm.maybe <|
                Maybe.map (Elm.list << List.map makeYaw)
                    speedChart.three
        , four =
            Elm.maybe <|
                Maybe.map (Elm.list << List.map makeYaw)
                    speedChart.four
        }


makeUpgradeSlot : UpgradeSlot -> Expression
makeUpgradeSlot upgradeSlot =
    case upgradeSlot of
        Officer ->
            Gen.ShipData.make_.officer

        SupportTeam ->
            Gen.ShipData.make_.supportTeam

        DefensiveRetrofit ->
            Gen.ShipData.make_.defensiveRetrofit

        Turbolasers ->
            Gen.ShipData.make_.turbolasers

        WeaponsTeam ->
            Gen.ShipData.make_.weaponsTeam

        Ordnance ->
            Gen.ShipData.make_.ordnance

        FleetCommand ->
            Gen.ShipData.make_.fleetCommand

        OffensiveRetrofit ->
            Gen.ShipData.make_.offensiveRetrofit

        IonCannons ->
            Gen.ShipData.make_.ionCannons

        FleetSupport ->
            Gen.ShipData.make_.fleetSupport

        ExperimentalRetrofit ->
            Gen.ShipData.make_.experimentalRetrofit

        Superweapon ->
            Gen.ShipData.make_.superweapon


makeShipData : ShipData -> Expression
makeShipData shipData =
    Gen.ShipData.make_.shipData
        { name = Elm.string shipData.name
        , size = makeShipSize shipData.size
        , faction = makeFaction shipData.faction
        , hull = Elm.int shipData.hull
        , squadronAttack = makeAttackProfile shipData.squadronAttack
        , command = Elm.int shipData.command
        , squadron = Elm.int shipData.squadron
        , engineering = Elm.int shipData.engineering
        , attack = makeAttack shipData.attack
        , shield = makeShield shipData.shield
        , defenseTokens =
            Elm.list <| List.map makeDefenseToken shipData.defenseTokens
        , speedChart = makeSpeedChart shipData.speedChart
        , slots = Elm.list <| List.map makeUpgradeSlot shipData.slots
        , points = Elm.int shipData.points
        , shipImage = Elm.maybe <| Maybe.map Elm.string shipData.shipImage
        , image = Elm.maybe <| Maybe.map Elm.string shipData.image
        }
