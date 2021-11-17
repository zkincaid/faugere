open Ctypes

open Bindings.B


module Fgb_int_zarith = 
  Faugere.Fgb_int(struct
    type coef = Z.t
    let coef_to_mpz z = from_voidp mpz_struct (to_voidp (Zarith_bind.MPZ.of_z z))
    let mpz_to_coef mpz = Zarith_bind.MPZ.to_z (from_voidp Zarith_bind.MPZ.t (to_voidp mpz))
  end)