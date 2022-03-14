
/* library definition for o_next */

/* case 1: no oracle to follow, hit limit */

o_next(_,A) :- g_read(o_orc,[]),
               g_read(o_depth,D), o_limit(D),
               !, A = Orc-[], write(open(Orc)), nl, fail.

/* case 2: no oracle to follow, not at limit */

o_next(_,_) :- g_read(o_orc,[]),
               g_read(o_depth,D), D1 is D+1, g_assign(o_depth,D1).

/* case 3: no oracle to follow, reduce depth on backtracking */

o_next(_,_) :- g_read(o_orc,[]),
               g_read(o_depth,D), D1 is D-1, g_assign(o_depth,D1),
               !, fail.

/* case 4: follow oracle */

o_next(N,_) :- g_read(o_orc, [N|S]), g_assign(o_orc,S).

/* limit */

o_limit(N) :- g_read(o_limit,Limit), N+1 > Limit.

               
