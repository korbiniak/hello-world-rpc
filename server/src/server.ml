open! Core
open Async
open Hello_world_protocol

type t = { config : Config.t } [@@deriving sexp_of]
type rpc_state = Socket.Address.Inet.t * Rpc.Connection.t [@@deriving sexp_of]

let init config = Deferred.Or_error.return { config }
let construct_hello_world ~hello ~world = [%string "%{hello}, %{world}!"]

let log_rpc rpc_state rpc_description =
  Log.Global.debug_s
    [%message "New Rpc" (rpc_state : rpc_state) (rpc_description : Rpc.Description.t)]
;;

let hello_world_implementation
  { config }
  rpc_state
  rpc_description
  (query : Hello_world.Query.t)
  =
  log_rpc rpc_state rpc_description;
  let response = construct_hello_world ~hello:query.hello ~world:query.world in
  (if config.uppercase then String.uppercase response else response)
  |> Deferred.Or_error.return
;;

let unkown_rpc rpc_state ~rpc_tag ~version =
  ignore rpc_state;
  Log.Global.error_s [%message "Unkown rpc" rpc_tag (version : int)];
  `Close_connection
;;

let implementations t =
  let implementations =
    List.concat
      [ Hello_world_protocol.Hello_world.implement (hello_world_implementation t) ]
  in
  let implementations = Versioned_rpc.Menu.add implementations in
  Rpc.Implementations.create_exn ~implementations ~on_unknown_rpc:(`Call unkown_rpc)
;;

let run { config } =
  let where_to_listen = Tcp.Where_to_listen.of_port config.port in
  Log.Global.info_s
    [%message "Spinning up server" (where_to_listen : Tcp.Where_to_listen.inet)];
  let%bind server =
    Rpc.Connection.serve
      ~implementations:(implementations { config })
      ~initial_connection_state:(fun address connection -> address, connection)
      ~where_to_listen
      ()
  in
  ignore server;
  Deferred.never ()
;;
