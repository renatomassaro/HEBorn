module Apps.LogViewer.Context.Messages exposing (Msg(..), MenuAction(..))

import ContextMenu exposing (ContextMenu)
import Apps.Instances.Models exposing (InstanceID)
import Apps.LogViewer.Context.Models exposing (Context)


type MenuAction
    = DoA
    | DoB


type Msg
    = MenuMsg (ContextMenu.Msg Context)
    | MenuClick MenuAction InstanceID
