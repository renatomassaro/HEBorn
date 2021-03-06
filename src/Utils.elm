module Utils
    exposing
        ( msgToCmd
        , boolToString
        , maybeToString
        , delay
        , safeUpdateDict
        , swap
        , andJust
        )

import Dict
import Time
import Task
import Process


-- I know this is not how it's supposed to be done but until I get a better
-- grasp of Elm, it's good enough.


msgToCmd : a -> Cmd a
msgToCmd msg =
    Task.perform (always msg) (Task.succeed ())


boolToString : Bool -> String
boolToString bool =
    case bool of
        True ->
            "true"

        False ->
            "false"


maybeToString : Maybe String -> String
maybeToString maybe =
    case maybe of
        Just something ->
            something

        Nothing ->
            ""


delay : Float -> msg -> Cmd msg
delay seconds msg =
    Process.sleep (Time.second * seconds)
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity


safeUpdateDict :
    Dict.Dict comparable a
    -> comparable
    -> a
    -> Dict.Dict comparable a
safeUpdateDict dict key value =
    let
        fnUpdate item =
            case item of
                Just _ ->
                    Just value

                Nothing ->
                    Nothing
    in
        Dict.update key fnUpdate dict


{-| Swaps the first argument of a 3-arity function with the last. Can be
helpful with test chains like:

    processes
        |> getProcessByID process.id
        |> andJust ((swap resumeProcess) processes 1)

To work with 2-arity functions, use the flip function from core.

-}
swap : (a -> b -> c -> d) -> c -> b -> a -> d
swap function =
    (\a b c -> function c b a)


{-| Like Maybe.andThen, but always returns `Just something`.
-}
andJust : (a -> b) -> Maybe a -> Maybe b
andJust callback maybe =
    case maybe of
        Just value ->
            Just (callback value)

        Nothing ->
            Nothing
