% class 1

% previously: imperical programming / functional programming
% now: logic programming
% ask quesions "is this statement true?"

% prolog is heavily used in AI research

% programming paradigms:
% array-based programming
% pure object-oriented programming

% atom number predicates

% knowledge base + logic engine + user client


% facts
% statements of uncoditional truth
teaching(david, csc324).


% rules
% statements of conditional truth
happy(ella) :- taking(ella, csc324).
veryHappy(ella) :- taking(ella, csc324), teaching(david, csc324).


% , -> and
% ; -> or (though not used in this course in this way)


% variables
% Captital
% can be instantiated to any term


happy(Y) :- taking(X, csc324).
% for all Y, Y is happy if there exists an X...
% why X existential? will get there


% arithmetic
% + - * / predicates, not evaluated to true false
+(2,3).

% < > <= >= predicates, evalutated to true false

% =:= (==) =\= (!=) numeric comparison
+(2,3) =:= +(4,2).
2 + 3 =:= 4 + 2.

% is
% instantiation: not really mutation 
X is 2 + 3, X > 1.
