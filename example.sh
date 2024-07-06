#!/bin/bash

# print help
standup
standup --help

# init
standup init # create a new sqlite db in ~/.standup

# ls
standup ls # prints all groups
stand ls [group] # prints all items in a group

# add
standup add [group] [item] # add an item to a group
standup add -g [group] # add a new group

# clean
standup clean [group] # remove all items from a group

# rm
standup rm group [id] # removes
standup rm item [id]
