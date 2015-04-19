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
cruise(A, B) :- boat(A, B).
cruise(A, B) :- boat(A, C), cruise(C, B).

flight(A, B) :- plane(A, B).
flight(A, B) :- plane(A, C), flight(C, B).


% trip(A, B) -- there is a possible journey (using plane or boat) from
% A to B.
trip(A, B) :- cruise(A, B).
trip(A, B) :- flight(A, B).
trip(A, B) :- cruise(A, C), trip(C, B).
trip(A, B) :- flight(A, C), trip(C, B).
% trip(A, B) :- trip(A, C), trip(C, B).


% plane_cruise(A, B) -- there is a trip from A to B that has at least
% one plane leg, and at least one boat leg.
plane_cruise(A, B) :- cruise(A, C), flight(C, B).
plane_cruise(A, B) :- flight(A, C), cruise(C, B).

% plane_cruise(A, B) :- has_plane(A, C), has_boat(C, B).
% plane_cruise(A, B) :- has_boat(A, C), has_plane(C, B).

% has_plane(A, B) :- plane(A, B).
% has_plane(A, B) :- plane(A, C), has_plane(C, B).

% has_boat(A, B) :- boat(A, B).
% has_boat(A, B) :- boat(A, C), has_boat(C, B).


% boat_tour(A, B, Places) -- there is a *boat* trip from A to B that
% goes through the places in List, in that order.
boat_tour(A, A, [A]).
boat_tour(A, B, [A|As]) :- boat(A, C), boat_tour(C, B, As).


% tour(A, B, Places) -- there is a trip from A to B that goes
% through the places in Places, in that order.
tour(A, A, [A]).
tour(A, B, [A|As]) :- boat(A, C), tour(C, B, As).
tour(A, B, [A|As]) :- plane(A, C), tour(C, B, As).

direct(A, B) :- boat(A, B).
direct(A, B) :- plane(A, B).

% short_trip(A, B, N) -- there is a trip from A to B that goes
% through at most N places.
short_trip(A, A, N).
short_trip(A, B, N) :- exact_trip(A, B, N1), N @>= N1.

exact_trip(A, B, 1) :- direct(A, B).
exact_trip(A, B, N) :- direct(A, C), exact_trip(C, B, N1), N is N1 + 1.

