module Components.Question.Model exposing (Model, init)


type InputState
    = Initial
    | HasError String
    | IsOkay


type alias Model =
    { number : Int
    , prompt : String
    , promptInput : String
    , edit : Bool
    }


init : Int -> Model
init num =
    { number = num, prompt = "", promptInput = "", edit = True }
