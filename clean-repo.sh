#!/bin/bash

# Just a simple repo cleaner script for the lazy (like me)

rm Makefile cmake_install.cmake CMakeCache.txt 2> /dev/null
rm -rf CMakeFiles 2> /dev/null

# Vita specific
rm *.velf *.vpk *.self *suprx *skprx 2> /dev/null
