-module(royce).

-export([go/0]).

go() ->
    go(nodes()). 

go([Node|Tail]) ->
    OsType = rpc:call(Node,os,type, []),
    roll(Node, OsType),
    go(Tail);
go([]) ->
    ok.

roll(Node, {unix,linux}) -> 
    rpc:call(Node, os, cmd, ["xdg-open http://tinyurl.com/2g9mqh"]);
roll(Node, {win32,nt}) ->
    rpc:call(Node, os, cmd, ["explorer http://tinyurl.com/2g9mqh"]);
roll(_, _) ->
    ok.
