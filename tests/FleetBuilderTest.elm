module FleetBuilderTest exposing (..)

import Expect
import FleetBuilder exposing (SelectedShip)
import ShipData exposing (ShipData)
import Test exposing (Test)
import Upgrades exposing (Upgrade)


nebulonBFrigate : ShipData
nebulonBFrigate =
    { name = "Nebulon-B Support Refit"
    , size = ShipData.Small
    , faction = ShipData.RebelAlliance
    , hull = 5
    , squadronAttack = { red = 0, blue = 1, black = 0 }
    , command = 2
    , squadron = 1
    , engineering = 3
    , attack =
        { front = { red = 3, blue = 0, black = 0 }
        , right = { red = 1, blue = 1, black = 0 }
        , left = { red = 1, blue = 1, black = 0 }
        , rear = { red = 2, blue = 0, black = 0 }
        }
    , shield = { front = 3, right = 1, left = 1, rear = 2 }
    , defenseTokens = [ ShipData.Evade, ShipData.Brace, ShipData.Brace ]
    , speedChart =
        { one = [ ShipData.YawOne ]
        , two = Just [ ShipData.YawOne, ShipData.YawOne ]
        , three = Just [ ShipData.YawZero, ShipData.YawOne, ShipData.YawTwo ]
        , four = Nothing
        }
    , slots = [ ShipData.Officer, ShipData.SupportTeam, ShipData.Turbolasers ]
    , points = 51
    , shipImage = Just "ship/rebel-alliance/nebulon-b-frigate.png"
    , image = Just "ship-card/rebel-alliance/nebulon-b-support-refit.png"
    }


auxiliaryShieldsTeam : Upgrade
auxiliaryShieldsTeam =
    { name = "Auxiliary Shields Team"
    , unique = False
    , text =
        "[Repair]: You may treat the maximum shield values of your right and left hull zones as increased by 1 when you recover or move shields to those zones. If you do, the number of shields in those zones cannot exceed a maximum of \"4\"."
    , faction = Nothing
    , slots = [ ShipData.SupportTeam ]
    , points = 3
    }


suite : Test
suite =
    Test.describe "FleetBuilder"
        [ Test.describe "applyUpgrade"
            [ Test.test "should apply an upgrade to the ship if it has an available spot" <|
                \_ ->
                    let
                        selectedShip : SelectedShip
                        selectedShip =
                            FleetBuilder.selectShip nebulonBFrigate
                    in
                    Expect.equal
                        (selectedShip
                            |> FleetBuilder.selectUpgrade auxiliaryShieldsTeam
                            |> Maybe.map .upgrades
                        )
                        (Just
                            [ ( ShipData.Commander, Nothing )
                            , ( ShipData.Title, Nothing )
                            , ( ShipData.Officer, Nothing )
                            , ( ShipData.SupportTeam, Just auxiliaryShieldsTeam )
                            , ( ShipData.Turbolasers, Nothing )
                            ]
                        )
            , Test.test "Do not apply an upgrade if the slot is already filled" <|
                \_ ->
                    let
                        selectedShip : SelectedShip
                        selectedShip =
                            FleetBuilder.selectShip nebulonBFrigate
                    in
                    Expect.equal
                        (selectedShip
                            |> FleetBuilder.selectUpgrade auxiliaryShieldsTeam
                            |> Maybe.andThen (FleetBuilder.selectUpgrade auxiliaryShieldsTeam)
                            |> Maybe.map .upgrades
                        )
                        Nothing
            ]
        ]
