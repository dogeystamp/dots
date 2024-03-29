# makefile for compiling individual files from vim

DBG_DIR=$(XDG_CACHE_HOME)/nvimdbg

$(DBG_DIR)%.cpp/binary: %.cpp
	$(LINK.cpp) -g -Wall -Wpedantic -std=c++20 $^ $(LOADLIBES) $(LDLIBS) -o $@

$(DBG_DIR)%.c/binary: %.c
	$(LINK.c) -g -Wall -Wpedantic $^ $(LOADLIBES) $(LDLIBS) -o $@
