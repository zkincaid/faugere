type fmonic = int list

type 'a fmon = 'a * fmonic

type 'a fpoly = Sum of 'a fmon list

module type Fgb_opt = sig

  val set_max_output_size : int -> unit
  val set_index : int -> unit
  val set_fgb_verbosity : int -> unit
  val set_force_elim : int -> unit
  val set_number_of_threads : int -> unit

end

  
module Fgb_int_zarith : sig

  include Fgb_opt

  val fgb : Z.t fpoly list -> string list -> string list -> Z.t fpoly list

end

