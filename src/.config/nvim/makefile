# makefile for compiling individual files from vim

~/.cache/termdebug/bin/%: %.cpp
	mkdir -p ~/.cache/termdebug/bin/
	$(LINK.cpp) -g -Wall -Wpedantic $^ $(LOADLIBES) $(LDLIBS) -o $@

~/.cache/termdebug/bin/%: %.c
	mkdir -p ~/.cache/termdebug/bin/
	$(LINK.c) -g -Wall -Wpedantic $^ $(LOADLIBES) $(LDLIBS) -o $@
