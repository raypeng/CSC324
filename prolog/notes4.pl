% class 4

teaching(blah, blahblah).

% student(ella).
% student(ella) :- taking(bob, w).
% student(X).
% [trace]  ?- student(ella).
%    Call: (6) student(ella) ? 
%    Exit: (6) student(ella) ? 
% true ;
%    Redo: (6) student(ella) ? 
%    Exit: (6) student(ella) ? 
% true ;
%    Redo: (6) student(ella) ? 
%    Call: (7) taking(bob, w) ? 
%    Fail: (7) taking(bob, w) ? 
%    Fail: (6) student(ella) ? 
% false.

% student(ella) :- taking(bob, w).
% student(ella).
% student(X).
% [trace]  ?- student(ella).
%    Call: (6) student(ella) ? 
%    Call: (7) taking(bob, w) ? 
%    Fail: (7) taking(bob, w) ? 
%    Redo: (6) student(ella) ? 
%    Exit: (6) student(ella) ? 
% true ;
%    Redo: (6) student(ella) ? 
%    Exit: (6) student(ella) ? 
% true.

% student(ella).
% student(ella) :- taking(bob, w).
% student(X).
% [trace]  ?- student(ella).
%    Call: (6) student(ella) ? 
%    Exit: (6) student(ella) ? 
% true ;
%    Redo: (6) student(ella) ? 
%    Call: (7) taking(bob, w) ? 
%    Fail: (7) taking(bob, w) ? 
%    Redo: (6) student(ella) ? 
%    Exit: (6) student(ella) ? 
% true.

% false -> automatically redo
% true -> option to redo
% only one false at the end

teacher(david).
teacher(karen).

% ?- teacher(X).
% X = david ;
% X = karen.

% [trace]  ?- teacher(X).
%    Call: (6) teacher(_G1756) ? 
%    Exit: (6) teacher(david) ? 
% X = david ;
%    Redo: (6) teacher(_G1756) ? 
%    Exit: (6) teacher(karen) ? 
% X = karen.

% last one . -> no more possible unification
% david/karen is instantiation of _G1756

% choose instantiation of variable when unified
% redo -> reinstantiation

taking(ella, csc324).
happy(X) :- student(X), taking(X, csc324).

% student(ella).
% student(bob).
% [trace]  ?- happy(X).
%    Call: (6) happy(_G4547) ? 
%    Call: (7) student(_G4547) ? 
%    Exit: (7) student(ella) ? 
%    Call: (7) taking(ella, csc324) ? 
%    Exit: (7) taking(ella, csc324) ? 
%    Exit: (6) happy(ella) ? 
% X = ella ;
%    Redo: (7) student(_G4547) ? 
%    Exit: (7) student(bob) ? 
%    Call: (7) taking(bob, csc324) ? 
%    Fail: (7) taking(bob, csc324) ? 
%    Fail: (6) happy(_G4547) ? 
% false.

% student(bob).
% student(ella).
% [trace]  ?- happy(X).
%    Call: (6) happy(_G4547) ? 
%    Call: (7) student(_G4547) ? 
%    Exit: (7) student(bob) ? 
%    Call: (7) taking(bob, csc324) ? 
%    Fail: (7) taking(bob, csc324) ? 
%    Redo: (7) student(_G4547) ? 
%    Exit: (7) student(ella) ? 
%    Call: (7) taking(ella, csc324) ? 
%    Exit: (7) taking(ella, csc324) ? 
%    Exit: (6) happy(ella) ? 
% X = ella.

