A simple Makefile for C
====

This repository contains a minimal Makefile for building executables and
static libraries in C.

* Use built-in rules to compile and link
* Track dependencies to header files (using `$(CC) -MMD`)
* Object files outside source directory (optional)
* Build static libraries (archives)
* Source file and object file subdirectories
* Uses `vpath` to locate source files
* Safe for parallel make (`make -jN`)
* `make clean`
* cscope, ctags and etags (optional)
* `make test`
* Profile using gprof
* Coverage using gcov and lcov

Usage
----

In the *beginning* of the file, modify `CC`, `CFLAGS`, `LDLIBS` and
`LDFLAGS`.

* Compiler options go to `CFLAGS`
* Libraries to link with go to `LDLIBS`
* Linker arguments (e.g. `-Lpath/to/lib`) go to `LDFLAGS`

Put file names of all targets (`TARGETS`) and source code files (`SRCS`), not
including header files.

List all targets and their dependencies.

To build, run `make`.
To build outside source directory, run `make -f path/to/Makefile`.

For cscope run `make cscope.out`.
For ctags run `make tags`.
For etag run `make etags`.

Testing, profiling and coverage
----

To enable profiling and/or coverage, set `PROFILE=1` or `COVERAGE=1`.
Run tests using `make test` (optional), which invokes the `TEST_SUITE`
specified in Makefile or run your tests manually.
Running tests will write out profile and coverage information to `gmon.out`
(profile) and `*.gcda` for each object file (coverage).
Run `make profile` to generate `gprof.out`.
Run `make coverage` to generate `coverage/index.html` using `lcov`.


    make PROFILE=1 COVERAGE=1
    make test
    make PROFILE=1 COVERAGE=1 coverage profile

Issues
----

  * `make clean all` doesn't work. Workaround: `make clean ; make all` works.
