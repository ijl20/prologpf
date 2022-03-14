fun fact(1) = 1;
    fact(N) = N * fact(N-1).

fact_goal(X) :- X = fact(5).

map_fact([],[]).
map_fact([H|T],[X|Y]) :- X = fact(H), map_fact(T,Y).

fun f(X) = if (map_fact(X,R)) then R else fail.

f_goal(X) :- X = f([1,2,3,4,5]).