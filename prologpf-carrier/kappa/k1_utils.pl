
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             TRANSFORMATION:                                               %%
%%                                                                           %%
%%   ORIGINAL CODE:                                                          %%
%%       a(X).                                                               %%
%%       a(X) :- c(X), d(X).                                                 %%
%%                                                                           %%
%%   TRANSFORMED CODE:                                                       %%
%%       a(X,1) :- o_kbuild(1).                                              %%
%%       a(X,2) :- o_kbuild(2), o_kfollow(N1), c(X,N1),                      %%
%%                              o_kfollow(N2), d(X,N2).                      %%
%%                                                                           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- public o_kinit/0, o_kbuild/1, o_kfollow/1, o_ksoln/1, o_k/5,
    o_kread_b_depth/1,
    o_kset_l/1, o_kread_l/1, o_kset_g/1, o_kread_g/1,
    o_kset_l0/1, o_kread_l0/1,
    o_kset_s/1, o_kread_s/1,
    o_kset_n/1, o_kread_n/1, o_kread_s/1, o_kset_orc_length/1,
    o_kread_orc/1, o_kread_port_orc/1, o_kset_orc/1,
    o_kdefer/0, o_kskip/0,
    o_kinterrupt/0, o_kfull_query/0, o_kloop/0.

%%%%%%%%%% ORACLE PRIMITIVES %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% o_kbuild: BUILD primitive embedded into user program  %%%%%

o_kbuild(N) :- pragma_c(o_kbuild1).
o_kbuild(_) :- pragma_c(o_kbuild2).

%%%%%%%%%%% o_kfollow: FOLLOW primitive embedded into user program %%%%

o_kfollow(_).

%%%%% UTILITY predicates with side-effects to set control parameters %%

o_kread_b_depth(N) :- pragma_c(o_kread_b_depth).

o_kset_l(L) :- pragma_c(o_kset_l).
o_kread_l(L) :- pragma_c(o_kread_l).

o_kset_l0(L) :- pragma_c(o_kset_l0).
o_kread_l0(L) :- pragma_c(o_kread_l0).

o_kset_g(G) :- pragma_c(o_kset_g).
o_kread_g(G) :- pragma_c(o_kread_g).

o_kset_n(N) :- pragma_c(o_kset_n).
o_kread_n(N) :- pragma_c(o_kread_n).

o_kset_s(S) :- pragma_c(o_kset_s).
o_kread_s(S) :- pragma_c(o_kread_s).

o_kdefer :- pragma_c(o_kdefer).

o_kskip :- pragma_c(o_kskip).

o_kport_orc :- pragma_c(o_kport_orc).

o_ksend_oracle :- pragma_c(o_ksend_oracle).

%%%%%%% INITIALISE (also called on program startup) %%%%%

o_kinit :- pragma_c(o_kinit).

o_ksol_count(N) :- g_read(o_SolnCount,N).

o_kloop1 :- read(X), call(X), o_kloop1.

o_kloop :- catch(o_kloop1, signal(2), (nl,write('delphi kappa nosplit'),nl,o_kloop)).

%%%%% utilities to set up oracle to be FOLLOWED %%%%%%%%%

o_kset_orc_length(L) :- pragma_c(o_kset_orc_length).
o_kread_orc_length(L) :- pragma_c(o_kread_orc_length).

o_kset_orc(Orc) :- o_kset_orc1(1,Orc).

o_kset_orc1(I,[]) :- I1 is I - 1, o_kset_orc_length(I1), !.
o_kset_orc1(I,[X|Xs]) :- o_kset_orc_index(I,X),
                I1 is I + 1,
                o_kset_orc1(I1,Xs).

o_kset_orc_index(I,X) :- pragma_c(o_kset_orc_index).

%%%%% utilities to read current oracle   %%%%%%%%%%%%%%%%

o_kread_orc_index(I,X) :- pragma_c(o_kread_orc_index).

o_kread_port_orc(Orc) :- o_kread_l(Length),
                o_kread_orc1(1, Length, Orc).

o_kread_orc(Orc) :- o_kread_b_depth(Length),
                o_kread_orc1(1, Length, Orc).

o_kread_orc1(From, To, []) :- From > To, !.
o_kread_orc1(From, To, [X|Xs]) :- 
                o_kread_orc_index(From, X),
                From1 is From + 1,
                o_kread_orc1(From1, To, Xs).

%%%%% procedure to handle INTERRUPT   %%%%%%%%%%%%%%%%%%%%%%%%%%%%

                                     % Interrupt received below 'l'
o_kinterrupt :- o_kread_b_depth(D), o_kread_l(L), D < L, !,        
                o_kread_s(S),
                o_kread_g(G), o_kread_n(N),
                nl, write('delphi kappa deferred '),
                write(N), write(' '), write(G), write(' '), write(L), write(' '),
                write(S), write(' '), write(D), nl,
                o_kset_orc_length(D),
                o_kinit,        
                o_kdefer,
                o_kfull_query.

o_kinterrupt :- o_kread_b_depth(D), o_kset_orc_length(D),
                o_ksend_oracle,
                o_kinit,        
                o_kskip,
                o_kfull_query.

o_kfull_query :- catch((o_query,fail), signal(2), o_kinterrupt). 

/**************************************************************************/
/*                                                                        */
/*                    S T R A T E G I E S                                 */
/*                                                                        */
/**************************************************************************/
/*                                                                        */
/*                                                                        */

o_ksoln(X) :- g_read(o_SolnCount,C), C1 is C + 1, g_assign(o_SolnCount,C1),
    o_kread_b_depth(D),                          % o_kread_width_index(D,W),
    write('delphi solution at depth='),write(D), %  write(' width='), write(W),
    write(': '), write(X), nl.

                       /* o_k/4 (compatible with k_utils version 1)       */
                       /*   only returns oracle to PORT on interruption   */
                       /*   so PP does not skip search already done in    */
                       /*   subtree.                                      */

o_k(G,N,L,Orc) :- 
    o_kport_orc,       /* set flag to return truncated PORT oracles       */
    o_kset_s(0),
    o_kset_g(G), o_kset_n(N), o_kset_l(L),
    o_kset_orc(Orc),
    o_kread_orc_length(L0), o_kset_l0(L0),
    o_krun.

o_k(G,N,L0,L,Orc) :-
    o_kset_s(0),
    o_kset_g(G), o_kset_n(N), 
    o_kset_l0(L0),o_kset_l(L),
    o_kset_orc(Orc), o_krun.

o_krun :-
    o_kinit,
    o_kread_g(G),
    o_kread_n(N),
    o_kread_l(L),
      write('delphi kappa started '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), nl,
    cputime(T0), g_assign(o_Tstart,T0),
    o_kfull_query.                       /* calls o_query, always fails */

o_krun :-      /* Statistics & Shutdown */
    cputime(T3), g_read(o_Tstart, T2), Time is T3-T2,
    g_read(o_Ttime, Prev_Ttime), Ttime is Prev_Ttime + Time, g_assign(o_Ttime, Ttime),
    o_kread_g(G),
    o_kread_n(N),
    o_kread_l(L),
    o_kread_s(S),
    o_ksol_count(C),
      write('delphi kappa completed '),
      write(N), write(' '), 
      write(G), write(' '),
      write(L), write(' '),
      write(S), write(' '),
      write(C), write(' '),
      write(0), write(' '),
      write(Time), write(' '),
      write(Ttime), nl.

%%%%% Executable startup message  %%%%%%%%%%%%%%%%

:- write('delphi kappa loaded'), nl.


