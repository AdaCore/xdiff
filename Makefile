DESTDIR ?= install

all:
	gprbuild -p -P ada_xdiff.gpr

clean:
	gprclean -P ada_xdiff.gpr
	rm -rf generated

install:
	gprinstall -f -r -p -P ada_xdiff.gpr --prefix=$(DESTDIR)
