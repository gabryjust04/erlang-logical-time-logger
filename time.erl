-module(time).
-export([zero/0,inc/2,merge/2,leq/2,clock/1,update/3,safe/2]).


zero() ->
    0.

inc(_Name,T) ->
    T+1.

merge(Ti,Tj) ->
    case Ti>Tj of
        true -> Ti;
        false -> Tj end.

leq(Ti,Tj) ->
    case Ti=<Tj of
        true -> true;
        false ->false end.

clock(Nodes) ->
    lists:foldl(fun(Node,Acc) -> 
        [{Node,0}|Acc]
        end,[],Nodes).

update(Node,Time,Clock) ->
    lists:keyreplace(Node,1,Clock,{Node,Time}).


safe(_,[]) ->
    true;
safe(Time,[{_,Value}|Clock]) ->
    case Value<Time of
        true -> false;
        false-> safe(Time,Clock) 
    end.



