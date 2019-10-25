
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


test/cwrapper: test/cwrapper.c
	clang cwrapper.c -lsymengine -o cwrapper
