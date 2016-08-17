module Components.Question.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Components.Question.Model exposing (..)
import Components.Question.Messages exposing (..)
import String
import Regex
import Exts.Html exposing (nbsp)


view : Model -> Html Msg
view model =
    div [ class "card-panel hoverable" ]
        [ div [ class "row" ]
            [ div [ class "col s11" ] [ content model ]
            , div [ class "col s1" ] [ menu model ]
            ]
        ]


content : Model -> Html Msg
content question =
    div []
        [ header question
        , editPrompt question
        ]


header : Model -> Html Msg
header question =
    div [ class "row" ]
        [ label question ]


menu : Model -> Html Msg
menu question =
    ul [ class "right" ]
        [ saveOrEditBtn question
        , deleteBtn question
        , upBtn question
        , downBtn question
        ]


questionItem view =
    li [ class "right", style [ ( "margin-bottom", "3px" ) ] ] [ view ]


saveOrEditBtn : Model -> Html Msg
saveOrEditBtn model =
    if not model.edit then
        editBtn model "edit"
    else if model.promptInput == model.prompt && model.prompt /= "" then
        editBtn model "done"
    else if model.promptInput /= "" then
        saveBtn model
    else
        text ""


saveBtn : Model -> Html Msg
saveBtn model =
    a
        [ onClick Save
        , class
            ((if model.promptInput == "" then
                "disabled "
              else if model.promptInput == model.prompt then
                "disabled "
              else
                ""
             )
                ++ "waves-effect waves-light btn-floating blue btn-large"
            )
        ]
        [ i [ class "material-icons" ] [ text "save" ] ]
        |> questionItem


editBtn : Model -> String -> Html Msg
editBtn model icon =
    a
        [ onClick (Edit (editId model))
        , class "waves-effect waves-light btn-floating"
        ]
        [ i [ class "material-icons" ]
            [ text icon
            ]
        ]
        |> questionItem


upBtn : Model -> Html Msg
upBtn model =
    case model.placeInList of
        FirstAndLast ->
            text ""

        First ->
            text ""

        _ ->
            a
                [ onClick Up
                , class "waves-effect waves-light btn-floating"
                ]
                [ i [ class "fa fa-angle-up", (attribute "aria-hidden" "true") ] [] ]
                |> questionItem


downBtn : Model -> Html Msg
downBtn model =
    case model.placeInList of
        FirstAndLast ->
            text ""

        Last ->
            text ""

        _ ->
            a
                [ onClick Down
                , class "waves-effect waves-light btn-floating"
                ]
                [ i [ class "fa fa-angle-down", (attribute "aria-hidden" "true") ] [] ]
                |> questionItem


deleteBtn : Model -> Html Msg
deleteBtn question =
    let
        modalId =
            ("delete-question-modal-" ++ (question.number |> toString))
    in
        div []
            [ deleteDialog modalId question
            , button
                [ onClick (DeleteDialog modalId)
                , class "waves-effect waves-light btn-floating"
                , attribute "data-target" modalId
                ]
                [ i [ class "material-icons" ] [ text "close" ] ]
            ]
            |> questionItem


label : Model -> Html Msg
label question =
    let
        q =
            ("Q" ++ (toString question.number))
    in
        strong [ class "blue-text text-darken-4" ]
            [ text q ]


deleteMsg =
    "Delete this question?"


deleteDialog : String -> Model -> Html Msg
deleteDialog modalId question =
    div [ id modalId, class "modal" ]
        [ div [ class "modal-content" ]
            [ h4 []
                [ a
                    [ href "#!"
                    , class "btn-floating modal-action modal-close waves-effect btn-flat hoverable right"
                    ]
                    [ i [ class "material-icons black-text" ] [ text "close" ] ]
                , text
                    ("Are you sure you want to delete question " ++ (question.number |> toString) ++ "?")
                ]
            , if question.prompt /= "" then
                div [ class "panel-card yellow lighten-5 z-depth-2", style [ ( "padding", "8px" ) ] ]
                    [ promptText question
                    ]
              else
                text ""
            ]
        , div [ class "modal-footer" ]
            [ a
                [ href "#!"
                , class "modal-action modal-close waves-effect waves-red btn red hoverable"
                , onClick (Delete)
                ]
                [ text "Delete Question" ]
            , a
                [ href "#!"
                , class "modal-action modal-close waves-effect waves-green btn-flat"
                ]
                [ text "Cancel" ]
            ]
        ]


editId question =
    "edit-q" ++ (question.number |> toString)


editPrompt : Model -> Html Msg
editPrompt question =
    div
        [ class "input-field" ]
        [ if question.edit then
            textarea
                [ onInput Input
                , style [ ( "padding", "10px" ) ]
                , placeholder "Enter question prompt text"
                , value question.promptInput
                , class "materialize-textarea yellow lighten-5"
                , id (editId question)
                ]
                []
          else
            promptText question
        ]


promptText : Model -> Html Msg
promptText question =
    let
        textParts =
            question.prompt
                |> replaceSpaces
                |> String.lines
                |> List.map text
    in
        p [ onDoubleClick (Edit (editId question)), style [ ( "padding", "10px" ) ] ] (List.intersperse (br [] []) textParts)


replaceSpaces : String -> String
replaceSpaces =
    Regex.replace Regex.All (Regex.regex " {2}") (\_ -> nbsp ++ nbsp)
