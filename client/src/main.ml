open! Core
open Async

let hello_world_rpc_command =
  Command.async_or_error
    ~summary:"Hello world RPC"
    (let%map_open.Command hello = anon ("HELLO" %: string)
     and world = anon ("WORLD" %: string)
     and host =
       flag
         "host"
         (optional_with_default "127.0.0.1" string)
         ~doc:"STRING Host to connect to"
     and port =
       flag "port" (optional_with_default 8080 int) ~doc:"INT Port to connect to"
     in
     fun () ->
       let where_to_connect =
         Tcp.Where_to_connect.of_host_and_port (Host_and_port.create ~host ~port)
       in
       let%map.Deferred.Or_error response =
         Client.hello_world_rpc ~where_to_connect ~query:{ hello; world }
       in
       match response with
       | Error error -> print_endline [%string "Error: %{Error.to_string_hum error}."]
       | Ok response -> print_endline response)
;;

let command =
  Command.group ~summary:"Hello world rpcs" [ "hello-world", hello_world_rpc_command ]
;;
