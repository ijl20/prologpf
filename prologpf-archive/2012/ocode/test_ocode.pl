a(_83):-
    b(_83),
    c(_83).

a(_101):-
    d(_101),
    e(_101).

b(p).

b(q).

c(_133):-
    d(_133).

d(r).

d(s).

d(_160):-
    e(_160).

e(p).

e(s).

e(t).

f:-
    !.

o_query:-
    a(_202),
    write(_202),
    nl.

'$orc_1_a'(1,_223,[1|_225],_227,_83):-
    o_next(_1278,_223),'$orc_1_b'(_1278,_223,_225,_1369,_83),
    o_next(_1381,_223),
    '$orc_1_c'(_1381,_223,_1369,_227,_83).

'$orc_1_a'(2,_289,[2|_291],_293,_101):-
    o_next(_1490,_289),'$orc_1_d'(_1490,_289,_291,_1577,_101),
    o_next(_1589,_289),
    '$orc_1_e'(_1589,_289,_1577,_293,_101).

'$orc_1_b'(3,_420,[3|_415],_415,p).

'$orc_1_b'(4,_494,[4|_489],_489,q).

'$orc_1_c'(5,_510,[5|_512],_514,_133):-
    o_next(_1695,_510),
    '$orc_1_d'(_1695,_510,_512,_514,_133).

'$orc_1_d'(6,_667,[6|_662],_662,r).

'$orc_1_d'(7,_753,[7|_748],_748,s).

'$orc_1_d'(8,_769,[8|_771],_773,_160):-
    o_next(_1803,_769),
    '$orc_1_e'(_1803,_769,_771,_773,_160).

'$orc_1_e'(9,_942,[9|_937],_937,p).

'$orc_1_e'(10,_1034,[10|_1029],_1029,s).

'$orc_1_e'(11,_1126,[11|_1121],_1121,t).

'$orc_0_o_query'(12,_1142,[12|_1144],_1146):-
    o_next(_1914,_1142),'$orc_1_a'(_1914,_1142,_1144,_1146,_202),
    write(_202),
    nl.

