open! Core
open Async
open Hello_world_protocol

let hello_world_rpc ~where_to_connect ~query =
  Rpc.Connection.with_client where_to_connect (fun conn ->
    let%bind.Deferred.Or_error conn = Versioned_rpc.Connection_with_menu.create conn in
    Hello_world.dispatch conn query)
  >>| Result.map_error ~f:Error.of_exn
  >>| Or_error.join
;;
