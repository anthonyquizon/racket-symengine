
SOEXT=so
OS := $(strip $(shell uname -s | tr '[:upper:]' '[:lower:]'))

ifneq ($(findstring cygwin, $(OS)),)
  SOEXT=dll
endif

ifeq ($(OS), Windows_NT)
  SOEXT=dll
endif

ifeq ($(OS), darwin)
  SOEXT=dylib
endif


default: ext/symengine.$(SOEXT)

# TODO deps management
extern/symengine.$(SOEXT): 
	mkdir -p extern
	git clone https://github.com/symengine/symengine.git symengine 
	cd symengine && cmake -DCMAKE_INSTALL_PREFIX:PATH="../extern" -DBUILD_SHARED_LIBS:BOOL=ON . && make && make install

update_symengine:
	cd symengine && git pull

test/cwrapper: test/cwrapper.c
	clang cwrapper.c -lsymengine -o cwrapper
