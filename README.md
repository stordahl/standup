# standup

Brain dumping on the command line.

## Motivation

I often struggle to keep track of disparate notes, particularly related to recurring meetings I have. I created standup to solve this problem. Standup allows you to easily create groups of notes, stored on a local SQLite database. 

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

## References

- [LuaRocks](https://luarocks.org/) - Lua package manager
- [Lua Static](https://github.com/ers35/luastatic) - Build executables from Lua modules

