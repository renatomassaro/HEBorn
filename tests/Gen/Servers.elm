module Gen.Servers exposing (..)

import Dict
import Game.Shared exposing (IP)
import Game.Servers.Models exposing (..)
import Game.Servers.Filesystem.Models exposing (Filesystem)
import Game.Servers.Logs.Models exposing (Logs)
import Game.Servers.Processes.Models exposing (Processes)
import Gen.Filesystem
import Gen.Processes
import Gen.Utils exposing (..)


id : Int -> ServerID
id seedInt =
    fuzz1 seedInt idSeed


idSeed : StringSeed
idSeed seed =
    smallStringSeed seed


{-| ip is todo
-}
ip : Int -> IP
ip seedInt =
    fuzz1 seedInt ipSeed


ipSeed : StringSeed
ipSeed seed =
    smallStringSeed seed


server : Int -> Server
server seedInt =
    StdServer
        (serverData seedInt)


serverData : Int -> ServerData
serverData seedInt =
    let
        ( id, ip ) =
            fuzz2
                seedInt
                idSeed
                ipSeed
    in
        serverArgs
            id
            ip
            (Gen.Filesystem.fsRandom seedInt)
            Dict.empty
            (Gen.Processes.processes seedInt)


serverArgs : ServerID -> IP -> Filesystem -> Logs -> Processes -> ServerData
serverArgs id ip filesystem logs processes =
    { id = id
    , ip = ip
    , filesystem = filesystem
    , logs = logs
    , processes = processes
    }


model : Int -> Servers
model seedInt =
    addServer initialServers (serverData seedInt)
