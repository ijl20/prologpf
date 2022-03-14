
:- main.

%  GLOBALS:
%    o_oracle:  current oracle list

o_build(N) :- g_read(o_oracle,C),    % add N to end of o_oracle
              append(C,[N],C1), 
              write(C1),nl,
              g_assign(o_oracle,C1).

o_build(_) :- g_read(o_oracle,C),    % remove last element of o_oracle
              append(C1,[_],C),
              g_assign(o_oracle,C1),
              fail.

o_follow(N) :- g_read(o_oracle,[N|C]), % take N from head of o_oracle
              g_assign(o_oracle,C),
              !.

o_follow(0) :- g_read(o_oracle,[]).

a(X) :- o_build(1),       % build code
        b(X),
        c(X).

b(a) :- o_build(1).
b(b) :- o_build(2).

c(b) :- o_build(1).

a(1,X) :- o_follow(N1),    % follow code
          b(N1,X),
          o_follow(N2),
          c(N2,X).
a(0,X) :- a(X).

b(1,a).
b(2,b).
b(0,X) :- b(X).
c(1,b).
c(0,X) :- c(X).
