module Components.Question exposing (model, update, view, Model, Msg)

import Material
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as App
import Html.Events exposing (..)
import Material.Card as Card
import Material.Options as Options
import Material.Elevation as Elevation
import Material.Options exposing (css)
import Material.Color as Color


-- MODEL


type alias Model =
    { number : Int
    , prompt : String
    , promptInput : String
    , edit : Bool
    , raised : Bool
    , placeInList : PlaceInList
    , mdl : Material.Model
    }


type PlaceInList
    = First
    | Middle
    | Last
    | FirstAndLast
    | TBD


model : Int -> Model
model num =
    { number = num, prompt = "", promptInput = "", edit = True, placeInList = TBD, mdl = Material.model, raised = False }



-- MESSAGES/UPDATE


type Msg
    = NoOp
    | Save
    | Raise
    | Edit String
    | Delete
    | DeleteDialog String
    | Up
    | Down
    | Input String
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input input ->
            { model | promptInput = input } ! []

        Edit modalId ->
            { model | edit = not model.edit } ! []

        Save ->
            { model | edit = False, prompt = model.promptInput } ! []

        Raise ->
            { model | raised = (not model.raised) } ! []

        Mdl msg' ->
            Material.update msg' model

        _ ->
            model ! []



-- VIEW


type alias Mdl =
    Material.Model


white : Options.Property c m
white =
    Color.text Color.white


view : Model -> Html Msg
view model =
    Card.view
        [ css "height" "128px"
        , css "width" "128px"
        , Color.background (Color.color Color.Brown Color.S500)
          -- Elevation
        , if model.raised then
            Elevation.e8
          else
            Elevation.e2
        , Elevation.transition 250
        , Options.attribute <| onMouseEnter Raise
        , Options.attribute <| onMouseLeave Raise
        ]
        [ Card.title [] [ Card.head [ white ] [ text "Hover here" ] ] ]
