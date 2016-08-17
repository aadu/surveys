module App.Messages exposing (Msg(..))

import Components.Question.Messages
import Components.Question.Model as Question


type Msg
    = NoOp
    | AddQuestion
    | QuestionMsg Question.Model Components.Question.Messages.Msg
