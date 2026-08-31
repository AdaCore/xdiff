BUILD_MODE ?= development
LIBRARY_TYPE ?= relocatable
PROCESSORS ?= 0
BUILD_DIR ?= .
INSTALL_DIR ?= .

# Define platform-specific variables
ifeq ($(OS),Windows_NT)
   OSNAME=$(OS)
else
   OSNAME := $(shell uname -s)
endif

ALL_LIBRARY_TYPES = static static-pic relocatable

.PHONY: lib
lib:
	gprbuild -k -P xdiff.gpr -p -j$(PROCESSORS) \
		--relocate-build-tree="$(BUILD_DIR)" \
		-XLIBRARY_TYPE=$(LIBRARY_TYPE) \
		-XBUILD_MODE=$(BUILD_MODE)

.PHONY: all
all:
	for kind in $(ALL_LIBRARY_TYPES) ; do \
		gprbuild -k -P xdiff.gpr -p -j$(PROCESSORS) \
			--relocate-build-tree="$(BUILD_DIR)" \
			-XLIBRARY_TYPE=$$kind \
			-XBUILD_MODE=$(BUILD_MODE) \
			-XOSNAME=$(OSNAME) ; \
	done

.PHONY: install
install:
	for kind in $(ALL_LIBRARY_TYPES) ; do \
		gprinstall -P src/c_xdiff/c_xdiff.gpr -p -f \
			-XLIBRARY_TYPE=$$kind \
			-XBUILD_MODE=$(BUILD_MODE) \
			-XOSNAME=$(OSNAME) \
			--relocate-build-tree="$(BUILD_DIR)"/src/c_xdiff \
			--prefix="$(INSTALL_DIR)" \
			--build-name=$$kind \
			--build-var=LIBRARY_TYPE ; \
		gprinstall -P xdiff.gpr -p -f \
			-XLIBRARY_TYPE=$$kind \
			-XBUILD_MODE=$(BUILD_MODE) \
			-XOSNAME=$(OSNAME) \
			--relocate-build-tree="$(BUILD_DIR)" \
			--prefix="$(INSTALL_DIR)" \
			--build-name=$$kind \
			--build-var=LIBRARY_TYPE ; \
	done

.PHONY: clean
clean:
	gprclean -P xdiff.gpr \
		--relocate-build-tree="$(BUILD_DIR)" \
		-XLIBRARY_TYPE=$(LIBRARY_TYPE) \
		-XBUILD_MODE=$(BUILD_MODE)
	gprclean -P src/c_xdiff/c_xdiff.gpr \
		--relocate-build-tree="$(BUILD_DIR)" \
		-XLIBRARY_TYPE=$(LIBRARY_TYPE) \
		-XBUILD_MODE=$(BUILD_MODE)
