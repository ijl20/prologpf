
:- main([o_utils]).

:- public '$orc_0_query'/4.

fun(wrap @ [X], container(X)).


query :- X = wrap @ [1], o_send_soln(X).
