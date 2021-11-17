module Fgb_int_zarith : sig

  include Faugere.Fgb_opt

  val fgb : Z.t Faugere.fpoly list -> string list -> string list -> Z.t Faugere.fpoly list

end

