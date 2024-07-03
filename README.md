# Lua CLI Starter

Build standalone executable CLIs with Lua

## Overview

This project acts as a starting point for building command line apps with Lua. It comes with a simple "Hello World" app that demonstrates some basic argument parsing.

## Usage

To use this repo...

- Clone the repo to your machine
- Rename `/src/app.lua` to `/src/{your app name}.lua`
- Replace all instances of `app` in the Makefile and all scripts with your app name
- Then build your app inside of `/src`!

When you want to build the app, simply run `make build`. This will create an executable inside `/build`

## References

- [LuaRocks](https://luarocks.org/) - Lua package manager
- [Lua Static](https://github.com/ers35/luastatic) - Build executables from Lua modules

