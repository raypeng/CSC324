% class 3

% how does prolog work?
% pattern matching + brute force search
% prolog is not pure logic programming...

% unification: whether two terms can be unified
% in prolog =/2 (= means unification, can be pattern matched)

% ?- bob = bob.
% true.
% ?- 3 = 4.
% false.

% variables
% ?- bob = X.
% X = bob.
% ?- X = bob, X = alice.
% false.

% predicates
% ?- bob = student(alice).
% false. (bob is not a predicate)
% ?- X = taking(csc148, sam).
% X = taking(csc148, sam).
% ?- taking(csc148, sam) = taking(csc148, X).
% X = sam.

% unification: do the two terms have the same structure (syntactically)
% not whether two terms evalutate to...

% ?- couple(X, Y) = couple(Y, X).
% X = Y. (<- ?- X = Y.)
% (a bit of symbolic calculation involved)
% when variable involved: can variables instantiated so that can be unified

% ?- 3 = 1 + 2.
% false. (no arithmetic calculation going on)
% ?- 3 + 4 = 2 + 5.
% false.
% ?- X = 3 + 4.
% X = 3+4.
% ?- [3, X, 4] = [3, 10, 4].
% X = 10.
% ?- [3, X, 4] = [3, 10, X].
% false. (must be same instantiation).
% ?- X(alice) = student(alice).
% ERROR, predicate name is not a first class value

student(bob).
student(ella).

% ?- student(david).
% false. (fail to unify)

taking(ella, csc324).
teaching(david, csc324).
happy(ella) :- taking(ella, csc324).
veryhappy(ella) :- taking(ella, csc324), teaching(david, csc324).

% ?- happy(ella).
% true.
% 1. happy(ella) matches LHS of above
% 2. taking(ella, csc324) as new subquery

% [trace]  ?- happy(ella).
%    Call: (6) happy(ella) ?
%    Call: (7) taking(ella, csc324) ? 
%    Exit: (7) taking(ella, csc324) ? 
%    Exit: (6) happy(ella) ? 
% true.

% [trace]  ?- student(david), student(ella).
%    Call: (7) student(david) ? 
%    Fail: (7) student(david) ? 
% false.

% [trace]  ?- veryhappy(ella).
%    Call: (6) veryhappy(ella) ? 
%    Call: (7) taking(ella, csc324) ? 
%    Exit: (7) taking(ella, csc324) ? 
%    Call: (7) teaching(david, csc324) ? 
%    Exit: (7) teaching(david, csc324) ? 
%    Exit: (6) veryhappy(ella) ? 
% true.

% everything is awesome!
awesome(X).

% [trace]  ?- awesome(david).
%    Call: (6) awesome(david) ? 
%    Exit: (6) awesome(david) ? 
% true.

% [trace]  ?- nodebug.
% true.
% turn off trace!

student(ray).
student(ray).

% ?- student(ray).
% true ;
% true.

% can continue with ;
% why is this the case?
% will see on friday
