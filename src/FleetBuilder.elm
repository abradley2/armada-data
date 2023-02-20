module FleetBuilder exposing (..)

import Array
import Css
import Css.Global
import Dict exposing (Dict)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Html.Styled.Lazy as LazyHtml
import Set
import ShipCards
import ShipData exposing (Faction, ShipData, UpgradeSlot)
import Theme
import UpgradeCards
import Upgrades exposing (Upgrade)


type alias Model =
    { name : String
    , faction : Faction
    , ships : List SelectedShip
    , mode : Mode
    }


type alias SelectedShip =
    { shipData : ShipData
    , upgrades : List ( UpgradeSlot, Maybe Upgrade )
    }


selectShip : ShipData -> SelectedShip
selectShip shipData =
    { shipData = shipData
    , upgrades =
        List.map (Tuple.pair >> (|>) Nothing)
            (ShipData.Commander :: ShipData.Title :: shipData.slots)
    }


type Mode
    = ViewFleet
    | SelectShips


type Msg
    = AddShipClicked
    | ShipSelected ShipData
    | UpgradeSelected Int Int (Maybe Upgrade)


init : String -> Faction -> Model
init name faction =
    { name = name
    , faction = faction
    , ships = []
    , mode = ViewFleet
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddShipClicked ->
            { model | mode = SelectShips }

        UpgradeSelected shipIdx slotIdx upgrade ->
            model.ships
                |> List.indexedMap
                    (\idx ship ->
                        if idx == shipIdx then
                            ship.upgrades
                                |> List.indexedMap
                                    (\idx_ ( slot, existingUpgrade ) ->
                                        if idx_ == slotIdx then
                                            ( slot, upgrade )

                                        else
                                            ( slot, existingUpgrade )
                                    )
                                |> (\upgrades -> { ship | upgrades = upgrades })

                        else
                            ship
                    )
                |> (\ships -> { model | ships = ships })

        ShipSelected shipData ->
            { model
                | ships = List.concat [ model.ships, [ selectShip shipData ] ]
                , mode = ViewFleet
            }


view : Model -> Html Msg
view model =
    case model.mode of
        ViewFleet ->
            fleetView model

        SelectShips ->
            shipSelectView model.faction


fleetView : Model -> Html Msg
fleetView model =
    Html.div
        []
        [ Html.button
            [ Events.onClick AddShipClicked
            ]
            [ Html.text "Add Ship"
            ]
        , selectedShipsView model.ships
        ]


shipSelectView : Faction -> Html Msg
shipSelectView =
    LazyHtml.lazy shipSelectView_


shipSelectView_ : Faction -> Html Msg
shipSelectView_ faction =
    let
        factionShips : List ShipData
        factionShips =
            List.filter
                (.faction >> (==) faction)
                ShipCards.allShips
    in
    Html.div
        []
    <|
        List.map
            (selectableShipView >> List.singleton >> Html.div [])
            factionShips


selectableShipView : ShipData -> Html Msg
selectableShipView ship =
    Html.button
        [ Events.onClick <| ShipSelected ship
        ]
        [ Html.text ship.name
        ]


selectedShipsView : List SelectedShip -> Html Msg
selectedShipsView =
    LazyHtml.lazy selectedShipsView_


selectedShipsView_ : List SelectedShip -> Html Msg
selectedShipsView_ ships =
    Html.div
        [ Attrs.class "selected-ships"
        ]
    <|
        Css.Global.global
            [ Css.Global.class "selected-ships"
                [ Css.fontSize (Css.rem 2)
                ]
            , Css.Global.class "selected-ships__upgrade-slot-button"
                [ Css.fontSize (Css.rem 1)
                ]
            ]
            :: List.indexedMap selectedShipView ships


selectedShipView : Int -> SelectedShip -> Html Msg
selectedShipView =
    LazyHtml.lazy2 selectedShipView_


selectedShipView_ : Int -> SelectedShip -> Html Msg
selectedShipView_ shipIdx ship =
    Html.div
        []
        [ Html.text ship.shipData.name
        , Html.div
            []
          <|
            List.indexedMap
                (\upgradeIdx upgrade ->
                    upgradeSlotButton shipIdx upgradeIdx ship.upgrades upgrade
                )
                ship.upgrades
        ]


upgradeSlotButton :
    Int
    -> Int
    -> List ( UpgradeSlot, Maybe Upgrade )
    -> ( UpgradeSlot, Maybe Upgrade )
    -> Html Msg
upgradeSlotButton =
    LazyHtml.lazy4 upgradeSlotButton_


upgradeSlotButton_ :
    Int
    -> Int
    -> List ( UpgradeSlot, Maybe Upgrade )
    -> ( UpgradeSlot, Maybe Upgrade )
    -> Html Msg
upgradeSlotButton_ shipIdx upgradeIdx selectedShipSlots ( slot, selectedUpgrade ) =
    Html.div
        [ Attrs.class "selected-ships__upgrade-slot-button" ]
        [ case slot of
            ShipData.Officer ->
                Html.text "Officer"

            ShipData.Title ->
                Html.text "Title"

            ShipData.SupportTeam ->
                Html.text "Support Team"

            ShipData.OffensiveRetrofit ->
                Html.text "Offensive Retrofit"

            ShipData.DefensiveRetrofit ->
                Html.text "Defensive Retrofit"

            ShipData.Turbolasers ->
                Html.text "Turbolasers"

            ShipData.Ordnance ->
                Html.text "Ordnance"

            ShipData.FleetCommand ->
                Html.text "Fleet Command"

            ShipData.WeaponsTeam ->
                Html.text "Weapons Team"

            ShipData.IonCannons ->
                Html.text "Ion Cannons"

            ShipData.ExperimentalRetrofit ->
                Html.text "Experimental Retrofit"

            ShipData.Superweapon ->
                Html.text "Superweapon"

            ShipData.Commander ->
                Html.text "Commander"

            ShipData.FleetSupport ->
                Html.text "Fleet Support"
        , selectableCards selectedShipSlots slot
            |> Html.map (Just >> UpgradeSelected shipIdx upgradeIdx)
        ]


selectableCards : List ( UpgradeSlot, Maybe Upgrade ) -> UpgradeSlot -> Html Upgrade
selectableCards =
    LazyHtml.lazy2 selectableCards_


{-| Given a ships upgrade slots, and a slot to select for, return
a list of upgrades that can be selected for that slot.
(some upgrades require multiple slots to be filled, hence the need for allSlots)
-}
selectableCards_ : List ( UpgradeSlot, Maybe Upgrade ) -> UpgradeSlot -> Html Upgrade
selectableCards_ shipSlots slot =
    let
        availableSlots : List UpgradeSlot
        availableSlots =
            shipSlots
                |> List.map Tuple.first
    in
    Html.select
        []
        (List.filter
            (\upgrade ->
                List.member slot upgrade.slots
                    && (Set.toList >> List.length >> ((==) (List.length upgrade.slots)))
                        (Set.intersect
                            (Set.fromList <| List.map ShipData.upgradeSlotToString availableSlots)
                            (Set.fromList <| List.map ShipData.upgradeSlotToString upgrade.slots)
                        )
            )
            UpgradeCards.allUpgrades
            |> List.map
                (\upgrade ->
                    Html.option
                        [ Events.onClick upgrade
                        , Attrs.value upgrade.name
                        ]
                        [ Html.text <| upgrade.name ]
                )
        )
