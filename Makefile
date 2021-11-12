CC = gcc
PY = python3
CFILES := $(shell find . -name "*.c")
HFILES := $(shell find . -name "*.h")
OBJS := $(CFILES:%.c=%.o)
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
	git add -A
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
    $(PY) bundle.py $(CFILES) -r
    head_cut

unpack:
    $(PY) bundle.py -u
    necromancy
