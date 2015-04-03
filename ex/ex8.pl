:- module(ex8,
          [change/4,
           changeList/3]).

% change(M, P, N, D)
change(M, P, 0, 0) :-
    M >= 0, changeP(M, P).
change(M, P, N, 0) :-
    M >= 0, N \= 0, changePN(M, P, N).
change(M, P, 0, D) :-
    M >= 0, D \= 0, changePD(M, P, D).
change(M, P, N, D) :-
    M >= 0, M1 is M - 10, change(M1, P, N, D1), D is D1 + 1.
change(M, P, N, D) :-
    M >= 0, M1 is M - 5, change(M1, P, N1, D), N is N1 + 1.
change(M, P, N, D) :-
    M >= 0, M1 is M - 1, change(M1, P1, N, D), P is P1 + 1.


% -- Some helpers you may want to implement --

% changeP(M, P) : Succeeds if and only if M = P.
changeP(M, P) :- M >= 0, M = P.

% changePN(M, P, N) : Succeeds if M = P + 5N.
changePN(M, P, 0) :-
    M >= 0, changeP(M, P).
changePN(M, P, N) :-
    M >= 0, N \= 0, M1 is M - 5, changePN(M1, P, N1), N is N1 + 1.

% changePD(M, P, D) : Succeeds if M = P + 10D.
changePD(M, P, 0) :-
    M >= 0, changeP(M, P).
changePD(M, P, D) :-
    M >= 0, D \= 0, M1 is M - 10, changePD(M1, P, D1), D is D1 + 1.


% changeList(M, Denoms, Counts)
changeList(0, [X], [0]).
% do not use C at all
changeList(M, [C|Cs], [0|L]) :-
    changeList(M, Cs, L).
changeList(M, [C|Cs], [N|L]) :-
    M >= C, M1 is M - C, changeList(M1, [C|Cs], [N1|L]), N is N1 + 1.
