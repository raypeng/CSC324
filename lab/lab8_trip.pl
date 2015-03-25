% Lab 8 - Planning trips in Prolog

% plane(A,B) means it is possible to travel directly from A to B on a plane.
% boat(A,B) means it is possible to travel directly from A to B on a boat.
plane(toronto, ny).
plane(toronto, vancouver).
plane(ny, london).
plane(london, bombay).
plane(london, oslo).
plane(vancouver, tokyo).
plane(bombay, katmandu).
boat(oslo, stockholm).
boat(stockholm, bombay).
boat(bombay, maldives).
boat(vancouver, tokyo).


% cruise(A, B) -- there is a possible boat journey from A to B.
cruise(A, B) :- plane(A, B).
cruise(A, B) :- boat(A, B).


% trip(A, B) -- there is a possible journey (using plane or boat) from
% A to B.
trip(A, B) :- cruise(A, B).
trip(A, B) :- cruise(A, C), trip(C, B).


% plane_cruise(A, B) -- there is a trip from A to B that has at least
% one plane leg, and at least one boat leg.



% boat_tour(A, B, Places) -- there is a *boat* trip from A to B that
% goes through the places in List, in that order.



% tour(A, B, Places) -- there is a trip from A to B that goes
% through the places in Places, in that order.



% short_trip(A, B, N) -- there is a trip from A to B that goes
% through at most N places.

