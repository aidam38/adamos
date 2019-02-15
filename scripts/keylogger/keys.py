#!/bin/python
# -*- coding: utf-8 -*-

import operator
from pprint import pprint
import locale

log = open("keys.log", "r")

modkeys = ["<lshft>", "<rshft>", "<lalt>", "<esc>", "<tab>", "<lctrl>", "<rctrl>", "\n", "<bcksp>", "<cpslk>", " ", "<altgr>", "<up>", "<down>", "<left>", "<right>", "<end>", "<del>", "<home>"]
modkeys_dict = dict((el,0) for el in modkeys)
bigline = ""

for line in log.readlines():
    if len(line.split(" > ")) > 1:
        l = line.split(" > ")[1].decode("UTF-8").lower() 
        for m in modkeys:
            modkeys_dict[m] += l.count(m)
            l = l.replace(m,"")
        bigline += (l.replace("\n",""))

char_dict = {}
for c in bigline:
    if c in char_dict.keys():
        char_dict[c] += 1
    else:
        char_dict[c] = 1

i = 0
char_dat = open("char.dat", "w")
for c in sorted(char_dict.items(), key=operator.itemgetter(1)):
    i += 1
    char_dat.write((str(i) + " " + c[0] + " " + str(c[1]) + "\n").encode("utf-8"))

i = 0
modkeys_dat = open("mod.dat", "w")
for m in sorted(modkeys_dict.items(), key=operator.itemgetter(1)):
    i += 1
    modkeys_dat.write(str(i) + " " + (str(m[0]).replace(" ", "<space>") + " " + str(m[1])).replace("\n", "<enter>") + "\n")

