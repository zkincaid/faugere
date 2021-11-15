open Ctypes

open Bindings.B

include Bindings.Common

let z_to_mpz z : mpz_t = from_voidp mpz_struct (to_voidp (Zarith_bind.MPZ.of_z z))
let mpz_to_z (mpz : mpz_t ) : Z.t = Zarith_bind.MPZ.to_z (from_voidp Zarith_bind.MPZ.t (to_voidp mpz))


module type Fgb_opt = sig

  val set_max_output_size : int -> unit
  val set_index : int -> unit
  val set_fgb_verbosity : int -> unit
  val set_force_elim : int -> unit
  val set_number_of_threads : int -> unit

end


module Fgb_int_zarith = struct 
 include Make (struct
    let power_set = power_set_int
  
    type coef = Z.t
    type ccoef = mpz_t
    let ccoef = mpz_t
    let coef_to_c = z_to_mpz

    let ccoef_to_ml  = mpz_to_z

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
