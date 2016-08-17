module Components.Question.Model exposing (Model, init, PlaceInList(..))


type InputState
    = Initial
    | HasError String
    | IsOkay


type PlaceInList
    = First
    | Middle
    | Last
    | FirstAndLast
    | TBD


type alias Model =
    { number : Int
    , prompt : String
    , promptInput : String
    , edit : Bool
    , placeInList : PlaceInList
    }


init : Int -> Model
init num =
    { number = num, prompt = "", promptInput = "", edit = True, placeInList = TBD }
