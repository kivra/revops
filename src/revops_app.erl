%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc revops_app
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(revops_app).

%%%_* Exports ==========================================================
-export([ensure_all_started/1]).
-export([save_env/1]).
-export([setup_env/1]).

%%%_* Types ============================================================
-type app()    :: atom().
-type key()    :: any().
-type val()    :: any().
-type appenv() :: {app(), [{key(), val()}]}.

%%%_* API ==============================================================
-spec ensure_all_started([app()]) -> revops:revop().
ensure_all_started(Apps) ->
  { fun() ->
        lists:map(fun(App) ->
                      {ok, Started} = application:ensure_all_started(App),
                      Started
                  end, Apps)
    end
  , fun(StartedList) ->
        lists:foreach(fun(Started) ->
                          lists:foreach(fun application:stop/1, Started)
                      end, StartedList)
    end
  }.

-spec setup_env([appenv()]) -> revops:revop().
setup_env(AppEnvs) ->
  Apps = [App || {App, _} <- AppEnvs],
  {Setup, Teardown} = save_env(Apps),
  { fun() ->
        SavedAppEnvs = Setup(),
        lists:foreach(fun set_all_env/1, AppEnvs),
        SavedAppEnvs
    end
  , Teardown
  }.

-spec save_env([app()]) -> revops:revop().
save_env(Apps) ->
  { fun() ->
        lists:map(fun(App) ->
                      Env = application:get_all_env(App),
                      {App, Env}
                  end, Apps)
    end
  , fun(AppEnvs) ->
        [unset_all_env(App) || {App, _Env} <- AppEnvs],
        lists:foreach(fun set_all_env/1, AppEnvs)
    end
  }.

%%%_* Internal functions ===============================================
unset_all_env(App) ->
  case application:get_all_env(App) of
    undefined ->
      [];
    Env ->
      [application:unset_env(App, Key) || {Key, _} <- Env]
  end.

set_all_env({App, Env}) ->
  [application:set_env(App, Key, Val) || {Key, Val} <- Env].

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
