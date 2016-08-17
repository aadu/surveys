module App.Update exposing (update)

import App.Model exposing (Model)
import App.Messages exposing (..)
import App.Ports exposing (..)
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

        QuestionMsg question questionMsg ->
            (case questionMsg of
                Components.Question.Messages.DeleteDialog modalId ->
                    model ! [ dialog modalId ]

                Components.Question.Messages.Edit textAreaId ->
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
                        { model | questions = sortQuestions questions } ! [ autoresize textAreaId ]

                Components.Question.Messages.Delete ->
                    { model
                        | questions =
                            (model.questions
                                |> List.filter
                                    (\q -> q.number /= question.number)
                                |> sortQuestions
                            )
                    }
                        ! []

                Components.Question.Messages.Up ->
                    let
                        questions =
                            model.questions
                                |> List.map
                                    (\q ->
                                        if q.number == (question.number - 1) then
                                            { q | number = question.number } ! []
                                        else if q.number == question.number then
                                            { q | number = (q.number - 1) } ! []
                                        else
                                            q ! []
                                    )
                                |> List.unzip
                                |> fst
                    in
                        { model | questions = sortQuestions questions } ! []

                Components.Question.Messages.Down ->
                    let
                        questions =
                            model.questions
                                |> List.map
                                    (\q ->
                                        if q.number == (question.number + 1) then
                                            { q | number = question.number } ! []
                                        else if q.number == question.number then
                                            { q | number = (q.number + 1) } ! []
                                        else
                                            q ! []
                                    )
                                |> List.unzip
                                |> fst
                    in
                        { model | questions = sortQuestions questions } ! []

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
            )


sortQuestions questions =
    questions
        |> List.sortBy .number
        |> List.indexedMap
            (\n q ->
                { q
                    | number = (n + 1)
                    , placeInList =
                        (if ((n == 0) && ((List.length questions) == 1)) then
                            Components.Question.Model.FirstAndLast
                         else if (n == 0) then
                            Components.Question.Model.First
                         else if ((n + 1) == (List.length questions)) then
                            Components.Question.Model.Last
                         else
                            Components.Question.Model.Middle
                        )
                }
            )



--
-- _ ->
--     ( model, Cmd.none )
