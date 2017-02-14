module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD


type alias Joke =
    { id : String
    , iconUrl : String
    , value : String
    }


type alias Model =
    Joke


initModel : Model
initModel =
    { id = ""
    , iconUrl = "https://assets.chucknorris.host/img/avatar/chuck-norris.png"
    , value = "Fetching a Joke ..."
    }


fetchJoke : Cmd Msg
fetchJoke =
    let
        url =
            "https://api.chucknorris.io/jokes/random"

        request =
            Http.get url jokeDecoder
    in
        Http.send ReceiveJoke request


jokeDecoder : JD.Decoder Joke
jokeDecoder =
    JD.map3 Joke
        (JD.field "id" JD.string)
        (JD.field "icon_url" JD.string)
        (JD.field "value" JD.string)


type Msg
    = FetchJoke
    | ReceiveJoke (Result Http.Error Joke)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchJoke ->
            ( { model | value = initModel.value }, fetchJoke )

        ReceiveJoke (Ok joke) ->
            ( joke, Cmd.none )

        ReceiveJoke (Err err) ->
            ( { model | value = toString err }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Chuck Norris Jokes" ]
        , viewJoke model
        , button [ onClick FetchJoke ] [ text "Fetch a new joke" ]
        ]


viewJoke : Model -> Html Msg
viewJoke model =
    div []
        [ img [ src model.iconUrl ] []
        , p [] [ text model.value ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, fetchJoke )
        , subscriptions = (\_ -> Sub.none)
        , update = update
        , view = view
        }
