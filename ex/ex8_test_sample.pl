:- use_module(library(plunit)).

:- begin_tests(ex8_tests).
:- use_module(ex8).

testChange(M, [X, Y, Z]) :- change(M, X, Y, Z).

test(change, nondet) :- change(10, 5, 1, 0).
test(changep1, nondet) :- change(0, 0, 0, 0).
test(changep2, nondet) :- change(1, 1, 0, 0).
test(changep3, nondet) :- change(5, 0, 1, 0).
test(changep4, nondet) :- change(10, 0, 0, 1).
test(change, fail) :- change(7, 5, 1, 1).
test(change) :-
    setof(L, testChange(8, L), Ls),
    Ls = [[3,1,0], [8,0,0]].
test(changes1) :-
    setof(L, testChange(13, L), Ls),
    Ls = [[13,0,0], [8,1,0], [3,2,0], [3,0,1]].
test(changes2) :-
    setof(L, testChange(7, L), Ls),
    Ls = [[2,1,0], [7,0,0]].

test(changeList, nondet) :- changeList(21, [1,5,10], [1,2,1]).
test(changeList) :-
    setof(L, changeList(16, [8,3,2], L), Ls),
    Ls = [[0,0,8], [0,2,5], [0,4,2], [1,0,4], [1,2,1], [2,0,0]].
test(changeLists1) :-
    setof(L, changeList(16, [8,4,2], L), Ls),
    Ls = [[0,0,8], [0,1,6], [0,2,4], [0,3,2], [0,4,0],
          [1,0,4], [1,1,2], [1,2,0], [2,0,0]].


:- end_tests(ex8_tests).

main(_) :- run_tests.
