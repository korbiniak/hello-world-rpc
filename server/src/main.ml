open! Core
open Async

let command =
  Command.async_or_error
    ~summary:"Run Hello World RPC server"
    (let%map_open.Command () =
       Log_extended.Command.setup_via_params
         ~log_to_console_by_default:(Stderr Color)
         ~log_to_syslog_by_default:false
         ()
     and uppercase = flag "uppercase" no_arg ~doc:"Uppercase the message"
     and port = flag "port" (optional int) ~doc:"INT port to listen on" in
     Log.Global.set_output (Log_extended.Global.get_output ());
     fun () ->
       let port = Option.value ~default:8080 port in
       let config = { Config.uppercase; port } in
       let%bind.Deferred.Or_error server = Server.init config in
       Server.run server |> Deferred.ok)
;;
