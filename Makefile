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

.PHONY: pre-commit
pre-commit: docs

.PHONY: docs
docs:
	rm -rf docs
	cp --no-preserve=mode -r $$(nix-build -A obandit)/share/doc docs
	cp doc/kroliki.jpg docs/kroliki.jpg
