module FleetBuilder exposing (..)

import Array
import Css
import Css.Global
import Dict exposing (Dict)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Html.Styled.Lazy as LazyHtml
import List.Extra as ListX
import Maybe.Extra as MaybeX
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


unselectUpgrade : Upgrade -> SelectedShip -> SelectedShip
unselectUpgrade upgrade ship =
    { ship
        | upgrades =
            List.map
                (\( slot, appliedUpgrade ) ->
                    if Maybe.map .name appliedUpgrade == Just upgrade.name then
                        ( slot, Nothing )

                    else
                        ( slot, appliedUpgrade )
                )
                ship.upgrades
    }


selectUpgrade : Upgrade -> SelectedShip -> Maybe SelectedShip
selectUpgrade upgrade ship =
    let
        applyUpgrade : List UpgradeSlot -> SelectedShip -> Maybe SelectedShip
        applyUpgrade reqSlots nextShip =
            case reqSlots of
                [] ->
                    Just nextShip

                reqSlot :: next ->
                    ListX.indexedFoldl
                        (\idx ( slot, appliedUpgrade ) acc ->
                            case acc of
                                Just _ ->
                                    acc

                                Nothing ->
                                    if slot == reqSlot && MaybeX.isNothing appliedUpgrade then
                                        Just <|
                                            { nextShip
                                                | upgrades =
                                                    ListX.updateAt
                                                        idx
                                                        (always ( slot, Just upgrade ))
                                                        nextShip.upgrades
                                            }

                                    else
                                        Nothing
                        )
                        Nothing
                        nextShip.upgrades
                        |> Maybe.andThen (applyUpgrade next)
    in
    applyUpgrade upgrade.slots ship


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
    | UpgradeSelected Int (Maybe Upgrade) Upgrade


init : String -> Faction -> Model
init name faction =
    { name = name
    , faction = faction
    , ships = []
    , mode = ViewFleet
    }
        |> (\m ->
                Maybe.map
                    (ShipSelected >> update >> (|>) m)
                    (List.head ShipCards.allShips)
                    |> Maybe.withDefault m
           )


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddShipClicked ->
            { model | mode = SelectShips }

        UpgradeSelected shipIdx previousUpgrade upgrade ->
            model.ships
                |> List.indexedMap
                    (\idx ship ->
                        if idx == shipIdx then
                            Maybe.map (unselectUpgrade >> (|>) ship) previousUpgrade
                                |> Maybe.withDefault ship
                                |> unselectUpgrade upgrade
                                |> selectUpgrade upgrade
                                |> Maybe.withDefault ship

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
        , selectedShipsView model.faction model.ships
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


selectedShipsView : Faction -> List SelectedShip -> Html Msg
selectedShipsView =
    LazyHtml.lazy2 selectedShipsView_


selectedShipsView_ : Faction -> List SelectedShip -> Html Msg
selectedShipsView_ faction ships =
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
            , Css.Global.class "upgrade-list-container"
                [ Css.padding (Css.rem 0.5)
                ]
            , Css.Global.class "upgrade-list-container__upgrade-list"
                [ Css.minWidth (Css.rem 20)
                , Css.maxWidth (Css.rem 32)
                , Css.displayFlex
                , Css.flexDirection Css.row
                , Css.margin (Css.rem -0.5)
                , Css.boxSizing Css.borderBox
                , Css.flexWrap Css.wrap
                ]
            , Css.Global.class "upgrade-icon"
                [ Css.display Css.inlineBlock
                , Css.width (Css.rem 2.5)
                , Css.height (Css.rem 2.5)
                , Css.cursor Css.pointer
                , Css.backgroundColor Theme.transparent
                , Css.borderRadius (Css.pct 100)
                , Css.borderWidth (Css.px 0)
                , Css.backgroundSize Css.cover
                , Css.backgroundImage (Css.url "/commander_upgrade.webp")
                , Css.Global.withClass "upgrade-icon--commander"
                    [ Css.backgroundImage (Css.url "/commander_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--defensive-retrofit"
                    [ Css.backgroundImage (Css.url "/defensive_retrofit_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--experimental-retrofit"
                    [ Css.backgroundImage (Css.url "/experimental_retrofit_upgrade.webp")
                    ]
                ]
            , Css.Global.class "upgrade-list__grid-item"
                [ Css.width (Css.calc (Css.pct 50) Css.minus (Css.rem 0.25))
                , Theme.tabletUp
                    [ Css.width (Css.calc (Css.pct 33.33) Css.minus (Css.rem 0.25))
                    ]
                , Css.margin (Css.rem 0)
                , Css.padding (Css.rem 0.125)
                , Css.Global.children
                    [ Css.Global.button
                        [ Css.border3 (Css.px 1) Css.solid Theme.softWhite
                        , Css.padding2 (Css.rem 1) (Css.rem 0.25)
                        , Css.boxSizing Css.borderBox
                        , Css.width (Css.pct 100)
                        , Css.height (Css.pct 100)
                        , Css.backgroundColor Theme.transparent
                        , Css.color Theme.softWhite
                        , Css.cursor Css.pointer
                        , Css.hover
                            [ Css.backgroundColor Theme.whiteGlass
                            ]
                        , Css.focus
                            [ Css.backgroundColor Theme.whiteGlass
                            , Css.outline Css.none
                            ]
                        ]
                    ]
                ]
            ]
            :: List.indexedMap (selectedShipView faction) ships


selectedShipView : Faction -> Int -> SelectedShip -> Html Msg
selectedShipView =
    LazyHtml.lazy3 selectedShipView_


selectedShipView_ : Faction -> Int -> SelectedShip -> Html Msg
selectedShipView_ faction shipIdx ship =
    Html.div
        []
        [ Html.text ship.shipData.name
        , Html.div
            []
          <|
            List.map
                (upgradeSlotButton faction shipIdx ship.upgrades)
                ship.upgrades
        ]


upgradeSlotButton :
    Faction
    -> Int
    -> List ( UpgradeSlot, Maybe Upgrade )
    -> ( UpgradeSlot, Maybe Upgrade )
    -> Html Msg
upgradeSlotButton =
    LazyHtml.lazy4 upgradeSlotButton_


upgradeSlotButton_ :
    Faction
    -> Int
    -> List ( UpgradeSlot, Maybe Upgrade )
    -> ( UpgradeSlot, Maybe Upgrade )
    -> Html Msg
upgradeSlotButton_ faction shipIdx selectedShipSlots ( slot, selectedUpgrade ) =
    Html.div
        [ Attrs.class "selected-ships__upgrade-slot-button" ]
        [ Html.div
            []
            [ case slot of
                ShipData.Officer ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.Title ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.SupportTeam ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.OffensiveRetrofit ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.DefensiveRetrofit ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.Turbolasers ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.Ordnance ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.FleetCommand ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.WeaponsTeam ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.IonCannons ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.ExperimentalRetrofit ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.Superweapon ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.Commander ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []

                ShipData.FleetSupport ->
                    Html.button
                        [ Attrs.class "upgrade-icon upgrade-icon--commander"
                        ]
                        []
            , List.singleton
                >> Html.b []
              <|
                case selectedUpgrade of
                    Just upgrade ->
                        Html.text upgrade.name

                    Nothing ->
                        Html.text "None"
            ]
        , selectableCards faction selectedShipSlots slot
            |> Html.map (UpgradeSelected shipIdx selectedUpgrade)
            |> List.singleton
            |> Html.div [ Attrs.class "upgrade-list-container" ]
        ]


selectableCards : Faction -> List ( UpgradeSlot, Maybe Upgrade ) -> UpgradeSlot -> Html Upgrade
selectableCards =
    LazyHtml.lazy3 selectableCards_


{-| Given a ships upgrade slots, and a slot to select for, return
a list of upgrades that can be selected for that slot.
(some upgrades require multiple slots to be filled, hence the need for allSlots)
-}
selectableCards_ : Faction -> List ( UpgradeSlot, Maybe Upgrade ) -> UpgradeSlot -> Html Upgrade
selectableCards_ faction shipSlots slot =
    let
        availableSlots : List UpgradeSlot
        availableSlots =
            shipSlots
                |> List.map Tuple.first
    in
    Html.div
        [ Attrs.class "upgrade-list-container__upgrade-list"
        ]
        (List.filter
            (\upgrade ->
                List.member slot upgrade.slots
                    && (Set.toList >> List.length >> (==) (List.length upgrade.slots))
                        (Set.intersect
                            (Set.fromList <| List.map ShipData.upgradeSlotToString availableSlots)
                            (Set.fromList <| List.map ShipData.upgradeSlotToString upgrade.slots)
                        )
            )
            UpgradeCards.allUpgrades
            |> List.filter (.faction >> Maybe.map ((==) faction) >> Maybe.withDefault True)
            |> List.map
                (\upgrade ->
                    Html.div
                        [ Attrs.class "upgrade-list__grid-item" ]
                        [ Html.button
                            [ Events.onClick upgrade
                            ]
                            [ Html.text <| upgrade.name ]
                        ]
                )
        )
