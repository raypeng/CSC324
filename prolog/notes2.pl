% class 2

happy(bob).
happy(alice).

happyTwo([X, Y]) :- happy(X), happy(Y).
happyTwo(X) :- happy(X).

/*
?- happyTwo([X, Y]).
X = Y, Y = bob ;
X = bob,
Y = alice ;
X = alice,
Y = bob ;
X = Y, Y = alice ;
false.

?- happyTwo(A).
A = [bob, bob] ;
A = [bob, alice] ;
A = [alice, bob] ;
A = [alice, alice] ;
A = bob ;
A = alice.
*/


% wish to be able to capture the length of input
% can do pattern matching on lists

% myLength(List, N): "predicate: the length of List is N"
myLength([], 0).
% myLength([X | Xs], N) :- myLength(Xs, N - 1). almost there

% myLength([X | Xs], N) :- myLength(Xs, N1), N1 =:= N - 1.
% ERROR: =:=/2: Arguments are not sufficiently instantiated
% need to use 'is'

% myLength([_ | Xs], N) :- myLength(Xs, N1), N1 is N - 1.
% ERROR: N not fully instantiated.

% myLength([_ | Xs], N) :- myLength(Xs, N1), N is N1 + 1.
% ERROR

% myLength([_ | Xs], N) :- N is N1 + 1, myLength(Xs, N1).
% ERROR

myLength([_ | Xs], N) :- myLength(Xs, N1), N is N1 + 1.

% need to think through this!


% myAppend(L1, L2, L3): "L3 is L1 concatenated with L2"
myAppend([], L, L).
% can't do myAppend [] lst lst = True in haskell, duplicate identifier
myAppend([X | Xs], Lst, [X | Zs]) :- myAppend(Xs, Lst, Zs).

/*
?- myAppend([1,2,3], [4,5], A).
A = [1, 2, 3, 4, 5].
?- myAppend([1,2,3], A, [1,2,3,4,5]).
A = [4, 5].
?- myAppend(L1, L2, [1,2,3,4,5]).
L1 = [],
L2 = [1, 2, 3, 4, 5] ;
L1 = [1],
L2 = [2, 3, 4, 5] ;
L1 = [1, 2],
L2 = [3, 4, 5] ;
L1 = [1, 2, 3],
L2 = [4, 5] ;
L1 = [1, 2, 3, 4],
L2 = [5] ;
L1 = [1, 2, 3, 4, 5],
L2 = [] ;
false.
*/
