# Hello World RPC

This is a short and comprehensive example of Jane Street's Ocaml 
[`Async_rpc`](https://github.com/janestreet/async/tree/master/async_rpc) library usage,
together with [`Babel`](https://ocaml.org/p/babel/latest/doc/index.html), which
adds nice support for handling different versions of the RPCs and negotiation
between client and the server.

I've learned this stuff during my Jane Streets internship this year. I'll probably use
this repository as a handy example for my future OCaml code.

## Usage

To run the server, run from the root directory:

    $ dune exec -- ./server/bin/server.exe -log-level debug
    [INFO] ("Spinning up server"(where_to_listen((socket_type((family PF_INET)(socket_type SOCK_STREAM)))(address 0.0.0.0:8080)(listening_on <opaque>))))

To make a call, run the client:

    $ dune exec -- ./client/bin/client.exe hello-world "Ciao" "Franek"
    Ciao, Franek!
