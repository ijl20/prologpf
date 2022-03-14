
:- main.

%  GLOBALS:
%    o_w_oracle:  current oracle being written in BUILD mode
%    o_r_oracle:  current oracle being read in FOLLOW mode
%    o_depth:     length of current write oracle
%    o_limit:     depth limit for search

o_build(N) :- g_read(o_limit,L),       % check depth
              g_read(o_depth,D),
              D1 is D+1,
              g_read(o_w_oracle,A),
              append(A,[N],A1), 
              ( D1 = L -> write(open(A1)),
                          nl, 
                          !,
                          fail;
              /* else */  g_assign(o_depth,D1),
                          g_assign(o_w_oracle,A1), 
                          write(A1),
                          nl
              ).

o_build(_) :- g_read(o_depth,D), D1 is D-1, g_assign(o_depth,D1), % D = D-1
              g_read(o_w_oracle,A),    % remove last element of write oracle
              append(A1,[_],A),
              g_assign(o_w_oracle,A1),
              fail.

o_follow(N) :- g_read(o_r_oracle,[N|A]), % take N from head of o_oracle
              g_assign(o_r_oracle,A),
              !.

o_follow(0) :- g_read(o_r_oracle,[]).

a(X) :- o_build(1),       % build code
        b(X),
        c(X),
        d(X).

b(a) :- o_build(1).
b(b) :- o_build(2).
b(c) :- o_build(3).

c(a) :- o_build(1).
c(c) :- o_build(2).

d(c) :- o_build(1).
d(d) :- o_build(2).

a(1,X) :- o_follow(N1),    % follow code
          b(N1,X),
          o_follow(N2),
          c(N2,X),
          o_follow(N3),
          d(N3,X).
a(0,X) :- a(X).            % tunnel code

b(1,a).
b(2,b).
b(3,c).
b(0,X) :- b(X).            % tunnel code

c(1,a).
c(2,c).
c(0,X) :- c(X).            % tunnel code

d(1,c).
d(2,d).
d(0,X) :- d(X).            % tunnel code

o_query :- true.
