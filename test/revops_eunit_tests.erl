%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc revops_eunit_tests
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(revops_eunit_tests).

%%%_* Includes =========================================================
-include_lib("eunit/include/eunit.hrl").

%%%_* Tests ============================================================
mock_test_() ->
  revops_eunit:setup(
    [revops_mock:setup_mocks(
       [ {revops_dummy, foo, fun() -> foo end}
       , {revops_dummy, bar, 0, bar}
       ])
    ],
    [ ?_assertEqual(foo, revops_dummy:foo())
    , ?_assertEqual(bar, revops_dummy:bar())
    ]).

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
