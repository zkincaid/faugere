module MPZ : sig

  type t

  type ptr = t Ctypes.abstract Ctypes.ptr

  val t : t Ctypes.abstract Ctypes.typ

  val clear : ptr -> unit

  val init : ptr -> unit

  val set : Z.t -> ptr -> unit

  val make : unit -> ptr
  (** like {!Ctypes.make}, but with finalise and type already specified.
  mpz is initialized. *)

  val of_z : Z.t -> ptr

  val to_z : ptr -> Z.t

end
