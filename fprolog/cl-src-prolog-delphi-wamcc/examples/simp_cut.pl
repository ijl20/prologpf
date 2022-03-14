
:- main([o_utils]).

a(X) :- b(X),c(X),d(X).

b(a).
b(a1) :- c(b).
b(X) :- d(X),!.
b(b).

c(b).
c(d).

d(d).
