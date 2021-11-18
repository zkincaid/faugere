open Faugere

(*This file gives an example of using the zarith version of fgb. *)

(*These types are used to represent polynomials just within this file. *)
type monic = Prod of (string * int) list

type mon = string * monic

type poly = Sum of mon list

(*These functions translate the polynomials used in this file to strings.*)
let monic_mon_to_string (Prod ms) = 
  let var_exp_to_string (v, e) = 
    if e = 1 then v
    else v ^ "^" ^ (string_of_int e)
  in
  String.concat "" (List.map var_exp_to_string ms)

let mon_to_string (c, Prod m) =
  if m = [] then (c)
  else if compare c "1" = 0 then (monic_mon_to_string (Prod m))
  else (c) ^ (monic_mon_to_string (Prod m)) 

let to_string (Sum p) = 
  String.concat " + " (List.map mon_to_string p)

(* The variables to be considered for this example. *)
let variables = ["x1"; "x2"; "x3"]

(* Translates a Faugere polynomial to an Example.poly.*)
let libpoly_to_poly (mons) = 
  let mapper (c, e) = 
    let zipped = List.map2 (fun v ex -> (v, ex)) variables e in
    c, Prod (List.filter (fun (_, ex) -> ex > 0) zipped)
  in
  Sum (List.map mapper mons)

let index_of v l = 
  let rec aux curr_i rest = 
    match rest with
    | [] -> -1
    | x :: xs -> 
      if x = v then curr_i
      else aux (curr_i + 1) xs
  in
  aux 0 l

let poly_to_libpoly (Sum mons) = 
  let mon_to_libmon (z, Prod monics) =
    let folder acc var = 
      if List.mem var (fst (List.split acc)) then acc
      else (var, 0) :: acc
    in
    let added_vars = List.fold_left folder monics variables in
    let indsexps = List.map (fun (v, e) -> (index_of v variables, e)) added_vars in
    let indsexpssorted = List.sort (fun (i, _) (ip, _) -> compare i ip) indsexps in
    z, snd (List.split indsexpssorted)
  in
  List.map mon_to_libmon mons
    


let () = 
  let p1 = Sum [("1", Prod[("x1", 1); ("x2", 2)]); ("2", Prod[("x2", 1); ("x3", 1)])] in 
  let p2 = Sum [("1", Prod[("x1", 1); ("x3", 2)]); ("2", Prod[])] in
  print_endline "Input polynomials";
  print_endline (String.concat "\n" (List.map to_string [p1; p2]));
  let fpolys = List.map poly_to_libpoly [p1; p2] in
  let gb = Fgb_int_str.fgb fpolys variables [] in
  print_endline "Grobner basis";
  print_endline (String.concat "\n" (List.map to_string (List.map libpoly_to_poly gb)))