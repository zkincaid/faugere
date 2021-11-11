open Ctypes

include Bind.Bindings(Stub)

type monic = Prod of (string * int) list

type mon = string * monic

type poly = Sum of mon list

type ipoly = unit ptr

let monic_mon_to_string (Prod ms) = 
  let var_exp_to_string (v, e) = 
    if e = 1 then v
    else v ^ "^" ^ (string_of_int e)
  in
  String.concat "" (List.map var_exp_to_string ms)

let mon_to_string (c, Prod m) =
  if m = [] then c
  else if c = "1" then (monic_mon_to_string (Prod m))
  else (c) ^ (monic_mon_to_string (Prod m)) 

let to_string (Sum p) = 
  String.concat " + " (List.map mon_to_string p)

let variables = ref []
let nb_vars = ref 0

let power_set_int vars = 
  let nb_vars = List.length vars in
  let vars_carray = CArray.of_list string vars in
  power_set_int (Unsigned.UInt32.of_int nb_vars) (Unsigned.UInt32.of_int 0) (CArray.start vars_carray)

let init vars = 
  nb_vars := List.length vars;
  variables := vars;
  saveptr_int ();
  init_integers ();
  power_set_int !variables;
  threads_fgb 1

let compare_vars (v1, _) (v2, _) = 
  if v1 = v2 then 0
  else if List.find (fun x -> x = v1 || x = v2) !variables = v1 then -1
  else 1

let monic_to_e_list (Prod ml) = 
  let sorted = List.sort compare_vars ml in
  let rec aux acc vlist monlist = 
    match (vlist, monlist) with
    | [], [] -> List.rev acc
    | _ :: vlistr, [] -> aux (0 :: acc) vlistr monlist
    | [], _ :: _ -> failwith "monomial with var that wasn't inititialized with"
    | v :: vlistr, (mv, me) :: monlistr ->
      if mv = v then aux (me :: acc) vlistr monlistr
      else aux (0 :: acc) vlistr monlist
  in
  aux [] !variables sorted

let create_poly (Sum mon_list) : ipoly =
  let nm = List.length mon_list in
  let p = creat_poly_int (Unsigned.UInt32.of_int nm) in
  let iterator i (coef, monic) = 
    let e = monic_to_e_list monic in
    set_expos2_int p (Unsigned.UInt32.of_int i) (CArray.start (CArray.of_list int e)) (Unsigned.UInt32.of_int !nb_vars);
    let coefmpz : mpz_t = CArray.start (CArray.make mpz_struct 1) in
    mpz_init_set_str coefmpz coef 10;
    set_coeff_gmp_int p (Unsigned.UInt32.of_int i) coefmpz;
  in
  List.iteri iterator mon_list;
  full_sort_poly2_int p;
  p
    
let set_default_options () =
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

let mpz_to_string (mpz : mpz_t) : string = 
  let buff = from_voidp char null in
  let res = mpz_get_str buff 10 mpz in
  res
  

let export_poly (poly : ipoly) = 
  let nb_mons = Unsigned.UInt32.to_int (nb_terms_int poly) in
  let nb_vars = List.length !variables in
  let mons = allocate_n i32 ~count:(nb_mons * nb_vars) in
  let cfs = allocate_n mpz_ptr ~count:nb_mons in
  let _ = export_poly_INT_gmp2_int nb_vars nb_mons cfs mons poly in
  let mons_arr = CArray.from_ptr mons (nb_mons * nb_vars) in
  let mons_arr_to_exp_list (acc, curr_mon) exp = 
    if List.length curr_mon = nb_vars then ((List.rev curr_mon) :: acc, [exp])
    else (acc, exp :: curr_mon)
  in
  let exp, last = CArray.fold_left mons_arr_to_exp_list ([], []) mons_arr in
  let exp_list = List.rev ((List.rev last) :: exp) in
  let cfs_list = CArray.to_list (CArray.from_ptr cfs nb_mons) in
  let mapper cf exp = 
    let exp_list_to_monic i e = (List.nth !variables i, e) in
    let monic_mon = List.filter (fun (_, e) -> e > 0) (List.mapi exp_list_to_monic exp) in
    (mpz_to_string cf, Prod monic_mon)
  in
  let epoly = List.map2 mapper cfs_list exp_list in
  Sum epoly
      


let fgb polys = 
  let output_basis = allocate_n dpol ~count:100000 in
  let n_input = List.length polys in
  let input_basis = CArray.start (CArray.of_list dpol polys) in
  let t0 = allocate_n double ~count:1 in
  let num_out = fgb_int input_basis (Unsigned.UInt32.of_int n_input) output_basis (Unsigned.UInt32.of_int 100000) t0 (addr (set_default_options ())) in
  let opolys = CArray.to_list (CArray.from_ptr output_basis (Unsigned.UInt32.to_int num_out)) in
  let res = List.map export_poly opolys in
  reset_memory_int (); (*not sure if these lines are necessary*)
  restoreptr_int ();
  res