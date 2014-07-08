CC=cc
CFLAGS=-std=c99
CFLAGS+=-W -Wall
#CFLAGS+=-O3
CFLAGS+=-O0 -g -ggdb
CFLAGS+=-MMD  # generate dependency .d files
LDLIBS=
LDFLAGS=

SRCS=test.c foo.c bar/bar.c
TARGETS=test libfoo.a bar/libbar.a

bar/libbar.a: bar/bar.o
libfoo.a: foo.o
test: test.o libfoo.a bar/libbar.a

.DEFAULT_GOAL=all
.PHONY: all
all: $(TARGETS)

.PHONY: clean
clean:
	$(RM) $(TARGETS)
	$(RM) $(OBJS)
	$(RM) $(DEPS)
	-@rmdir $(OBJDIRS)

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
