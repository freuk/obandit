#!/usr/bin/env ocaml
#use "topfind"
#require "bos.setup"
#require "rresult"
open Bos_setup
open Rresult

let unsupported = Ok 1

let publish = function
  | "distrib" :: uri :: name :: version :: msg :: archive :: _ ->
      let scp = Cmd.(v  "scp" % archive % (Printf.sprintf "web:/mnt/web/web/%s/releases" name))
      in let _ = OS.Cmd.(run scp) in Ok 0
  | "doc" :: uri :: name :: version :: msg :: docdir :: _ ->
      let scp = Cmd.(v "rsync" % "-r" % (Printf.sprintf "%s/" docdir) % (Printf.sprintf "web:/mnt/web/web/%s/doc" name))
      in let _ = OS.Cmd.(run scp) in Ok 0
  | "alt" :: kind :: uri :: name :: version :: msg :: archive :: _ ->
      unsupported
  | args ->
      unsupported

let issue = function
  | "list" :: uri :: _ -> unsupported
  | "show" :: uri :: id :: _ -> unsupported
  | "open" :: uri :: title :: descr :: _ -> unsupported
  | "close" :: uri :: id :: msg :: _ -> unsupported
  | args -> unsupported

let request = function
  | "publish" :: args -> publish args
  | "issue" :: args -> issue args
  | args -> unsupported

let main () =
  let doc = "the unsupportive delegate" in
    begin match OS.Arg.(parse ~doc ~pos:string ()) with
      | "ipc" :: verbosity :: req ->
          Logs.level_of_string verbosity
            >>= fun level -> Logs.set_level level; request req
              | "ipc" :: [] ->
                  R.error_msg "malformed delegate request, verbosity is missing"
              | args ->
                  R.error_msgf "unknown arguments: %s" (String.concat ~sep:" " args)
    end
    |> Logs.on_error_msg ~use:(fun () -> 2)

let () = 
  exit (main ())
