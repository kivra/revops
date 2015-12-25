%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc revops
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(revops).

%%%_* Exports ==========================================================
-export([do/1]).
-export([undo/1]).

-export_type([revops/0]).
-export_type([revop/0]).

%%%_* Types ============================================================
-type setup()    :: fun(() -> any()).
-type teardown() :: fun((any()) -> any()).
-type revop()    :: {setup(), teardown()}.
-type revops()   :: [revop()].

%%%_* API ==============================================================
-spec do(revops()) -> [fun(() -> any())].
do(Revops) ->
  lists:foldl(fun({Setup, Teardown}, Teardowns) ->
                  Result =
                    try
                      Setup()
                    catch
                      Class:Error ->
                        _ = undo(Teardowns),
                        erlang:Class(Error)
                    end,
                  [fun() -> Teardown(Result) end | Teardowns]
              end, [], Revops).

-spec undo([fun(() -> any())]) -> [any()].
undo(Teardowns) ->
  lists:map(fun(Teardown) -> Teardown() end, Teardowns).

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
