#!/bin/python
import sys
import os
from math import *

binout = open('/home/adam/soc/swift_eunomia/eunomia/eunomia_001/bin.out', 'r')
id = sys.argv[1]
out = ""

line = binout.readline()
while line:
    elms = line.split()
    if (elms[0] == id):
        a = float(elms[2])
        e = float(elms[3])
        i = radians(float(elms[4]))
        O = radians(float(elms[5]))
        o = radians(float(elms[6]))
        M = radians(float(elms[7]))

        E = M + (e-pow(e,3)/8)*sin(M) + pow(e,2)/2*sin(2*M) + pow(e,3)*3/8*sin(3*M)
        f = 2*atan(sqrt((1+e)/(1-e))*tan(E/2))
        r = a*(1-e*cos(E))
        x = r*(cos(O)*cos(o+f)-sin(O)*sin(o+f)*cos(i))
        y = r*(sin(O)*cos(o+f)-cos(O)*sin(o+f)*cos(i))
        z = r*(sin(i)*sin(o+f))
        out += str(x) + " " + str(y) + " " + str(z) + "\n"
    line = binout.readline()

xyz = open(os.getcwd() + "/xyz" + str(id), "w")
xyz.write(out)
