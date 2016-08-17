module App.Model exposing (..)

import App.Messages exposing (Msg)
import Components.Question.Model as Question


type alias Model =
    { questions : List Question.Model }


init : ( Model, Cmd Msg )
init =
    { questions = [] } ! []
