open! Core
open Async

type t =
  { uppercase : bool
  ; port : int
  }
[@@deriving sexp]

val load : Filename.t -> t Deferred.Or_error.t
