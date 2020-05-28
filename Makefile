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

.PHONY: docs
docs:
	rm -rf docs
	cp --no-preserve=mode -r $$(nix-build -A obandit)/share/doc docs
	for i in docs/*.html ; do echo "$$i" && pandoc -s $$i -o $$i.md -t commonmark ; done
	rm docs/*.html

#.PHONY: docdeploy
#docdeploy:
	#rsync -r _build/doc/api.docdir/ web:/mnt/web/web/obandit/doc
