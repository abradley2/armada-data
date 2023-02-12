module Main exposing (Eff(..), Model, Msg(..), main)

import Browser
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Theme exposing (theme)


type alias Model =
    {}


type Eff
    = EffNone


perform : Eff -> Cmd Msg
perform effect =
    case effect of
        EffNone ->
            Cmd.none


type Msg
    = NoOp


init : ( Model, Eff )
init =
    ( {}, EffNone )


update : Msg -> Model -> ( Model, Eff )
update msg model =
    ( model, EffNone )


view : Model -> Html Msg
view _ =
    Html.div
        [ Attrs.css
            [ Css.backgroundColor theme.softWhite
            , Css.height (Css.vh 100)
            , Css.width (Css.vw 100)
            ]
        ]
        [ Html.button
            [ Events.onClick NoOp ]
            [ Html.text "Click me" ]
        ]


main : Program () Model Msg
main =
    Browser.element
        { init = always (Tuple.mapSecond perform init)
        , update = \msg -> update msg >> Tuple.mapSecond perform
        , view = view >> Html.toUnstyled
        , subscriptions = always Sub.none
        }
