module App.Messages exposing (Msg(..))

import Components.Question.Messages
import Components.Question.Model as Question


type Msg
    = NoOp
    | AddQuestion
    | DeleteQuestion Question.Model
    | QuestionMsg Question.Model Components.Question.Messages.Msg
