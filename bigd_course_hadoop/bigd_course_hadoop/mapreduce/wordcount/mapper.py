# Mapper
import re
import sys

WORD_RE = re.compile(r"[\w']+")

for line in sys.stdin:
    line = line.strip()
    words = WORD_RE.findall(line)
    for word in words:
        print("{}\t{}".format(word, 1))
