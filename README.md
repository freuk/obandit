Obandit — Ocaml Multi-Armed Bandits
-------------------------------------------------------------------------------
%%VERSION%%

Obandit is an OCaml module for basic multi-armed bandits. It supports the
EXP3, UCB1 and Epsilon-greedy algorithms.

Obandit is distributed under the ISC license.

Homepage: git.freux.fr/obandit  

## Installation

Obandit can be installed with `opam`:

    opam install obandit

If you don't use `opam` consult the [`opam`](opam) file for build
instructions.

## Documentation

The documentation and API reference is generated from the source
interfaces. It can be consulted [online][doc] or via `odig doc
obandit`.

[doc]: freux.fr/obandit/doc

## Sample programs

If you installed Obandit with `opam` sample programs are located in
the directory `opam var obandit:doc`.

In the distribution sample programs and tests are located in the
[`test`](test) directory of the distribution. They can be built and run
with:

    topkg build --tests true && topkg test 
