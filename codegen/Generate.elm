module Generate exposing (main)

import Elm
import Gen.CodeGen.Generate as Generate
import Gen.ShipData
import I18NextGen
import Json.Decode as Decode exposing (Decoder, Value)
import ShipData exposing (ShipData)


type Flags
    = Translations I18NextGen.Flags
    | Ships (List ShipData)


flagsDecoder : Decoder Flags
flagsDecoder =
    Decode.oneOf
        [ Decode.andThen
            (always <| Decode.map Translations I18NextGen.flagsDecoder)
            (Decode.field "lang" Decode.value)
        , Decode.map
            Ships
            (Decode.field "ships" (Decode.list ShipData.shipDataDecoder))
        ]


makeYaw : ShipData.Yaw -> Elm.Expression
makeYaw yaw =
    case yaw of
        ShipData.YawZero ->
            Gen.ShipData.make_.yawZero

        ShipData.YawOne ->
            Gen.ShipData.make_.yawOne

        ShipData.YawTwo ->
            Gen.ShipData.make_.yawTwo


makeAttackProfile : ShipData.AttackProfile -> Elm.Expression
makeAttackProfile attackProfile =
    Gen.ShipData.make_.attackProfile
        { red = Elm.int attackProfile.red
        , blue = Elm.int attackProfile.blue
        , black = Elm.int attackProfile.black
        }


makeAttack : ShipData.Attack -> Elm.Expression
makeAttack attack =
    Gen.ShipData.make_.attack
        { front = makeAttackProfile attack.front
        , left = makeAttackProfile attack.left
        , right = makeAttackProfile attack.right
        , rear = makeAttackProfile attack.rear
        }


makeShield : ShipData.Shield -> Elm.Expression
makeShield shield =
    Gen.ShipData.make_.shield
        { front = Elm.int shield.front
        , left = Elm.int shield.left
        , right = Elm.int shield.right
        , rear = Elm.int shield.rear
        }


makeShipSize : ShipData.Size -> Elm.Expression
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


makeDefenseToken : ShipData.DefenseToken -> Elm.Expression
makeDefenseToken defenseToken =
    case defenseToken of
        ShipData.Evade ->
            Gen.ShipData.make_.evade

        ShipData.Redirect ->
            Gen.ShipData.make_.redirect

        ShipData.Scatter ->
            Gen.ShipData.make_.scatter

        ShipData.Contain ->
            Gen.ShipData.make_.contain

        ShipData.Brace ->
            Gen.ShipData.make_.brace

        ShipData.Salvo ->
            Gen.ShipData.make_.salvo


makeSpeedChart : ShipData.SpeedChart -> Elm.Expression
makeSpeedChart speedChart =
    Gen.ShipData.make_.speedChart
        { one = Elm.list (List.map makeYaw speedChart.one)
        , two = Elm.maybe (Maybe.map (List.map makeYaw >> Elm.list) speedChart.two)
        , three = Elm.maybe (Maybe.map (List.map makeYaw >> Elm.list) speedChart.three)
        , four = Elm.maybe (Maybe.map (List.map makeYaw >> Elm.list) speedChart.four)
        }


makeUpgradeSlot : ShipData.UpgradeSlot -> Elm.Expression
makeUpgradeSlot upgradeSlot =
    case upgradeSlot of
        ShipData.Officer ->
            Gen.ShipData.make_.officer

        ShipData.SupportTeam ->
            Gen.ShipData.make_.supportTeam

        ShipData.DefensiveRetrofit ->
            Gen.ShipData.make_.defensiveRetrofit

        ShipData.OffensiveRetrofit ->
            Gen.ShipData.make_.offensiveRetrofit

        ShipData.Turbolasers ->
            Gen.ShipData.make_.turbolasers

        ShipData.WeaponsTeam ->
            Gen.ShipData.make_.weaponsTeam

        ShipData.Ordnance ->
            Gen.ShipData.make_.ordnance

        ShipData.FleetCommand ->
            Gen.ShipData.make_.fleetCommand

        ShipData.IonCannons ->
            Gen.ShipData.make_.ionCannons

        ShipData.FleetSupport ->
            Gen.ShipData.make_.fleetSupport

        ShipData.ExperimentalRetrofit ->
            Gen.ShipData.make_.experimentalRetrofit

        ShipData.Superweapon ->
            Gen.ShipData.make_.superweapon


main : Program Value () ()
main =
    Generate.fromJson
        flagsDecoder
        (\flagsType ->
            case flagsType of
                Translations flags ->
                    I18NextGen.files flags

                Ships ships ->
                    [ Elm.file [ "Ships" ]
                        [ Elm.declaration "allShips"
                            (Elm.list <|
                                List.map
                                    (\shipData ->
                                        Gen.ShipData.make_.shipData
                                            { name = Elm.string shipData.name
                                            , size = makeShipSize shipData.size
                                            , attack = makeAttack shipData.attack
                                            , command = Elm.int shipData.command
                                            , defenseTokens =
                                                Elm.list
                                                    (List.map
                                                        makeDefenseToken
                                                        shipData.defenseTokens
                                                    )
                                            , engineering = Elm.int shipData.engineering
                                            , faction = Elm.string shipData.faction
                                            , hull = Elm.int shipData.hull
                                            , image =
                                                Elm.maybe <|
                                                    Maybe.map Elm.string shipData.image
                                            , shipImage =
                                                Elm.maybe <|
                                                    Maybe.map Elm.string shipData.shipImage
                                            , slots =
                                                Elm.list
                                                    (List.map makeUpgradeSlot shipData.slots)
                                            , speedChart =
                                                makeSpeedChart shipData.speedChart
                                            , shield = makeShield shipData.shield
                                            , points = Elm.int shipData.points
                                            , squadron = Elm.int shipData.squadron
                                            , squadronAttack =
                                                makeAttackProfile
                                                    shipData.squadronAttack
                                            }
                                    )
                                    ships
                            )
                        ]
                    ]
        )
