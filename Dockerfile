FROM ocaml/opam
RUN opam install topkg-care
RUN opam pin add --dev-repo cmdliner
RUN opam pin add --dev-repo topkg-care
RUN opam pin add --dev-repo topkg
RUN opam install batteries
RUN sudo apt-get install vim -y
ENV TOPKG_DELEGATE ./ocaml_delegate.ml
ENV EDITOR vim
CMD /bin/bash
