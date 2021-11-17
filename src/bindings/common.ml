open Ctypes

open B

type cpoly = unit ptr

type fmonic = int list

type 'a fmon = 'a * fmonic

type 'a fpoly = Sum of 'a fmon list


module Make (A : sig
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
                  end ) = struct

  let max_output_size = ref 100000

  let set_max_output_size size = max_output_size := size

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

  let set_index size = 
    setf (getf options env) index (Unsigned.UInt32.of_int size)

  let set_fgb_verbosity v = 
    setf options verb v

  let set_force_elim flag = 
    setf (getf options env) force_elim flag

  let number_of_threads = ref 1

  let set_number_of_threads t = number_of_threads := t

  let set_order (block1 : string list) (block2 : string list) : unit = 
    let n_vars_block1 = Unsigned.UInt32.of_int (List.length block1) in
    let n_vars_block2 = Unsigned.UInt32.of_int (List.length block2) in
    A.power_set n_vars_block1 n_vars_block2 (CArray.start (CArray.of_list string (block1 @ block2)))
    
  let create_poly ((Sum mon_list) : A.coef fpoly) : cpoly = 
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

end

module type Fgb_opt = sig

  val set_max_output_size : int -> unit
  val set_index : int -> unit
  val set_fgb_verbosity : int -> unit
  val set_force_elim : int -> unit
  val set_number_of_threads : int -> unit

end

module type Poly = sig
  type fmonic = int list

  type 'a fmon = 'a * fmonic

  type 'a fpoly = Sum of 'a fmon list
end