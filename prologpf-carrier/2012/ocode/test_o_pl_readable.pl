a(X):-
    b(X),
    c(X).

a(X):-
    d(X).

b(p).

b(q).

c(q).

d(r).

d(s).

'$orc_1_a'(3,Oracle_acc,[3|Hole1],Hole3,X):-
    o_next(N,Oracle_acc),'$orc_1_b'(N,Oracle_acc,Hole1,Hole2,X),
    o_next(M,Oracle_acc),'$orc_1_c'(M,Oracle_acc,Hole2,Hole3,X).

'$orc_1_a'(4,Oracle_acc,[4|Hole1],Hole2,X):-
    o_next(N,Oracle_acc),'$orc_1_d'(N,Oracle_acc,Hole1,Hole2,X).

'$orc_1_b'(3,Oracle_acc,[3|Hole],Hole,p).

'$orc_1_b'(4,Oracle_acc,[4|Hole],Hole,q).

'$orc_1_c'(2,Oracle_acc,[2|Hole],Hole,q).

'$orc_1_d'(3,Oracle_acc,[3|Hole],Hole,r).

'$orc_1_d'(4,Oracle_acc,[4|Hole],Hole,s).

