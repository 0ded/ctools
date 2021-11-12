CC = gcc
PY = python3
CFILES := $(shell find . -name "*.c")
HFILES := $(shell find . -name "*.h")
OBJS := $(CFILES:%.c=%.o)
COMPACT_FILE = code.source
EXEC = out.bin
DEBUG_FLAG = -g
COMP_FLAG = -std=c99 -c

$(EXEC): $(OBJS)
	$(CC) $? -o $@

/%.o: %.c %.h
	$(CC) $(COMP_FLAG) $?

clean:
	rm -rf *.o *.gch *.out $(EXEC)

+run: clean $(EXEC)
	./$(EXEC)

git:
	git add .
	git commit -m "$(shell date)"

get_obj:
	echo $(OBJS)

get_source:
	echo $(CFILES)

necromancy:
	$(PY) guillotine.py $(CFILES)

head_cut:
	rm -rf $(HFILES)

compact:
ifeq (,$(wildcard $(COMPACT_FILE)))
	$(PY) bundle.py $(CFILES) -r
	$(shell make head_cut)
else
	$(shell echo "$(COMPACT_FILE) file exists!")
endif

bundle_u:
ifeq (,$(wildcard $(COMPACT_FILE)))
	$(shell echo "$(COMPACT_FILE) file not found!")
else
	$(PY) bundle.py -u
endif

unpack: bundle_u
	$(shell make necromancy)
	rm -rf $(COMPACT_FILE)
