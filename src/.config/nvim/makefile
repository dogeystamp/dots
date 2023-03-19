# makefile for compiling individual files from vim

~/.cache/termdebug/%: %.cpp
	mkdir -p ~/.cache/termdebug/
	$(LINK.cpp) -g -Wall -Wpedantic $^ $(LOADLIBES) $(LDLIBS) -o $@
