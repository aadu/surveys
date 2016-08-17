module Main exposing (..)

import Html.App exposing (program)
import App.Model exposing (init, Model)
import App.Update exposing (update)
import App.View exposing (view)
import App.Subscriptions exposing (subscriptions)


main : Program Never
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
