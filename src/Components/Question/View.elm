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
        [ questionItem
            (if question.edit then
                saveBtn question
             else
                editBtn question
            )
        , questionItem (deleteBtn question)
        , questionItem (upBtn question)
        ]


questionItem view =
    li [ style [ ( "margin-bottom", "3px" ) ] ] [ view ]


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
                ++ "waves-effect waves-light btn-floating"
            )
        ]
        [ i [ class "material-icons" ] [ text "save" ] ]


editBtn : Model -> Html Msg
editBtn model =
    a
        [ onClick Edit
        , class "waves-effect waves-light btn-floating"
        ]
        [ i [ class "material-icons" ] [ text "edit" ] ]


upBtn : Model -> Html Msg
upBtn model =
    a
        [ onClick Edit
        , class "waves-effect waves-light btn-floating"
        ]
        [ i [ class "material-icons" ] [ text "swap_vert" ] ]


deleteBtn : Model -> Html Msg
deleteBtn question =
    let
        modalId =
            ("delete-question-modal-" ++ (question.number |> toString))
    in
        div []
            [ button
                [ onClick Delete
                , class "waves-effect waves-light btn-floating"
                , attribute "data-target" modalId
                ]
                [ i [ class "material-icons" ] [ text "close" ] ]
            ]


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
            [ h4 [] [ text "Are you sure?" ]
            , p [] [ text deleteMsg ]
            ]
        , div [ class "modal-footer" ]
            [ a
                [ href "#!"
                , class "modal-action modal-close waves-effect waves-red btn red"
                , onClick (Edit)
                ]
                [ text ("Delete Question " ++ (question.number |> toString)) ]
            , a
                [ href "#!"
                , class "modal-action modal-close waves-effect waves-green btn-flat"
                ]
                [ text "Nope, I changed my mind" ]
            ]
        ]


editPrompt : Model -> Html Msg
editPrompt question =
    div
        [ class "input-field" ]
        [ if question.edit then
            textarea
                [ onInput Input
                , placeholder "Enter question prompt text"
                , value question.promptInput
                , class "materialize-textarea"
                , id ("edit-q" ++ (question.number |> toString))
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
        p [ onDoubleClick Edit ] (List.intersperse (br [] []) textParts)


replaceSpaces : String -> String
replaceSpaces =
    Regex.replace Regex.All (Regex.regex " {2}") (\_ -> nbsp ++ nbsp)
