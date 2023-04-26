
:- main([f_utils]).

fun(foo(X), if(append([a],[b],[b,c]),x,y)).

fun(bah(X), if((append([],[],[]),append([a],[b],[a,b])),x,y)).

ex1(X,Y) :- Y = foo(X).

ex2(X,Y) :- Y = bah(X).
