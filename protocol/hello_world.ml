module Stable = struct
  open Core.Core_stable

  module Query = struct
    module V1 = struct
      type t =
        { hello : String.V1.t
        ; world : String.V1.t
        }
      [@@deriving sexp, compare, bin_io]
    end
  end

  module Response = struct
    module V1 = struct
      type t = String.V1.t Or_error.V2.t [@@deriving sexp, compare, bin_io]
    end
  end
end

open! Core
open Async

let rpc version bin_query bin_response =
  Rpc.Rpc.create ~name:"hello-world-rpc" ~version ~bin_query ~bin_response
;;

let v1 = rpc 1 Stable.Query.V1.bin_t Stable.Response.V1.bin_t
let caller = Babel.Caller.Rpc.singleton v1

let%expect_test _ =
  Babel.Caller.print_shapes caller;
  [%expect
    {|
    ((((name hello-world-rpc) (version 1))
      (Rpc (query 13d043897ea4e5bd11e00a5e10ac5a96)
       (response a77b3b6e3753246ce7ec1f3467c939eb)))) |}];
  return ()
;;

let callee = Babel.Callee.Rpc.singleton v1

let%expect_test _ =
  Babel.Callee.print_shapes callee;
  let () =
    [%expect
      {|
    (Ok
     ((hello-world-rpc
       ((1
         (Rpc (query 13d043897ea4e5bd11e00a5e10ac5a96)
          (response a77b3b6e3753246ce7ec1f3467c939eb))))))) |}]
  in
  let description = Babel.check_compatibility_exn ~caller ~callee in
  print_s [%sexp (description : Rpc.Description.t)];
  [%expect {| ((name hello-world-rpc) (version 1)) |}];
  return ()
;;

let dispatch = Babel.Caller.Rpc.dispatch_multi caller
let implement f = Babel.Callee.implement_multi_exn callee ~f

module Query = Stable.Query.V1
module Response = Stable.Response.V1
