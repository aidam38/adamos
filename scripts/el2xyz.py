#!/bin/python
# Convert from orbital elements to xyz position
"""http://ccar.colorado.edu/asen5070/handouts/kep2cart_2002.doc"""
__author__ = "Adam Krivka"

import sys
import os
from math import *

def kepler(M, e):
    """Solution of Kepler equation"""
    eps = 1E-13
    E2 = M+e*sin(M)
    while True:
        E1 = E2
        E2 = M+e*sin(E1)
        if abs(E2-E1)<eps:
            break 
    return E2

def el2xyz(path):
    """Conversion from orbital elements to xyz positions (from file bin.out by script follow2)"""
    binout = open(path, 'r')
    line = binout.readline()
    while line:
        elms = line.split()
        if int(elms[0]) > 0:
            a = float(elms[2])
            e = float(elms[3])
            inc = radians(float(elms[4]))
            capom = radians(float(elms[5]))
            omega = radians(float(elms[6]))
            M = radians(float(elms[7]))
    
            # E = M + (e-pow(e,3.0)/8.0)*sin(M) + pow(e,2)/2.0*sin(2.0*M) + pow(e,3)*3.0/8.0*sin(3.0*M)
            E = kepler(M, e)
            f = 2.0*atan(sqrt((1.0+e)/(1.0-e))*tan(E/2.0))
            r = a*(1-e*cos(E))
            x = r*(cos(capom)*cos(omega+f)-sin(capom)*sin(omega+f)*cos(inc))
            y = r*(sin(capom)*cos(omega+f)+cos(capom)*sin(omega+f)*cos(inc))
            z = r*sin(inc)*sin(omega+f)
            print (str(x) + " " + str(y) + " " + str(z))
        line = binout.readline()

def main():
    if (len(sys.argv) >= 2):
        el2xyz(sys.argv[1])
    else:
        print "Usage el2xyz.py infile"

if __name__ == "__main__":
    main()
