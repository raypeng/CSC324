% class 5

% grading scheme vote on next mon
% a2 only automarked 6 percent

with(L, E, [E|L]).
with([X|Xs], E, [X|Ys]) :- with(Xs, E, Ys).

shuffled([], []).
shuffled([X|Xs], L2) :- shuffled(Xs, Ys), with(Ys, X, L2).

% ?- shuffled([1,2,3], [2,3,1]).
% true ;
% false.
% ?- shuffled([1,2,3], [3,2,1]).
% true.

% in general, try to avoid unnecessary backtracking

% [trace]  ?- shuffled([1,2,3], [2,3,1]).
%    Call: (6) shuffled([1, 2, 3], [2, 3, 1]) ? 
%    Call: (7) shuffled([2, 3], _G395) ? 
%    Call: (8) shuffled([3], _G395) ? 
%    Call: (9) shuffled([], _G395) ? 
%    Exit: (9) shuffled([], []) ? 
%    Call: (9) with([], 3, _G396) ? 
%    Exit: (9) with([], 3, [3]) ? 
%    Exit: (8) shuffled([3], [3]) ? 
%    Call: (8) with([3], 2, _G399) ? 
%    Exit: (8) with([3], 2, [2, 3]) ? 
%    Exit: (7) shuffled([2, 3], [2, 3]) ? 
%    Call: (7) with([2, 3], 1, [2, 3, 1]) ? 
%    Call: (8) with([3], 1, [3, 1]) ? 
%    Call: (9) with([], 1, [1]) ? 
%    Exit: (9) with([], 1, [1]) ? 
%    Exit: (8) with([3], 1, [3, 1]) ? 
%    Exit: (7) with([2, 3], 1, [2, 3, 1]) ? 
%    Exit: (6) shuffled([1, 2, 3], [2, 3, 1]) ? 
% true ;
%    Redo: (8) with([3], 2, _G399) ? 
%    Call: (9) with([], 2, _G391) ? 
%    Exit: (9) with([], 2, [2]) ? 
%    Exit: (8) with([3], 2, [3, 2]) ? 
%    Exit: (7) shuffled([2, 3], [3, 2]) ? 
%    Call: (7) with([3, 2], 1, [2, 3, 1]) ? 
%    Fail: (7) with([3, 2], 1, [2, 3, 1]) ? 
%    Fail: (6) shuffled([1, 2, 3], [2, 3, 1]) ? 
% false.

% where choice points will occur?

% in general not feasible to eliminate all nondet ; behavior

% ?- shuffled([1,2,3], X).
% X = [1, 2, 3] ;
% X = [2, 1, 3] ;
% X = [2, 3, 1] ;
% X = [1, 3, 2] ;
% X = [3, 1, 2] ;
% X = [3, 2, 1].

% ?- shuffled(X, [1,2,3]).
% X = [1, 2, 3] ;
% X = [2, 1, 3] ;
% X = [3, 1, 2] ;
% X = [1, 3, 2] ;
% X = [2, 3, 1] ;
% X = [3, 2, 1] ;
% nonstop

% [trace]  ?- shuffled(X, []).
%    Call: (6) shuffled(_G1480, []) ? 
%    Exit: (6) shuffled([], []) ? 
% X = [] ;
%    Redo: (6) shuffled(_G1480, []) ? 
%    Call: (7) shuffled(_G1547, _G1557) ? 
%    Exit: (7) shuffled([], []) ? 
%    Call: (7) with([], _G1546, []) ? 
%    Fail: (7) with([], _G1546, []) ? 
%    Redo: (7) shuffled(_G1547, _G1557) ? 
%    Call: (8) shuffled(_G1550, _G1560) ? 
%    Exit: (8) shuffled([], []) ? 
%    Call: (8) with([], _G1549, _G1561) ? 
%    Exit: (8) with([], _G1549, [_G1549]) ? 
%    Exit: (7) shuffled([_G1549], [_G1549]) ? 
%    Call: (7) with([_G1549], _G1546, []) ? 
%    Fail: (7) with([_G1549], _G1546, []) ? 
%    Redo: (8) shuffled(_G1550, _G1560) ? 
%    Call: (9) shuffled(_G1553, _G1563) ? 

% recursive calls go no closer to base case!

% for future use of prolog, pay special attention to documentation
% whether uninstantiation is supported will be specified

shuffled2([], []).
shuffled2([X|Xs], L2) :- with(Ys, X, L2), shuffled2(Xs, Ys).

% ?- shuffled2(X, [1,2,3]).
% X = [1, 2, 3] ;
% X = [2, 1, 3] ;
% X = [2, 3, 1] ;
% X = [1, 3, 2] ;
% X = [3, 1, 2] ;
% X = [3, 2, 1].

% ?- shuffled2([1,2,3], X).
% X = [1, 2, 3] ;
% nonstop

% ?- with(L, 1, LE).
% LE = [1|L] ;
% L = [_G1424|_G1425],
% LE = [_G1424, 1|_G1425] ;
% L = [_G1424, _G1430|_G1431],
% LE = [_G1424, _G1430, 1|_G1431] ;
% L = [_G1424, _G1430, _G1436|_G1437],
% LE = [_G1424, _G1430, _G1436, 1|_G1437] ;
% L = [_G1424, _G1430, _G1436, _G1442|_G1443],
% LE = [_G1424, _G1430, _G1436, _G1442, 1|_G1443] ;
% L = [_G1424, _G1430, _G1436, _G1442, _G1448|_G1449],
% LE = [_G1424, _G1430, _G1436, _G1442, _G1448, 1|_G1449] ;
% L = [_G1424, _G1430, _G1436, _G1442, _G1448, _G1454|_G1455],
% LE = [_G1424, _G1430, _G1436, _G1442, _G1448, _G1454, 1|_G1455] ;
% L = [_G1424, _G1430, _G1436, _G1442, _G1448, _G1454, _G1460|_G1461],
% LE = [_G1424, _G1430, _G1436, _G1442, _G1448, _G1454, _G1460, 1|_G1461] 

% good behavior to have infinite possibility
% good for with but horrible for shuffled

% so far we have seen how backtracking occur passively
% will see how to control backtracking next time
