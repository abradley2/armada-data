module FleetBuilder exposing (..)

import Css
import Css.Global
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Html.Styled.Lazy as LazyHtml
import Json.Decode as Decode
import List.Extra as ListX
import Maybe.Extra as MaybeX
import ReCase
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
    , selectingUpgradeFor : Maybe ( Int, UpgradeSlot )
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


selectedShipPoints : SelectedShip -> Int
selectedShipPoints ship =
    ship.shipData.points
        + List.foldr
            (\( _, upgrade ) total ->
                Maybe.map (.points >> (+) total) upgrade
                    |> Maybe.withDefault total
            )
            0
            ship.upgrades


type Mode
    = ViewFleet
    | SelectShips


type Msg
    = AddShipClicked
    | ShipSelected ShipData
    | UpgradeSelected Int (Maybe Upgrade) Upgrade
    | UpgradeSlotButtonClicked Int UpgradeSlot


init : String -> Faction -> Model
init name faction =
    { name = name
    , faction = faction
    , ships = []
    , mode = ViewFleet
    , selectingUpgradeFor = Nothing
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

        UpgradeSlotButtonClicked shipIdx upgradeSlot ->
            { model
                | selectingUpgradeFor = Just ( shipIdx, upgradeSlot )
            }

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
                |> (\ships ->
                        { model
                            | ships = ships
                            , selectingUpgradeFor = Nothing
                        }
                   )

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
        [ Attrs.css
            []
        ]
        [ Html.button
            [ Events.onClick AddShipClicked
            ]
            [ Html.text "Add Ship"
            ]
        , selectedShipsView model
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


selectedShipsView : Model -> Html Msg
selectedShipsView model =
    let
        faction =
            model.faction

        ships =
            model.ships
    in
    Html.div
        [ Attrs.class "selected-ships"
        ]
    <|
        stylesheet ()
            :: List.indexedMap (selectedShipView faction model.selectingUpgradeFor) ships


stylesheet : () -> Html msg
stylesheet =
    LazyHtml.lazy stylesheet_


stylesheet_ : () -> Html msg
stylesheet_ =
    always <|
        Css.Global.global
            [ Css.Global.class "selected-ship-title"
                [ Css.fontSize (Css.rem 1.25)
                , Css.fontWeight Css.bold
                , Css.Global.descendants
                    [ Css.Global.class "selected-ship-title__points"
                        [ Css.fontSize (Css.rem 0.8)
                        , Css.fontWeight Css.normal
                        , Css.paddingLeft (Css.rem 0.25)
                        , Css.display Css.inlineBlock
                        , Css.color Theme.turquoiseBlue
                        ]
                    ]
                ]
            , Css.Global.class "selected-ships__upgrade-slot-button"
                [ Css.fontSize (Css.rem 1)
                , Css.fontWeight Css.normal
                , Css.displayFlex
                , Css.justifyContent Css.spaceBetween
                , Css.alignItems Css.center
                , Css.color Theme.softWhite
                , Css.backgroundColor Theme.transparent
                , Css.borderWidth (Css.rem 0)
                , Css.cursor Css.pointer
                , Css.hover
                    [ Css.textDecoration Css.underline
                    , Css.backgroundColor Theme.whiteGlass
                    ]
                , Css.focus
                    [ Css.textDecoration Css.underline
                    , Css.backgroundColor Theme.whiteGlass
                    , Css.outline Css.none
                    ]
                ]
            , Css.Global.class "upgrade-slot-button__points"
                [ Css.fontSize (Css.rem 0.8)
                , Css.fontWeight Css.normal
                , Css.paddingLeft (Css.rem 0.25)
                , Css.display Css.inlineBlock
                , Css.color Theme.turquoiseBlue
                ]
            , Css.Global.class "upgrade-list-container"
                [ Css.padding (Css.rem 0)
                , Css.Global.withClass "upgrade-list-container--show"
                    [ Css.padding (Css.rem 0.5)
                    ]
                ]
            , Css.Global.class "upgrade-icon"
                [ Css.display Css.inlineBlock
                , Css.width (Css.rem 2.5)
                , Css.height (Css.rem 2.5)
                , Css.marginRight (Css.rem 0.5)
                , Css.cursor Css.pointer
                , Css.backgroundColor Theme.transparent
                , Css.borderRadius (Css.pct 100)
                , Css.borderWidth (Css.px 0)
                , Css.backgroundSize Css.cover
                , Css.Global.withClass "upgrade-icon--commander"
                    [ Css.backgroundImage (Css.url "/images/commander_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--defensive-retrofit"
                    [ Css.backgroundImage (Css.url "/images/defensive_retrofit_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--experimental-retrofit"
                    [ Css.backgroundImage (Css.url "/images/experimental_retrofit_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--fleet-command"
                    [ Css.backgroundImage (Css.url "/images/fleet_command_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--ion-cannons"
                    [ Css.backgroundImage (Css.url "/images/ion_cannons_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--fleet-support"
                    [ Css.backgroundImage (Css.url "/images/fleet_support_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--offensive-retrofit"
                    [ Css.backgroundImage (Css.url "/images/offensive_retrofit_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--officer"
                    [ Css.backgroundImage (Css.url "/images/officer_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--ordnance"
                    [ Css.backgroundImage (Css.url "/images/ordnance_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--superweapon"
                    [ Css.backgroundImage (Css.url "/images/superweapon_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--title"
                    [ Css.backgroundImage (Css.url "/images/title_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--support-team"
                    [ Css.backgroundImage (Css.url "/images/support_team_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--turbolasers"
                    [ Css.backgroundImage (Css.url "/images/turbolasers_upgrade.webp")
                    ]
                , Css.Global.withClass "upgrade-icon--weapons-team"
                    [ Css.backgroundImage (Css.url "/images/weapon_team_upgrade.webp")
                    ]
                ]
            , Css.Global.class "upgrade-list-container__upgrade-list"
                [ Css.minWidth (Css.rem 24)
                , Css.maxWidth (Css.rem 48)
                , Css.flexDirection Css.row
                , Css.margin (Css.rem -1)
                , Css.boxSizing Css.borderBox
                , Css.flexWrap Css.wrap
                , Css.display Css.none
                , Css.Global.withClass "upgrade-list-container__upgrade-list--show"
                    [ Css.displayFlex
                    , Css.padding2 (Css.rem 1) (Css.rem 0)
                    ]
                ]
            , Css.Global.class "upgrade-list__upgrade-grid-item"
                [ Css.width (Css.pct 50)
                , Css.boxSizing Css.borderBox
                , Theme.tabletUp
                    [ Css.width (Css.pct 33.333)
                    ]
                , Css.margin (Css.rem 0)
                , Css.padding (Css.rem 0.5)
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
                        , Css.displayFlex
                        , Css.justifyContent Css.spaceBetween
                        , Css.alignItems Css.center
                        , Css.position Css.relative
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
            , Css.Global.class "upgrade-grid-item__upgrade-name"
                [ Css.flex (Css.pct 100)
                ]
            , Css.Global.class "upgrade-grid-item__upgrade-points"
                [ Css.minWidth (Css.rem 1.5)
                , Css.boxSizing Css.contentBox
                , Css.padding4 (Css.rem 0) (Css.rem 0.75) (Css.rem 0) (Css.rem 0.25)
                ]
            , Css.Global.class "upgrade-grid-item__info-icon"
                [ Css.position Css.absolute
                , Css.display Css.inlineFlex
                , Css.alignItems Css.center
                , Css.justifyContent Css.center
                , Css.backgroundColor Theme.darkGray
                , Css.border3 (Css.px 1) Css.solid Theme.softWhite
                , Css.borderRadius (Css.pct 100)
                , Css.width (Css.rem 2)
                , Css.height (Css.rem 2)
                , Css.top (Css.rem -0.9)
                , Css.right (Css.rem -0.9)
                , Css.boxSizing Css.borderBox
                ]
            ]


selectedShipView : Faction -> Maybe ( Int, UpgradeSlot ) -> Int -> SelectedShip -> Html Msg
selectedShipView =
    LazyHtml.lazy4 selectedShipView_


selectedShipView_ : Faction -> Maybe ( Int, UpgradeSlot ) -> Int -> SelectedShip -> Html Msg
selectedShipView_ faction selectingUpgradesFor shipIdx ship =
    Html.div
        []
        [ Html.div
            [ Attrs.class "selected-ship-title"
            ]
            [ Html.text ship.shipData.name
            , let
                points =
                    selectedShipPoints ship
              in
              Html.span
                [ Attrs.class "selected-ship-title__points"
                ]
                [ Html.text <| String.fromInt ship.shipData.points
                , if points /= ship.shipData.points then
                    Html.b [] << List.singleton << Html.text <| " (" ++ String.fromInt points ++ ")"

                  else
                    Html.text ""
                ]
            ]
        , let
            ( emptyUpgradeSlots, filledUpgradeSlots ) =
                ListX.indexedFoldl
                    (\idx ( slotType, upgrade ) ( emptySlots, filledSlots ) ->
                        Maybe.map
                            (always <|
                                ( emptySlots
                                , ( idx
                                  , slotType
                                  , upgrade
                                  )
                                    :: filledSlots
                                )
                            )
                            upgrade
                            |> Maybe.withDefault
                                ( ( idx
                                  , slotType
                                  , upgrade
                                  )
                                    :: emptySlots
                                , filledSlots
                                )
                    )
                    ( [], [] )
                    ship.upgrades
          in
          Html.div
            []
          <|
            List.indexedMap
                (\upgradeIdx ( slotType, upgrade ) ->
                    let
                        show =
                            selectingUpgradesFor == Just ( shipIdx, slotType )
                    in
                    Html.div
                        []
                        [ upgradeSlotButton
                            shipIdx
                            upgradeIdx
                            ( slotType, upgrade )
                        , selectableCards faction
                            shipIdx
                            upgradeIdx
                            show
                            ship.upgrades
                            upgrade
                            slotType
                            |> List.singleton
                            |> Html.div
                                [ Attrs.classList
                                    [ ( "upgrade-list-container", True )
                                    , ( "upgrade-list-container--show", show )
                                    ]
                                ]
                        ]
                )
                ship.upgrades
        ]


upgradeMenuId : Int -> Int -> UpgradeSlot -> String
upgradeMenuId shipIdx upgradeIdx slot =
    "ship_"
        ++ String.fromInt shipIdx
        ++ "_"
        ++ String.fromInt upgradeIdx
        ++ "_"
        ++ (ReCase.recase ReCase.ToSnake <|
                ShipData.upgradeSlotToString slot
           )


upgradeSlotButton :
    Int
    -> Int
    -> ( UpgradeSlot, Maybe Upgrade )
    -> Html Msg
upgradeSlotButton =
    LazyHtml.lazy3 upgradeSlotButton_


upgradeSlotButton_ :
    Int
    -> Int
    -> ( UpgradeSlot, Maybe Upgrade )
    -> Html Msg
upgradeSlotButton_ shipIdx upgradeIdx ( slot, selectedUpgrade ) =
    Html.button
        [ Attrs.class "selected-ships__upgrade-slot-button"
        , Attrs.attribute "aria-controls" (upgradeMenuId shipIdx upgradeIdx slot)
        ]
        [ case slot of
            ShipData.Officer ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--officer"
                    ]
                    []

            ShipData.Title ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--title"
                    ]
                    []

            ShipData.SupportTeam ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--support-team"
                    ]
                    []

            ShipData.OffensiveRetrofit ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--offensive-retrofit"
                    ]
                    []

            ShipData.DefensiveRetrofit ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--defensive-retrofit"
                    ]
                    []

            ShipData.Turbolasers ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--turbolasers"
                    ]
                    []

            ShipData.Ordnance ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--ordnance"
                    ]
                    []

            ShipData.FleetCommand ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--fleet-command"
                    ]
                    []

            ShipData.WeaponsTeam ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--weapons-team"
                    ]
                    []

            ShipData.IonCannons ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--ion-cannons"
                    ]
                    []

            ShipData.ExperimentalRetrofit ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--experimental-retrofit"
                    ]
                    []

            ShipData.Superweapon ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--superweapon"
                    ]
                    []

            ShipData.Commander ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--commander"
                    ]
                    []

            ShipData.FleetSupport ->
                Html.span
                    [ Attrs.class "upgrade-icon upgrade-icon--fleet-support"
                    ]
                    []
        , List.singleton
            >> Html.b []
          <|
            case selectedUpgrade of
                Just upgrade ->
                    Html.span
                        []
                        [ Html.text upgrade.name
                        , Html.span
                            [ Attrs.class "upgrade-slot-button__points" ]
                            [ Html.text <| String.fromInt upgrade.points ]
                        ]

                Nothing ->
                    Html.text "None"
        ]


selectableCards :
    Faction
    -> Int
    -> Int
    -> Bool
    -> List ( UpgradeSlot, Maybe Upgrade )
    -> Maybe Upgrade
    -> UpgradeSlot
    -> Html Msg
selectableCards =
    LazyHtml.lazy7 selectableCards_


{-| Given a ships upgrade slots, and a slot to select for, return
a list of upgrades that can be selected for that slot.
(some upgrades require multiple slots to be filled, hence the need for allSlots)
-}
selectableCards_ :
    Faction
    -> Int
    -> Int
    -> Bool
    -> List ( UpgradeSlot, Maybe Upgrade )
    -> Maybe Upgrade
    -> UpgradeSlot
    -> Html Msg
selectableCards_ faction shipIdx upgradeIdx show shipSlots existingUpgrade slot =
    let
        availableSlots : List UpgradeSlot
        availableSlots =
            shipSlots
                |> List.map Tuple.first
    in
    Html.node
        "select-menu"
        [ Attrs.classList
            [ ( "upgrade-list-container__upgrade-list", True )
            , ( "upgrade-list-container__upgrade-list--show", show )
            ]
        , Attrs.id <| upgradeMenuId shipIdx upgradeIdx slot
        , Attrs.attribute "show"
            (if show then
                "true"

             else
                "false"
            )
        , Events.on "requestedopen"
            (Decode.succeed
                (UpgradeSlotButtonClicked shipIdx slot)
            )
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
                        [ Attrs.class "upgrade-list__upgrade-grid-item" ]
                        [ Html.button
                            [ Events.onClick (UpgradeSelected shipIdx existingUpgrade upgrade)
                            ]
                            [ Html.span
                                [ Attrs.class "upgrade-grid-item__upgrade-name"
                                ]
                                [ Html.text <| upgrade.name ]
                            , Html.span
                                [ Attrs.class "upgrade-grid-item__upgrade-points" ]
                                [ Html.text << String.fromInt <| upgrade.points ]
                            , Html.span
                                [ Attrs.class "upgrade-grid-item__info-icon" ]
                                [ Html.text "?" ]
                            ]
                        ]
                )
        )
