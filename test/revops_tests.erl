%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc revops_tests
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(revops_tests).

%%%_* Includes =========================================================
-include_lib("eunit/include/eunit.hrl").

%%%_* Tests ============================================================
revops_test_() ->
  F1 = {fun() -> setup end, fun(setup) -> ok end},
  Crash = {fun() -> throw(crash) end, fun(_) -> ok end},
  [ ?_assertEqual([ok,ok], revops:undo(revops:do([F1, F1])))
  , ?_assertThrow(crash, revops:undo(revops:do([F1, F1, Crash])))
  ].

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
