/****************************************************************************
PrologPF: A Parallel Functional Prolog Compiler    Cambridge University
Version 0.02                                       I.Lewis, D.Diaz(wamcc)-1994

File : queens4.c
Main : main([o_utils])
****************************************************************************/

#define DEBUG_LEVEL    0

#include "wam_engine.h"

#include "queens4.h"
#include "queens4.usr"


#define ASCII_PRED "get_solutions"
#define PRED       X6765745F736F6C7574696F6E73
#define ARITY      2

Begin_Private_Pred
      get_x_variable(2,1)
      put_nil(1)
      execute(Pred_Name(X736F6C7665,3),1,"solve",3)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "solve"
#define PRED       X736F6C7665
#define ARITY      3

Begin_Private_Pred
      try_me_else(1)
      get_list(1)
      unify_x_variable(1)
      unify_x_variable(3)
      get_structure(X737175617265,2,1,"square")
      unify_x_local_value(0)
      unify_x_variable(1)
      get_list(2)
      unify_x_variable(2)
      unify_x_value(3)
      get_structure(X737175617265,2,2,"square")
      unify_x_local_value(0)
      unify_x_value(1)
      proceed

label(1)
      trust_me_else_fail
      allocate(4)
      get_y_variable(3,0)
      get_y_variable(1,1)
      get_y_variable(0,2)
      put_y_value(1,0)
      put_y_variable(2,1)
      put_y_value(3,2)
      call(Pred_Name(X6E6577737175617265,3),1,1,"newsquare",3)          /* begin sub 1 */
      put_y_value(3,0)
      put_list(1)
      unify_y_local_value(2)
      unify_y_local_value(1)
      put_y_value(0,2)
      deallocate
      execute(Pred_Name(X736F6C7665,3),1,"solve",3)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "newsquare"
#define PRED       X6E6577737175617265
#define ARITY      3

Begin_Private_Pred
      switch_on_term(G_label(1),G_label(4),fail,G_label(2),fail)

label(1)
      try_me_else(3)

label(2)
      allocate(5)
      get_list(0)
      unify_x_variable(0)
      unify_y_variable(0)
      get_structure(X737175617265,2,0,"square")
      unify_y_variable(4)
      unify_y_variable(3)
      get_structure(X737175617265,2,1,"square")
      unify_y_variable(2)
      unify_y_variable(1)
      math_load_y_value(4,0)
      math_load_x_value(2,2)
      builtin_2(lt,0,2)
      math_load_y_value(4,0)
      function_1(inc,0,0)
      get_y_value(2,0)
      put_y_value(1,0)
      put_x_value(2,1)
      call(Pred_Name(X736E696E74,2),1,1,"snint",2)          /* begin sub 1 */
      put_y_value(4,0)
      put_y_value(3,1)
      put_y_value(2,2)
      put_y_value(1,3)
      call(Pred_Name(X6E6F74746872656174656E6564,4),1,2,"notthreatened",4)          /* begin sub 2 */
      put_y_value(2,0)
      put_y_value(1,1)
      put_y_value(0,2)
      deallocate
      execute(Pred_Name(X73616665,3),1,"safe",3)

label(3)
      trust_me_else_fail

label(4)
      get_nil(0)
      get_structure(X737175617265,2,1,"square")
      unify_integer(1)
      unify_x_variable(0)
      put_x_value(2,1)
      execute(Pred_Name(X736E696E74,2),1,"snint",2)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "snint"
#define PRED       X736E696E74
#define ARITY      2

Begin_Private_Pred
      try_me_else(1)
      get_x_value(0,1)
      proceed

label(1)
      trust_me_else_fail
      math_load_x_value(1,1)
      function_1(dec,1,1)
      math_load_x_value(1,1)
      put_integer(0,2)
      builtin_2(gt,1,2)
      execute(Pred_Name(X736E696E74,2),1,"snint",2)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "notthreatened"
#define PRED       X6E6F74746872656174656E6564
#define ARITY      4

Begin_Private_Pred
      builtin_2(term_neq,0,2)
      builtin_2(term_neq,1,3)
      math_load_x_value(0,0)
      math_load_x_value(1,1)
      function_2(sub,5,0,1)
      math_load_x_value(2,2)
      math_load_x_value(3,3)
      function_2(sub,4,2,3)
      builtin_2(term_neq,5,4)
      math_load_x_value(0,0)
      math_load_x_value(1,1)
      function_2(add,1,0,1)
      math_load_x_value(2,2)
      math_load_x_value(3,3)
      function_2(add,0,2,3)
      builtin_2(term_neq,1,0)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "safe"
#define PRED       X73616665
#define ARITY      3

Begin_Private_Pred
      try_me_else(1)
      get_nil(2)
      proceed

label(1)
      trust_me_else_fail
      allocate(3)
      get_y_variable(2,0)
      get_y_variable(1,1)
      get_list(2)
      unify_x_variable(0)
      unify_y_variable(0)
      get_structure(X737175617265,2,0,"square")
      unify_x_variable(0)
      unify_x_variable(1)
      put_y_value(2,2)
      put_y_value(1,3)
      call(Pred_Name(X6E6F74746872656174656E6564,4),1,1,"notthreatened",4)          /* begin sub 1 */
      put_y_value(2,0)
      put_y_value(1,1)
      put_y_value(0,2)
      deallocate
      execute(Pred_Name(X73616665,3),1,"safe",3)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "query"
#define PRED       X7175657279
#define ARITY      0

Begin_Private_Pred
      allocate(1)
      put_integer(4,0)
      put_y_variable(0,1)
      call(Pred_Name(X6765745F736F6C7574696F6E73,2),1,1,"get_solutions",2)          /* begin sub 1 */
      put_y_unsafe_value(0,0)
      deallocate
      execute(Pred_Name(X6F5F73656E645F736F6C6E,1),0,"o_send_soln",1)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$exe_1"
#define PRED       X246578655F31
#define ARITY      0

Begin_Private_Pred
      allocate(1)
      get_y_bc_reg(0)
      call(Pred_Name(X6F5F626670,0),0,1,"o_bfp",0)          /* begin sub 1 */
      cut_y(0)
      deallocate
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$exe_2"
#define PRED       X246578655F32
#define ARITY      0

Begin_Private_Pred
      put_constant(X74727565,0,"true")
      put_constant(X74727565,1,"true")
      execute(Pred_Name(X746F705F6C6576656C,2),0,"top_level",2)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_2_get_solutions"
#define PRED       X246F72635F325F6765745F736F6C7574696F6E73
#define ARITY      6

Begin_Private_Pred
      switch_on_term(G_label(1),fail,G_label(1),fail,fail)

label(1)
      allocate(6)
      get_integer(1,0)
      get_y_variable(4,1)
      get_list(2)
      unify_integer(1)
      unify_y_variable(3)
      get_y_variable(2,3)
      get_y_variable(1,4)
      get_y_variable(0,5)
      put_y_variable(5,0)
      put_y_value(4,1)
      call(Pred_Name(X6F5F6E657874,2),0,1,"o_next",2)          /* begin sub 1 */
      put_y_unsafe_value(5,0)
      put_y_value(4,1)
      put_y_value(3,2)
      put_y_value(2,3)
      put_y_value(1,4)
      put_nil(5)
      put_y_value(0,6)
      deallocate
      execute(Pred_Name(X246F72635F335F736F6C7665,7),0,"$orc_3_solve",7)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_3_solve"
#define PRED       X246F72635F335F736F6C7665
#define ARITY      7

Begin_Private_Pred
      switch_on_term(G_label(2),fail,G_label(1),fail,fail)

label(1)
      switch_on_integer(lst(i(1,3) i(2,5) ),"[(1,3),(2,5)]")

label(2)
      try_me_else(4)

label(3)
      get_integer(1,0)
      get_list(2)
      unify_integer(1)
      unify_x_variable(0)
      get_x_value(0,3)
      get_list(5)
      unify_x_variable(0)
      unify_x_variable(2)
      get_structure(X737175617265,2,0,"square")
      unify_x_local_value(4)
      unify_x_variable(0)
      get_list(6)
      unify_x_variable(1)
      unify_x_value(2)
      get_structure(X737175617265,2,1,"square")
      unify_x_local_value(4)
      unify_x_value(0)
      proceed

label(4)
      trust_me_else_fail

label(5)
      allocate(10)
      get_integer(2,0)
      get_y_variable(6,1)
      get_list(2)
      unify_integer(2)
      unify_y_variable(8)
      get_y_variable(4,3)
      get_y_variable(3,4)
      get_y_variable(1,5)
      get_y_variable(0,6)
      put_y_variable(9,0)
      put_y_value(6,1)
      call(Pred_Name(X6F5F6E657874,2),0,1,"o_next",2)          /* begin sub 1 */
      put_y_value(9,0)
      put_y_value(6,1)
      put_y_value(8,2)
      put_y_variable(5,3)
      put_y_value(1,4)
      put_y_variable(2,5)
      put_y_value(3,6)
      call(Pred_Name(X246F72635F335F6E6577737175617265,7),0,2,"$orc_3_newsquare",7)          /* begin sub 2 */
      put_y_variable(7,0)
      put_y_value(6,1)
      call(Pred_Name(X6F5F6E657874,2),0,3,"o_next",2)          /* begin sub 3 */
      put_y_unsafe_value(7,0)
      put_y_value(6,1)
      put_y_unsafe_value(5,2)
      put_y_value(4,3)
      put_y_value(3,4)
      put_list(5)
      unify_y_local_value(2)
      unify_y_local_value(1)
      put_y_value(0,6)
      deallocate
      execute(Pred_Name(X246F72635F335F736F6C7665,7),0,"$orc_3_solve",7)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_3_newsquare"
#define PRED       X246F72635F335F6E6577737175617265
#define ARITY      7

Begin_Private_Pred
      switch_on_term(G_label(2),fail,G_label(1),fail,fail)

label(1)
      switch_on_integer(lst(i(1,3) i(2,5) ),"[(1,3),(2,5)]")

label(2)
      try_me_else(4)

label(3)
      allocate(14)
      get_integer(1,0)
      get_y_variable(5,1)
      get_list(2)
      unify_integer(1)
      unify_y_variable(12)
      get_y_variable(3,3)
      get_list(4)
      unify_x_variable(0)
      unify_y_variable(0)
      get_structure(X737175617265,2,0,"square")
      unify_y_variable(8)
      unify_y_variable(7)
      get_structure(X737175617265,2,5,"square")
      unify_y_variable(2)
      unify_y_variable(1)
      get_y_variable(11,6)
      math_load_y_value(8,1)
      math_load_y_value(11,0)
      builtin_2(lt,1,0)
      math_load_y_value(8,0)
      function_1(inc,0,0)
      get_y_value(2,0)
      put_y_variable(13,0)
      put_y_value(5,1)
      call(Pred_Name(X6F5F6E657874,2),0,1,"o_next",2)          /* begin sub 1 */
      put_y_value(13,0)
      put_y_value(5,1)
      put_y_value(12,2)
      put_y_variable(9,3)
      put_y_value(1,4)
      put_y_value(11,5)
      call(Pred_Name(X246F72635F325F736E696E74,6),0,2,"$orc_2_snint",6)          /* begin sub 2 */
      put_y_variable(10,0)
      put_y_value(5,1)
      call(Pred_Name(X6F5F6E657874,2),0,3,"o_next",2)          /* begin sub 3 */
      put_y_value(10,0)
      put_y_value(5,1)
      put_y_value(9,2)
      put_y_variable(4,3)
      put_y_value(8,4)
      put_y_value(7,5)
      put_y_value(2,6)
      put_y_value(1,7)
      call(Pred_Name(X246F72635F345F6E6F74746872656174656E6564,8),0,4,"$orc_4_notthreatened",8)          /* begin sub 4 */
      put_y_variable(6,0)
      put_y_value(5,1)
      call(Pred_Name(X6F5F6E657874,2),0,5,"o_next",2)          /* begin sub 5 */
      put_y_unsafe_value(6,0)
      put_y_value(5,1)
      put_y_unsafe_value(4,2)
      put_y_value(3,3)
      put_y_value(2,4)
      put_y_value(1,5)
      put_y_value(0,6)
      deallocate
      execute(Pred_Name(X246F72635F335F73616665,7),0,"$orc_3_safe",7)

label(4)
      trust_me_else_fail

label(5)
      allocate(6)
      get_integer(2,0)
      get_y_variable(4,1)
      get_list(2)
      unify_integer(2)
      unify_y_variable(3)
      get_y_variable(2,3)
      get_nil(4)
      get_structure(X737175617265,2,5,"square")
      unify_integer(1)
      unify_y_variable(1)
      get_y_variable(0,6)
      put_y_variable(5,0)
      put_y_value(4,1)
      call(Pred_Name(X6F5F6E657874,2),0,6,"o_next",2)          /* begin sub 6 */
      put_y_unsafe_value(5,0)
      put_y_value(4,1)
      put_y_value(3,2)
      put_y_value(2,3)
      put_y_value(1,4)
      put_y_value(0,5)
      deallocate
      execute(Pred_Name(X246F72635F325F736E696E74,6),0,"$orc_2_snint",6)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_2_snint"
#define PRED       X246F72635F325F736E696E74
#define ARITY      6

Begin_Private_Pred
      switch_on_term(G_label(2),fail,G_label(1),fail,fail)

label(1)
      switch_on_integer(lst(i(1,3) i(2,5) ),"[(1,3),(2,5)]")

label(2)
      try_me_else(4)

label(3)
      get_integer(1,0)
      get_list(2)
      unify_integer(1)
      unify_x_variable(0)
      get_x_value(0,3)
      get_x_value(4,5)
      proceed

label(4)
      trust_me_else_fail

label(5)
      allocate(6)
      get_integer(2,0)
      get_y_variable(4,1)
      get_list(2)
      unify_integer(2)
      unify_y_variable(3)
      get_y_variable(2,3)
      get_y_variable(1,4)
      math_load_x_value(5,5)
      function_1(dec,0,5)
      get_y_variable(0,0)
      math_load_y_value(0,1)
      put_integer(0,0)
      builtin_2(gt,1,0)
      put_y_variable(5,0)
      put_y_value(4,1)
      call(Pred_Name(X6F5F6E657874,2),0,1,"o_next",2)          /* begin sub 1 */
      put_y_unsafe_value(5,0)
      put_y_value(4,1)
      put_y_value(3,2)
      put_y_value(2,3)
      put_y_value(1,4)
      put_y_unsafe_value(0,5)
      deallocate
      execute(Pred_Name(X246F72635F325F736E696E74,6),0,"$orc_2_snint",6)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_4_notthreatened"
#define PRED       X246F72635F345F6E6F74746872656174656E6564
#define ARITY      8

Begin_Private_Pred
      switch_on_term(G_label(1),fail,G_label(1),fail,fail)

label(1)
      get_integer(1,0)
      get_list(2)
      unify_integer(1)
      unify_x_variable(0)
      get_x_value(0,3)
      builtin_2(term_neq,4,6)
      builtin_2(term_neq,5,7)
      math_load_x_value(4,4)
      math_load_x_value(5,5)
      function_2(sub,1,4,5)
      math_load_x_value(6,6)
      math_load_x_value(7,7)
      function_2(sub,0,6,7)
      builtin_2(term_neq,1,0)
      math_load_x_value(4,4)
      math_load_x_value(5,5)
      function_2(add,1,4,5)
      math_load_x_value(6,6)
      math_load_x_value(7,7)
      function_2(add,0,6,7)
      builtin_2(term_neq,1,0)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_3_safe"
#define PRED       X246F72635F335F73616665
#define ARITY      7

Begin_Private_Pred
      switch_on_term(G_label(2),fail,G_label(1),fail,fail)

label(1)
      switch_on_integer(lst(i(1,3) i(2,5) ),"[(1,3),(2,5)]")

label(2)
      try_me_else(4)

label(3)
      get_integer(1,0)
      get_list(2)
      unify_integer(1)
      unify_x_variable(0)
      get_x_value(0,3)
      get_nil(6)
      proceed

label(4)
      trust_me_else_fail

label(5)
      allocate(11)
      get_integer(2,0)
      get_y_variable(5,1)
      get_list(2)
      unify_integer(2)
      unify_y_variable(9)
      get_y_variable(3,3)
      get_y_variable(2,4)
      get_y_variable(1,5)
      get_list(6)
      unify_x_variable(0)
      unify_y_variable(0)
      get_structure(X737175617265,2,0,"square")
      unify_y_variable(8)
      unify_y_variable(7)
      put_y_variable(10,0)
      put_y_value(5,1)
      call(Pred_Name(X6F5F6E657874,2),0,1,"o_next",2)          /* begin sub 1 */
      put_y_value(10,0)
      put_y_value(5,1)
      put_y_value(9,2)
      put_y_variable(4,3)
      put_y_value(8,4)
      put_y_value(7,5)
      put_y_value(2,6)
      put_y_value(1,7)
      call(Pred_Name(X246F72635F345F6E6F74746872656174656E6564,8),0,2,"$orc_4_notthreatened",8)          /* begin sub 2 */
      put_y_variable(6,0)
      put_y_value(5,1)
      call(Pred_Name(X6F5F6E657874,2),0,3,"o_next",2)          /* begin sub 3 */
      put_y_unsafe_value(6,0)
      put_y_value(5,1)
      put_y_unsafe_value(4,2)
      put_y_value(3,3)
      put_y_value(2,4)
      put_y_value(1,5)
      put_y_value(0,6)
      deallocate
      execute(Pred_Name(X246F72635F335F73616665,7),0,"$orc_3_safe",7)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "$orc_0_query"
#define PRED       X246F72635F305F7175657279
#define ARITY      4

Begin_Public_Pred
      switch_on_term(G_label(1),fail,G_label(1),fail,fail)

label(1)
      allocate(5)
      get_integer(1,0)
      get_y_variable(3,1)
      get_list(2)
      unify_integer(1)
      unify_y_variable(2)
      get_y_variable(1,3)
      put_y_variable(4,0)
      put_y_value(3,1)
      call(Pred_Name(X6F5F6E657874,2),0,1,"o_next",2)          /* begin sub 1 */
      put_y_value(4,0)
      put_y_value(3,1)
      put_y_value(2,2)
      put_y_value(1,3)
      put_integer(4,4)
      put_y_variable(0,5)
      call(Pred_Name(X246F72635F325F6765745F736F6C7574696F6E73,6),0,2,"$orc_2_get_solutions",6)          /* begin sub 2 */
      put_y_unsafe_value(0,0)
      deallocate
      execute(Pred_Name(X6F5F73656E645F736F6C6E,1),0,"o_send_soln",1)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY


Begin_Init_Tables(queens4)

 Define_Atom(X5B5D,"[]")
 Define_Atom(X6765745F736F6C7574696F6E73,"get_solutions")
 Define_Atom(X736F6C7665,"solve")
 Define_Atom(X737175617265,"square")
 Define_Atom(X6E6577737175617265,"newsquare")
 Define_Atom(X736E696E74,"snint")
 Define_Atom(X6E6F74746872656174656E6564,"notthreatened")
 Define_Atom(X73616665,"safe")
 Define_Atom(X7175657279,"query")
 Define_Atom(X246578655F31,"$exe_1")
 Define_Atom(X246578655F32,"$exe_2")
 Define_Atom(X74727565,"true")
 Define_Atom(X246F72635F325F6765745F736F6C7574696F6E73,"$orc_2_get_solutions")
 Define_Atom(X246F72635F335F736F6C7665,"$orc_3_solve")
 Define_Atom(X246F72635F335F6E6577737175617265,"$orc_3_newsquare")
 Define_Atom(X246F72635F325F736E696E74,"$orc_2_snint")
 Define_Atom(X246F72635F345F6E6F74746872656174656E6564,"$orc_4_notthreatened")
 Define_Atom(X246F72635F335F73616665,"$orc_3_safe")
 Define_Atom(X246F72635F305F7175657279,"$orc_0_query")


 Define_Pred(X6765745F736F6C7574696F6E73,2,0)

 Define_Pred(X736F6C7665,3,0)

 Define_Pred(X6E6577737175617265,3,0)

 Define_Pred(X736E696E74,2,0)

 Define_Pred(X6E6F74746872656174656E6564,4,0)

 Define_Pred(X73616665,3,0)

 Define_Pred(X7175657279,0,0)

 Define_Pred(X246578655F31,0,0)

 Define_Pred(X246578655F32,0,0)

 Define_Pred(X246F72635F325F6765745F736F6C7574696F6E73,6,0)

 Define_Pred(X246F72635F335F736F6C7665,7,0)

 Define_Pred(X246F72635F335F6E6577737175617265,7,0)

 Define_Pred(X246F72635F325F736E696E74,6,0)

 Define_Pred(X246F72635F345F6E6F74746872656174656E6564,8,0)

 Define_Pred(X246F72635F335F73616665,7,0)

 Define_Pred(X246F72635F305F7175657279,4,1)

 Init_Usr_File

End_Init_Tables


Begin_Exec_Directives(queens4)


 Exec_Directive(1,Pred_Name(X246578655F31,0))
 Exec_Directive(2,Pred_Name(X246578655F32,0))

End_Exec_Directives


/*** MAIN ***/

int main(int argc,char *argv[])

{
 unix_argc=argc;
 unix_argv=argv;


 Init_Wam_Engine();

 Init_Tables_Of_Module(Builtin)
 Init_Tables_Of_Module(o_utils)
 Init_Tables_Of_Module(queens4)

 Exec_Directives_Of_Module(Builtin)
 Exec_Directives_Of_Module(o_utils)
 Exec_Directives_Of_Module(queens4)

 Term_Wam_Engine();

 return 0;
}
