module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (type_)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)


type alias JokeResponse =
    { id : Int
    , joke : String
    , categories : List String
    }


jokeResponseDecoder : Decoder JokeResponse
jokeResponseDecoder =
    decode JokeResponse
        |> required "id" int
        |> required "joke" string
        |> optional "categories" (list string) []
        |> field "value"


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
            Http.get url jokeResponseDecoder

        cmd =
            Http.send Joke request
    in
        cmd


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )


type Msg
    = Joke (Result Http.Error JokeResponse)
    | Reload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok jokeResponse) ->
            ( (toString jokeResponse.id) ++ " " ++ jokeResponse.joke, Cmd.none )

        Joke (Err err) ->
            ( toString (err), Cmd.none )

        Reload ->
            ( model, randomJoke )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ button [ type_ "button", onClick Reload ] [ text "Reload" ] ]
        , div [] [ text model ]
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
