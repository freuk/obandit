open Obandit

type bandit = Exp3 | Ucb1 | EGreedy

let bandits = [("exp3",Exp3);("ucb1",Ucb1);("expgreedy",EGreedy)]

let line_stream_of_channel channel =
    Stream.from
      (fun _ ->
         try Some (input_line channel) with End_of_file -> None)

let getA a = match a with
      |(Action i) -> i
      |(Reset i) -> i

let runchan chan_in chan_out k rate bandit_type =
  let f_estimates (initialb:banditEstimates rangedBandit)
      (step:banditEstimates rangedBandit -> float -> rangedAction * banditEstimates rangedBandit) =
    let stream_in = line_stream_of_channel chan_in
    in let f (b:banditEstimates rangedBandit) line =
      let rewards = BatString.split_on_char ' ' line
      in let reward = if b.bandit.a>=0
           then float_of_string (List.nth rewards b.bandit.a)
           else 0.
      in let a,b = step b reward
      in let i = getA a
      in (Printf.fprintf chan_out "%d\n" i;(b,None))
    in ignore (BatStream.foldl f initialb stream_in)
  and f_policy (initialb:banditPolicy rangedBandit)
      (step:banditPolicy rangedBandit -> float -> rangedAction * banditPolicy rangedBandit) =
    let stream_in = line_stream_of_channel chan_in
    in let f b line =
      let rewards = BatString.split_on_char ' ' line
      in let reward = if b.bandit.a>=0
           then float_of_string (List.nth rewards b.bandit.a)
           else 0.
      in let a,b = step b reward
      in let i = getA a
      in (Printf.fprintf chan_out "%d\n" i;(b,None))
    in ignore (BatStream.foldl f initialb stream_in)
  in match bandit_type with
  |Exp3 ->
    let module P = struct
      let k = k
      let eta = rate
    end
    in let module BM: RangedBandit with type bandit=banditPolicy = WrapRange01(MakeFixedExp3(P))
    in let (initialb:banditPolicy rangedBandit)= BM.initialBandit
    in f_policy initialb BM.step
  |Ucb1 ->
    let module P = struct
      let k = k
    end
    in let module BM: RangedBandit with type bandit=banditEstimates = WrapRange01(MakeUCB1(P))
    in let (initialb:banditEstimates rangedBandit)= BM.initialBandit
    in let (step:banditEstimates rangedBandit -> float -> rangedAction * banditEstimates rangedBandit) = BM.step
    in f_estimates initialb step
  |EGreedy ->
    let module P = struct
      let k = k
      let epsilon = rate
    end
    in let module BM: RangedBandit with type bandit=banditEstimates = WrapRange01(MakeEpsilonGreedy(P))
    in let (initialb:banditEstimates rangedBandit)= BM.initialBandit
    in let (step:banditEstimates rangedBandit -> float -> rangedAction * banditEstimates rangedBandit) = BM.step
    in f_estimates initialb step

let csv fn_in fn_out k rate bandit_type =
  let chan_in, chan_out = (open_in fn_in), (open_out fn_out)
  in try
    runchan chan_in chan_out k rate bandit_type
  with e ->
    close_in_noerr chan_in;
    close_out_noerr chan_out;
    raise e
