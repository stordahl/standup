#!/usr/bin/env bash

# I use brew to manage deps on Ubuntu. 
# I'm sure you don't.
# See the lua static docs to figure out the 
# right values to pass on line 13

rm -rf build
mkdir build

luastatic \
	src/app.lua \
	$(brew --prefix lua)/lib/liblua.a -I$(brew --prefix lua)/include/lua \
	-o build/app

mv app.luastatic.c build/
