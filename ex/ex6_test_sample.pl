:- use_module(library(plunit)).

:- begin_tests(ex6_tests).
:- use_module(ex6).

% Three different kinds of tests:
% 1. Expect success
% 2. Expect failure
% 3. Collect all possible instantiations
test(sub1, nondet) :- sublist([], [a]).
test(subp1, nondet) :- sublist([a], [a,b]).
test(subp2, nondet) :- sublist([a,b], [c,a,b]).
test(subp3, nondet) :- sublist([a,b], [a,b]).
test(subp4, nondet) :- sublist([1,2,3], [1,2,4,1,2,3]).
test(sub2, fail) :- sublist([c,d,a], [d,a,c]).
test(subf1, fail) :- sublist([d], [a,c]).
test(subf2, fail) :- sublist([1,3], [1,2,3]).
test(subf3, fail) :- sublist([2,3], [2,2,1,3,2]).
test(sub3) :- setof(S, sublist(S, [1,2,3]), Ss),
              Ss = [[], [1], [1,2], [1,2,3], [2], [2,3], [3]].

test(with1, nondet) :- with([a,b,c], 1, [a,b,1,c]).
test(withp1, nondet) :- with([a], 1, [1,a]).
test(withp2, nondet) :- with([a], 1, [a,1]).
test(withp3, nondet) :- with([a,b,a,b], c, [a,b,c,a,b]).
test(with2, fail) :- with([], 1, [2, 3]).
test(withf1, fail) :- with([1,2,3], 1, [1,2,3]).
test(withf2, fail) :- with([1,2,3], 4, [1,2,3,3]).
test(withf3, fail) :- with([1,2,3], 4, [1,2,3,3,4]).
test(with3) :- setof(S, E^with(S, E, [1,2,3,4]), Ss),
               Ss = [[1,2,3], [1,2,4], [1,3,4], [2,3,4]].

test(shuffled1, nondet) :- shuffled([a,b,c], [a,c,b]).
test(shuffledp1, nondet) :- shuffled([c,a,b], [a,b,c]).
test(shuffledp2, nondet) :- shuffled([a,b,c], [a,b,c]).
test(shuffledp3, nondet) :- shuffled([c,i,b,c], [i,c,b,c]).
test(shuffledp4, nondet) :- shuffled([], []).
test(shuffled2, fail) :- shuffled([a,b,c], []).
test(shuffledf1, fail) :- shuffled([a,b,c], [a,b,c,c]).
test(shuffledf2, fail) :- shuffled([a,b,c,c], [a,b,c]).
test(shuffledf3, fail) :- shuffled([a,b,d,c], [a,b,c,e]).
test(shuffledf4, fail) :- shuffled([a,b,c,d], [1,2,3,4]).

:- end_tests(ex6_tests).

main(_) :- run_tests.
