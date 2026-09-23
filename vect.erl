-module(vect).
-export([zero/0, inc/2, merge/2, leq/2, clock/1, update/3, safe/2]).


zero() ->
    [].


inc(Name, T) ->
    case lists:keyfind(Name, 1, T) of
        false ->
            [{Name, 1} | T];

        {Name, Value} ->
            lists:keyreplace(Name, 1, T, {Name, Value + 1})
    end.


merge([], Time) ->
    Time;

merge([{Name, Ti} | Rest], Time) ->
    case lists:keyfind(Name, 1, Time) of
        {Name, Tj} ->
            [{Name, max(Ti, Tj)} |
             merge(Rest, lists:keydelete(Name, 1, Time))];

        false ->
            [{Name, Ti} | merge(Rest, Time)]
    end.


leq([], _Tj) ->
    true;

leq(_Ti, []) ->
    false;

leq([{Node, Vali} | Vecti], Vectj) ->
    case lists:keyfind(Node, 1, Vectj) of
        {Node, Valj} ->
            case Vali =< Valj of
                true ->
                    leq(Vecti, Vectj);
                false ->
                    false
            end;

        false ->
            false
    end.


clock(_) ->
    [].


update(From, Time, Clock) ->
    {From, Value} = lists:keyfind(From, 1, Time),

    case lists:keyfind(From, 1, Clock) of
        {From, _} ->
            lists:keyreplace(From, 1, Clock, {From, Value});

        false ->
            [{From, Value} | Clock]
    end.


safe(Time, Clock) ->
    leq(Time, Clock).