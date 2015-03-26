:- module(ex7,
          [contains/2,
           preorder/2,
           insert/3]).

% contains(T, Elem)
contains(node(Elem, _, _), Elem).
contains(node(_, T1, _), Elem) :- contains(T1, Elem).
contains(node(_, _, T2), Elem) :- contains(T2, Elem).


% preorder(T, List)
preorder(empty, []).
preorder(node(E, T1, T2), [E|Es]) :-
    preorder(T1, L1), preorder(T2, L2), append(L1, L2, Es).


% insert(T1, Elem, T2)
% You may asume that T1 and Elem are fully instantiated.
insert(T1, Elem, T2) :-
    preorder(T1, L1), preorder(T2, L2), with(L1, Elem, L2).


% with(L, E, LE) : LE is the the list L with the item E inserted somewhere.
with(L, E, [E|L]).
with([X|Xs], E, [X|Ys]) :- with(Xs, E, Ys).
