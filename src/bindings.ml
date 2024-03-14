(**This module contains a functor which when provided with a stub.ml file will contatin all of the bindings to the fgb libraries. 
   It is not meant to be used by users. *)

open Ctypes


module Bindings (F : FOREIGN) = struct
  open F
 
  let expos = typedef (ptr void) "Expos"

  let dpol = typedef (ptr void) "Dpol"

  let dpol_int = typedef dpol "Dpol_INT"

  let ui32 = uint32_t

  let i32 = int

  let mp_limb_t = ptr uint

  type mpz_struct
  let mpz_struct : mpz_struct structure typ = structure "__mpz_struct"
  let mp_alloc = field mpz_struct "_mp_alloc" int
  let mp_size = field mpz_struct "_mp_size" int
  let mp_d = field mpz_struct "_mp_d" (ptr mp_limb_t)
  let () = seal mpz_struct

  type mpz_t = mpz_struct structure ptr
  let mpz_t : mpz_t typ = ptr mpz_struct (* Not very safe *)
  type mpz_ptr = mpz_struct structure ptr
  let mpz_ptr : mpz_ptr typ = ptr mpz_struct
  type mpz_srcptr = mpz_struct structure ptr
  let mpz_srcptr : mpz_srcptr typ = ptr mpz_struct
  (*let mpz_ptr = typedef (ptr mpz_struct) "mpz_ptr"*)
 
  
  let mpz_init_set_str = foreign "mpz_init_set_str" (mpz_t @-> string @-> int @-> returning void)
  let mpz_get_str = foreign "mpz_get_str" (ptr char @-> int @-> mpz_srcptr @-> returning string)

  let mpz_import = foreign "mpz_import" (mpz_ptr @-> PosixTypes.size_t @-> int @-> PosixTypes.size_t @-> int @-> PosixTypes.size_t @-> ptr void @-> returning void)
  let mpz_export = foreign "mpz_export" (ptr void @-> ptr PosixTypes.size_t @-> int @-> PosixTypes.size_t @-> int @-> PosixTypes.size_t @-> mpz_srcptr @-> returning (ptr void))

  type sfgb_comp_desc
  let sfgb_comp_desc : sfgb_comp_desc structure typ = structure "SFGB_Comp_Desc"
  let compute = field sfgb_comp_desc "_compute" i32
  let nb = field sfgb_comp_desc "_nb" i32
  let force_elim = field sfgb_comp_desc "_force_elim" i32
  let off = field sfgb_comp_desc "_off" ui32
  let index = field sfgb_comp_desc "_index" ui32
  let zone = field sfgb_comp_desc "_zone" ui32
  let memory = field sfgb_comp_desc "_memory" ui32
  let nb2 = field sfgb_comp_desc "_nb2" i32
  let force_elim2 = field sfgb_comp_desc "_force_elim2" i32
  let bk2 = field sfgb_comp_desc "_bk2" ui32
  let aggressive2 = field sfgb_comp_desc "_aggressive2" i32
  let dlim = field sfgb_comp_desc "_dlim" i32
  let skip = field sfgb_comp_desc "_skip" i32
  let () = seal sfgb_comp_desc

  let fgb_comp_desc = ptr sfgb_comp_desc

  type sfgb_options
  let sfgb_options : sfgb_options structure typ = structure "SFGB_Options"
  let env = field sfgb_options "_env" sfgb_comp_desc
  let mini = field sfgb_options "_mini" bool
  let elim = field sfgb_options "_elim" ui32
  let bk0 = field sfgb_options "_bk0" ui32
  let step0 = field sfgb_options "_step0" ui32
  let elim0 = field sfgb_options "_elim0" bool
  let verb = field sfgb_options "_verb" i32
  let () = seal sfgb_options

  let fgb_options = ptr sfgb_options

  let threads_fgb = foreign "threads_FGb" (int @-> returning void)

  (*----------------------------------Integer functions----------------------------------*)

  let reset_memory_int = foreign "FGb_int_reset_memory" (void @-> returning void)

  let alloc_int = foreign "FGb_int_alloc" (ui32 @-> returning string)

  let init_urgent_int = foreign "FGb_int_init_urgent" (ui32 @-> ui32 @-> string @-> ui32 @-> bool @-> returning void)

  (*let init = foreign "FGb_int_init" (bool @-> bool @-> bool @-> FILE)*)

  let creat_poly_int = foreign "FGb_int_creat_poly" (ui32 @-> returning dpol)

  let assign_expos_int = foreign "FGb_int_assign_expos" (ptr i32 @-> i32 @-> returning expos)

  let reset_expos_int = foreign "FGb_int_reset_expos" (ui32 @-> ui32 @-> ptr string @-> returning void)

  let reset_coeffs_int = foreign "FGb_int_reset_coeffs" (ui32 @-> returning void)

  let set_coeff_raw_int = foreign "FGb_int_set_coeff_raw" (dpol @-> ui32 @-> ptr ui32 @-> ui32 @-> returning void)

  let enter_INT = foreign "FGb_int_enter_INT" (void @-> returning void)

  let exit_INT = foreign "FGb_int_exit_INT" (void @-> returning void)

  let set_coeff_gmp_int = foreign "FGb_int_set_coeff_gmp" (dpol_int @-> ui32 @-> mpz_t @-> returning void)

  let export_poly_INT_gmp_int = foreign "FGb_int_export_poly_INT_gmp" (i32 @-> i32 @-> ptr i32 @-> dpol_int @-> returning (ptr mpz_t))

  let export_poly_INT_gmp2_int = foreign "FGb_int_export_poly_INT_gmp2" (i32 @-> i32 @-> ptr mpz_ptr @-> ptr i32 @-> dpol_int @-> returning int)

  let groebner_int = foreign "FGb_int_groebner" (ptr dpol @-> ui32 @-> ptr dpol @-> bool @-> ui32 @-> ptr double @-> ui32 @-> ui32 @-> bool @-> fgb_comp_desc @-> returning ui32)

  let hilbert_int = foreign "FGb_int_hilbert" (ptr dpol @-> ui32 @-> ptr dpol @-> bool @-> ui32 @-> ptr double @-> ui32 @-> ui32 @-> bool @-> returning ui32)

  let nb_terms_int = foreign "FGb_int_nb_terms" (dpol @-> returning ui32)

  let set_expos2_int = foreign "FGb_int_set_expos2" (dpol @-> ui32 @-> ptr i32 @-> ui32 @-> returning void)
  
  let full_sort_poly2_int = foreign "FGb_int_full_sort_poly2" (dpol @-> returning void)

  let export_poly_INT_int = foreign "FGb_int_export_poly_INT" (i32 @-> i32 @-> ptr i32 @-> ptr ui32 @-> ptr ui32 @-> dpol @-> ptr ui32 @-> returning i32)

  let saveptr_int = enter_INT

  let restoreptr_int = exit_INT

  let init_integers = foreign "init_FGb_Integers" (void @-> returning void)

  let power_set_int = foreign "FGb_int_PowerSet" (ui32 @-> ui32 @-> ptr string @-> returning void)
  
  let fgb_int = foreign "FGb_int_fgb" (ptr dpol @-> ui32 @-> ptr dpol @-> ui32 @-> ptr double @-> fgb_options @-> returning ui32)


  (*--------------------------------------------------Modular functions------------------------------------------*)

  let reset_memory = foreign "FGb_reset_memory" (void @-> returning void)

  let alloc = foreign "FGb_alloc" (ui32 @-> returning string)

  let init_urgent = foreign "FGb_init_urgent" (ui32 @-> ui32 @-> string @-> ui32 @-> bool @-> returning void)

  (*let init = foreign "FGb_int_init" (bool @-> bool @-> bool @-> FILE)*)

  let creat_poly = foreign "FGb_creat_poly" (ui32 @-> returning dpol)

  let assign_expos = foreign "FGb_assign_expos" (ptr i32 @-> i32 @-> returning expos)

  let reset_expos = foreign "FGb_reset_expos" (ui32 @-> ui32 @-> ptr string @-> returning void)

  let reset_coeffs = foreign "FGb_reset_coeffs" (ui32 @-> ptr ui32 @-> returning void)

  let set_coeff_i32 = foreign "FGb_set_coeff_I32" (dpol @-> ui32 @-> i32 @-> returning void)

  let set_expos_d = foreign "FGb_set_expos_d" (dpol @-> ui32 @-> expos @-> returning void)

  let full_sort_poly = foreign "FGb_full_sort_poly" (dpol @-> returning void)

  let export_poly = foreign "FGb_export_poly" (i32 @-> i32 @-> ptr i32 @-> ptr i32 @-> dpol @-> returning i32)

  let groebner = foreign "FGb_groebner" (ptr dpol @-> ui32 @-> ptr dpol @-> bool @-> ui32 @-> ptr double @-> ui32 @-> ui32 @-> bool @-> fgb_comp_desc @-> returning ui32)

  let hilbert = foreign "FGb_hilbert" (ptr dpol @-> ui32 @-> ptr dpol @-> bool @-> ui32 @-> ptr double @-> ui32 @-> ui32 @-> bool @-> returning ui32)

  let nb_terms = foreign "FGb_nb_terms" (dpol @-> returning ui32)

  let set_expos2 = foreign "FGb_set_expos2" (dpol @-> ui32 @-> ptr i32 @-> ui32 @-> returning void)
  
  let full_sort_poly2 = foreign "FGb_full_sort_poly2" (dpol @-> returning void)

  (*let export_poly_INT = foreign "FGb_export_poly_INT" (i32 @-> i32 @-> ptr i32 @-> ptr ui32 @-> ptr ui32 @-> dpol @-> ptr ui32 @-> returning i32)*)

  let saveptr () = ()

  let restoreptr () = ()

  let init_modp = foreign "init_FGb_Modp" (int @-> returning void)

  let power_set = foreign "FGb_PowerSet" (ui32 @-> ui32 @-> ptr string @-> returning void)
  
  let fgb = foreign "FGb_fgb" (ptr dpol @-> ui32 @-> ptr dpol @-> ui32 @-> ptr double @-> fgb_options @-> returning ui32)


end