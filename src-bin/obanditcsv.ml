open Obandit

let line_stream_of_channel channel =
    Stream.from
      (fun _ ->
         try Some (input_line channel) with End_of_file -> None)

let runchan chan_in chan_out k =
  let module Pk = struct
    let k = k
  end
  in let module BM = WrapRange01(MakeUCB1(Pk))
  in let initialb = BM.initialBandit
  in let stream_in = line_stream_of_channel chan_in
  in let f b line =
    let rewards = BatString.split_on_char ' ' line
    in let a,b = BM.step b (float_of_string (List.nth rewards b.bandit.a))
    in let i = (match a with
      |(Action i) -> i
      |(Reset i) -> i)
    in (Printf.fprintf chan_out "%d\n" i;(b,None))
  in BatStream.foldl f initialb stream_in

let csv fn_in fn_out k =
  let chan_in, chan_out = (open_in fn_in), (open_out fn_out)
  in try
    runchan chan_in chan_out k
  with e ->
    close_in_noerr chan_in;
    close_out_noerr chan_out;
    raise e
