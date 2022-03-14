:- initialization(g_assign(a,b)).
p(X) :- g_read(a,X), q(X).
q(b).
