

o_get_orace(N,P) :- step_oracle(0,N,P).

step_oracle(C,N,P) :-
    (C mod N) =:= P,
    g_read(o_count,M),
    C < M,
    g_read(o_orcs(C),S),
    g_assign(o_orc,S).

step_oracle(C,N,P) :-
    C1 is C + 1,
    g_read(o_count,M),
    C1 < M,
    step_oracle(C1,N,P).
