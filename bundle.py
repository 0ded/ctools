import os
import sys
import re

KNOWN_FLAGS = ["-r", "-u"]

LINE_BREAK = "!BREAK!"
FILE_BREAK = "!FILE!"
OUT_FILE = "./code.source"


def main(files):
    code = ""
    for filename in files:
        code += FILE_BREAK+filename+FILE_BREAK
        code += create_inb(filename)
    bundle(code)


def bundle(code):
    with open(OUT_FILE, "w") as file:
        file.write(code)


def create_inb(filename):
    with open(filename, "r") as file:
        file = file.readlines()
        out = ""
        for line in file:
            out += (line.replace("\n", LINE_BREAK))
        inb = out
    return inb


def remove_c(flags):
    if "-r" in flags:
        for i in sys.argv:
            os.remove(i)


def unpack(flags):
    if "-u" in flags:
        with open(OUT_FILE, "r") as source:
            files = source.readlines()[0].split(FILE_BREAK)
            for i in range(1, len(files)):
                if i % 2 == 1:
                    print(files[i])
                    open(files[i], "w").write(files[i+1].replace(LINE_BREAK, "\r\n"))


def extract_flags():
    flags = []
    for f in KNOWN_FLAGS:
        if f in sys.argv:
            flags.append(f)
            sys.argv.remove(f)
    return flags


if __name__ == "__main__":
    sys.argv.remove(os.path.basename(__file__))
    flags = extract_flags()
    unpack(flags)
    main(sys.argv)
    remove_c(flags)
