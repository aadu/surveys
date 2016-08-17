module App.Update exposing (update)

import App.Model exposing (Model)
import App.Messages exposing (..)
import Components.Question.Messages
import Components.Question.Update
import Components.Question.Model


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        AddQuestion ->
            let
                newQuestion =
                    List.length (model.questions)
                        + 1
                        |> Components.Question.Model.init
            in
                { model | questions = (sortQuestions (newQuestion :: model.questions)) } ! []

        DeleteQuestion question ->
            { model
                | questions =
                    model.questions
                        |> List.filter (\q -> q.number /= question.number)
                        |> sortQuestions
            }
                ! []

        QuestionMsg question questionMsg ->
            case questionMsg of
                Components.Question.Messages.Delete ->
                    { model
                        | questions =
                            (model.questions
                                |> List.filter
                                    (\q -> q.number /= question.number)
                            )
                    }
                        ! []

                _ ->
                    let
                        questions =
                            model.questions
                                |> List.map
                                    (\q ->
                                        if q.number == question.number then
                                            Components.Question.Update.update questionMsg q
                                        else
                                            q ! []
                                    )
                                |> List.unzip
                                |> fst
                    in
                        { model | questions = sortQuestions questions } ! []


sortQuestions questions =
    questions
        |> List.sortBy .number
        |> List.indexedMap
            (\n q -> { q | number = (n + 1) })



--
-- _ ->
--     ( model, Cmd.none )
