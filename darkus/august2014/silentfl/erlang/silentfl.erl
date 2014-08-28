#!/usr/bin/escript -n
% parameter -n for native compiling
%
% made by Silent
% silentfl@mail.ru
% 2014.08.27

-mode(compile).

-export([main/1]).
-record(digit, { x, y, value }).

main([FileName, _, M]) -> 
  init(self(), list_to_integer(M)),
  try
    {ok, File} = file:open(FileName, [read]),
    read_lines(File, 0)
  catch
    Err:X -> 
      io:format("fail: ~p ~p\n", [Err, X]),
      self() ! { done }
  end,
  receive
    { done } ->
      ok
  end.

read_lines(File, Level) ->
  case file:read_line(File) of
    {ok, L} ->
      proc_row ! { Level, L },
      read_lines(File, Level+1);
    eof -> 
      proc_waiter ! { read, done }
  end.

init(Main, Columns) ->
  register(proc_hash,    spawn(fun() -> hash_do()    end)), 
  register(proc_row,     spawn(fun() -> row_do()     end)), 
  register(proc_checker, spawn(fun() -> checker_do() end)), 
  register(proc_out,     spawn(fun() -> out_do([])     end)), 
  register(proc_waiter,  spawn(fun() -> waiter_do(Main, Columns)  end)),
  register(proc_waiter_col,  spawn(fun() -> waiter_col_do(Columns-2, 1)  end)),
  register_columns(Columns, 1).

register_columns(Columns, J) ->
  if 
    J =< Columns ->
      register(list_to_atom(integer_to_list(J)),  spawn(fun() -> col_do(J, 0, "") end)),
      register_columns(Columns, J+1);
    true ->
      void
  end.

waiter_col_do(N, I) ->
  receive
    { col, done } ->
      if 
        I =:= N ->
          proc_waiter ! { cols, done };
        I < N -> 
          waiter_col_do(N, I+1);
        true ->
          void
      end
  end.

waiter_do(Main, Columns) ->
  receive
    { read, done } -> proc_row     ! { quit },    waiter_do(Main, Columns);
    { row,  done } -> proc_hash    ! { quit },    waiter_do(Main, Columns);
    { hash, done } -> proc_waiter  ! { cols, 1 }, waiter_do(Main, Columns);
    { cols, done } -> proc_checker ! { quit },    waiter_do(Main, Columns);
    { cols, X } ->
      list_to_atom(integer_to_list(X)) ! { quit },
      if 
        X < Columns-2 ->
          proc_waiter ! { cols, X + 1 };
        true ->
          void
      end,                                        waiter_do(Main, Columns);
    { check, done }  -> proc_out ! { quit },      waiter_do(Main, Columns);
    { out,   done }  -> Main ! { done }
  end.

row_do() ->
  receive
    { quit } ->
      proc_waiter ! { row, done };
    { I, Data } ->
      row_to_hashes(I, 1, lists:flatlength(Data)-1, Data),  % length-1 because last elem is "\n"
      row_do()
  end.

col_do(J, Length, Data) ->
  receive
    { quit } ->
      proc_waiter_col ! { col, done };
    { I, Hash } ->
      if 
        Length =:= 12 ->
          DataNew = Data ++ Hash,
          proc_checker ! { I, J, DataNew },
          col_do(J, 15, DataNew);
        Length =:= 15 ->
          DataNew = lists:sublist(Data, 4, 12) ++ Hash,
          proc_checker ! { I, J, DataNew  },
          col_do(J, 15, DataNew);
        true ->
          col_do(J, Length + 3, Data ++ Hash)
      end
  end.

checker_do() ->
  receive
    { quit } -> proc_waiter ! { check, done };
    { I, J, "111101101101111" } -> proc_out ! { I, J, 0 }, checker_do();
    { I, J, "110010010010111" } -> proc_out ! { I, J, 1 }, checker_do();
    { I, J, "111001111100111" } -> proc_out ! { I, J, 2 }, checker_do();
    { I, J, "111001111001111" } -> proc_out ! { I, J, 3 }, checker_do();
    { I, J, "101101111001001" } -> proc_out ! { I, J, 4 }, checker_do();
    { I, J, "111100111001111" } -> proc_out ! { I, J, 5 }, checker_do();
    { I, J, "111100111101111" } -> proc_out ! { I, J, 6 }, checker_do();
    { I, J, "111001011010010" } -> proc_out ! { I, J, 7 }, checker_do();
    { I, J, "111101111101111" } -> proc_out ! { I, J, 8 }, checker_do();
    { I, J, "111101111001111" } -> proc_out ! { I, J, 9 }, checker_do();
    { _, _, _ } -> checker_do() % others message ignored
  end.

out_do(Answer) ->
  receive
    { quit } ->
      % немножно безобразия для вывода, соответствующего условиям задачи
      Cmp = fun(A,B) -> (A#digit.x < B#digit.x) or ((A#digit.x =:= B#digit.x) and (A#digit.y < B#digit.y)) end,
      lists:foreach(
        fun(Item) -> io:format("Digit ~p on (~p, ~p)\n", [Item#digit.value, Item#digit.x, Item#digit.y]) end,
        lists:sort(Cmp, Answer)
      ),
      proc_waiter ! { out, done };
    { X, Y, Digit } ->
      out_do(Answer ++ [#digit{ x=X-3, y=Y, value=Digit }])
  end.

row_to_hashes(I, J, N, Data) ->
  if 
    N-J+1 >= 3 ->
      proc_hash ! { I, J, lists:sublist(Data, J, 3) },
      row_to_hashes(I, J+1, N, Data);
    true ->
      void
  end.

hash_do() ->
  receive
    { quit } ->
      proc_waiter ! { hash, done };
    { I, J, Data } ->
      list_to_atom(integer_to_list(J)) ! { I, Data},
      hash_do()
  end.

