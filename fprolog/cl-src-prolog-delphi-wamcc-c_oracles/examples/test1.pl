
:- main([o_utils_c]).

a(X) :- b(X), c(X).
a(X) :- d(X).
b(a).
b(c).
c(c).
d(d).
