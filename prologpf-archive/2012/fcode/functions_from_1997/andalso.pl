
:- main([f_utils]).

fun(a(X), if((X>3,X>5),bigger35,notbigger35)).

query :- true.

ex1(X,Y) :- Y = a(X).
