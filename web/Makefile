.PHONY:all

R_OPTS=--no-save --no-restore --no-init-file --no-site-file # vanilla, but with --environ

all: web.md

web.md : web.Rmd
	R ${R_OPTS} -e "library(knitr);knit('web.Rmd')"

.PHONY:clean
clean:
	rm web.md
