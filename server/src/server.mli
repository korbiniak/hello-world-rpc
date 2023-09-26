open! Core
open Async

type t [@@deriving sexp_of]

val init : Config.t -> t Deferred.Or_error.t
val run : t -> unit Deferred.t
