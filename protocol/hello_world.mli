open! Core
open Async

module Query : sig
  type t =
    { hello : string
    ; world : string
    }
  [@@deriving sexp_of]
end

module Response : sig
  type t = string Or_error.t [@@deriving sexp_of]
end

module Stable : sig
  module Query : sig
    module V1 : Stable_without_comparator with type t = Query.t
  end

  module Response : sig
    module V1 : Stable_without_comparator with type t = Response.t
  end
end

val dispatch
  :  Versioned_rpc.Connection_with_menu.t
  -> Query.t
  -> Response.t Or_error.t Deferred.t

val implement
  :  ('a -> Rpc.Description.t -> Query.t -> Response.t Deferred.t)
  -> 'a Rpc.Implementation.t list
