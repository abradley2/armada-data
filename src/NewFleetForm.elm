module NewFleetForm exposing (Model, Msg(..), ValidModel, init, update, view)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import I18Next exposing (Translations)
import Json.Decode as Decode
import ShipData exposing (Faction(..))
import String.Nonempty as NonemptyString exposing (NonemptyString)
import Translations.Factions
import Translations.NewFleetForm as Translations
import Verify.Form exposing (FieldValidator, FormValidator)


type alias Model =
    { name : String
    , nameError : Maybe String
    , faction : Maybe Faction
    , factionError : Maybe String
    }


update : List Translations -> Msg -> Model -> ( Model, Maybe ValidModel )
update language msg model =
    case msg of
        NameChanged name ->
            ( { model | name = name }, Nothing )

        FactionSelected faction ->
            ( { model | faction = Just faction }, Nothing )

        SubmitClicked ->
            case
                Verify.Form.run
                    (fleetFormValidator language)
                    { model
                        | nameError = Nothing
                        , factionError = Nothing
                    }
            of
                Err nextModel ->
                    ( nextModel, Nothing )

                Ok validModel ->
                    ( model, Just validModel )


type Msg
    = NameChanged String
    | FactionSelected Faction
    | SubmitClicked


type alias ValidModel =
    { name : NonemptyString
    , faction : Faction
    }


fleetFormValidator : List Translations -> FormValidator Model ValidModel
fleetFormValidator translations =
    Verify.Form.validate ValidModel
        |> Verify.Form.verify .name (nameValidator translations)
        |> Verify.Form.verify .faction (factionValidator translations)


nameValidator : List Translations -> FieldValidator String Model NonemptyString
nameValidator translations name =
    case NonemptyString.fromString name of
        Just validName ->
            Ok validName

        Nothing ->
            Err <|
                \form ->
                    { form
                        | nameError =
                            Just
                                (Translations.emptyNameError translations)
                    }


factionValidator : List Translations -> FieldValidator (Maybe Faction) Model Faction
factionValidator translations faction =
    case faction of
        Just validFaction ->
            Ok validFaction

        Nothing ->
            Err <|
                \form ->
                    { form
                        | factionError =
                            Just
                                (Translations.factionRequiredError translations)
                    }


nameInputId : String
nameInputId =
    "new-fleet-name"


factionSelectId : String
factionSelectId =
    "new-fleet-faction"


view : List Translations -> Model -> Html Msg
view language model =
    Html.div
        [ Attrs.css
            [ Css.displayFlex
            , Css.flexDirection Css.column
            ]
        ]
        [ Html.div
            []
            [ Html.label
                [ Attrs.for nameInputId
                ]
                [ Html.text <|
                    Translations.nameLabel language
                ]
            , Html.input
                [ Attrs.id nameInputId
                , Events.onInput NameChanged
                ]
                [ Html.text model.name
                ]
            , Html.br [] []
            , Html.text <| Maybe.withDefault "" model.nameError
            ]
        , Html.div
            []
            [ Html.label
                [ Attrs.for factionSelectId
                ]
                [ Html.text <|
                    Translations.factionLabel language
                ]
            , Html.select
                [ Attrs.id factionSelectId
                , Events.on
                    "change"
                    (Decode.at [ "target", "value" ] Decode.string
                        |> Decode.andThen
                            (\val ->
                                if val == Translations.Factions.galacticEmpire language then
                                    Decode.succeed (FactionSelected GalacticEmpire)

                                else if val == Translations.Factions.rebelAlliance language then
                                    Decode.succeed (FactionSelected RebelAlliance)

                                else
                                    Decode.fail ""
                            )
                    )
                ]
                [ Html.option
                    []
                    [ Html.text <|
                        Translations.factionSelectPlaceholder language
                    ]
                , Html.option
                    []
                    [ Html.text <|
                        Translations.Factions.galacticEmpire language
                    ]
                , Html.option
                    []
                    [ Html.text <|
                        Translations.Factions.rebelAlliance language
                    ]
                ]
            , Html.br [] []
            , Html.text <| Maybe.withDefault "" model.factionError
            ]
        , Html.div
            []
            [ Html.button
                [ Events.onClick SubmitClicked
                ]
                [ Html.text <|
                    Translations.createButtonLabel language
                ]
            ]
        ]


init : Model
init =
    { name = ""
    , nameError = Nothing
    , faction = Nothing
    , factionError = Nothing
    }
