.PHONY:all

all: zmk

.PHONY:zmk
zmk:
	zymake -l localhost zymakefile

slow:
	zymake zymakefile

rstudio:
	zymake -l localhost zymakefile

dummy:
	zymake -d zymakefile

.PHONY:clean
clean:
	rm -rf o figure
