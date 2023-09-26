(lang dune 3.10)

(name hello_world_rpc)

(generate_opam_files false)

(authors "Franciszek Malinka")

(license MIT)

(package
 (name hello_world_rpc)
 (synopsis "Example Async RPC server-client application")
 (description
  "This is a simple Async RPC application developed after my internship at Jane Street. I'll probably use it in the future as a handy example to refer from. Also, I haven't seen much Async RPCs examples on the web.")
 (depends ocaml dune)
 (tags
  (async rpc)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
