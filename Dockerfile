FROM ocaml/opam
RUN opam install topkg-care
RUN opam install batteries
CMD /bin/bash
