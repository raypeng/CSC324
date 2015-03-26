:- use_module(library(plunit)).

:- begin_tests(trees).
:- use_module(ex7).

test(contains, nondet) :- 
    contains(node(bob, empty, 
                       node(10, node(alice, empty, empty), empty)), alice).
test(containsp1, nondet) :- 
    contains(node(bob, empty, 
                       node(10, node(alice, empty, empty), empty)), bob).
test(containsp2, nondet) :- 
    contains(node(bob, empty, 
                       node(10, node(alice, empty, empty), empty)), 10).
test(containsf1, fail) :- 
    contains(node(bob, empty, 
                       node(10, node(alice, empty, empty), empty)), eva).

test(preorder, nondet) :- preorder(empty, []).
test(preorderp1, nondet) :- 
    preorder(node(bob, empty, 
                       node(10, node(alice, empty, empty), empty)),
            [bob, 10, alice]).
test(preorderp2, nondet) :- 
    preorder(node(bob, empty, empty), [bob]).

test(insert, nondet) :- 
    insert(node(100,
                  node(50,
                       node(20,
                            node(10,
                                 node(5,
                                      empty,
                                      empty),
                                 empty),
                            empty),
                       empty),
                  empty),
           25,
           node(100,
                  node(50,
                       node(20,
                            node(10,
                                 node(5,
                                      empty,
                                      empty),
                                 empty),
                            node(25, empty, empty)),
                       empty),
                  empty)).
test(insertp1, nondet) :-
    insert(node(1, empty, empty), 2, node(1, node(2, empty, empty), empty)).
test(insertp2, nondet) :-
    insert(node(1, empty, empty), 2, node(1, empty, node(2, empty, empty))).
test(insertp3, nondet) :-
    insert(node(1, empty, empty), 2, node(2, empty, node(1, empty, empty))).
test(insertf1, fail) :-
    insert(node(1, empty, empty), 2, node(1, empty, node(3, empty, empty))).
test(insertf2, fail) :-
    insert(node(1, empty, empty), 2, node(1, empty, empty)).

:- end_tests(trees).

main(_) :- run_tests.
