:- module(ex6,
          [sublist/2,
           with/3,
           shuffled/2]).

% sublist(S, L) : S is a sublist of list L.
sublist(S, L) :- sublisthelper(0, S, L).
% 0/1 is used to track whether already matching part of sublist
sublisthelper(_, [], _).
sublisthelper(_, [X|Xs], [X|Ys]) :- sublisthelper(1, Xs, Ys).
sublisthelper(0, [X|Xs], [_|Ys]) :- sublisthelper(0, [X|Xs], Ys).

% with(L, E, LE) : LE is the the list L with the item E inserted somewhere.
with([], E, [E]).
with([X|Xs], E, [X|[E|Xs]]).
with([X|Xs], E, [E|[X|Xs]]).
% need to enforce E != F, else more results will be returned
with([X|Xs], E, [X|[F|Ys]]) :- with(Xs, E, [F|Ys]), not(E = F).

% shuffled(L, S) : S is list L in some order.
% You may assume both L and S are fully instantiated.
shuffled([], []).
% see? that simple!
shuffled([X|Xs], S) :- with(SS, X, S), shuffled(Xs, SS).
