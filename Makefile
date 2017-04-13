.PHONY: docker
docker-build:
	docker build -t ocaml-obandit .

docker-run:
	docker run --volume=`pwd`:/home/opam/pkg -itd --name=obandit ocaml-obandit /bin/bash
	docker cp ~/.ssh obandit:/home/opam/
	docker exec -d obandit sudo chown -R opam:opam /home/opam/.ssh
	docker attach obandit

docker-clean:
	docker rm obandit

nix:
	nix-build -A obandit

#.PHONY: build
#build:
	#topkg build

#.PHONY: doc
#doc:
	#nix-shell --run "topkg doc --docflags='-g odoc_custom.cma'"

#.PHONY: docdeploy
#docdeploy:
	#rsync -r _build/doc/api.docdir/ web:/mnt/web/web/obandit/doc
