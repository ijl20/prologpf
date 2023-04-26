a(X) :- b(X), c(X).
a(X) :- d(X), e(X).
b(p).
b(q).
c(X) :- d(X).
d(r).
d(s).
d(X) :- e(X).
e(p).
e(s).
e(t).

f :- !.

o_query :- a(X), write(X), nl.