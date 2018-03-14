FROM ocaml/opam:debian
RUN sudo apt-get install vim libgmp-dev -y
RUN opam update
RUN opam install topkg-care opam-publish cmdliner batteries
ENV EDITOR vim
ENV TOPKG_DELEGATE toy-github-topkg-delegate
CMD rm -rf /home/opam/.ssh
WORKDIR /home/opam/pkg
CMD /bin/bash
