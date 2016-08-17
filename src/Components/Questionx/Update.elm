module Components.Question.Update exposing (..)

import Components.Question.Model exposing (..)
import Components.Question.Messages exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Input input ->
            { model | promptInput = input } ! []

        Edit modalId ->
            { model | edit = not model.edit } ! []

        Save ->
            { model | edit = False, prompt = model.promptInput } ! []

        _ ->
            model ! []
