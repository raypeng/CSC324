% This is a Prolog comment.
student(bob).             % "bob is a student"
student(lily).
teacher(david).           % "david is a teacher"
teaching(david, csc324).  % "david is teaching csc324"
taking(lily, csc324).     % "lily is taking csc324"

student(ella).
taking(ella, csc324).
friend(ella, bob).
friend(ella, lily).
friend(bob, lily).

% load pl file to swipl
% ?- [filename-without-extension]

% query who is a student
% ?- student(X)

% ?- student(bob), student(lily), teacher(david).
% ?- student(bob), student(david).
% ?- student(X), teacher(X).
% ?- student(X), teacher(Y).

% This line means "X is happy if X is taking csc324."
happy(X) :- taking(X, csc324).
isfriend(X, Y) :- friend(X, Y) ; friend(Y, X).
busy(X) :- teaching(X, Y) ; taking(X, Y).
trio(X, Y, Z) :- isfriend(X, Y), isfriend(X, Z), isfriend(Y, Z).

team([lily, bob, ella]).
pair([X, Y]) :- isfriend(X, Y).

onlyHello([hello]).
onlyHappy([X]) :- happy(X).
onlyHappy2([X, Y]) :- happy(X), happy(Y).
oneHappy3([X, Y, Z]) :- happy(X) ; happy(Y) ; happy(Z).
