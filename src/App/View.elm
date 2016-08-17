module App.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Components.Question.View
import App.Model exposing (Model)
import App.Messages exposing (Msg(..))


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "margin-top", "30px" ) ] ]
        [ questionList model
        , questionsMenu
        , questionLog model
        ]


questionLog : Model -> Html Msg
questionLog model =
    model.questions
        |> List.map
            (\q ->
                pre []
                    [ code []
                        [ (q |> toString |> text) ]
                    ]
            )
        |> div [ class "row" ]


questionList : Model -> Html Msg
questionList model =
    model.questions
        |> List.map
            (\q ->
                App.map (QuestionMsg q) (Components.Question.View.view q)
            )
        |> div []


questionsMenu : Html Msg
questionsMenu =
    div [ class "row" ]
        [ a
            [ class "btn-floating waves-effect hoverable right btn-large"
            , onClick AddQuestion
            , style [ ( "margin-right", "10px" ) ]
            ]
            [ i [ class "material-icons" ] [ text "add" ]
            ]
        ]



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "33%" )
        , ( "border", "4px solid #337AB7" )
        ]
    }
