module App.View exposing (view, Mdl)

import Html.App as App
import Html exposing (..)
import Html exposing (..)
import App.Model exposing (Model, model)
import App.Update exposing (Msg(..))
import Components.Question as Question
import Material
import Material.Layout as Layout


type alias Mdl =
    Material.Model


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.scrolling
        ]
        { header = []
        , drawer = []
        , tabs = ( [], [] )
        , main =
            [ (model
                |> .question
                |> Question.view
                |> App.map QuestionMsg
              )
            ]
        }



--
-- |> Material.Scheme.top
