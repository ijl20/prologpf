:- main.
d(1,a).
b(1,b).
d(2,c) :- b(1,b).
d(3,d).
:- d(X,Y).
:- g_assign(o_limit,1000).
