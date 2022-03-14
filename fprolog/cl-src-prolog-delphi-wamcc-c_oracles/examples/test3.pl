
:- main([o_utils_c]).

a(X) :- b(X), c(X).
a(X) :- d(X).
b(a).
b(c).
c(c) :- f.
d(d).
e :- b(_).
e :- c(_).
f :- c(_).
f :- d(_), !.
