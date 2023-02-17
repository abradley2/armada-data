module FleetBuilder exposing (..)

import Html.Styled as Html exposing (Html)
import Html.Styled.Events as Events
import Html.Styled.Lazy as LazyHtml
import ShipCards
import ShipData exposing (Faction, ShipData)


type alias Model =
    { name : String
    , faction : Faction
    , ships : List ShipData
    , mode : Mode
    }


type Mode
    = ViewFleet
    | SelectShips


type Msg
    = AddShipClicked


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


view : Model -> Html Msg
view model =
    case model.mode of
        ViewFleet ->
            fleetView model

        SelectShips ->
            shipSelectView model.faction


fleetView : Model -> Html Msg
fleetView _ =
    Html.button
        [ Events.onClick AddShipClicked
        ]
        [ Html.text "Add Ship"
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
    Html.text ship.name
