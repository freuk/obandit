(*---------------------------------------------------------------------------
 Copyright (c) 2017 Valentin Reis. All rights reserved.
 Distributed under the ISC license, see terms at the end of the file.
 %%NAME%% %%VERSION%%
 ---------------------------------------------------------------------------*)

open Obanditcsv
open Cmdliner

type copts = {
  debug : bool}
let copts debug = {debug;}

let copts_sect = "COMMON OPTIONS"
let help_secs = [
  `S copts_sect;
  `P "These options are common to all commands.";
                                  `S "MORE HELP";
                                  `P "Use `$(mname) $(i,COMMAND) --help' for help on a single command.";`Noblank;]

let help man_format cmds topic = match topic with
  | None -> `Help (`Pager, None) (* help about the program. *)
  | Some topic ->
      let topics = "topics" :: "patterns" :: "environment" :: cmds in
      let conv, _ = Cmdliner.Arg.enum (List.rev_map (fun s -> (s, s)) topics) in
        match conv topic with
          | `Error e -> `Error (false, e)
          | `Ok t when t = "topics" -> List.iter print_endline topics; `Ok ()
          | `Ok t when List.mem t cmds -> `Help (man_format, Some t)
          | `Ok t ->
              let page = (topic, 7, "", "", ""), [`S topic; `P "Say something";] in
                `Ok (Cmdliner.Manpage.print man_format Format.std_formatter page)

let copts_t =
  let docs = copts_sect in
  let debug =
    let doc = "Give debug output." in
      Arg.(value & flag & info ["debug"] ~docs ~doc)
  in Term.(const copts $ debug)

let help_cmd =
  let topic =
    let doc = "The topic to get help on. `topics' lists the topics." in
      Arg.(value & pos 0 (some string) None & info [] ~docv:"TOPIC" ~doc)
  in
  let doc = "display help about obandit and obandit commands" in
  let man =
    [`S "DESCRIPTION";
     `P "Prints help about obandit commands and other subjects..."] @ help_secs
  in
    Term.(ret
            (const help $ Term.man_format $ Term.choice_names $topic)),
    Term.info "help" ~doc ~man

let csv_cmd =
  let docs = copts_sect
  in let f_in =
    let doc = "Input csv." in
      Arg.(required & pos 0 (some file) None & info [] ~docv:"IN" ~docs ~doc)
  in let doc = "Apply the bandit algorithm on a csv file."
  in let f_out =
    let doc = "Output csv." in
      Arg.(required & pos 1 (some string) None & info [] ~docv:"OUT" ~docs ~doc)
  in let doc = "Apply the bandit algorithm on a csv file."
  in let k  =
    let doc = "Arm count." in
      Arg.(required & pos 2 (some int) None & info [] ~docv:"K" ~docs ~doc)
  in let rate =
    let doc = "Rate." in
      Arg.(required & pos 3 (some float) None & info [] ~docv:"RATE" ~docs ~doc)
  in let bandit =
    let doc = "Bandit type." in
      Arg.(required & pos 4 (some (enum Obanditcsv.bandits)) None & info [] ~docv:"IN" ~docs ~doc)
  in let doc = "Apply the bandit algorithm on a csv file."
  in let man =
  [`S "DESCRIPTION";
   `P doc] @ help_secs
  in
    Term.(const Obanditcsv.csv $ f_in $ f_out $ k $ rate $ bandit),
    Term.info "csv" ~doc ~sdocs:docs ~man

let cmds = [csv_cmd;]

let default_cmd =
  let doc = "Obandit commandline tool." in
  let man = help_secs in
    Term.(ret (const  (`Help (`Pager, None)) )),
    Term.info "obandit" ~version:"0.1" ~sdocs:copts_sect ~doc ~man

let () =
  Printexc.record_backtrace true;
  match Term.eval_choice default_cmd cmds with
    | `Error _ -> exit 1 | _ -> exit 0

(*---------------------------------------------------------------------------
 Copyright (c) 2017 Valentin Reis

 Permission to use, copy, modify, and/or distribute this software for any
 purpose with or without fee is hereby granted, provided that the above
 copyright notice and this permission notice appear in all copies.

 THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 ---------------------------------------------------------------------------*)

