'$fun_map'([_87,[]],[]):-
    !.

'$fun_map'([_94,[_95|_96]],[_398|_399]):-
    !,
    '$fun_eval'(_94@[_95],_398),
    '$fun_map'([_94,_96],_399).

'$fun_map'(_537,lambda(_532,'$fun_map'([_518,_520],_526),_526)):-
    append(_537,_532,[_518,_520]),
    !.

'$fun_inc'([_125],_677):-
    !,
    '$fun_+'([_125,1],_677).

'$fun_inc'(_737,lambda(_732,'$fun_inc'([_720],_726),_726)):-
    append(_737,_732,[_720]),
    !.

'$fun_sum'([_164,_165],_881):-
    !,
    '$fun_+'([_164,_165],_881).

'$fun_sum'(_943,lambda(_938,'$fun_sum'([_924,_926],_932),_932)):-
    append(_943,_938,[_924,_926]),
    !.

'$fun_f'([_210,1],a):-
    !.

'$fun_f'([_210,_217],b):-
    !.

'$fun_f'(_1123,lambda(_1118,'$fun_f'([_1104,_1106],_1112),_1112)):-
    append(_1123,_1118,[_1104,_1106]),
    !.

map_goal(_141):-
    '$fun_map'([inc,[1,2,3]],_1181),
    _141=_1181.

map_goal2(_182):-
    '$fun_sum'([2],_1346),
    '$fun_map'([_1346,[5,4,3]],_1288),
    _182=_1288.

f_goal(_234,_235,_236):-
    '$fun_f'([_234,_235],_1435),
    _236=_1435.

f_goal2(_255,_256,_257):-
    '$fun_f'([2],_1534),_255=_1534,
    '$fun_eval'(_255@[_257],_1583),
    _256=_1583.
