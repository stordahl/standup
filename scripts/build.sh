#!/usr/bin/env bash

# I use brew to manage deps on Ubuntu. 
# I'm sure you don't.
# See the lua static docs to figure out the 
# right values to pass on line 13

rm -rf build
mkdir build

luastatic \
  standup.lua \
	standup/init.lua \
  standup/core.lua \
  standup/db.lua \
  standup/string.lua \
  standup/utils.lua \
	$(brew --prefix lua)/lib/liblua.a -I$(brew --prefix lua)/include/lua \
	-o build/standup

mv standup.luastatic.c build/
