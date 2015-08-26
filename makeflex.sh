#!/bin/bash

flex -o$1.cpp $1.lex
g++ $1.cpp -o $1 -std=c++11
