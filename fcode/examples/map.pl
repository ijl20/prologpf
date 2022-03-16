
fun map(_,[])    = [] ;
    map(F,[X|L]) = [ F @ [X] | map(F,L) ].

fun wrap(X) = wrapped(X).

q_map(X) :- X = map(wrap,[a,b,c]).

