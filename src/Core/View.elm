module Core.View exposing (view)

import Html exposing (Html, div, text)
import Game.Account.Models exposing (isAuthenticated)
import Core.Messages exposing (CoreMsg(..))
import Core.Models exposing (CoreModel)
import OS.View
import Landing.View


view : CoreModel -> Html CoreMsg
view model =
    page model


page : CoreModel -> Html CoreMsg
page model =
    if isAuthenticated model.game.account then
        OS.View.view model
    else
        Html.map MsgLand (Landing.View.view model)


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
