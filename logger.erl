-module(logger).
-export([start/1,stop/1]).


start(Nodes) ->
    spawn_link(fun() -> init(Nodes) end).

stop(Logger) ->
    Logger ! stop.

init(Nodes) ->
    Clock = vect:clock(Nodes),
    loop(Clock,[]).

add_to_list(Event, []) ->
    [Event];
add_to_list({From, Time, Msg} = Event,
            [{OFrom, OTime, OMsg} = Old | Rest]) ->
    case vect:leq(Time, OTime) of
        true ->
            [Event, Old | Rest];
        false ->
            [Old | add_to_list(Event, Rest)]
    end.
check_queue([], _Clock) ->
    [];

check_queue([{From, Time, Msg} = Event | Rest], Clock) ->
    case vect:safe(Time, Clock) of
        true ->
            log(From, Time, Msg),
            check_queue(Rest, Clock);

        false ->
            [Event | Rest]
    end.

loop(Clock,MsgList) ->
    receive
        {log,From,Time,Msg} ->
            NewClock = vect:update(From,Time,Clock),
            NewQueue = add_to_list({From,Time,Msg},MsgList),
            RemainingQueue = check_queue(NewQueue, NewClock),
            loop(NewClock,RemainingQueue);
        stop ->
            ok 
        end.

log(From, Time, Msg) ->
    io:format("log: ~w ~w ~p~n", [Time, From, Msg]).
