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
    , upgrades = List.map (Tuple.pair >> (|>) (Just ())) shipData.slots
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
    let
        className =
            "selected-ships"
    in
    Html.div
        [ Attrs.class className
        ]
    <|
        Css.Global.global
            [ Css.Global.class className
                [ Css.Global.descendants
                    [ Css.Global.div
                        [ Css.fontSize (Css.rem 2)
                        ]
                    ]
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
        ]
