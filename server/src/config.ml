open! Core
open Async

type t =
  { uppercase : bool
  ; port : int
  }
[@@deriving sexp]

let load filename = Reader.load_sexp filename t_of_sexp
