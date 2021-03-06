module Helper.Filesystem
    exposing
        ( addFileRecursively
        , addPathParents
        )

import Game.Servers.Filesystem.Models exposing (..)


{-| Private function used by a reducer in addPathParents to add folder to given
filesystem.
-}
addFolderReducer : String -> ( Filesystem, String ) -> ( Filesystem, String )
addFolderReducer folderName ( filesystem, path ) =
    let
        folder =
            Folder { id = "id", name = folderName, path = path }

        filesystem_ =
            addFile folder filesystem

        path_ =
            if path /= "/" then
                path ++ "/" ++ folderName
            else
                path ++ folderName
    in
        ( filesystem_, path_ )


{-| Like "mkdir -p", add folders recursively for given path.
-}
addPathParents : String -> Filesystem -> Filesystem
addPathParents path filesystem =
    if pathExists path filesystem then
        filesystem
    else
        let
            ( filesystem_, _ ) =
                path
                    |> String.split "/"
                    |> List.filter ((/=) "")
                    |> List.foldl addFolderReducer ( filesystem, "" )
        in
            filesystem_


{-| addFileRecursively is a helper because on tests we often want to add a file
in a specific path which *we assume* already exists. On production, we do not assume
this, the path must exists. For a test, however, it's OK to assume. This helper
allow us to have this assumption when adding files. It's usually safe to use
addFileRecursively instead of addFile for tests, unless you want to test exactly
the assumption that the path the file is being added to must exist.
-}
addFileRecursively : File -> Filesystem -> Filesystem
addFileRecursively file filesystem =
    filesystem
        |> addPathParents (getFilePath file)
        |> addFile file
