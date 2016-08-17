module App.Subscriptions exposing (subscriptions)

import App.Model exposing (Model, model)
import App.Update exposing (..)
import Material.Layout as Layout


subscriptions model =
    Layout.subs Mdl model
