%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% @doc revops_app_tests
%%% @end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(revops_app_tests).

%%%_* Includes =========================================================
-include_lib("eunit/include/eunit.hrl").

%%%_* Tests ============================================================
revops_save_env_test_() ->
  revops_eunit:setup(
    [revops_app:save_env([revops])],
    fun() ->
        {Setup, Teardown} = revops_app:save_env([revops]),
        ok = application:set_env(revops, x, 1),
        Saved = Setup(),
        ok = application:set_env(revops, x, 2),
        ok = application:set_env(revops, y, 1),
        Teardown(Saved),
        ?assertEqual(Saved, [{revops, application:get_all_env(revops)}]),
        ?assertEqual({ok, 1}, application:get_env(revops, x)),
        ?assertEqual(undefined, application:get_env(revops, y))
    end).

revops_setup_env_test_() ->
  revops_eunit:setup(
    [revops_app:setup_env([{revops, [{a, 1}]}])],
    ?_assertEqual({ok, 1}, application:get_env(revops, a))
   ).

revops_ensure_apps_test_() ->
  revops_eunit:setup([revops_app:ensure_all_started([revops])],
                     ?_assert(true)).

%%%_* Emacs ============================================================
%%% Local Variables:
%%% allout-layout: t
%%% erlang-indent-level: 2
%%% End:
