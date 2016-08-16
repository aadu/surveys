module Main exposing (..)

import String exposing (lines)
import Regex
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events exposing (onClick, onDoubleClick, onInput, onSubmit)
import Exts.Html exposing (nbsp)


-- component import example
-- import Components.Hello exposing (hello)
-- APP


main : Program Never
main =
    Html.beginnerProgram { model = initModel, view = view, update = update }



-- MODEL


type alias Model =
    { questions : List Question
    , prompt : String
    , questionID : Maybe Int
    , responseID : Maybe Int
    }


type alias Question =
    { number : Int
    , prompt : String
    , promptInput : String
    , edit : Bool
    }


type alias Response =
    { number : Int
    , questionID : Int
    , prompt : String
    , promptImput : String
    }


initModel : Model
initModel =
    { questions = []
    , prompt = ""
    , questionID = Nothing
    , responseID = Nothing
    }


newQuestion : Int -> Question
newQuestion number =
    { number = number, prompt = "", promptInput = "", edit = True }



-- UPDATE


type Msg
    = NoOp
    | Save
    | AddQuestion
    | QuestionInput Question String
    | EditQuestion Question
    | Cancel
    | DeleteQuestion Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        AddQuestion ->
            let
                questionNum =
                    List.length (model.questions) + 1
            in
                { model | questions = ((newQuestion questionNum) :: model.questions) |> sortQuestions }

        DeleteQuestion number ->
            let
                questions =
                    List.filter
                        (\question -> question.number /= number)
                        model.questions
            in
                { model | questions = questions |> sortQuestions }

        QuestionInput question input ->
            let
                questions =
                    List.map
                        (\q ->
                            if q.number == question.number then
                                { q | promptInput = input, edit = input /= question.prompt }
                            else
                                q
                        )
                        model.questions
            in
                { model | questions = questions }

        EditQuestion question ->
            let
                questions =
                    List.map
                        (\q ->
                            if q.number == question.number then
                                { q | edit = True }
                            else
                                q
                        )
                        model.questions
            in
                { model | questions = questions }

        Save ->
            let
                questions =
                    List.map
                        (\q -> { q | prompt = q.promptInput, edit = False })
                        model.questions
            in
                { model | questions = questions }

        _ ->
            model


sortQuestions : List Question -> List Question
sortQuestions questions =
    let
        sortedQuestions =
            List.sortBy .number questions
    in
        List.indexedMap
            (\n question -> { question | number = (n + 1) })
            sortedQuestions



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "margin-top", "30px" ) ] ]
        [ -- inline CSS (literal)
          div [ class "row" ]
            [ questionList model.questions
            ]
        , div [ class "row" ]
            (List.map (\q -> (pre [] [ code [] [ (q |> toString |> text) ] ]))
                model.questions
            )
        ]


questionList : List Question -> Html Msg
questionList questions =
    div []
        [ ul [ class "collection" ] (List.map questionView (List.sortBy .number questions))
        , a [ class "btn-floating waves-effect", onClick AddQuestion ]
            [ i [ class "material-icons" ] [ text "add" ]
            ]
        , a [ class "btn-floating waves-effect", onClick Save ]
            [ i [ class "material-icons" ] [ text "save" ]
            ]
        ]


questionNumber : Question -> Html Msg
questionNumber question =
    strong [ class "blue-text text-darken-4" ]
        [ ("Q" ++ (question.number |> toString) |> text)
        ]


replaceSpaces : String -> String
replaceSpaces =
    Regex.replace Regex.All (Regex.regex " ") (\_ -> nbsp)


formatQuestionPrompt : Question -> Html Msg
formatQuestionPrompt question =
    let
        textParts =
            List.map text (question.prompt |> replaceSpaces |> lines)
    in
        p [ onDoubleClick (EditQuestion question) ] (List.intersperse (br [] []) textParts)


questionEdit : Question -> Html Msg
questionEdit question =
    div [ class "row" ]
        [ div
            [ class "input-field col s10"
            ]
            [ if question.edit then
                textarea
                    [ onInput (QuestionInput question)
                    , value question.promptInput
                    , class "materialize-textarea amber lighten-5"
                    , id ("edit-q" ++ (question.number |> toString))
                    ]
                    []
              else
                formatQuestionPrompt question
            ]
        ]


questionHeader : Question -> Html Msg
questionHeader question =
    div [ class "row" ]
        [ questionNumber question
        , div [ class "secondary-content" ]
            [ button [ onClick (EditQuestion question), class "btn-floating" ]
                [ i [ class "material-icons grey dark-1" ] [ text "edit" ] ]
            , button [ onClick (DeleteQuestion question.number), class "btn-floating", style [ ( "margin-left", "2mm" ) ] ]
                [ i [ class "material-icons red darken-2" ] [ text "close" ] ]
            ]
        ]


questionView : Question -> Html Msg
questionView question =
    li [ class "collection-item" ]
        [ questionHeader question
        , questionEdit question
        ]



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "33%" )
        , ( "border", "4px solid #337AB7" )
        ]
    }
