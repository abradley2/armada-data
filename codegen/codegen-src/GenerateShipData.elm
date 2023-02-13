module GenerateShipData exposing (..)

import Elm exposing (Expression)
import Gen.ShipData
import Json.Decode as Decode exposing (Decoder)
import ShipData
    exposing
        ( Attack
        , AttackProfile
        , DefenseToken(..)
        , Shield
        , ShipData
        , Size(..)
        , SpeedChart
        , UpgradeSlot(..)
        , Yaw(..)
        )


type alias ExpressionDecoder t =
    { decoder : Decoder t
    , expression : t -> Expression
    }


sizeDecoder : ExpressionDecoder Size
sizeDecoder =
    let
        decoder : Decoder Size
        decoder =
            Decode.oneOf
                [ tokenDecoder "small" Small
                , tokenDecoder "medium" Medium
                , tokenDecoder "large" Large
                , tokenDecoder "huge" Huge
                ]

        expression : Size -> Expression
        expression shipSize =
            case shipSize of
                ShipData.Small ->
                    Gen.ShipData.make_.small

                ShipData.Medium ->
                    Gen.ShipData.make_.medium

                ShipData.Large ->
                    Gen.ShipData.make_.large

                ShipData.Huge ->
                    Gen.ShipData.make_.huge
    in
    ExpressionDecoder decoder expression


attackProfileDecoder : ExpressionDecoder AttackProfile
attackProfileDecoder =
    let
        decoder : Decoder AttackProfile
        decoder =
            Decode.map3 AttackProfile
                (Decode.field "0" Decode.int)
                (Decode.field "1" Decode.int)
                (Decode.field "2" Decode.int)

        expression : AttackProfile -> Expression
        expression attackProfile =
            Gen.ShipData.make_.attackProfile
                { red = Elm.int attackProfile.red
                , blue = Elm.int attackProfile.blue
                , black = Elm.int attackProfile.black
                }
    in
    ExpressionDecoder decoder expression


attackDecoder : ExpressionDecoder Attack
attackDecoder =
    let
        value : Decoder Attack
        value =
            Decode.map4
                Attack
                (Decode.field "front" attackProfileDecoder.decoder)
                (Decode.field "right" attackProfileDecoder.decoder)
                (Decode.field "left" attackProfileDecoder.decoder)
                (Decode.field "rear" attackProfileDecoder.decoder)

        expression : Attack -> Expression
        expression attack =
            Gen.ShipData.make_.attack
                { front = attackProfileDecoder.expression attack.front
                , right = attackProfileDecoder.expression attack.right
                , left = attackProfileDecoder.expression attack.left
                , rear = attackProfileDecoder.expression attack.rear
                }
    in
    ExpressionDecoder value expression


shieldDecoder : ExpressionDecoder Shield
shieldDecoder =
    let
        decoder : Decoder Shield
        decoder =
            Decode.map4
                Shield
                (Decode.field "front" Decode.int)
                (Decode.field "right" Decode.int)
                (Decode.field "left" Decode.int)
                (Decode.field "rear" Decode.int)

        expression : Shield -> Expression
        expression shield =
            Gen.ShipData.make_.shield
                { front = Elm.int shield.front
                , right = Elm.int shield.right
                , left = Elm.int shield.left
                , rear = Elm.int shield.rear
                }
    in
    ExpressionDecoder decoder expression


defenseTokenDecoder : ExpressionDecoder DefenseToken
defenseTokenDecoder =
    let
        decoder : Decoder DefenseToken
        decoder =
            Decode.oneOf
                [ tokenDecoder "Evade" Evade
                , tokenDecoder "Redirect" Redirect
                , tokenDecoder "Contain" Contain
                , tokenDecoder "Brace" Brace
                , tokenDecoder "Scatter" Scatter
                , tokenDecoder "Salvo" Salvo
                ]

        expression : DefenseToken -> Expression
        expression defenseToken =
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
    in
    ExpressionDecoder decoder expression


yawDecoder : ExpressionDecoder Yaw
yawDecoder =
    let
        decoder : Decoder Yaw
        decoder =
            Decode.oneOf
                [ tokenDecoder "-" YawZero
                , tokenDecoder "|" YawOne
                , tokenDecoder "||" YawTwo
                ]

        expression : Yaw -> Expression
        expression yaw =
            case yaw of
                YawZero ->
                    Gen.ShipData.make_.yawZero

                YawOne ->
                    Gen.ShipData.make_.yawOne

                YawTwo ->
                    Gen.ShipData.make_.yawTwo
    in
    ExpressionDecoder decoder expression


speedChartDecoder : ExpressionDecoder SpeedChart
speedChartDecoder =
    let
        decoder : Decoder SpeedChart
        decoder =
            Decode.map4
                SpeedChart
                (Decode.field "1" (Decode.list yawDecoder.decoder))
                (maybe << Decode.field "2" <| Decode.list yawDecoder.decoder)
                (maybe << Decode.field "3" <| Decode.list yawDecoder.decoder)
                (maybe << Decode.field "4" <| Decode.list yawDecoder.decoder)

        expression speedChart =
            Gen.ShipData.make_.speedChart
                { one = Elm.list <| List.map yawDecoder.expression speedChart.one
                , two =
                    Elm.maybe <|
                        Maybe.map (Elm.list << List.map yawDecoder.expression)
                            speedChart.two
                , three =
                    Elm.maybe <|
                        Maybe.map (Elm.list << List.map yawDecoder.expression)
                            speedChart.three
                , four =
                    Elm.maybe <|
                        Maybe.map (Elm.list << List.map yawDecoder.expression)
                            speedChart.four
                }
    in
    ExpressionDecoder decoder expression


upgradeSlotDecoder : ExpressionDecoder UpgradeSlot
upgradeSlotDecoder =
    let
        decoder : Decoder UpgradeSlot
        decoder =
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

        expression : UpgradeSlot -> Expression
        expression upgradeSlot =
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
    in
    ExpressionDecoder decoder expression


shipDataDecoder : ExpressionDecoder ShipData
shipDataDecoder =
    let
        decoder : Decoder ShipData
        decoder =
            Decode.succeed ShipData
                |> andMap (Decode.field "name" Decode.string)
                |> andMap (Decode.field "size" sizeDecoder.decoder)
                |> andMap (Decode.field "faction" Decode.string)
                |> andMap (Decode.field "hull" Decode.int)
                |> andMap (Decode.field "squadron-attack" attackProfileDecoder.decoder)
                |> andMap (Decode.field "command" Decode.int)
                |> andMap (Decode.field "squadron" Decode.int)
                |> andMap (Decode.field "engineering" Decode.int)
                |> andMap (Decode.field "attack" attackDecoder.decoder)
                |> andMap (Decode.field "shield" shieldDecoder.decoder)
                |> andMap (Decode.field "defense-tokens" (Decode.list defenseTokenDecoder.decoder))
                |> andMap (Decode.field "speed-chart" speedChartDecoder.decoder)
                |> andMap (Decode.field "slots" (Decode.list upgradeSlotDecoder.decoder))
                |> andMap (Decode.field "points" Decode.int)
                |> andMap (maybe <| Decode.field "ship-image" Decode.string)
                |> andMap (maybe <| Decode.field "image" Decode.string)

        expression : ShipData -> Expression
        expression shipData =
            Gen.ShipData.make_.shipData
                { name = Elm.string shipData.name
                , size = sizeDecoder.expression shipData.size
                , faction = Elm.string shipData.faction
                , hull = Elm.int shipData.hull
                , squadronAttack = attackProfileDecoder.expression shipData.squadronAttack
                , command = Elm.int shipData.command
                , squadron = Elm.int shipData.squadron
                , engineering = Elm.int shipData.engineering
                , attack = attackDecoder.expression shipData.attack
                , shield = shieldDecoder.expression shipData.shield
                , defenseTokens =
                    Elm.list <| List.map defenseTokenDecoder.expression shipData.defenseTokens
                , speedChart = speedChartDecoder.expression shipData.speedChart
                , slots = Elm.list <| List.map upgradeSlotDecoder.expression shipData.slots
                , points = Elm.int shipData.points
                , shipImage = Elm.maybe <| Maybe.map Elm.string shipData.shipImage
                , image = Elm.maybe <| Maybe.map Elm.string shipData.image
                }
    in
    ExpressionDecoder decoder expression


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


andMap : Decoder a -> Decoder (a -> b) -> Decoder b
andMap decoder acc =
    Decode.map2 (\a f -> f a) decoder acc


maybe : Decoder a -> Decoder (Maybe a)
maybe decoder =
    Decode.oneOf
        [ decoder |> Decode.map Just
        , Decode.succeed Nothing
        ]
