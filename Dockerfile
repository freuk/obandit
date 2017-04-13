FROM ocaml/opam
RUN opam install topkg-care
RUN opam pin add --dev-repo cmdliner
RUN opam pin add --dev-repo topkg-care
RUN opam pin add --dev-repo topkg
RUN opam install batteries
RUN sudo apt-get install vim -y
ENV EDITOR vim
ENV TOPKG_DELEGATE ./delegate.ml
CMD rm -rf /home/opam/.ssh
WORKDIR /home/opam/pkg
CMD /bin/bash
