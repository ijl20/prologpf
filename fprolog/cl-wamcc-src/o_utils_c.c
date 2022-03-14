/****************************************************************************
PrologPF: A Parallel Functional Prolog Compiler    Cambridge University
Version 0.03                                       I.Lewis, D.Diaz(wamcc)-1997

File : o_utils_c.c
Main : no_main
****************************************************************************/

#define DEBUG_LEVEL    0

#include "wam_engine.h"

#include "o_utils_c.h"
#include "o_utils_c.usr"


#define ASCII_PRED "o_build"
#define PRED       X6F5F6275696C64
#define ARITY      1

Begin_Public_Pred
      try_me_else(1)
      pragma_c(o_build1)
      proceed

label(1)
      trust_me_else_fail
      pragma_c(o_build2)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_follow"
#define PRED       X6F5F666F6C6C6F77
#define ARITY      1

Begin_Public_Pred
      pragma_c(o_follow)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_set_l"
#define PRED       X6F5F7365745F6C
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_set_l)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_read_l"
#define PRED       X6F5F726561645F6C
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_read_l)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_set_g"
#define PRED       X6F5F7365745F67
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_set_g)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_read_g"
#define PRED       X6F5F726561645F67
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_read_g)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_set_n"
#define PRED       X6F5F7365745F6E
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_set_n)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_read_n"
#define PRED       X6F5F726561645F6E
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_read_n)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_read_s"
#define PRED       X6F5F726561645F73
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_read_s)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_init"
#define PRED       X6F5F696E6974
#define ARITY      0

Begin_Private_Pred
      pragma_c(o_init)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_set_current"
#define PRED       X6F5F7365745F63757272656E74
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_set_current)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_read_current"
#define PRED       X6F5F726561645F63757272656E74
#define ARITY      1

Begin_Private_Pred
      pragma_c(o_read_current)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_sol_count"
#define PRED       X6F5F736F6C5F636F756E74
#define ARITY      1

Begin_Private_Pred
      put_constant(X6F5F536F6C6E436F756E74,1,"o_SolnCount")
      builtin_2(g_read,1,0)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_read_orc"
#define PRED       X6F5F726561645F6F7263
#define ARITY      3

Begin_Private_Pred
      pragma_c(o_read_orc)
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_print_orcs"
#define PRED       X6F5F7072696E745F6F726373
#define ARITY      0

Begin_Private_Pred
      allocate(1)
      put_y_variable(0,0)
      call(Pred_Name(X6F5F726561645F73,1),1,1,"o_read_s",1)          /* begin sub 1 */
      put_integer(0,0)
      put_y_unsafe_value(0,1)
      deallocate
      execute(Pred_Name(X6F5F7072696E745F6F72637331,2),1,"o_print_orcs1",2)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_print_orcs1"
#define PRED       X6F5F7072696E745F6F72637331
#define ARITY      2

Begin_Private_Pred
      try_me_else(1)
      allocate(3)
      get_y_variable(2,0)
      get_y_variable(1,1)
      get_y_bc_reg(0)
      math_load_y_value(2,1)
      math_load_y_value(1,0)
      builtin_2(lt,1,0)
      put_y_value(2,0)
      call(Pred_Name(X6F5F7072696E745F6F7263,1),1,1,"o_print_orc",1)          /* begin sub 1 */
      math_load_y_value(2,0)
      function_1(inc,0,0)
      put_y_value(1,1)
      call(Pred_Name(X6F5F7072696E745F6F72637331,2),1,2,"o_print_orcs1",2)          /* begin sub 2 */
      cut_y(0)
      deallocate
      proceed

label(1)
      trust_me_else_fail
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_print_orc"
#define PRED       X6F5F7072696E745F6F7263
#define ARITY      1

Begin_Private_Pred
      allocate(3)
      get_y_variable(2,0)
      put_y_value(2,0)
      put_integer(0,1)
      put_y_variable(1,2)
      call(Pred_Name(X6F5F726561645F6F7263,3),1,1,"o_read_orc",3)          /* begin sub 1 */
      put_constant(X5B,0,"[")
      call(Pred_Name(X7772697465,1),0,2,"write",1)          /* begin sub 2 */
      put_y_value(2,0)
      put_integer(1,1)
      put_y_value(1,2)
      call(Pred_Name(X6F5F7072696E745F6F726331,3),1,3,"o_print_orc1",3)          /* begin sub 3 */
      put_y_value(2,0)
      put_y_value(1,1)
      put_y_variable(0,2)
      call(Pred_Name(X6F5F726561645F6F7263,3),1,4,"o_read_orc",3)          /* begin sub 4 */
      put_y_value(0,0)
      call(Pred_Name(X7772697465,1),0,5,"write",1)          /* begin sub 5 */
      put_constant(X5D,0,"]")
      call(Pred_Name(X7772697465,1),0,6,"write",1)          /* begin sub 6 */
      deallocate
      execute(Pred_Name(X6E6C,0),0,"nl",0)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_print_orc1"
#define PRED       X6F5F7072696E745F6F726331
#define ARITY      3

Begin_Private_Pred
      try_me_else(1)
      allocate(5)
      get_y_variable(2,0)
      get_y_variable(3,1)
      get_y_variable(1,2)
      get_y_bc_reg(0)
      math_load_y_value(3,1)
      math_load_y_value(1,0)
      builtin_2(lt,1,0)
      put_y_value(2,0)
      put_y_value(3,1)
      put_y_variable(4,2)
      call(Pred_Name(X6F5F726561645F6F7263,3),1,1,"o_read_orc",3)          /* begin sub 1 */
      put_y_value(4,0)
      call(Pred_Name(X7772697465,1),0,2,"write",1)          /* begin sub 2 */
      put_constant(X2C,0,",")
      call(Pred_Name(X7772697465,1),0,3,"write",1)          /* begin sub 3 */
      math_load_y_value(3,0)
      function_1(inc,1,0)
      put_y_value(2,0)
      put_y_value(1,2)
      call(Pred_Name(X6F5F7072696E745F6F726331,3),1,4,"o_print_orc1",3)          /* begin sub 4 */
      cut_y(0)
      deallocate
      proceed

label(1)
      trust_me_else_fail
      proceed

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_get_oracle"
#define PRED       X6F5F6765745F6F7261636C65
#define ARITY      0

Begin_Private_Pred
      try_me_else(1)
      allocate(2)
      put_y_variable(1,0)
      call(Pred_Name(X6F5F726561645F63757272656E74,1),1,1,"o_read_current",1)          /* begin sub 1 */
      put_y_variable(0,0)
      call(Pred_Name(X6F5F726561645F73,1),1,2,"o_read_s",1)          /* begin sub 2 */
      math_load_y_value(1,1)
      math_load_y_value(0,0)
      builtin_2(lt,1,0)
      deallocate
      proceed

label(1)
      trust_me_else_fail
      allocate(3)
      put_y_variable(1,0)
      call(Pred_Name(X6F5F726561645F63757272656E74,1),1,3,"o_read_current",1)          /* begin sub 3 */
      put_y_variable(2,0)
      call(Pred_Name(X6F5F726561645F73,1),1,4,"o_read_s",1)          /* begin sub 4 */
      math_load_y_value(1,1)
      math_load_y_value(2,0)
      builtin_2(lt,1,0)
      put_y_variable(0,0)
      call(Pred_Name(X6F5F726561645F67,1),1,5,"o_read_g",1)          /* begin sub 5 */
      math_load_y_value(1,1)
      math_load_y_value(0,0)
      function_2(add,0,1,0)
      call(Pred_Name(X6F5F7365745F63757272656E74,1),1,6,"o_set_current",1)          /* begin sub 6 */
      deallocate
      execute(Pred_Name(X6F5F6765745F6F7261636C65,0),1,"o_get_oracle",0)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_soln"
#define PRED       X6F5F736F6C6E
#define ARITY      1

Begin_Public_Pred
      allocate(1)
      get_y_variable(0,0)
      put_constant(X6F5F536F6C6E436F756E74,2,"o_SolnCount")
      put_x_variable(0,1)
      builtin_2(g_read,2,1)
      math_load_x_value(0,0)
      function_1(inc,0,0)
      put_constant(X6F5F536F6C6E436F756E74,1,"o_SolnCount")
      builtin_2(g_assign,1,0)
      put_constant(X64656C70686920736F6C7574696F6E20,0,"delphi solution ")
      call(Pred_Name(X7772697465,1),0,1,"write",1)          /* begin sub 1 */
      put_y_value(0,0)
      call(Pred_Name(X7772697465,1),0,2,"write",1)          /* begin sub 2 */
      deallocate
      execute(Pred_Name(X6E6C,0),0,"nl",0)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY



#define ASCII_PRED "o_bfp_c"
#define PRED       X6F5F6266705F63
#define ARITY      0

Begin_Public_Pred
      try_me_else(1)
      allocate(7)
      call(Pred_Name(X6F5F696E6974,0),1,1,"o_init",0)          /* begin sub 1 */
      put_constant(X6F5F536F6C6E436F756E74,1,"o_SolnCount")
      put_integer(0,0)
      builtin_2(g_assign,1,0)
      put_integer(1,0)
      put_y_variable(6,1)
      call(Pred_Name(X61726776,2),0,2,"argv",2)          /* begin sub 2 */
      put_y_variable(2,0)
      put_y_value(6,1)
      call(Pred_Name(X6E756D6265725F61746F6D,2),0,3,"number_atom",2)          /* begin sub 3 */
      put_y_value(2,0)
      call(Pred_Name(X6F5F7365745F67,1),1,4,"o_set_g",1)          /* begin sub 4 */
      put_integer(2,0)
      put_y_variable(5,1)
      call(Pred_Name(X61726776,2),0,5,"argv",2)          /* begin sub 5 */
      put_y_variable(3,0)
      put_y_value(5,1)
      call(Pred_Name(X6E756D6265725F61746F6D,2),0,6,"number_atom",2)          /* begin sub 6 */
      put_y_value(3,0)
      call(Pred_Name(X6F5F7365745F6E,1),1,7,"o_set_n",1)          /* begin sub 7 */
      put_integer(3,0)
      put_y_variable(4,1)
      call(Pred_Name(X61726776,2),0,8,"argv",2)          /* begin sub 8 */
      put_y_variable(1,0)
      put_y_value(4,1)
      call(Pred_Name(X6E756D6265725F61746F6D,2),0,9,"number_atom",2)          /* begin sub 9 */
      put_y_value(1,0)
      call(Pred_Name(X6F5F7365745F6C,1),1,10,"o_set_l",1)          /* begin sub 10 */
      put_constant(X64656C70686920626670207374617274656420,0,"delphi bfp started ")
      call(Pred_Name(X7772697465,1),0,11,"write",1)          /* begin sub 11 */
      put_y_value(3,0)
      call(Pred_Name(X7772697465,1),0,12,"write",1)          /* begin sub 12 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,13,"write",1)          /* begin sub 13 */
      put_y_value(2,0)
      call(Pred_Name(X7772697465,1),0,14,"write",1)          /* begin sub 14 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,15,"write",1)          /* begin sub 15 */
      put_y_value(1,0)
      call(Pred_Name(X7772697465,1),0,16,"write",1)          /* begin sub 16 */
      call(Pred_Name(X6E6C,0),0,17,"nl",0)          /* begin sub 17 */
      put_y_variable(0,0)
      call(Pred_Name(X63707574696D65,1),0,18,"cputime",1)          /* begin sub 18 */
      put_constant(X6F5F42467374617274,1,"o_BFstart")
      put_y_unsafe_value(0,0)
      builtin_2(g_assign,1,0)
      call(Pred_Name(X625F7175657279,0),0,19,"b_query",0)          /* begin sub 19 */
      fail

label(1)
      retry_me_else(2)
      allocate(10)
      put_y_variable(6,0)
      call(Pred_Name(X63707574696D65,1),0,20,"cputime",1)          /* begin sub 20 */
      put_integer(1,0)
      put_y_variable(9,1)
      call(Pred_Name(X61726776,2),0,21,"argv",2)          /* begin sub 21 */
      put_y_variable(5,0)
      put_y_value(9,1)
      call(Pred_Name(X6E756D6265725F61746F6D,2),0,22,"number_atom",2)          /* begin sub 22 */
      put_integer(2,0)
      put_y_variable(8,1)
      call(Pred_Name(X61726776,2),0,23,"argv",2)          /* begin sub 23 */
      put_y_variable(0,0)
      put_y_value(8,1)
      call(Pred_Name(X6E756D6265725F61746F6D,2),0,24,"number_atom",2)          /* begin sub 24 */
      put_integer(3,0)
      put_y_variable(7,1)
      call(Pred_Name(X61726776,2),0,25,"argv",2)          /* begin sub 25 */
      put_y_variable(4,0)
      put_y_value(7,1)
      call(Pred_Name(X6E756D6265725F61746F6D,2),0,26,"number_atom",2)          /* begin sub 26 */
      put_integer(10000,0)
      call(Pred_Name(X6F5F7365745F6C,1),1,27,"o_set_l",1)          /* begin sub 27 */
      put_y_variable(3,0)
      call(Pred_Name(X6F5F726561645F73,1),1,28,"o_read_s",1)          /* begin sub 28 */
      put_constant(X6F5F42467374617274,2,"o_BFstart")
      put_x_variable(0,1)
      builtin_2(g_read,2,1)
      math_load_y_value(6,1)
      math_load_x_value(0,0)
      function_2(sub,0,1,0)
      get_y_variable(2,0)
      put_constant(X6F5F424674696D65,1,"o_BFtime")
      put_y_unsafe_value(2,0)
      builtin_2(g_assign,1,0)
      put_constant(X64656C70686920626670206F7261636C657320,0,"delphi bfp oracles ")
      call(Pred_Name(X7772697465,1),0,29,"write",1)          /* begin sub 29 */
      put_y_value(0,0)
      call(Pred_Name(X7772697465,1),0,30,"write",1)          /* begin sub 30 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,31,"write",1)          /* begin sub 31 */
      put_y_value(5,0)
      call(Pred_Name(X7772697465,1),0,32,"write",1)          /* begin sub 32 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,33,"write",1)          /* begin sub 33 */
      put_y_value(4,0)
      call(Pred_Name(X7772697465,1),0,34,"write",1)          /* begin sub 34 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,35,"write",1)          /* begin sub 35 */
      put_y_value(3,0)
      call(Pred_Name(X7772697465,1),0,36,"write",1)          /* begin sub 36 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,37,"write",1)          /* begin sub 37 */
      put_y_value(2,0)
      call(Pred_Name(X7772697465,1),0,38,"write",1)          /* begin sub 38 */
      call(Pred_Name(X6E6C,0),0,39,"nl",0)          /* begin sub 39 */
      put_y_variable(1,0)
      call(Pred_Name(X63707574696D65,1),0,40,"cputime",1)          /* begin sub 40 */
      put_constant(X6F5F4674696D65,1,"o_Ftime")
      put_y_unsafe_value(1,0)
      builtin_2(g_assign,1,0)
      put_y_value(0,0)
      call(Pred_Name(X6F5F7365745F63757272656E74,1),1,41,"o_set_current",1)          /* begin sub 41 */
      call(Pred_Name(X6F5F6765745F6F7261636C65,0),1,42,"o_get_oracle",0)          /* begin sub 42 */
      call(Pred_Name(X665F7175657279,0),0,43,"f_query",0)          /* begin sub 43 */
      fail

label(2)
      trust_me_else_fail
      allocate(9)
      put_y_variable(8,0)
      call(Pred_Name(X63707574696D65,1),0,44,"cputime",1)          /* begin sub 44 */
      put_constant(X6F5F4674696D65,2,"o_Ftime")
      put_x_variable(0,1)
      builtin_2(g_read,2,1)
      math_load_y_value(8,1)
      math_load_x_value(0,0)
      function_2(sub,0,1,0)
      get_y_variable(1,0)
      put_integer(1,0)
      put_y_variable(6,1)
      call(Pred_Name(X61726776,2),0,45,"argv",2)          /* begin sub 45 */
      put_integer(2,0)
      put_y_variable(7,1)
      call(Pred_Name(X61726776,2),0,46,"argv",2)          /* begin sub 46 */
      put_integer(3,0)
      put_y_variable(5,1)
      call(Pred_Name(X61726776,2),0,47,"argv",2)          /* begin sub 47 */
      put_y_variable(4,0)
      call(Pred_Name(X6F5F726561645F73,1),1,48,"o_read_s",1)          /* begin sub 48 */
      put_y_variable(3,0)
      call(Pred_Name(X6F5F736F6C5F636F756E74,1),1,49,"o_sol_count",1)          /* begin sub 49 */
      put_constant(X6F5F424674696D65,1,"o_BFtime")
      put_y_variable(2,0)
      builtin_2(g_read,1,0)
      math_load_y_value(2,1)
      math_load_y_value(1,0)
      function_2(add,0,1,0)
      get_y_variable(0,0)
      put_constant(X64656C7068692062667020636F6D706C6574656420,0,"delphi bfp completed ")
      call(Pred_Name(X7772697465,1),0,50,"write",1)          /* begin sub 50 */
      put_y_value(7,0)
      call(Pred_Name(X7772697465,1),0,51,"write",1)          /* begin sub 51 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,52,"write",1)          /* begin sub 52 */
      put_y_value(6,0)
      call(Pred_Name(X7772697465,1),0,53,"write",1)          /* begin sub 53 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,54,"write",1)          /* begin sub 54 */
      put_y_value(5,0)
      call(Pred_Name(X7772697465,1),0,55,"write",1)          /* begin sub 55 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,56,"write",1)          /* begin sub 56 */
      put_y_value(4,0)
      call(Pred_Name(X7772697465,1),0,57,"write",1)          /* begin sub 57 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,58,"write",1)          /* begin sub 58 */
      put_y_value(3,0)
      call(Pred_Name(X7772697465,1),0,59,"write",1)          /* begin sub 59 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,60,"write",1)          /* begin sub 60 */
      put_y_value(2,0)
      call(Pred_Name(X7772697465,1),0,61,"write",1)          /* begin sub 61 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,62,"write",1)          /* begin sub 62 */
      put_y_value(1,0)
      call(Pred_Name(X7772697465,1),0,63,"write",1)          /* begin sub 63 */
      put_constant(X20,0," ")
      call(Pred_Name(X7772697465,1),0,64,"write",1)          /* begin sub 64 */
      put_y_value(0,0)
      call(Pred_Name(X7772697465,1),0,65,"write",1)          /* begin sub 65 */
      call(Pred_Name(X6E6C,0),0,66,"nl",0)          /* begin sub 66 */
      deallocate
      execute(Pred_Name(X68616C74,0),0,"halt",0)

End_Pred

#undef ASCII_PRED
#undef PRED
#undef ARITY


Begin_Init_Tables(o_utils_c)

 Define_Atom(X5B5D,"[]")
 Define_Atom(X6F5F6275696C64,"o_build")
 Define_Atom(X6F5F666F6C6C6F77,"o_follow")
 Define_Atom(X6F5F7365745F6C,"o_set_l")
 Define_Atom(X6F5F726561645F6C,"o_read_l")
 Define_Atom(X6F5F7365745F67,"o_set_g")
 Define_Atom(X6F5F726561645F67,"o_read_g")
 Define_Atom(X6F5F7365745F6E,"o_set_n")
 Define_Atom(X6F5F726561645F6E,"o_read_n")
 Define_Atom(X6F5F726561645F73,"o_read_s")
 Define_Atom(X6F5F696E6974,"o_init")
 Define_Atom(X6F5F7365745F63757272656E74,"o_set_current")
 Define_Atom(X6F5F726561645F63757272656E74,"o_read_current")
 Define_Atom(X6F5F736F6C5F636F756E74,"o_sol_count")
 Define_Atom(X6F5F536F6C6E436F756E74,"o_SolnCount")
 Define_Atom(X6F5F726561645F6F7263,"o_read_orc")
 Define_Atom(X6F5F7072696E745F6F726373,"o_print_orcs")
 Define_Atom(X6F5F7072696E745F6F72637331,"o_print_orcs1")
 Define_Atom(X6F5F7072696E745F6F7263,"o_print_orc")
 Define_Atom(X5B,"[")
 Define_Atom(X5D,"]")
 Define_Atom(X6F5F7072696E745F6F726331,"o_print_orc1")
 Define_Atom(X2C,",")
 Define_Atom(X6F5F6765745F6F7261636C65,"o_get_oracle")
 Define_Atom(X6F5F736F6C6E,"o_soln")
 Define_Atom(X64656C70686920736F6C7574696F6E20,"delphi solution ")
 Define_Atom(X6F5F6266705F63,"o_bfp_c")
 Define_Atom(X64656C70686920626670207374617274656420,"delphi bfp started ")
 Define_Atom(X20," ")
 Define_Atom(X6F5F42467374617274,"o_BFstart")
 Define_Atom(X6F5F424674696D65,"o_BFtime")
 Define_Atom(X64656C70686920626670206F7261636C657320,"delphi bfp oracles ")
 Define_Atom(X6F5F4674696D65,"o_Ftime")
 Define_Atom(X64656C7068692062667020636F6D706C6574656420,"delphi bfp completed ")


 Define_Pred(X6F5F6275696C64,1,1)

 Define_Pred(X6F5F666F6C6C6F77,1,1)

 Define_Pred(X6F5F7365745F6C,1,0)

 Define_Pred(X6F5F726561645F6C,1,0)

 Define_Pred(X6F5F7365745F67,1,0)

 Define_Pred(X6F5F726561645F67,1,0)

 Define_Pred(X6F5F7365745F6E,1,0)

 Define_Pred(X6F5F726561645F6E,1,0)

 Define_Pred(X6F5F726561645F73,1,0)

 Define_Pred(X6F5F696E6974,0,0)

 Define_Pred(X6F5F7365745F63757272656E74,1,0)

 Define_Pred(X6F5F726561645F63757272656E74,1,0)

 Define_Pred(X6F5F736F6C5F636F756E74,1,0)

 Define_Pred(X6F5F726561645F6F7263,3,0)

 Define_Pred(X6F5F7072696E745F6F726373,0,0)

 Define_Pred(X6F5F7072696E745F6F72637331,2,0)

 Define_Pred(X6F5F7072696E745F6F7263,1,0)

 Define_Pred(X6F5F7072696E745F6F726331,3,0)

 Define_Pred(X6F5F6765745F6F7261636C65,0,0)

 Define_Pred(X6F5F736F6C6E,1,1)

 Define_Pred(X6F5F6266705F63,0,1)

 Init_Usr_File

End_Init_Tables


Begin_Exec_Directives(o_utils_c)



End_Exec_Directives
