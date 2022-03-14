
:- main([f_utils,k1_utils]).

%%% Sound unification algorithm with occurs check that is called
%%% by code resulting from transforming clauses to eliminate
%%% repeated variables in the head.
%%% This should be coded in a lower-level language for efficiency.

unify(X,Y) :-
	var(X) ->
		(var(Y) ->
			X = Y;
		%true ->
			functor(Y,_,N),
			(N = 0 ->
				true;
			N = 1 ->
				arg(1,Y,Y1), not_occurs_in(X,Y1);
			%true ->
				not_occurs_in_args(X,Y,N)),
			X = Y);
	var(Y) ->
		functor(X,_,N),
		(N = 0 ->
			true;
		N = 1 ->
			arg(1,X,X1), not_occurs_in(Y,X1);
		%true ->
			not_occurs_in_args(Y,X,N)),
		X = Y;
	%true ->
		functor(X,F,N),
		functor(Y,F,N),
		(N = 0 ->
			true;
		N = 1 ->
			arg(1,X,X1), arg(1,Y,Y1), unify(X1,Y1);
		%true ->
			unify_args(X,Y,N)).

unify_args(X,Y,N) :-
	N = 2 ->
		arg(2,X,X2), arg(2,Y,Y2), unify(X2,Y2),
		arg(1,X,X1), arg(1,Y,Y1), unify(X1,Y1);
	%true ->
		arg(N,X,Xn), arg(N,Y,Yn), unify(Xn,Yn),
		N1 is N - 1, unify_args(X,Y,N1).

not_occurs_in(Var,Term) :-
	Var == Term ->
		fail;
	var(Term) ->
		true;
	%true ->
		functor(Term,_,N),
		(N = 0 ->
			true;
		N = 1 ->
			arg(1,Term,Arg1), not_occurs_in(Var,Arg1);
		%true ->
			not_occurs_in_args(Var,Term,N)).

not_occurs_in_args(Var,Term,N) :-
	N = 2 ->
		arg(2,Term,Arg2), not_occurs_in(Var,Arg2),
		arg(1,Term,Arg1), not_occurs_in(Var,Arg1);
	%true ->
		arg(N,Term,ArgN), not_occurs_in(Var,ArgN),
		N1 is N - 1, not_occurs_in_args(Var,Term,N1).


query(D) :- query([],[],D,_,[X|X],PrfOut),  write_proof(PrfOut).
query(D) :- D1 is D + 1, D1 < 32, query(D1).

query(PosAncestors,NegAncestors,DepthIn,DepthOut,ProofIn,ProofOut) :-
	int_query(PosAncestors,NegAncestors,DepthIn,DepthOut,ProofIn,ProofOut,
	          query).



unifiable_member(X,[Y|_]) :-			% run-time predicate to
	unify(X,Y).				% find complementary ancestor
unifiable_member(X,[_|L]) :-
	unifiable_member(X,L).

identical_member(X,[Y|_])  :-			% run-time predicate to
	X == Y,					% find identical ancestor
	!.
identical_member(X,[_|L]) :-
	identical_member(X,L).

nonidentical_member(X,[Y|L]) :-			% run-time predicate to
	X \== Y,				% find identical ancestor
	nonidentical_member(X,L).
nonidentical_member(_X,[]).

differing_member(X,[Y|L]) :-			% run-time predicate to
	X \== Y,				% constrain literal to not
	differing_member(X,L).			% be identical to ancestor
differing_member(_X,[]).

%%% Proof Printing.
%%%
%%% Add extra arguments to each goal so that information
%%% on what inferences were made in the proof can be printed
%%% at the end.

write_proof(Proof) :-
	write('Proof:'),
	nl,
	write('Goal#  Wff#  Wff Instance'),
	nl,
	write('-----  ----  ------------'),
	add_proof_query_line(Proof,Proof2),
	process_proof(Proof2,0,Proof1),
	write_proof1(Proof1),
        !.

write_proof1([]).
write_proof1([[LineNum,X,Head,Depth,Subgoals]|Y]) :-
	nl,
	write_indent_for_number(LineNum),
	write('['),
	write(LineNum),
	write(']  '),
	write_indent_for_number(X),
	write(X),
	write('   '),
	write_proof_indent(Depth),
	copy_term(Head,H_copy), numbervars(H_copy,23,_), write(H_copy),
%	write(Head),
	(Subgoals = [] ->
		true;
	%true ->
		write(' :- '),
		write_proof_subgoals(Subgoals)),
	write(.),
	write_proof1(Y),
        !.	

write_proof_subgoals([X,Y|Z]) :-
	write('['),
	write(X),
	write('] , '),
	write_proof_subgoals([Y|Z]).
write_proof_subgoals([X]) :-
	write('['),
	write(X),
	write(']'),
        !.

write_proof_indent(N) :-
	N > 0,
	write('   '),
	N1 is N - 1,
	write_proof_indent(N1).
write_proof_indent(0) :- !.

process_proof([Prf|PrfEnd],_LineNum,Result) :-
	Prf == PrfEnd,
	!,
	Result = [].
process_proof([[[X,Head,PosAncestors,NegAncestors]|Y]|PrfEnd],LineNum,Result) :-
	LineNum1 is LineNum + 1,
	process_proof([Y|PrfEnd],LineNum1,P),
	(Head == query ->
		Depth is 0;
	%true ->
		list_length(PosAncestors,N1),	% compute indentation to show
		list_length(NegAncestors,N2),	% level of goal nesting from
		Depth is N1 + N2 + 1),		% lengths of ancestor lists
	Depth1 is Depth + 1,
	collect_proof_subgoals(Depth1,P,Subgoals),
	(X = redn ->
		X1 = red,
		negated_literal(Head,Head1);
	 (number(X) , X < 0) ->
		X1 is - X,
		negated_literal(Head,Head1);
	%true ->
		X1 = X,
		Head1 = Head),
	Result = [[LineNum,X1,Head1,Depth,Subgoals]|P].

collect_proof_subgoals(_Depth1,[],Result) :-
	Result = [].
collect_proof_subgoals(Depth1,[[LineNum,_,_,Depth,_]|P],Result) :-
	Depth = Depth1,
	collect_proof_subgoals(Depth1,P,R),
	Result = [LineNum|R].
collect_proof_subgoals(Depth1,[[_,_,_,Depth,_]|P],Result) :-
	Depth > Depth1,
	collect_proof_subgoals(Depth1,P,Result).
collect_proof_subgoals(Depth1,[[_,_,_,Depth,_]|_],Result) :-
	Depth < Depth1,
	Result = [],
        !.

add_proof_query_line(Proof,Proof2) :-
	Proof = [Prf|_PrfEnd],
	nonvar(Prf),
	Prf = [[_,query,_,_]|_],
	!,
	Proof2 = Proof.
add_proof_query_line(Proof,Proof2) :-
	Proof = [Prf|PrfEnd],
	Proof2 = [[[0,query,[],[]]|Prf]|PrfEnd].


%%% prove(Goal) can be used to prove Goal using code compiled by PTTP.
%%% It uses depth-first iterative-deepening search and prints the proof.
%%%
%%% Depth-first iterative-deepening search can be controlled
%%% by extra paramaters of the prove predicate:
%%%    prove(Goal,Max,Min,Inc,Proof)
%%% Max is the maximum depth to search (defaults to a big number),
%%% Min is the minimum depth to search (defaults to 0),
%%% Inc is the amount to increment the bound each time (defaults to 1).
%%% ProofIn specifies initial steps of proof to retrace (defaults to []).
%%% ProofOut is used to return list of steps in completed proof.
%%%
%%% A query can be compiled along with the axioms by including the
%%% clause 'query :- ...'.  The query can then be proved by 'prove(query)'.
%%% The predicate 'query' is special because it will not be added to
%%% the ancestor list and the depth bound will not be decremented by its body.
%%% This makes 'prove((a,b))' and 'prove(query)' with 'query :- a , b'
%%% function equivalently.

expand_input_proof([],_Proof).
expand_input_proof([N|L],[[N|_]|L1]) :-
	expand_input_proof(L,L1), !.

contract_output_proof([Prf|PrfEnd],Proof) :-
	Prf == PrfEnd,
	!,
	Proof = [].
contract_output_proof([[[N,_,_,_]|L]|PrfEnd],[N|L1]) :-
	contract_output_proof([L|PrfEnd],L1).

%%% Utility functions.

%%% Sometimes the `functor' predicate doesn't work as expected and
%%% a more comprehensive predicate is needed.  The `myfunctor'
%%% predicate overcomes the problem of functor(X,13,0) causing
%%% an error in Symbolics Prolog.  You may need to use it if
%%% `functor' in your Prolog system fails to construct or decompose
%%% terms that are numbers or constants.

myfunctor(Term,F,N) :-
	nonvar(F),
	atomic(F),
	N == 0,
	!,
	Term = F.
myfunctor(Term,F,N) :-
	nonvar(Term),
	atomic(Term),
	!,
	F = Term,
	N = 0.
myfunctor(Term,F,N) :-
	functor(Term,F,N).

list_length([_X|L],N) :-
	list_length(L,N1),
	N is N1 + 1.
list_length([],0) :- !.

negated_functor(F,NotF) :-
	name(F,L),
	name(not_,L1),
	(append(L1,L2,L) ->
		true;
	%true ->
		append(L1,L,L2)),
	name(NotF,L2).

negated_literal(Lit,NotLit) :-
	Lit =.. [F1|L1],
	negated_functor(F1,F2),
	(var(NotLit) ->
		NotLit =.. [F2|L1];
	%true ->
		NotLit =.. [F2|L2],
		L1 == L2).

write_indent_for_number(N) :-
	((number(N) , N <  100) -> write(' ') ; true),
	((number(N) , N <   10) -> write(' ') ; true),
        !.

write_clause(A) :-
	nl,
%	copy_term(A,B), numbervars(B,23,_), write(B),
	write(A),
	write(.),
        !.

write_clause(A,_) :-				% 2-ary predicate for use as
	write_clause(A), !.			% apply_to_conjuncts argument

write_clause_with_number(A,WffNum) :-
	nl,
	write_indent_for_number(WffNum),
	write(WffNum),
	write('  '),
        copy_term(A,B), numbervars(B,23,_), write(B),
%	write(B),
	write(.), 
        !.

%%% List of builtin predicates that can appear in clause bodies.
%%% No extra arguments are added for ancestor goals or depth-first
%%% iterative-deepening search.  Also, if a clause body is
%%% composed entirely of builtin goals, the head is not saved
%%% as an ancestor for use in reduction or pruning.
%%% This list can be added to as required.

builtin(T) :-
	functor(T,F,N),
	builtin(F,N), !.

builtin(!,0).
builtin(true,0).
builtin(false,0).
builtin(fail,0).
builtin(succeed,0).
builtin(trace,0).
builtin(atom,1).
builtin(integer,1).
builtin(number,1).
builtin(atomic,1).
builtin(constant,1).
builtin(functor,3).
builtin(arg,3).
builtin(var,1).
builtin(nonvar,1).
builtin(call,1).
builtin(=,2).
builtin(\=,2).
builtin(==,2).
builtin(\==,2).
builtin(=\=,2).
builtin(>,2).
builtin(<,2).
builtin(>=,2).
builtin(=<,2).
builtin(dif,2).
builtin(is,2).
builtin(max,3).
builtin(min,3).
builtin(display,1).
builtin(write,1).
builtin(nl,0).
builtin(infer_by,_).
builtin(search_cost,_).
builtin(test_and_decrement_search_cost,_).
builtin(unify,_).
builtin(identical_member,_).
builtin(unifiable_member,_).
builtin(inc_ncalls,0).
builtin(axioms,_).
builtin(anc_del,_). builtin(anc_union,_). builtin(anc_subset,_) :- !.

%%% Theorem proving examples from
%%%   Chang, C.L. and R.C.T. Lee.
%%%   Symbolic Logic and Mechanical Theorem Proving.
%%%   Academic Press, New York, 1973, pp. 298-305.

/*
chang_lee_example1 :-
	nl,
	write(chang_lee_example1),
	pttp((
		p(g(X,Y),X,Y),
		p(X,h(X,Y),Y),
		(p(U,Z,W) :- p(X,Y,U) , p(Y,Z,V) , p(X,V,W)),
		(p(X,V,W) :- p(X,Y,U) , p(Y,Z,V) , p(U,Z,W)),
		(query :- p(k(X),X,k(X)))
	)),
	fail.				% clear stack used in compilation
chang_lee_example1 :-
	prove(query).			% run query with fresh stack


%%% A harder problem.
%%% Problem 4 from Overbeek's competition problems.

overbeek4 :-
	pttp((
		p(e(X,e(e(Y,e(Z,X)),e(Z,Y)))),
		(p(Y) :- p(e(X,Y)), p(X)),
		(query :- p(e(e(e(a,e(b,c)),c),e(b,a))))
	)),
	fail.
overbeek4 :-
	prove(query,100,0,2).	% cost 30 proof

*/

%;;;;;;;;;;;;;;;;;;;;;;;; end file pttp-in-prolog-2e.pl

inc_ncalls.

% compiled chang_lee_example1:

/*
int_p(g(_163,_164),_4714,_4715,_4585,_4586,_4534,_4534,_4589,_4590,_4528):-(unify(_163,_4714),unify(_164,_4715)),inc_ncalls,_4589=[_5883,[1,_4528,_4585,_4586]|_5882],_4590=[_5883|_5882].

int_p(_163,h(_7581,_164),_7269,_7139,_7140,_7088,_7088,_7143,_7144,_7082):-(unify(_163,_7581),unify(_164,_7269)),inc_ncalls,_7143=[_8427,[2,_7082,_7139,_7140]|_8426],_7144=[_8427|_8426].

int_p(_139,_140,_141,_9683,_9631,_9685,_9686,_9687,_9688,_9626):-(_9685>=3,_9632 is _9685-3),inc_ncalls,_9630=[_9626|_9683],(_9687=[_10855,[3,_9626,_9683,_9631]|_10854],_10722=[_10855|_10854]),p(_163,_164,_139,_9630,_9631,_9632,_11548,_10722,_11550),p(_164,_140,_127,_9630,_9631,_11548,_12456,_11550,_12458),p(_163,_127,_141,_9630,_9631,_12456,_9686,_12458,_9688).

int_p(_163,_127,_141,_15333,_15281,_15335,_15336,_15337,_15338,_15276):-(_15335>=3,_15282 is _15335-3),inc_ncalls,_15280=[_15276|_15333],(_15337=[_16505,[4,_15276,_15333,_15281]|_16504],_16372=[_16505|_16504]),p(_163,_164,_139,_15280,_15281,_15282,_17198,_16372,_17200),p(_164,_140,_127,_15280,_15281,_17198,_18106,_17200,_18108),p(_139,_140,_141,_15280,_15281,_18106,_15336,_18108,_15338).

int_query(_20919,_20920,_20921,_20922,_20923,_20924,_20862):-(_20923=[_21469,[5,query,_20919,_20920]|_21468],_21336=[_21469|_21468]),p(k(_163),_163,k(_163),_20919,_20920,_20921,_20922,_21336,_20924).

p(_40900,_40901,_40902,_40749,_40746,_40862,_40860,_40858,_40856):-
    _40792=p(_40900,_40901,_40902),
    nonidentical_member(_40792,_40749),
    ((
%     identical_member(_40792,_40746),!; 
      unifiable_member(_40792,_40746)),
     inc_ncalls,
     _40860=_40862,
     _40858=[_40662,[red,_40792,_40749,_40746]|_40661],
     _40856=[_40662|_40661]; %  OR 
     int_p(_40900,_40901,_40902,_40749,_40746,
           _40862,_40860,_40858,_40856,_40792
          )
    ).

% end chang_lee_example1

% chang lee example 2:

int_p(e,_168,_5880,_5750,_5751,_5699,_5699,_5754,_5755,_5693):-unify(_168,_5880),_5754=[_6680,[1,_5693,_5750,_5751]|_6679],_5755=[_6680|_6679].

int_p(_168,e,_8066,_7936,_7937,_7885,_7885,_7940,_7941,_7879):-unify(_168,_8066),_7940=[_8866,[2,_7879,_7936,_7937]|_8865],_7941=[_8866|_8865].

int_p(_168,_10251,e,_10122,_10123,_10071,_10071,_10126,_10127,_10065):-unify(_168,_10251),_10126=[_11052,[3,_10065,_10122,_10123]|_11051],_10127=[_11052|_11051].

int_p(a,b,c,_12308,_12309,_12257,_12257,_12312,_12313,_12251):-_12312=[_13363,[4,_12251,_12308,_12309]|_13362],_12313=[_13363|_13362].

int_p(_135,_136,_137,_14619,_14567,_14621,_14622,_14623,_14624,_14562):-(_14621>=3,_14568 is _14621-3),_14566=[_14562|_14619],(_14623=[_15791,[5,_14562,_14619,_14567]|_15790],_15658=[_15791|_15790]),p(_168,_129,_135,_14566,_14567,_14568,_16484,_15658,_16486),p(_129,_136,_123,_14566,_14567,_16484,_17392,_16486,_17394),p(_168,_123,_137,_14566,_14567,_17392,_14622,_17394,_14624).

int_p(_168,_123,_137,_20269,_20217,_20271,_20272,_20273,_20274,_20212):-(_20271>=3,_20218 is _20271-3),_20216=[_20212|_20269],(_20273=[_21441,[6,_20212,_20269,_20217]|_21440],_21308=[_21441|_21440]),p(_168,_129,_135,_20216,_20217,_20218,_22134,_21308,_22136),p(_129,_136,_123,_20216,_20217,_22134,_23042,_22136,_23044),p(_135,_136,_137,_20216,_20217,_23042,_20272,_23044,_20274).

int_query(_25855,_25856,_25857,_25858,_25859,_25860,_25798):-(_25859=[_26405,[7,query,_25855,_25856]|_26404],_26272=[_26405|_26404]),p(b,a,c,_25855,_25856,_25857,_25858,_26272,_25860).

p(_48921,_48922,_48923,_48770,_48767,_48883,_48881,_48879,_48877):-
    _48813=p(_48921,_48922,_48923),
    nonidentical_member(_48813,_48770),
    ((
%     identical_member(_48813,_48767),!; 
      unifiable_member(_48813,_48767)),
     _48881=_48883,
     _48879=[_48683,[red,_48813,_48770,_48767]|_48682],
     _48877=[_48683|_48682];
     int_p(_48921,_48922,_48923,_48770,_48767,_48883,
           _48881,_48879,_48877,_48813
          )
    ).

% version of 'p' below avoids use of ';' 

%p(_48921,_48922,_48923,_48770,_48767,_48883,_48881,_48879,_48877):-
%    _48813=p(_48921,_48922,_48923),
%    nonidentical_member(_48813,_48770),
%    p_aux(_48813,_48767,_48881,_48883,_48879,_48683,_48770,_48682,
%          _48877,_48921,_48922,_48923).

%p_aux(_48813,_48767,_48881,_48883,_48879,_48683,_48770,_48682,
%      _48877,_48921,_48922,_48923) :-
%      unifiable_member(_48813,_48767),
%     _48881=_48883,
%     _48879=[_48683,[red,_48813,_48770,_48767]|_48682],
%     _48877=[_48683|_48682].

%p_aux(_48813,_48767,_48881,_48883,_48879,_48683,_48770,_48682,
%      _48877,_48921,_48922,_48923) :-
%     int_p(_48921,_48922,_48923,_48770,_48767,_48883,
%           _48881,_48879,_48877,_48813).


% end chang lee example 2
*/
% compiled overbeek:

int_p(  e(_132,e(e(_126,e(_123,_4158)),e(_4855,_4856))),
        _3078,
        _3079,
        _3027,
        _3027,
        _3082,
        _3083,
        _3021) :-
    ((unify(_132,_4158),
      unify(_123,_4855)),
    unify(_126,_4856)),
    inc_ncalls,
    _3082=[_5699,[1,_3021,_3078,_3079]|_5698],
    _3083=[_5699|_5698].

int_p(  _126,
        _6921,
        _6869,
        _6923,
        _6924,
        _6925,
        _6926,
        _6864) :-
    (_6923>=2,
     _6870 is _6923-2),
    inc_ncalls,
    _6868=[_6864|_6921],
    (_6925=[_7787,[2,_6864,_6921,_6869]|_7786],
     _7654=[_7787|_7786]),
    p(e(_132,_126),_6868,_6869,_6870,_8480,_7654,_8482),
    p(_132,_6868,_6869,_8480,_6924,_8482,_6926).

int_query(_10887,
          _10888,
          _10889,
          _10890,
          _10891,
          _10892,
          _10830) :-
    (_10891=[_11437,[3,query,_10887,_10888]|_11436],
     _11304=[_11437|_11436]),
    p(e(e(e(a,e(b,c)),c),e(b,a)),_10887,_10888,_10889,_10890,_11304,_10892).

p(_22638,
  _22487,
  _22484,
  _22600,
  _22598,
  _22596,
  _22594) :-
    _22530=p(_22638),
    nonidentical_member(_22530,_22487),
    ((identical_member(_22530,_22484),
      !;
      unifiable_member(_22530,_22484)),
     inc_ncalls,
     _22598=_22600,
     _22596=[_22400,[red,_22530,_22487,_22484]|_22399],
     _22594=[_22400|_22399];
     int_p(_22638,_22487,_22484,_22600,_22598,_22596,_22594,_22530)
    ).

% end overbeek


o_query :- query(0),nl, o_ksoln('found - see Incoming window').

:- o_kloop.
