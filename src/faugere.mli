include Bindings.Common.Poly

module type Fgb_opt = Bindings.Common.Fgb_opt

module Fgb_int : functor (C : sig type coef val coef_to_mpz : coef -> Bindings.B.mpz_t val mpz_to_coef : Bindings.B.mpz_t -> coef end) ->
  sig
  
  include Fgb_opt

  val fgb : C.coef fpoly list -> string list -> string list -> C.coef fpoly list
  
end


module Fgb_int_str : sig

  include Fgb_opt

  val fgb : string fpoly list -> string list -> string list -> string fpoly list

end

module Fgb_mod : sig

  include Fgb_opt

  val fgb : int fpoly list -> string list -> string list -> int -> int fpoly list

end
