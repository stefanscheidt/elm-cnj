module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http


type alias Model =
    String


initModel : Model
initModel =
    "Finding a joke ..."


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "http://api.icndb.com/jokes/random"

        request =
            Http.getString url

        cmd =
            Http.send Joke request
    in
        cmd


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )


type Msg
    = Joke (Result Http.Error String)
    | Reload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok joke) ->
            ( joke, Cmd.none )

        Joke (Err err) ->
            ( toString (err), Cmd.none )

        Reload ->
            ( model, randomJoke )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model ]
        , div [] [ button [ type_ "button", onClick Reload ] [ text "Reload" ] ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
