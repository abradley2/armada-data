module Main exposing (Eff(..), Model, Msg(..), main)

import Browser
import Css
import FleetBuilder
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import I18Next exposing (Translations)
import Language
import NewFleetForm
import ShipData exposing (Faction(..))
import String.Nonempty as NonemptyString
import Theme
import Translations


type Form
    = FleetBuilder FleetBuilder.Model
    | NewFleetForm NewFleetForm.Model


type alias Model =
    { form : Maybe Form
    , language : List Translations
    }


type Eff
    = EffNone


perform : Eff -> Cmd Msg
perform effect =
    case effect of
        EffNone ->
            Cmd.none


type Msg
    = SelectFleetClicked FleetBuilder.Model
    | CreateFleetClicked
    | CreateFleetFormSubmitted NewFleetForm.ValidModel
    | NewFleetFormMsg NewFleetForm.Msg


init : ( Model, Eff )
init =
    ( { form = Nothing
      , language = List.singleton Language.defaultLanguage
      }
    , EffNone
    )


update : Msg -> Model -> ( Model, Eff )
update msg model =
    case msg of
        NewFleetFormMsg subMsg ->
            case model.form of
                Just (NewFleetForm form) ->
                    let
                        ( nextForm, submitted ) =
                            NewFleetForm.update model.language subMsg form
                    in
                    case submitted of
                        Nothing ->
                            ( { model | form = Just (NewFleetForm nextForm) }, EffNone )

                        Just submittedForm ->
                            ( { model
                                | form =
                                    Just
                                        (FleetBuilder <|
                                            FleetBuilder.init
                                                (NonemptyString.toString submittedForm.name)
                                                submittedForm.faction
                                        )
                              }
                            , EffNone
                            )

                _ ->
                    ( model, EffNone )

        SelectFleetClicked fleetBuilderModel ->
            ( { model | form = Just <| FleetBuilder fleetBuilderModel }, EffNone )

        CreateFleetFormSubmitted form ->
            ( { model
                | form =
                    Just <|
                        FleetBuilder <|
                            FleetBuilder.init (NonemptyString.toString form.name) form.faction
              }
            , EffNone
            )

        CreateFleetClicked ->
            ( { model | form = Just <| NewFleetForm NewFleetForm.init }, EffNone )


view : Model -> Html Msg
view model =
    Html.div
        [ Attrs.css
            [ Css.backgroundColor Theme.softWhite
            , Css.height (Css.vh 100)
            , Css.width (Css.vw 100)
            ]
        ]
        [ Html.div
            []
            [ Html.h3
                []
                [ Html.text <|
                    Translations.greeting model.language
                ]
            ]
        , case model.form of
            Just (NewFleetForm form) ->
                NewFleetForm.view model.language form
                    |> Html.map NewFleetFormMsg

            Just (FleetBuilder _) ->
                Html.text "Fleet Builder Form"

            Nothing ->
                Html.div
                    []
                    [ Html.button
                        [ Events.onClick CreateFleetClicked
                        ]
                        [ Html.text <|
                            Translations.createFleetButton model.language
                        ]
                    ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = always (Tuple.mapSecond perform init)
        , update = \msg -> update msg >> Tuple.mapSecond perform
        , view = view >> Html.toUnstyled
        , subscriptions = always Sub.none
        }
