-module(node_snoop).

-export([start/0, stop/0, start_monitoring_nodes/0]).

start() ->
    register(?MODULE, spawn(?MODULE, start_monitoring_nodes, [])).

stop() ->
    net_kernel:monitor_nodes(false),	     
    io:format("Stopped monitoring nodes...~n"),
    ?MODULE ! stop.

start_monitoring_nodes() ->
    net_kernel:monitor_nodes(true),
    io:format("Monitoring nodes...~n"),
    loop().

loop() ->
    receive 
	stop ->
	    ok;
	{nodeup, Node} ->
	    io:format("Node [~p] came up.~n", [Node]),
	    loop();
	{nodedown, Node} ->
	    io:format("Node [~p] went down.~n", [Node]),
	    loop();
	Unknown ->
	    io:format("Unknown message [~p].~n", [Unknown]),
	    loop()
    end.
