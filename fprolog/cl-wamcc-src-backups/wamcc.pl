/*-------------------------------------------------------------------------*/
/* PrologPF to Wam Compiler               Ian Lewis - Cambridge University */
/*-------------------------------------------------------------------------*/
/* Built upon wamcc system:             INRIA Rocquencourt - ChLoE Project */
/*                                                      Daniel Diaz - 1991 */
/*                                                                         */
/* main directive:  :- go. (at end of this file)                           */
/*                                                                         */
/* input:                                                                  */
/*   CommandLine: a file name or a list of options and file names          */
/*                                                                         */
/* Comments:                                                               */
/*                                                                         */
/* !    : The 5 required cuts are indicated thus: (% cut important)        */
/*        All others a just to remove redundant choice points              */
/*                                                                         */
/* Fin  : A 'difference' variable marking hole at end of list              */
/*                                                                         */
/* LSuiv: LSuiv est une liste a placer en fin de liste resultat. Elle sert */
/*        a eviter un append. Exemple:                                     */
/*                                                                         */
/*        au lieu de:                                                      */
/*           f(L1,L2,R) :- trait(L1,R1), trait(L2,R2), append(R1,R2,R).    */
/*                                                                         */
/*           trait([],[]).                                                 */
/*           trait([E|L],[E1|R]):- modif(E,E1),trait(L,R).                 */
/*                                                                         */
/*        on ecrit:                                                        */
/*           f(L1,L2,R1):- trait(L1,R2,R1), trait(L2,[],R2).               */
/*                                                                         */
/*           trait([],LSuiv,LSuiv).                                        */
/*           trait([E|L],LSuiv,[E1|R]):- modif(E,E1), trait(L,LSuiv,R).    */
/*                                                                         */
/* global variables (g_assign/2, g_read/2):                                */
/*                                                                         */
/* options:mode_c=t/f  fast_math=t/f  no_inline=t/f  debug=0-2  verbose=t/f*/
/*                                                                         */
/* others: module, file_in, file_out, file_h, file_usr (files)                 */
/*         file_nb: file counter (as a key for info about predicates)      */
/*         aux (auxiliary counter)                                         */
/*         nb_clause_exe ('$exe_i' clause counter, i.e. directives)        */
/*         nb_clause_dyn ('$dyn_j' clause counter, i.e. dynamic clauses)   */
/*-------------------------------------------------------------------------*/

:- main([wamcc0,wamcc1,wamcc2,wamcc3,wamcc4,
         wamcc5,wamcc6,wamcc7,wamcc8,wamcc_ocode]).


wamcc(CmdLine):-
	(cmd_line(CmdLine,LFile)
              -> (g_read(verbose,t) -> display_version
	                            ;  true),
	         compile1(LFile)
	      ;
                 display_version,
                 display_help, 
		 error('')).

/***************************************************************************/

compile1([]):-
	!.                                            % cut important

compile1([File|LFile]):-
	!,                                            % cut important
	(compile2(File), fail ; true),                 % gc
	compile1(LFile).

/***************************************************************************/

compile2(File):-
	get_file_names(File),
        (g_read(verbose,t) -> g_read(file_in,FileIn),
	                      formata('Compiling ~w...~n',[FileIn])
                           ;  true),
	g_assign(aux,1),
	read_files(LSrc,Main),
        /* ijl 3/feb/97 debug */ nl,write('Returned from read_files'),nl,
        /* ijl 3/feb/97 debug  write('LSrc:'),nl, */
        /* ijl 3/feb/97 debug  print_prog(LSrc),nl, */
        /* ijl 3/feb/97 debug */ write('Main:'),nl,
        /* ijl 3/feb/97 debug */ write(Main),nl,
	compiler(LSrc,Main),
	!.                                            % cut important

compile2(_):- 
	seen, 
	told, 
	error('        ... Fail').

/***************************************************************************/

get_file_names(File):-
	atom_length(File,L),
	P is L-2,
	(sub_atom(File,P,3,'.pl') -> L1 is P-1,
                                    sub_atom(File,1,L1,Prefix),
				    FileIn=File
                                 ;
                                    Prefix=File,
                                    atom_concat(Prefix,'.pl',FileIn)),
	(g_read(mode_c,t) -> atom_concat(Prefix,'.c',FileOut),
   	                     atom_concat(Prefix,'.h',FileH),
			     atom_concat(Prefix,'.usr',FileUsr)
                          ;
			     atom_concat(Prefix,'.wam',FileOut),
			     FileH=null,
			     FileUsr=null),
	base_name(Prefix,Module),
	g_assign(module,Module),
	g_assign(file_in,FileIn),
	g_assign(file_out,FileOut),
	g_assign(file_h,FileH),
	g_assign(file_usr,FileUsr).

/***************************************************************************/

base_name(Prefix,Module):-
	(sub_atom(Prefix,P,1,'/') -> atom_length(Prefix,L),
	                             P1 is P+1,
				     L1 is L-P,
	                             sub_atom(Prefix,P1,L1,Prefix1),
				     base_name(Prefix1,Module)
                                  ;
				     Module=Prefix).

/***************************************************************************/

cmd_line(CmdLine,LFile):-
        ((CmdLine=[_|_] ; CmdLine==[]) -> CmdLine1=CmdLine
                                       ;  CmdLine1=[CmdLine]),
	set_default_options,
	cmd_line1(CmdLine1,LFile).

cmd_line1([],[]).

cmd_line1([Opt|CmdLine],LFile):-
        (Opt= -Opt1, !
             ;
	 sub_atom(Opt,1,1,'-'), !,
         atom_length(Opt,L), L1 is L-1, sub_atom(Opt,2,L1,Opt1)),
	traite_opt(Opt1),
	cmd_line1(CmdLine,LFile).

cmd_line1([File|CmdLine],[File|LFile]):-
	cmd_line1(CmdLine,LFile).

/***************************************************************************/

set_default_options:-
	g_assign(mode_c,       t),
        g_assign(fast_math,    f),
	g_assign(no_stack_test,f),
        g_assign(no_inline,    f),
        g_assign(debug,        0),
        g_assign(verbose,      f).

/***************************************************************************/

traite_opt(c):-             g_assign(mode_c,        t).
traite_opt(wam):-           g_assign(mode_c,        f).
traite_opt(fast_math):-     g_assign(fast_math,     t).
traite_opt(no_stack_test):- g_assign(no_stack_test, t).
traite_opt(no_inline):-     g_assign(no_inline,     t).
traite_opt(dbg0):-          g_assign(debug,         0).
traite_opt(dbg):-           g_assign(debug,         1).
traite_opt(dbg1):-          g_assign(debug,         1).
traite_opt(dbg2):-          g_assign(debug,         2).
traite_opt(v):-             g_assign(verbose,       t).

/***************************************************************************/

:- public display_version/0.

display_version:-
	!,
	ProgramCmt='PrologPF: A Parallel Functional Prolog Compiler',
        wam_version(V),
	wam_year(Y),
	name(ProgramCmt,SProgramCmt),
	length(SProgramCmt,LC),
	name(V,SV),
	length(SV,LV),
	DC is 40-LC,
	DV is 42-LV,
	formata('~s~*c   Cambridge University~n',[SProgramCmt,DC,32]),
	formata('Version ~s~*c I.Lewis, D.Diaz(wamcc)-~d~n~n',
                [SV,DV,32,Y]).

/***************************************************************************/

display_help:-
	compiler_name(Name),
	formata('Usage:~n~n',[]),
        formata('   ~w [option | filename]...~n~n',[Name]),
	formata('Options:~n~n',[]),
	formata('   -c             produce a .c   file~n',[]),
	formata('   -wam           produce a .wam file~n',[]),
	formata('   -fast_math     do not test types in math expressions~n',[]),
	formata('   -no_stack_test do not include additional code to test stack overflow~n',[]),
	formata('   -no_inline     do not inline any builtin predicates~n',[]),
	formata('   -dbg           compile for prolog debugging~n',[]),
	formata('   -dbg2          compile for prolog and wam debugging~n',[]),
	formata('   -v             verbose mode~n',[]),
	formata('   -h             display help~n',[]).

/***************************************************************************/

compiler(LSrc,Main):-
	g_read(mode_c,ModeC),
        /* ijl 8/apr/97 */ prog_to_ocode(LSrc,LSrc1),
        /* ijl 9/apr/97 */ write('ocode:'),nl,
        /* ijl 9/apr/97 */ print_prog(LSrc1),nl,
	exec_passes(LSrc1,LClComp),                                  !,
        /* ijl 3/feb/97 debug */ print_exec_passes_output(LClComp), 
	cree_paquets(LClComp,LPaq),                                 !,
        /* ijl 3/feb/97 debug */ print_cree_paquets_output(LPaq),
	exec_indexation(LPaq,LPaqW),                                !,
        /* ijl 3/apr/97 debug */ print_exec_index_output(LPaqW),
	(ModeC==f
	   ->  wam_emission(LPaqW)
	   ;   c_emission(LPaqW,Main)).

/***************************************************************************/

exec_passes([],[]).

exec_passes([ClSrc|LSrc],[clcomp(Pred,Arg1,W)|LClComp]):-
	sucre_syntaxique(ClSrc,LSrc,ClSrc1,LSrc1),                  !,
	format_interne(ClSrc1,Arg1,T,C,NbChunk),                    !,
        /* ijl 7/apr/97 debug print_format_int(ClSrc1,Arg1,T,C,NbChunk), */
	classif_variables(T,C),                                     !,
	generation_code(T,C,NbChunk,Pred,W),                        !,
	allocation_varsX(W),                                        !,
	exec_passes(LSrc1,LClComp).

/***************************************************************************/

cree_paquets([],[]).

cree_paquets([ClComp|LClComp],LPaq1):-
	cree_paquets(LClComp,LPaq),
	ajout_clause(LPaq,ClComp,LPaq1),
	!.

/***************************************************************************/

ajout_clause(LPaq,ClComp,[Paq|LPaq1]):-             % replace paquet devant
	trouve_paquet(LPaq,ClComp,Paq,LPaq1).

/***************************************************************************/

trouve_paquet([],clcomp(Pred,Arg1,W),paq(Pred,[Cl]),[]):-
	format_index(Arg1,W,Cl).

trouve_paquet([paq(Pred,LCl)|LPaq],clcomp(Pred,Arg1,W),paq(Pred,[Cl|LCl]),LPaq):- 
	format_index(Arg1,W,Cl).

trouve_paquet([Paq|LPaq],ClComp,Paq1,[Paq|LPaq1]):-
	trouve_paquet(LPaq,ClComp,Paq1,LPaq1).

/***************************************************************************/

format_index(Arg1,W,cl(_,Arg1,W)).                    % pour indexation

/***************************************************************************/

exec_indexation([],[]).

exec_indexation([paq(Pred,LCl)|LPaq],[paq(Pred,LClW)|LPaqW]):-
	indexation(LCl,LClW),
	!,
	exec_indexation(LPaq,LPaqW).


/*--- Gestion des ensembles (sans unification) ----------------------------*/

:- public ens_ajout/3, ens_retrait/3,
          ens_elt/2, ens_inter/3,  ens_union/3, ens_compl/3.

ens_ajout([],X,[X]).

ens_ajout([Y|L],X,[Y|L]):-
	X==Y, 
	!.

ens_ajout([Y|L],X,[Y|L1]):- 
	ens_ajout(L,X,L1).


ens_retrait([Y|L],X,L):-                % ens_retrait(L,X,L1) echoue si
        X==Y,                           % X n'appartient pas a L
        !.

ens_retrait([Y|L],X,[Y|L1]):-
        ens_retrait(L,X,L1).


ens_elt([Y|_],X):-
	X==Y, 
	!.

ens_elt([_|L],X):-
	ens_elt(L,X).


ens_inter([],_,[]).

ens_inter([X|L1],L2,[X|L3]):-
	ens_elt(L2,X), 
	!, 
	ens_inter(L1,L2,L3).

ens_inter([_|L1],L2,L3):-
	ens_inter(L1,L2,L3).


ens_union([],L2,L2).

ens_union([X|L1],L2,L3):-
	ens_elt(L2,X),
	!,
	ens_union(L1,L2,L3).

ens_union([X|L1],L2,[X|L3]):-
	ens_union(L1,L2,L3).


ens_compl([],_,[]).

ens_compl([X|L],L1,L3):-
	(ens_elt(L1,X) -> L3=L2
                       ;  L3=[X|L2]),
        ens_compl(L,L1,L2).


/*--- Erreurs -------------------------------------------------------------*/

:- public error/1.

error(Err):-
	write(Err), nl,
	abort.


/*--- Unix interface ------------------------------------------------------*/

go:- unix(argv(L)), (L\==[] -> wamcc(L), halt_or_else(0,true) ; true).

:- go.

/***************************************************************************/
/***************************************************************************/
/***************************************************************************/

/*--- IJL debug code ------------------------------------------------------*/

print_list([]).
print_list([Cl]) :- write('      '),write(Cl), nl, !.
print_list([Cl|Cls]) :- 
        write('      '),write(Cl),write(','),nl,
        print_list(Cls).

/***************************************************************************/
/* print_exec_passes_output dumps the output of the relation to stdout, so */
/* you can see what the relation does.                                     */

print_exec_passes_output(ClComp) :- write('exec_passes output:'), nl,
        write('['),nl,
        print_list(ClComp),
        write(']'),nl,nl.

/****************************************************************************/
/* print_cree_paquets_output dumps the output of the relation to stdout, so */
/* you can see what the relation does.                                      */

print_cree_paquets_output(LPaq) :- write('cree_paquets output:'), nl,
        write('['),nl,
        print_list(LPaq),
        write(']'),nl,nl.

/***************************************************************************/
/* print_exec_index_output dumps the output of the relation to stdout, so */
/* you can see what the relation does.                                      */

print_exec_index_output(LPaqW) :- write('exec_index output:'), nl,
        write('['),nl,
        print_exec_index_output1(LPaqW),
        write(']'),nl,nl.

print_exec_index_output1([]).
print_exec_index_output1([paq(Pred,List)]) :- 
        write('  '),write(paq),write('('),
        write(Pred), write(','),nl,
        write('    '),write('['),nl,
        print_list(List),nl,
        write('    '),write(']'),nl, !.               
print_exec_index_output1([paq(Pred,List)|Paqs]) :-
        write('  '),write(paq),write('('),
        write(Pred), write(','),nl,
        write('    '),write('['),nl,
        print_list(List),nl,
        write('    '),write(']'),nl,               
        print_exec_index_output1(Paqs).

/***************************************************************************/
/* print_format_int dumps the output of the relation to stdout, so         */
/* you can see what the relation does.                                     */

print_format_int(ClSrc1,Arg1,T,C,NbChunk) :-
       write('format_interne:'),nl,
       write('  ClSrc1:'),nl,
       write('    '),write(ClSrc1),nl,
       write('  Arg1:'),nl,
       write('    '),write(Arg1),nl,
       write('  T:'),nl,
       write('    '),write(T),nl,
       write('  C:'),nl,
       write('    '),write(C),nl,
       write('  NbChunk:'),nl,
       write('    '),write(NbChunk),nl.

/***************************************************************************/
/*  print program                                                          */

print_prog([Cl|Prog]) :- print_clause(Cl),nl, print_prog(Prog).
print_prog([]).

print_clause((H:-B)) :- write(H), write(' :-'), nl,
                        print_goal(B), write('.'), nl,
                        !.
print_clause(H) :- write(H), write('.'), nl.

print_goal((P,Q)) :- print_goal(P), write(','), nl,
                     print_goal(Q),!.
print_goal((P;Q)) :- print_goal(P), write(';'), nl,
                     print_goal(Q),!.
print_goal((P->Q)) :- print_goal(P), write('->'), nl,
                      print_goal(Q),!.
print_goal(P) :- write('    '),write(P).



