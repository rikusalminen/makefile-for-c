CC=cc
CFLAGS=-std=c99
CFLAGS+=-W -Wall
#CFLAGS+=-O3
CFLAGS+=-O0 -g -ggdb
CFLAGS+=-MMD  # generate dependency .d files
LDLIBS=
LDFLAGS=

SRCS=foo-test.c foo.c bar/bar.c
TARGETS=foo-test libfoo.a bar/libbar.a

bar/libbar.a: bar/bar.o
libfoo.a: foo.o
foo-test: foo-test.o libfoo.a bar/libbar.a

TEST_SUITE=foo-test

.DEFAULT_GOAL=all
.PHONY: all
all: $(TARGETS)

.PHONY: clean
clean:
	$(RM) $(TARGETS)
	$(RM) $(OBJS)
	$(RM) $(DEPS)
	$(RM) cscope.out cscope.out.in cscope.out.po
	$(RM) tags TAGS
ifeq ($(COVERAGE), 1)
	$(RM) -r coverage
	$(RM) coverage.info
	$(RM) $(OBJS:.o=.gcno)
	$(RM) $(OBJS:.o=.gcda)
endif
ifeq ($(PROFILE), 1)
	$(RM) gmon.out
	$(RM) gprof.out
endif

	-@rmdir $(OBJDIRS)

.PHONY: test
test: $(TEST_SUITE)
	$(CURDIR)/$(TEST_SUITE)

SRC_PATH ?= $(dir $(abspath $(firstword $(MAKEFILE_LIST))))
vpath %.c $(SRC_PATH)src
vpath %.h $(SRC_PATH)include
CFLAGS+=-I$(SRC_PATH)include

#SRCS=$(notdir $(wildcard $(SRC_PATH)src/*.c))
OBJS=$(SRCS:.c=.o)
DEPS=$(OBJS:.o=.d)

# Object file subdirectories
OBJDIRS=$(filter-out $(CURDIR)/, $(dir $(abspath $(OBJS))))
$(OBJDIRS): ; @mkdir $@
$(DEPS): | $(OBJDIRS)
$(OBJS): | $(OBJDIRS)

-include $(DEPS)

# implicit rules for building archives not parallel safe (e.g. make -j 3)
%.a: ; ar rcs $@ $<

# cscope.out
cscope.out: $(SRCS)
	cscope -f $@ -I$(SRC_PATH)include -bq $^

# ctags
tags: $(SRCS)
	ctags -f $@ -R $(SRC_PATH)include $^

# etags
TAGS: $(SRCS)
	etags -f $@ -R $(SRC_PATH)include $^

# Profile (gprof)
ifeq ($(PROFILE), 1)
CFLAGS+=-pg
LDFLAGS+=-pg

gmon.out: test

gprof.out: gmon.out
	gprof $(CURDIR)/$(TEST_SUITE) > $@

.PHONY: profile
profile: gprof.out
endif

# Coverage (gcov, lcov)
ifeq ($(COVERAGE), 1)
CFLAGS+=-ftest-coverage -fprofile-arcs
LDFLAGS+=-coverage
LDLIBS+=-lgcov

$(OBJS:.o=.gcda): test

coverage.info: $(OBJS:.o=.gcda)
	lcov --capture --directory $(CURDIR) --output-file $@

coverage/index.html: coverage.info
	genhtml -o coverage $<

.PHONY: coverage
coverage: coverage/index.html
endif
