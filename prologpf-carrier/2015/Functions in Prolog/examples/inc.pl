% Sample prologpf function and goal
%

fun inc(X) = X + 1.

inc_goal(X,Y) :- Y = inc(X).
