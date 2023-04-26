:- initialization(g_assign(a,t)).
:- initialization(print(7)).
foo(P,Q) :- g_read(a,t), !,  print(a_t_ok).

