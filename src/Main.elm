module Main exposing (..)

import Array exposing (Array)
import Html.App as App
import Html exposing (..)
import Material
import Components.Question as Question
import Material.Helpers exposing (pure, lift, map1st, map2nd)
import Material.Layout as Layout
import Material.Options as Options exposing (css, when)


-- MODEL


type alias Model =
    { question : Question.Model
    , mdl : Material.Model
    }


model : Model
model =
    { question = (Question.model 1)
    , mdl = Material.model
    }



-- import App.Ports exposing (..)
-- MESSAGES/UPDATE


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



-- VIEW


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.scrolling
        ]
        { header = header model
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ Options.div boxed
                [ (model
                    |> .question
                    |> Question.view
                    |> App.map QuestionMsg
                  )
                ]
            ]
        }


header : Model -> List (Html Msg)
header model =
    [ Layout.row
        [ Options.nop
        , css "transition" "height 333ms ease-in-out 0s"
        ]
        [ Layout.title [] [ text "Surveys" ]
        , Layout.spacer
        ]
    ]


boxed : List (Options.Property a b)
boxed =
    [ css "margin" "auto"
    , css "padding-left" "8%"
    , css "padding-right" "8%"
    ]



-- APP


main : Program Never
main =
    App.program
        { init = ( model, Layout.sub0 Mdl )
        , update = update
        , view = view
        , subscriptions = \_ -> (Layout.subs Mdl model.mdl)
        }
