#!/usr/bin/env escript

-mode(compile).

-define(M0, {0, ["111","101","101","101","111"]}).
-define(M1, {1, ["110","010","010","010","111"]}).
-define(M2, {2, ["111","001","111","100","111"]}).
-define(M3, {3, ["111","001","111","001","111"]}).
-define(M4, {4, ["101","101","111","001","001"]}).
-define(M5, {5, ["111","100","111","001","111"]}).
-define(M6, {6, ["111","100","111","101","111"]}).
-define(M7, {7, ["111","001","011","010","010"]}).
-define(M8, {8, ["111","101","111","101","111"]}).
-define(M9, {9, ["111","101","111","001","111"]}).

main([FileName]) ->
    try
        {ok, File} = file:open(FileName, []),
        FiveLines = prefetch(File, 5),
        iterate_rows(File, FiveLines, 0)
    catch
        _:_ -> ok
    end;
main(_) ->
    usage().

usage() ->
    io:format("usage: pochta-rossii.erl file\n"),
    halt(1).

prefetch(File, Lines) ->
    [begin {ok, L} = file:read_line(File), L end || _ <- lists:seq(1, Lines)].

match([], []) -> true;
match([[A,B,C]|Es], [[A,B,C|_]|Ls]) -> match(Es, Ls);
match(_, _) -> false.

iterate_rows(File, FiveLines, Row) ->
    iterate_columns(FiveLines, Row, 0),
    case file:read_line(File) of
        {ok, L} -> iterate_rows(File, tl(FiveLines)++[L], Row+1);
        _ -> ok
    end.

iterate_columns([[]|_], _, _) -> ok;
iterate_columns(FiveLines, Row, Column) ->
    test(FiveLines, Row, Column),
    iterate_columns([tl(L) || L <- FiveLines], Row, Column+1).

test(FiveLines, Row, Column) ->
    _ = [
         io:format("~p at [~p, ~p]\n", [S, Row, Column])
         || {S, M} <- [?M0,?M1,?M2,?M3,?M4,?M5,?M6,?M7,?M8,?M9],
            match(M, FiveLines)
        ],
    ok.
