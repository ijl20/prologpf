
solution(_250) :-
    initial_state(_253),
    can_reach(_253,_256),
    final_state(_256),
    _256=state(_262,_263,_250).

initial_state(state(_297,[1,2,3,4,5,6,7,8,9,10,11,12],[])) :-
    gen_board(20,_297).

gen_board(0,[]).

gen_board(_365,[no_piece,no_piece,no_piece,border|_366]) :-
    _365>0,
    _381 is _365-1,
    gen_board(_381,_366).

final_state(state(_414,[],_415)).

can_reach(_436,_437) :-
    trans(_436,_441),
    _441=_437.

can_reach(_468,_469) :-
    trans(_468,_473),
    can_reach(_473,_469).

trans(_500,_501) :-
    _500=state(_505,_506,_507),
    select(_515,_506,_516),
    pent(_515,_521,_522),
    play_pent(_505,_522,_527),
    _501=state(_527,_516,[[_515,_521]|_507]).

play_pent(_574,_575,_576) :-
    match(_574,_575,_581),
    trim(_581,_576).

trim([],[]).

trim([border|_626],_629) :-
    trim(_626,_629).

trim([piece|_653],_656) :-
    trim(_653,_656).

trim(_680,_680) :-
    _680=[no_piece|_684].

match(_707,[],_707).

match([piece|_726],[dnm|_729],[piece|_732]) :-
    match(_726,_729,_732).

match([piece|_760],[op|_763],[piece|_766]) :-
    match(_760,_763,_766).

match([no_piece|_794],[np|_797],[piece|_800]) :-
    match(_794,_797,_800).

match([no_piece|_828],[dnm|_831],[no_piece|_834]) :-
    match(_828,_831,_834).

match([border|_862],[dnm|_865],[border|_868]) :-
    match(_862,_865,_868).

pent(1,1,[np,np,np,dnm,np,dnm,np]).

pent(1,2,[np,op,np,dnm,np,np,np]).

pent(1,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,np]).

pent(1,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,np,np]).

pent(2,1,[np,op,dnm,np,np,np,dnm,dnm,np]).

pent(3,1,[np,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(3,2,[np,np,np,dnm,np,dnm,dnm,dnm,np]).

pent(3,3,[np,dnm,op,op,np,dnm,np,np,np]).

pent(3,4,[np,op,op,dnm,np,op,op,dnm,np,np,np]).

pent(4,1,[np,op,dnm,op,np,op,dnm,np,np,np]).

pent(4,2,[np,op,op,dnm,np,np,np,dnm,np]).

pent(4,3,[np,dnm,np,np,np,dnm,dnm,dnm,np]).

pent(4,4,[np,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(5,1,[np,np,dnm,np,np,np]).

pent(5,2,[np,np,dnm,dnm,np,np,dnm,dnm,np]).

pent(5,3,[np,np,op,dnm,np,np,np]).

pent(5,4,[np,np,dnm,dnm,np,np,dnm,dnm,dnm,np]).

pent(5,5,[np,np,np,dnm,np,np]).

pent(5,6,[np,np,np,dnm,dnm,np,np]).

pent(5,7,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,np]).

pent(5,8,[np,dnm,dnm,np,np,dnm,dnm,np,np]).

pent(6,1,[np,dnm,op,np,np,dnm,np,np]).

pent(6,2,[np,op,op,dnm,np,np,op,dnm,dnm,np,np]).

pent(6,3,[np,np,op,dnm,dnm,np,np,dnm,dnm,dnm,np]).

pent(6,4,[np,np,dnm,np,np,dnm,dnm,np]).

pent(7,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,np,np]).

pent(7,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np]).

pent(7,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(7,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(8,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,np]).

pent(8,2,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(8,3,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,dnm,np]).

pent(8,4,[np,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(9,1,[np,np,op,dnm,dnm,np,np,dnm,dnm,np]).

pent(9,2,[np,dnm,np,np,np,dnm,dnm,np]).

pent(9,3,[np,op,op,dnm,np,np,np,dnm,dnm,np]).

pent(9,4,[np,np,dnm,np,np,dnm,dnm,dnm,np]).

pent(9,5,[np,op,dnm,np,np,op,dnm,dnm,np,np]).

pent(9,6,[np,op,dnm,op,np,np,dnm,np,np]).

pent(9,7,[np,op,dnm,np,np,np,dnm,dnm,dnm,np]).

pent(9,8,[np,op,dnm,np,np,np,dnm,np]).

pent(10,1,[np,np,dnm,op,np,dnm,dnm,np,np]).

pent(10,2,[np,np,op,dnm,dnm,np,op,dnm,dnm,np,np]).

pent(10,3,[np,op,op,dnm,np,np,np,dnm,dnm,dnm,np]).

pent(10,4,[np,dnm,np,np,np,dnm,np]).

pent(11,1,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,np]).

pent(11,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np]).

pent(11,3,[np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(11,4,[np,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

pent(12,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

query :-
    solution(_2816),
    o_send_soln(_2816).

dd :-
    write(orc(22)),
    g_assign(o_orc,[1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,1,1,4,4,4,6,4]),
    write([1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,1,1,4,4,4,6,4]),
    g_assign(o_limit,-1),
    g_assign(o_depth,0),
    g_assign(o_proc_num,99),
    '$orc_0_query'(_2987,_2988,[_2989|_2988],_2992),
    write(_2988),
    nl,
    fail.

dd1 :-
    write(bad_orc(23)),
    nl,
    g_assign(o_orc,[1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,3,1,4,4,5,6,4]),
    write([1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,3,1,4,4,5,6,4]),
    g_assign(o_limit,-1),
    g_assign(o_depth,0),
    g_assign(o_proc_num,87),
    '$orc_0_query'(_3190,_3191,[_3192|_3191],_3195),
    write(_3191),
    nl,
    g_read(o_depth,_3203),
    write('Depth='),
    write(_3203),
    nl,
    nl,
    fail.

'$orc_1_solution'(1,A,[1|E],En,_250) :-
    o_next(N,A),
    '$orc_1_initial_state'(N,A,E,E1,_253),
    o_next(N1,A),
    '$orc_2_can_reach'(N1,A,E1,E2,_253,_256),
    o_next(N2,A),
    '$orc_1_final_state'(N2,A,E2,En,_256),
    _256=state(_262,_263,_250).

'$orc_1_initial_state'(1,A,[1|E],En,state(_297,[1,2,3,4,5,6,7,8,9,10,11,12],[])) :-
    o_next(N,A),
    '$orc_2_gen_board'(N,A,E,En,20,_297).

'$orc_2_gen_board'(1,A,[1|E],E,0,[]).

'$orc_2_gen_board'(2,A,[2|E],En,_365,[no_piece,no_piece,no_piece,border|_366]) :-
    _365>0,
    _381 is _365-1,
    o_next(N,A),
    '$orc_2_gen_board'(N,A,E,En,_381,_366).

'$orc_1_final_state'(1,A,[1|E],E,state(_414,[],_415)).

'$orc_2_can_reach'(1,A,[1|E],En,_436,_437) :-
    o_next(N,A),
    '$orc_2_trans'(N,A,E,En,_436,_441),
    _441=_437.

'$orc_2_can_reach'(2,A,[2|E],En,_468,_469) :-
    o_next(N,A),
    '$orc_2_trans'(N,A,E,E1,_468,_473),
    o_next(N1,A),
    '$orc_2_can_reach'(N1,A,E1,En,_473,_469).

'$orc_2_trans'(1,A,[1|E],En,_500,_501) :-
    _500=state(_505,_506,_507),
    select(_515,_506,_516),
    o_next(N,A),
    '$orc_3_pent'(N,A,E,E1,_515,_521,_522),
    o_next(N1,A),
    '$orc_3_play_pent'(N1,A,E1,En,_505,_522,_527),
    _501=state(_527,_516,[[_515,_521]|_507]).

'$orc_3_play_pent'(1,A,[1|E],En,_574,_575,_576) :-
    o_next(N,A),
    '$orc_3_match'(N,A,E,E1,_574,_575,_581),
    o_next(N1,A),
    '$orc_2_trim'(N1,A,E1,En,_581,_576).

'$orc_2_trim'(1,A,[1|E],E,[],[]).

'$orc_2_trim'(2,A,[2|E],En,[border|_626],_629) :-
    o_next(N,A),
    '$orc_2_trim'(N,A,E,En,_626,_629).

'$orc_2_trim'(3,A,[3|E],En,[piece|_653],_656) :-
    o_next(N,A),
    '$orc_2_trim'(N,A,E,En,_653,_656).

'$orc_2_trim'(4,A,[4|E],E,_680,_680) :-
    _680=[no_piece|_684].

'$orc_3_match'(1,A,[1|E],E,_707,[],_707).

'$orc_3_match'(2,A,[2|E],En,[piece|_726],[dnm|_729],[piece|_732]) :-
    o_next(N,A),
    '$orc_3_match'(N,A,E,En,_726,_729,_732).

'$orc_3_match'(3,A,[3|E],En,[piece|_760],[op|_763],[piece|_766]) :-
    o_next(N,A),
    '$orc_3_match'(N,A,E,En,_760,_763,_766).

'$orc_3_match'(4,A,[4|E],En,[no_piece|_794],[np|_797],[piece|_800]) :-
    o_next(N,A),
    '$orc_3_match'(N,A,E,En,_794,_797,_800).

'$orc_3_match'(5,A,[5|E],En,[no_piece|_828],[dnm|_831],[no_piece|_834]) :-
    o_next(_18650,A),
    '$orc_3_match'(_18650,A,E,En,_828,_831,_834).

'$orc_3_match'(6,A,[6|E],En,[border|_862],[dnm|_865],[border|_868]) :-
    o_next(_18843,A),
    '$orc_3_match'(_18843,A,E,En,_862,_865,_868).

'$orc_3_pent'(1,A,[1|E],E,1,1,[np,np,np,dnm,np,dnm,np]).

'$orc_3_pent'(2,_6712,[2|_6707],_6707,1,2,[np,op,np,dnm,np,np,np]).

'$orc_3_pent'(3,_6875,[3|_6870],_6870,1,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,np]).

'$orc_3_pent'(4,_7038,[4|_7033],_7033,1,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,np,np]).

'$orc_3_pent'(5,_7201,[5|_7196],_7196,2,1,[np,op,dnm,np,np,np,dnm,dnm,np]).

'$orc_3_pent'(6,_7364,[6|_7359],_7359,3,1,[np,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(7,_7527,[7|_7522],_7522,3,2,[np,np,np,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(8,_7690,[8|_7685],_7685,3,3,[np,dnm,op,op,np,dnm,np,np,np]).

'$orc_3_pent'(9,_7853,[9|_7848],_7848,3,4,[np,op,op,dnm,np,op,op,dnm,np,np,np]).

'$orc_3_pent'(10,_8016,[10|_8011],_8011,4,1,[np,op,dnm,op,np,op,dnm,np,np,np]).

'$orc_3_pent'(11,_8179,[11|_8174],_8174,4,2,[np,op,op,dnm,np,np,np,dnm,np]).

'$orc_3_pent'(12,_8342,[12|_8337],_8337,4,3,[np,dnm,np,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(13,_8505,[13|_8500],_8500,4,4,[np,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(14,_8668,[14|_8663],_8663,5,1,[np,np,dnm,np,np,np]).

'$orc_3_pent'(15,_8831,[15|_8826],_8826,5,2,[np,np,dnm,dnm,np,np,dnm,dnm,np]).

'$orc_3_pent'(16,_8994,[16|_8989],_8989,5,3,[np,np,op,dnm,np,np,np]).

'$orc_3_pent'(17,_9157,[17|_9152],_9152,5,4,[np,np,dnm,dnm,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(18,_9320,[18|_9315],_9315,5,5,[np,np,np,dnm,np,np]).

'$orc_3_pent'(19,_9483,[19|_9478],_9478,5,6,[np,np,np,dnm,dnm,np,np]).

'$orc_3_pent'(20,_9646,[20|_9641],_9641,5,7,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,np]).

'$orc_3_pent'(21,_9809,[21|_9804],_9804,5,8,[np,dnm,dnm,np,np,dnm,dnm,np,np]).

'$orc_3_pent'(22,_9972,[22|_9967],_9967,6,1,[np,dnm,op,np,np,dnm,np,np]).

'$orc_3_pent'(23,_10135,[23|_10130],_10130,6,2,[np,op,op,dnm,np,np,op,dnm,dnm,np,np]).

'$orc_3_pent'(24,_10298,[24|_10293],_10293,6,3,[np,np,op,dnm,dnm,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(25,_10461,[25|_10456],_10456,6,4,[np,np,dnm,np,np,dnm,dnm,np]).

'$orc_3_pent'(26,_10624,[26|_10619],_10619,7,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,np,np]).

'$orc_3_pent'(27,_10787,[27|_10782],_10782,7,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np]).

'$orc_3_pent'(28,_10950,[28|_10945],_10945,7,3,[np,np,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(29,_11113,[29|_11108],_11108,7,4,[np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(30,_11276,[30|_11271],_11271,8,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,np]).

'$orc_3_pent'(31,_11439,[31|_11434],_11434,8,2,[np,dnm,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(32,_11602,[32|_11597],_11597,8,3,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(33,_11765,[33|_11760],_11760,8,4,[np,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(34,_11928,[34|_11923],_11923,9,1,[np,np,op,dnm,dnm,np,np,dnm,dnm,np]).

'$orc_3_pent'(35,_12091,[35|_12086],_12086,9,2,[np,dnm,np,np,np,dnm,dnm,np]).

'$orc_3_pent'(36,_12254,[36|_12249],_12249,9,3,[np,op,op,dnm,np,np,np,dnm,dnm,np]).

'$orc_3_pent'(37,_12417,[37|_12412],_12412,9,4,[np,np,dnm,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(38,_12580,[38|_12575],_12575,9,5,[np,op,dnm,np,np,op,dnm,dnm,np,np]).

'$orc_3_pent'(39,_12743,[39|_12738],_12738,9,6,[np,op,dnm,op,np,np,dnm,np,np]).

'$orc_3_pent'(40,_12906,[40|_12901],_12901,9,7,[np,op,dnm,np,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(41,_13069,[41|_13064],_13064,9,8,[np,op,dnm,np,np,np,dnm,np]).

'$orc_3_pent'(42,_13232,[42|_13227],_13227,10,1,[np,np,dnm,op,np,dnm,dnm,np,np]).

'$orc_3_pent'(43,_13395,[43|_13390],_13390,10,2,[np,np,op,dnm,dnm,np,op,dnm,dnm,np,np]).

'$orc_3_pent'(44,_13558,[44|_13553],_13553,10,3,[np,op,op,dnm,np,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(45,_13721,[45|_13716],_13716,10,4,[np,dnm,np,np,np,dnm,np]).

'$orc_3_pent'(46,_13884,[46|_13879],_13879,11,1,[np,dnm,dnm,dnm,np,dnm,dnm,np,np,dnm,dnm,np]).

'$orc_3_pent'(47,_14047,[47|_14042],_14042,11,2,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(48,_14210,[48|_14205],_14205,11,3,[np,dnm,dnm,dnm,np,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(49,_14373,[49|_14368],_14368,11,4,[np,dnm,dnm,np,np,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_3_pent'(50,_14536,[50|_14531],_14531,12,1,[np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np,dnm,dnm,dnm,np]).

'$orc_0_query'(1,_14554,[1|_14556],_14558) :-
    o_next(_19139,_14554),
    '$orc_1_solution'(_19139,_14554,_14556,_14558,_2816),
    o_send_soln(_2816).

'$orc_0_dd'(1,_14743,[1|_14745],_14745) :-
    write(orc(22)),
    g_assign(o_orc,[1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,1,1,4,4,4,6,4]),
    write([1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,1,1,4,4,4,6,4]),
    g_assign(o_limit,-1),
    g_assign(o_depth,0),
    g_assign(o_proc_num,99),
    '$orc_0_query'(_2987,_2988,[_2989|_2988],_2992),
    write(_2988),
    nl,
    fail.

'$orc_0_dd1'(1,_14922,[1|_14924],_14924) :-
    write(bad_orc(23)),
    nl,
    g_assign(o_orc,[1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,3,1,4,4,5,6,4]),
    write([1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,2,1,3,1,4,4,5,6,4]),
    g_assign(o_limit,-1),
    g_assign(o_depth,0),
    g_assign(o_proc_num,88),
    '$orc_0_query'(_3190,_3191,[_3192|_3191],_3195),
    write(_3191),
    nl,
    g_read(o_depth,_3203),
    write('Depth='),
    write(_3203),
    nl,
    nl,
    fail.

