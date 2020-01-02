#!/usr/bin/env python
import sys
import os
import re
import argparse

# setting command line arguments
parser = argparse.ArgumentParser()
parser.add_argument('-c', '--contents', action='store_true', help='print only contents of the snippet')
parser.add_argument('-d', '--desc', action='store_true', help='print only descs of the snippet\'s placeholders')
parser.add_argument('-r', '--repository', help='define alternative repository')
parser.add_argument('filetype:alias')

# parsing command line arguments
args = vars(parser.parse_args())
content = args['contents']
desc = args['desc']
repository = args['repository']
filetype = re.search("^.+(?=:)", args['filetype:alias']).group()
alias = re.search("(?<=:).+$", args['filetype:alias']).group()

# setting repository location
if(repository is not None):
	repository_location = repository
else:
	from snipsrc import *

# loading the correct snippet
for ft in os.listdir(repository_location):
	if(re.match("^" + ft + "$", filetype)):
		for snip in os.listdir(repository_location + "/" + ft):
			if(alias == snip.split(' - ')[0]):
				snippet = open(repository_location + "/" + ft + "/" + snip).read()

# snippet post-processing

def expand(matchobj):
	return ":" + os.popen(matchobj.group(1)).read().strip()

placeholders = []
placeholder_matcher = re.compile("\$\{\d+[:|!](.*?)\}|\$\d+")
while True:
	pl = placeholder_matcher.search(snippet)
	if(pl is None):
		break
	print(pl.group(1))
	# matching for shell expansions
	if (re.match("\$\{\d+!(.*?)\}", pl.group(0))):
		pl_new = re.sub(pl.group(1), expand, pl.group(0))
	elif (re.match("^\$\d+$", pl.group(0))):
		pl_new = re.sub("\$(\d+)", "${\g<1>:}", pl.group(0))
	else:
		pl_new = pl.group(0)

	print(pl_new)
	placeholder_id = int(re.search("(?<=\$\{)(\d+)(?=:.*\})", pl_new).group(0))
	while (placeholder_id + 1 > len(placeholders)):
		placeholders.append([])
	# matching for default values for placeholders and saving descs
	placeholders[placeholder_id].append( (pl.span()[0], pl.span()[0] + len(re.search("\$\{\d+:(.*)\}", pl_new).group(1))) )
	snippet = re.sub("\g<1>", snippet, 1)


# convert placeholder descs to line:character format
placeholders_linechar = []
line_lengths = []
length = 0
for char in list(snippet):
	length += 1
	if(char == "\n"):
		line_lengths.append(length)
		length = 0

for (i, placeholder) in enumerate(placeholders):

	for (j, place) in enumerate(placeholder):
		char = [place[0], place[1]]
		line = [0, 0]
		for (k, delimiter) in enumerate(place):
			for (l, length) in enumerate(line_lengths):
				char[k] -= length
				if(char[k] < 0):
					char[k] += length + 1
					line[k] = l + 1
					break
		while(i + 1 > len(placeholders_linechar)):
			placeholders_linechar.append([])
		placeholders_linechar[i].append(str(line[0]) + "." + str(char[0]) + "," + str(line[1]) + "." + str(char[1]))

if(content and not desc):
	print(snippet)
if(not content and desc):
	print(placeholders_linechar)
if((content and desc) or (not content and not desc)):
	print(snippet)
	print(placeholders_linechar)
