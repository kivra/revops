%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc revops_mock
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(revops_mock).

%%%_* Exports ==========================================================
-export([setup_mocks/1]).

%%%_* Types ============================================================
-type func()     :: atom().
-type mockspec() :: {module(), func(), fun()}
                  | {module(), func(), arity(), any()}.

%%%_* API ==============================================================
-spec setup_mocks([mockspec()]) -> mock:revop().
setup_mocks(MockSpecs) ->
  { fun() ->
        lists:usort(
          lists:map(fun({Mod, Func, Expect}) ->
                        ensure_meck_new(Mod, [passthrough]),
                        meck:expect(Mod, Func, Expect),
                        Mod;
                       ({Mod, Func, Arity, Expect}) ->
                        ensure_meck_new(Mod, [passthrough]),
                        meck:expect(Mod, Func, Arity, Expect),
                        Mod
                    end, MockSpecs))
    end
  , fun(MockedModules) ->
        lists:foreach(fun meck:unload/1, MockedModules)
    end
  }.

%%%_* Internal =========================================================
ensure_meck_new(Mod, Options) ->
  try meck:new(Mod, Options)
  catch error:{already_started, _} -> ok
  end.

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
