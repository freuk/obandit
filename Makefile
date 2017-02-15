.PHONY: doc
doc:
	nix-shell --run "topkg doc --docflags='-g ltxhtml.cma'"
