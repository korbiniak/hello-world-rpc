open! Core
open Async
open Hello_world_protocol

val hello_world_rpc
  :  where_to_connect:[< Socket.Address.t ] Tcp.Where_to_connect.t
  -> query:Hello_world.Query.t
  -> Hello_world.Response.t Deferred.Or_error.t
