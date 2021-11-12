open Faugere.Fgb

type monic = Prod of (string * int) list

type 'a mon = 'a * monic

type 'a poly = PSum of 'a mon list

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

let to_string (PSum p) = 
  String.concat " + " (List.map mon_to_string p)

let variables = ["x1"; "x2"; "x3"]

let libpoly_to_poly (Sum mons) = 
  let mapper (c, e) = 
    let zipped = List.map2 (fun v ex -> (v, ex)) variables e in
    c, Prod (List.filter (fun (_, ex) -> ex > 0) zipped)
  in
  PSum (List.map mapper mons)


let () = 
  let p1 = Sum [("1", [1; 2; 0]); ("2", [0; 1; 1])] in
  let p2 = Sum [("1", [1; 0; 2]); ("2", [])] in
  let results = Fgb_int.fgb [p1; p2] variables [] in
  print_endline (String.concat "\n" (List.map to_string (List.map libpoly_to_poly results)))