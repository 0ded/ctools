import os
import sys
import re


LINE_BREAK = "!BREAK!"
FILE_BREAK = "!FILE!"
OUT_FILE = "./code.source"


def main(files, flags):
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


if __name__ == "__main__":
    main()
