-module(magoo_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    %% {ok, { {one_for_one, 3, 10}, [ ?CHILD(magoo_server, worker )]} }.
    ChildModule = magoo_server,

    RestartStrategy = one_for_one, % one_for_all
    MaxRestart = 3,
    MaxSecondsBetweenRestarts = 10,
    SupFlags = {RestartStrategy,MaxRestart,MaxSecondsBetweenRestarts},

    StartFunc = {ChildModule, start_link, []},
    Restart = permanent, %  | transient | temporary
    Shutdown = 5000, % brutal_kill, | int()>0 | infinity    
    Type = worker,

    {ok, {SupFlags, 
	  [
	   { ChildModule, StartFunc, Restart, Shutdown, Type, [ChildModule]}
	  ]}}.


%% child_spec() = {Id,StartFunc,Restart,Shutdown,Type,Modules}
%%  Id = term()
%%  StartFunc = {M,F,A}
%%   M = F = atom()
%%   A = [term()]
%%  Restart = permanent | transient | temporary
%%  Shutdown = brutal_kill | int()>0 | infinity
%%  Type = worker | supervisor
%%  Modules = [Module] | dynamic
%%   Module = atom()
