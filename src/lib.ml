open Ctypes

include Bind.Bindings(Stub)

type cpoly = unit ptr

type fmonic = int list

type 'a fmon = 'a * fmonic

type 'a fpoly = Sum of 'a fmon list

module Common (A : sig
                    val saveptr : unit -> unit
                    val init_coef : unit -> unit
                    val power_set : Unsigned.UInt32.t -> Unsigned.UInt32.t -> string ptr -> unit

                    type coef
                    type ccoef
                    val ccoef : ccoef typ 
                    val coef_to_c : coef -> ccoef
                    val ccoef_to_ml : ccoef -> coef
                    val set_coef : cpoly -> Unsigned.UInt32.t -> ccoef -> unit
                    val creat_poly : Unsigned.UInt32.t -> cpoly
                    val set_exp : cpoly -> Unsigned.UInt32.t -> int ptr -> Unsigned.UInt32.t -> unit
                    val sort_poly : cpoly -> unit

                    val nb_terms : cpoly -> Unsigned.UInt32.t
                    val export_poly : int -> int -> ccoef ptr -> int ptr -> cpoly -> int

                    val fgb : cpoly ptr -> Unsigned.UInt32.t -> cpoly ptr -> Unsigned.UInt32.t -> float ptr -> sfgb_options structure ptr -> Unsigned.UInt32.t
                    val reset_memory : unit -> unit
                    val restoreptr : unit -> unit
                  end ) = struct

  let options =
    let opt = make sfgb_options in 
    let fgb_comp_des = make sfgb_comp_desc in
    setf fgb_comp_des compute 1;
    setf fgb_comp_des nb 0;
    setf fgb_comp_des force_elim 0;
    setf fgb_comp_des off (Unsigned.UInt32.of_int 0);
    setf fgb_comp_des index (Unsigned.UInt32.of_int 500000);
    setf fgb_comp_des zone (Unsigned.UInt32.of_int 0);
    setf fgb_comp_des memory (Unsigned.UInt32.of_int 0);

    setf opt mini true;
    setf opt elim (Unsigned.UInt32.of_int 0);
    setf opt bk0 (Unsigned.UInt32.of_int 0);
    setf opt step0 (Unsigned.UInt32.of_int (-1));
    setf opt elim0 false;
    setf opt verb 0;
    setf opt env fgb_comp_des;
    opt

  let power_set block1 block2 = 
    let n_vars_block1 = Unsigned.UInt32.of_int (List.length block1) in
    let n_vars_block2 = Unsigned.UInt32.of_int (List.length block2) in
    A.power_set n_vars_block1 n_vars_block2 (CArray.start (CArray.of_list string (block1 @ block2)))
    

  let init block1 block2 =
    A.saveptr ();         (* not sure if it's necessary to do this here.*)
    A.init_coef ();
    power_set block1 block2;
    threads_fgb 1

  let create_poly (Sum mon_list) : cpoly = 
    let nm = List.length mon_list in
    let p = A.creat_poly (Unsigned.UInt32.of_int nm) in
    let iterator i (coef, e) = 
      A.set_exp p (Unsigned.UInt32.of_int i) (CArray.start (CArray.of_list int e)) (Unsigned.UInt32.of_int (List.length e));
      A.set_coef p (Unsigned.UInt32.of_int i) (A.coef_to_c coef);
    in
    List.iteri iterator mon_list;
    A.sort_poly p;
    p
    
  let export_poly nb_vars (poly : cpoly) = 
    let nb_mons = Unsigned.UInt32.to_int (A.nb_terms poly) in
    let mons = allocate_n i32 ~count:(nb_mons * nb_vars) in
    let cfs = allocate_n A.ccoef ~count:nb_mons in
    let _ = A.export_poly nb_vars nb_mons cfs mons poly in
    let mons_arr = CArray.from_ptr mons (nb_mons * nb_vars) in
    let mons_arr_to_exp_list (acc, curr_mon) exp = 
      if List.length curr_mon = nb_vars then ((List.rev curr_mon) :: acc, [exp])
      else (acc, exp :: curr_mon)
    in
    let exp, last = CArray.fold_left mons_arr_to_exp_list ([], []) mons_arr in
    let exp_list = List.rev ((List.rev last) :: exp) in
    let cfs_list = CArray.to_list (CArray.from_ptr cfs nb_mons) in
    let mapper cf exp =
      (A.ccoef_to_ml cf, exp)
    in
    let epoly = List.map2 mapper cfs_list exp_list in
    Sum epoly

  let fgb polys block1 block2 = 
    init block1 block2;
    let n_vars = List.length block1 + List.length block2 in
    let output_basis = allocate_n dpol ~count:100000 in
    let n_input = List.length polys in
    let cpolys = List.map create_poly polys in
    let input_basis = CArray.start (CArray.of_list dpol cpolys) in
    let t0 = allocate_n double ~count:1 in
    let num_out = A.fgb input_basis (Unsigned.UInt32.of_int n_input) output_basis (Unsigned.UInt32.of_int 100000) t0 (addr options) in
    let opolys = CArray.to_list (CArray.from_ptr output_basis (Unsigned.UInt32.to_int num_out)) in
    let res = List.map (export_poly n_vars) opolys in
    A.reset_memory (); (*not sure if these lines are necessary*)
    A.restoreptr ();
    res

end
   
  
module Fgb_int = Common
(struct
  let saveptr = saveptr_int
  let init_coef = init_integers
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
  let fgb = fgb_int

  let reset_memory = reset_memory_int
  let restoreptr = restoreptr_int
end)

module Fgb_mod = Common
(struct
  let saveptr = saveptr
  let init_coef () = init_modp 65521
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
  let fgb = fgb

  let reset_memory = reset_memory
  let restoreptr = restoreptr

end)