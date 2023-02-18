module FleetBuilder exposing (..)

import Css
import Css.Global
import Dict exposing (Dict)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Html.Styled.Lazy as LazyHtml
import ShipCards
import ShipData exposing (Faction, ShipData, UpgradeSlot)
import Theme


type alias Model =
    { name : String
    , faction : Faction
    , ships : List SelectedShip
    , mode : Mode
    }


type alias SelectedShip =
    { shipData : ShipData
    , upgrades : List ( UpgradeSlot, Maybe () )
    }


selectShip : ShipData -> SelectedShip
selectShip shipData =
    { shipData = shipData
    , upgrades =
        List.map (Tuple.pair >> (|>) (Just ()))
            (ShipData.Commander :: ShipData.Title :: shipData.slots)
    }


type Mode
    = ViewFleet
    | SelectShips


type Msg
    = AddShipClicked
    | ShipSelected ShipData


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
            :: List.map selectedShipView ships


selectedShipView : SelectedShip -> Html Msg
selectedShipView =
    LazyHtml.lazy selectedShipView_


selectedShipView_ : SelectedShip -> Html Msg
selectedShipView_ ship =
    Html.div
        []
        [ Html.text ship.shipData.name
        , Html.div
            []
          <|
            List.map
                (\upgrade ->
                    upgradeSlotButton upgrade
                )
                ship.upgrades
        ]


upgradeSlotButton : ( UpgradeSlot, Maybe () ) -> Html Msg
upgradeSlotButton ( slot, upgrade ) =
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
        ]
