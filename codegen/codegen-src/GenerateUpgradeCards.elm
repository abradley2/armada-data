module GenerateUpgradeCards exposing (..)

import Elm exposing (Expression)
import Gen.Upgrades
import GenerateShipData
import Upgrades exposing (Upgrade)


makeUpgrade : Upgrade -> Expression
makeUpgrade upgrade =
    Gen.Upgrades.make_.upgrade
        { name = Elm.string upgrade.name
        , unique = Elm.bool upgrade.unique
        , text = Elm.string upgrade.text
        , faction = Elm.maybe <| Maybe.map GenerateShipData.makeFaction upgrade.faction
        , slots =
            Elm.list <|
                List.map
                    GenerateShipData.makeUpgradeSlot
                    upgrade.slots
        , points = Elm.int upgrade.points
        }
