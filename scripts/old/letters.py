#!/bin/python

import json
import operator
from pprint import pprint

with open('/home/adam/letters.json') as f:
    data = json.load(f)

data_iter = []
for key in data:
    tup = (key, data[key])
    data_iter.append(tup)

data_sorted = sorted(data_iter, key=lambda x: x[1], reverse=True)

for i in range(len(data_sorted)):
    print(str(i) + " " + data_sorted[i][0] + " " + str(data_sorted[i][1]))
