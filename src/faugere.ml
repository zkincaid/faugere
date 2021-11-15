open Ctypes
open Bindings.B

include Bindings.Common

module type Fgb_opt = sig

  val set_max_output_size : int -> unit
  val set_index : int -> unit
  val set_fgb_verbosity : int -> unit
  val set_force_elim : int -> unit
  val set_number_of_threads : int -> unit

end

module Fgb_int_str = struct 
 include Make (struct
    let power_set = power_set_int
  
    type coef = string
    type ccoef = mpz_t
    let ccoef = mpz_t
    let coef_to_c s = 
      let res = CArray.start (CArray.make mpz_struct 1) in
      mpz_init_set_str res s 10;
      res

    let ccoef_to_ml mpz = 
      let buff = from_voidp char null in
      let res = mpz_get_str buff 10 mpz in
      res

    let set_coef = set_coeff_gmp_int
    let creat_poly = creat_poly_int
    let set_exp = set_expos2_int
    let sort_poly = full_sort_poly2_int
    let nb_terms = nb_terms_int
    let export_poly = export_poly_INT_gmp2_int
  end)

  let fgb polys block1 block2 = 
    saveptr_int ();         (* not sure if it's necessary to do this here.*)
    init_integers ();
    set_order block1 block2;
    threads_fgb !number_of_threads;
    let n_vars = List.length block1 + List.length block2 in
    let output_basis = allocate_n dpol ~count:!max_output_size in
    let n_input = List.length polys in
    let cpolys = List.map create_poly polys in
    let input_basis = CArray.start (CArray.of_list dpol cpolys) in
    let t0 = allocate_n double ~count:1 in
    let num_out = fgb_int input_basis (Unsigned.UInt32.of_int n_input) output_basis (Unsigned.UInt32.of_int !max_output_size) t0 (addr options) in
    let opolys = CArray.to_list (CArray.from_ptr output_basis (Unsigned.UInt32.to_int num_out)) in
    let res = List.map (export_poly n_vars) opolys in
    reset_memory_int (); (*not sure if these lines are necessary*)
    restoreptr_int ();
    res

end

module Fgb_mod = struct
  include Make (struct
    let power_set = power_set

    type coef = int
    type ccoef = int
    let ccoef = int
    let coef_to_c a = a

    let ccoef_to_ml a = a
    let set_coef = set_coeff_i32
    let creat_poly = creat_poly
    let set_exp = set_expos2
    let sort_poly = full_sort_poly2
    let nb_terms = nb_terms
    let export_poly nvars nmons cfs mons p = export_poly nvars nmons mons cfs p

  end)

  let fgb polys block1 block2 modulus = 
    saveptr ();         (* not sure if it's necessary to do this here.*)
    init_modp modulus;
    set_order block1 block2;
    threads_fgb !number_of_threads;
    let n_vars = List.length block1 + List.length block2 in
    let output_basis = allocate_n dpol ~count:!max_output_size in
    let n_input = List.length polys in
    let cpolys = List.map create_poly polys in
    let input_basis = CArray.start (CArray.of_list dpol cpolys) in
    let t0 = allocate_n double ~count:1 in
    let num_out = fgb input_basis (Unsigned.UInt32.of_int n_input) output_basis (Unsigned.UInt32.of_int !max_output_size) t0 (addr options) in
    let opolys = CArray.to_list (CArray.from_ptr output_basis (Unsigned.UInt32.to_int num_out)) in
    let res = List.map (export_poly n_vars) opolys in
    reset_memory (); (*not sure if these lines are necessary*)
    restoreptr ();
    res

end

