#!/bin/bash
#

echo 'Your input is ' $1
echo 'Your outpur is ' $2

ase convert -i cp2k-restart -o xsd $1 $2
