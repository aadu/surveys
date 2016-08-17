module App.Model exposing (model, Model)

import Material
import Components.Question as Question


type alias Model =
    { question : Question.Model
    , mdl : Material.Model
    }


model : Model
model =
    { question = (Question.model 1)
    , mdl = Material.model
    }
