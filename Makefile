.PHONY: doc
doc:
	nix-shell --run "topkg doc --docflags='-g odoc_custom.cma'"

.PHONY: docdeploy
docdeploy:
	rsync -r _build/doc/api.docdir/ web:/mnt/web/web/obandit/doc
