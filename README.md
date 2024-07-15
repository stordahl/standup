# standup

Brain dumping on the command line.

## Motivation

I often struggle to keep track of disparate notes, particularly related to recurring meetings I have. I created standup to solve this problem. Standup allows you to easily create groups of notes, stored in a local SQLite database. 

## Usage

```bash
# print help
standup
standup --help

# init
standup init # create a new sqlite db in ~/.standup

# ls
standup ls # prints all groups
stand ls [group] # prints all items in a group

# add
standup add [group] # add a new group
standup add [group] [item] # add an item to a group

# clean
standup clean [group] # remove all items from a group

# rm
standup rm [group] # removes an entire group
standup rm [group] [id] 
```

## Installation

> The binary and build system has only been tested on Linux (Ubuntu Server 22.04.3)

To install the latest version of standup, run the following command.

```bash
curl -s https://raw.githubusercontent.com/stordahl/standup/main/scripts/install.sh | bash
```

### Build from source

To build from source, you'll need 
- [Lua](https://www.lua.org/download.html)
- [LuaRocks](https://luarocks.org/)
- [Lua Static](https://github.com/ers35/luastatic?tab=readme-ov-file)
- [LuaSQLite3](http://lua.sqlite.org/index.cgi/home)

Once the deps are installed, clone the repo and run

```bash
make install-local
```

## References

- [LuaRocks](https://luarocks.org/) - Lua package manager
- [Lua Static](https://github.com/ers35/luastatic) - Build executables from Lua modules

