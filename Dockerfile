FROM ocaml/opam
RUN sudo apt-get install vim libgmp-dev -y
RUN opam install topkg-care opam-publish
RUN opam pin add --dev-repo cmdliner
RUN opam pin add --dev-repo topkg-care
RUN opam pin add --dev-repo topkg
RUN opam install batteries
ENV EDITOR vim
ENV TOPKG_DELEGATE toy-github-topkg-delegate
CMD rm -rf /home/opam/.ssh
WORKDIR /home/opam/pkg
CMD /bin/bash
