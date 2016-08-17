module App.Update exposing (update, Msg(..))

import Array exposing (Array)
import App.Model exposing (Model)
import Material
import Material.Helpers exposing (pure)
import Components.Question as Question
import Material.Helpers exposing (pure, lift, map1st, map2nd)


-- import App.Ports exposing (..)
-- UPDATE


type Msg
    = Increase Int
    | Reset Int
    | Add
    | Remove
    | QuestionMsg Question.Msg
    | Mdl (Material.Msg Msg)


map : Int -> (a -> a) -> Array a -> Array a
map k f a =
    Array.get k a
        |> Maybe.map (\x -> Array.set k (f x) a)
        |> Maybe.withDefault a


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg' ->
            Material.update msg' model

        QuestionMsg a ->
            lift .question (\m x -> { m | question = x }) QuestionMsg Question.update a model

        _ ->
            model ! []
