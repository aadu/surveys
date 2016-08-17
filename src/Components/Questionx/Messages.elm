module Components.Question.Messages exposing (..)


type Msg
    = NoOp
    | Save
    | Edit String
    | Delete
    | DeleteDialog String
    | Up
    | Down
    | Input String
