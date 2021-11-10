open Faugere.Lib

let () = 
  init ["x1"; "x2"; "x3"]; 
  let p1 = Sum [("1", Prod["x1", 1; "x2", 2]); ("2", Prod["x1", 1; "x3", 1])] in
  let p2 = Sum [("1", Prod["x2", 1; "x3", 2]); ("2", Prod[])] in
  let polys = List.map create_poly [p1; p2] in
  let results = fgb polys in
  print_endline (String.concat "\n" (List.map to_string results))