# Created by Oded Ginat 2021
# For more information: https://github.com/0ded/ctools
CC = gcc
PY = python3
CFILES = $(shell find . -name "*.c")
HFILES = $(shell find . -name "*.h")
OBJS := $(CFILES:%.c=%.o)
COMPACT_FILE = code.source
EXEC = out.bin
DEBUG_FLAG = -g
COMP_FLAG = -std=c99 -c

$(EXEC): $(OBJS)
ifeq (,$(wildcard $(COMPACT_FILE)))
	@$(CC) $? -o $@
	@echo "compiled"
else
	@$(MAKE) -s unpack
	@$(MAKE) -s
endif

/%.o: %.c %.h
	@$(CC) $(COMP_FLAG) $?

clean:
	@rm -rf *.o *.gch *.out $(EXEC)
	@echo "binaries terminated"

+run: clean $(EXEC)
	@echo "-----------------------------"
	@echo "-----------------------------"
	@echo "-----------------------------"
	./$(EXEC)
	@echo "-----------------------------"
	@$(MAKE) -s clean

git:
	git add .
	git commit -m "$(shell date)"

get_obj:
	@echo $(OBJS)

get_source:
	@echo "$(CFILES)"

necromancy:
ifeq (,$(wildcard guillotine.py))
	@echo "Error creating headers, reclone repo"
else
	@$(PY) guillotine.py $(CFILES)
	@echo "creating headers"
endif

head_cut:
	@rm -rf $(HFILES)
	@echo "headers removed"

compact: clean
ifeq (,$(wildcard bundle.py))
	@echo "Error bundeling, reclone repo"
else
ifeq (,$(wildcard $(COMPACT_FILE)))
	@$(PY) bundle.py $(CFILES) -r
	@$(MAKE) -s head_cut
	@echo "source code packed"
else
	@echo "$(COMPACT_FILE) file exists!"
endif
endif

unpack:
ifeq (,$(wildcard bundle.py))
	@echo "Error unpacking, reclone repo"
else
ifeq (,$(wildcard $(COMPACT_FILE)))
	@echo "$(COMPACT_FILE) file not found!"
else
	@$(PY) bundle.py -u
	@echo "extracted"
	@rm -rf $(COMPACT_FILE)
	@$(MAKE) -s necromancy
endif
endif
