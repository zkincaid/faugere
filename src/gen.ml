let write_extern_c () = 
  let c_in = open_in "stub.c" in
  let rec read_insert_line is_done lines =
    if is_done then List.rev (("#if defined (__cplusplus)\n}\n#endif") :: lines)
    else
      try
        let line = (input_line c_in) ^ "\n" in
        if line = "#include \"ctypes_cstubs_internals.h\"\n" then read_insert_line false ("#if defined (__cplusplus)\nextern \"C\"{\n#endif\n" :: line :: lines)
        else
          read_insert_line false (line :: lines)
      with End_of_file -> read_insert_line true lines
  in
  let lines = read_insert_line false [] in
  close_in c_in;
  let c_out = open_out "stub.c" in
  List.iter (output_string c_out) lines;
  flush c_out;
  close_out c_out

let () = 
  let tmp_out = open_out "stub.c" in
  let ml_out = open_out "stub.ml" in
  output_string ml_out "(**Generated stub file. Not meant to be used by users of the faugere package. *)";
  Cstubs.write_ml (Format.formatter_of_out_channel ml_out) ~prefix:"fgb_stub" (module Bindings.Bindings);
  output_string tmp_out "#include \"common.h\"\n#include \"call_fgb_int.h\"\n#include \"call_fgb_mod.h\"\n";
  Cstubs.write_c (Format.formatter_of_out_channel tmp_out) ~prefix:"fgb_stub" (module Bindings.Bindings);
  flush tmp_out;
  flush ml_out;
  close_out tmp_out;
  close_out ml_out;
  write_extern_c ()
