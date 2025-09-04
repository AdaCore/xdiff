DESTDIR ?= install

all:
	gprbuild -p -P xdiff.gpr

clean:
	gprclean -P xdiff.gpr
	rm -rf generated

install:
	gprinstall -f -r -p -P xdiff.gpr --prefix=$(DESTDIR)
