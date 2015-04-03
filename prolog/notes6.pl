% class 6

student(bob).
student(rachel).

teacher(david).

taking(bob, csc324).
taking(rachel, csc324).
teaching(david, csc324).

taking(bob, csc488).

% happy(X) :-
%     student(X), !, taking(X, csc324).
% happy(X) :-
%     teacher(X), teaching(X, csc324).
% without ! cut
% ?- happy(bob).
% true ;
% false.

% want to stop backtracking as long as first match succeed
% ! called cut
% side effect: stop backtracking, remove all previous choice points

% think of it as a wall, once pass a wall, can't go back
% alternatively, think of decision tree, cut part of tree

% happy(X) :-
%     !, student(X), taking(X, csc324).
% happy(X) :-
%     teacher(X), teaching(X, csc324).
% ?- happy(david).
% false.
% eliminate other rules
% ?- happy(X).
% X = bob ;
% X = rachel.
% doesn't eliminate choice points in subquery, given the position of !

% happy(X) :-
%     student(X), !, taking(X, csc324).
% happy(X) :-
%     teacher(X), teaching(X, csc324).
% ?- happy(X).
% X = bob.
% eliminates choice points for student(X) subquery

% happy(X) :-
%     student(X), !, taking(X, Y).
% happy(X) :-
%     teacher(X), teaching(X, csc324).
% ?- happy(bob).
% true ;
% true.

% happy(X) :-
%     student(X), !, taking(X, Y), !.
% happy(X) :-
%     teacher(X), teaching(X, csc324).
% ?- happy(bob).
% true.
% can do multiple cuts in one rule
% no need to give all the courses one takes

% be careful with cuts, might eliminates too much

% happy(student(X)) :- ...
% happy(teacher(X)) :- ...
% is one way of matching cases, mutex guaranteed

happy(X) :-
    student(X), !, taking(X, Y).
happy(X) :-
    teacher(X), teaching(X, csc324).

chocolate(bob).
chocolate(david).

% veryHappy(X) :- happy(X), chocolate(X).
% [trace]  ?- veryHappy(X).
%    Call: (6) veryHappy(_G1087) ? 
%    Call: (7) happy(_G1087) ? 
%    Call: (8) student(_G1087) ? 
%    Exit: (8) student(bob) ? 
%    Call: (8) taking(bob, _G1162) ? 
%    Exit: (8) taking(bob, csc324) ? 
%    Exit: (7) happy(bob) ? 
%    Call: (7) chocolate(bob) ? 
%    Fail: (7) chocolate(bob) ? 
%    Redo: (8) taking(bob, _G1162) ? 
%    Exit: (8) taking(bob, csc488) ? 
%    Exit: (7) happy(bob) ? 
%    Call: (7) chocolate(bob) ? 
%    Fail: (7) chocolate(bob) ? 
%    Fail: (6) veryHappy(_G1087) ? 
% false.
% can't examine david, cut out

% veryHappy(X) :- chocolate(X), happy(X).
% ?- veryHappy(X).
% X = bob ;
% X = bob ;
% X = david.
% cut prevents all backtracking in the query, not effecting previous queries
% cut is a wall in the current house, not blocking other houses
