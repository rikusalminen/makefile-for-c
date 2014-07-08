A simple Makefile for C
====

This repository contains a minimal Makefile for building executables and
static libraries in C.

  * Use built-in rules to compile and link
  * Track dependencies to header files (using $(CC) -MMD)
  * Object files outside source directory (optional)
  * Build static libraries (archives)
  * Source file and object file subdirectories
  * Uses vpath to locate source files
  * Safe for parallel make (make -jN)
  * make clean
  * cscope, ctags and etags (optional)

Usage
----

In the *beginning* of the file, modify CC, CFLAGS, LDLIBS and LDFLAGS.

  * Compiler options go to CFLAGS
  * Libraries to link with go to LDLIBS
  * Linker arguments (e.g. -Lpath/to/lib) go to LDFLAGS

Put file names of all targets (TARGETS) and source code files (SRCS), not
including header files.

In the *end* of the file, list all targets and their dependencies.

To build, run `make`.
To build outside source directory, run `make -f path/to/Makefile`.

For cscope run `make cscope.out`.
For ctags run `make tags`.
For etag run `make etags`.

Issues
----

  * `make clean all` doesn't work. Workaround: `make clean ; make all` works.
