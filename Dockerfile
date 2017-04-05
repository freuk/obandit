FROM ocaml/opam
RUN opam install topkg-care
RUN opam pin add --dev-repo cmdliner
RUN opam pin add --dev-repo topkg-care
RUN opam pin add --dev-repo topkg
RUN opam install batteries
ENV TOPKG_DELEGATE ./ocaml_delegate.ml
CMD /bin/bash
