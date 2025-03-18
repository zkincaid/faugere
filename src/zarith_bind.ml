open
  struct
    module Ppxc__zarith_bind =
      struct
        open! Ctypes[@@ocaml.warning "-33-66"]
        module MPZ =
          struct
            type t
            let t : t Ctypes.abstract Ctypes.typ =
              Ctypes_static.Abstract
                {
                  Ctypes_static.aname = "__mpz_struct";
                  Ctypes_static.asize = 16;
                  Ctypes_static.aalignment = 8
                }
            external clear :
              _ Cstubs_internals.fatptr -> unit =
                "ppxc_zarith_bind_c_ee_mpz_clear"[@@noalloc ]
            let clear : 'ppxc__t_0 -> 'ppxc__t_1 =
              fun ppxc__0_zarith_bind_c ->
                let Ctypes_static.CPointer ppxc__1_zarith_bind_c =
                  ppxc__0_zarith_bind_c in
                clear ppxc__1_zarith_bind_c
            and _ =
              if false
              then
                Stdlib.ignore
                  ((Ctypes.ptr t : _ Ctypes.abstract Ctypes.ptr Ctypes.typ) : 
                  'ppxc__t_0 Ctypes.typ)
            external init :
              _ Cstubs_internals.fatptr -> unit =
                "ppxc_zarith_bind_e_12a_mpz_init"
            let init : 'ppxc__t_0 -> 'ppxc__t_1 =
              fun ppxc__0_zarith_bind_e ->
                let Ctypes_static.CPointer ppxc__1_zarith_bind_e =
                  ppxc__0_zarith_bind_e in
                init ppxc__1_zarith_bind_e
            and _ =
              if false
              then
                Stdlib.ignore
                  ((Ctypes.ptr t : _ Ctypes.abstract Ctypes.ptr Ctypes.typ) : 
                  'ppxc__t_0 Ctypes.typ)
            external set :
              Z.t -> _ Cstubs_internals.fatptr -> unit =
                "ppxc_zarith_bind_18_225_fset"
            let set : 'ppxc__t_0 -> 'ppxc__t_1 -> 'ppxc__t_2 =
              fun ppxc__0_zarith_bind_18 ->
                fun ppxc__1_zarith_bind_18 ->
                  let Ctypes_static.CPointer ppxc__2_zarith_bind_18 =
                    ppxc__1_zarith_bind_18 in
                  set ppxc__0_zarith_bind_18 ppxc__2_zarith_bind_18
            and _ =
              if false
              then
                Stdlib.ignore
                  ((Ctypes.ptr t : _ Ctypes.abstract Ctypes.ptr Ctypes.typ) : 
                  'ppxc__t_1 Ctypes.typ)
            external to_z :
              _ Cstubs_internals.fatptr -> Z.t =
                "ppxc_zarith_bind_27_3ff_fto_z"
            let to_z : 'ppxc__t_0 -> 'ppxc__t_1 =
              fun ppxc__0_zarith_bind_27 ->
                let Ctypes_static.CPointer ppxc__1_zarith_bind_27 =
                  ppxc__0_zarith_bind_27 in
                to_z ppxc__1_zarith_bind_27
            and _ =
              if false
              then
                Stdlib.ignore
                  ((Ctypes.ptr t : _ Ctypes.abstract Ctypes.ptr Ctypes.typ) : 
                  'ppxc__t_0 Ctypes.typ)
          end
      end
    module type __ppxc_zarith_bind  =
      sig include module type of Ppxc__zarith_bind end
  end
[@@@ocaml.text
  "Copied from https://github.com/fdopen/ctypes-zarith/blob/master/lib/ctypes_zarith.c.ml "]
module MPZ =
  struct
    type t = Ppxc__zarith_bind.MPZ.t
    open!
      struct
        module type __ppxc_zarith_bind  =
          sig include __ppxc_zarith_bind with type  MPZ.t =  t end
      end[@@ocaml.warning "-33-66"]
    let t : t Ctypes.abstract Ctypes.typ = Ppxc__zarith_bind.MPZ.t[@@ocaml.warning
                                                                    "-32"]
    type ptr = t Ctypes.abstract Ctypes.ptr
    let clear =
      if false
      then
        let module Ppxc__zarith_bind =
          (Ppxc__zarith_bind : __ppxc_zarith_bind) in
          Ppxc__zarith_bind.MPZ.clear
      else Ppxc__zarith_bind.MPZ.clear
    let init =
      if false
      then
        let module Ppxc__zarith_bind =
          (Ppxc__zarith_bind : __ppxc_zarith_bind) in
          Ppxc__zarith_bind.MPZ.init
      else Ppxc__zarith_bind.MPZ.init
    let make () =
      let r = Ctypes.allocate_n ~finalise:clear t ~count:1 in init r; r
    let set =
      if false
      then
        let module Ppxc__zarith_bind =
          (Ppxc__zarith_bind : __ppxc_zarith_bind) in
          Ppxc__zarith_bind.MPZ.set
      else Ppxc__zarith_bind.MPZ.set
    let of_z x = let r = make () in set x r; r
    let to_z =
      if false
      then
        let module Ppxc__zarith_bind =
          (Ppxc__zarith_bind : __ppxc_zarith_bind) in
          Ppxc__zarith_bind.MPZ.to_z
      else Ppxc__zarith_bind.MPZ.to_z
  end
