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

git:
	git add .
	git commit -m "$(shell date)"

get_obj:
	@echo $(OBJS)

get_source:
	@echo "$(CFILES)"

necromancy:
	@$(PY) guillotine.py $(CFILES)
	@echo "creating headers"

head_cut:
	@rm -rf $(HFILES)
	@echo "headers removed"

compact: clean
ifeq (,$(wildcard $(COMPACT_FILE)))
	@$(PY) bundle.py $(CFILES) -r
	@$(MAKE) -s head_cut
	@echo "source code packed"
else
	@echo "$(COMPACT_FILE) file exists!"
endif

unpack:
ifeq (,$(wildcard $(COMPACT_FILE)))
	@echo "$(COMPACT_FILE) file not found!"
else
	@$(PY) bundle.py -u
	@echo "extracted"
	@rm -rf $(COMPACT_FILE)
	@$(MAKE) -s necromancy
endif
