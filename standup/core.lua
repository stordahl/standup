local db           = require 'standup.db'
local utils        = require 'standup.utils'

local str_fmt      = string.format
local table_concat = table.concat
local table_insert = table.insert

local _M = {}


-- Returns all available CLI options
--
function _M.get_available_opts()
  local t = {
    help    = { flags = {'help'},
                help_text = 'List all commands'},
    version = { flags = {'-v'},
                help_text = 'Show version information'},
    init    = { flags = {'init'},
                help_text = 'Create a new sqlite db in ~/.standup'},
    ls      = { flags = {'ls'},
                help_text = 'List all groups. Pass a group id to list all items in that group.'},
    add     = { flags = {'add'},
                help_text = 'Add a group or an item.'},
    clean   = { flags = {'clean'},
                help_text = 'Remove all items in a group'},
    rm      = { flags = {'rm'},
                help_text = 'Remove group. Pass an item id to remove a single item'}
  }
  return t
end

-- Returns CLI option which matches one of the available options defined
-- in `get_available_opts` function
--
function _M.get_opt(args)
  --if #args == 1 then -- option can only be a single argument
    for opt_label, opt in pairs(_M.get_available_opts()) do
      for _, flag in pairs(opt['flags']) do
        if flag == args[1] then return opt_label end
      end
    end
  --end

  return nil
end

-- Calls standup module function with the following name: `run_{opt_name}_opt`
--
function _M.run_opt(t)
  return _M['run_' .. t.opt .. '_opt'](t)
end

-- Prints version information to the screen
--
function _M.run_version_opt(_)
  print(str_fmt('standup version: %s', utils.get_version()))
end

-- Prints help message
--
function _M.run_help_opt(_)
  print(_M.get_help_str())
end

-- Prints error message to the screen
--
function _M.print_err(err)
  print(str_fmt('standup: %s\nSee \'standup -h\' or \'standup --help\'', err))
end

-- Returns the usage text using the definition table
-- from the `get_available_opts` function
--
function _M.get_help_str()
  local t = {
    'standup - brain dumping on the command line\n\n',
    'Usage:\n',
    '  # list all groups\n  standup ls \n\n',
    '  # list all items in a group \n  standup ls [group]\n\n',
    '  # add a new group\n  standup add [group]\n\n',
    '  # add a new item to a group\n standup add [group] [item]\n\n',
  }

  table_insert(t, '\nCommands:')

  for _, opt in pairs(_M.get_available_opts()) do
    local flags = table_concat(opt['flags'], ', ')
    table_insert(t, str_fmt('\n  %s\t%s', flags, opt['help_text']))
  end

  return table_concat(t)
end

function _M.run_init_opt(_)
  db.init_db()
end

function _M.run_ls_opt(t)
  if #t.args == 1 then return db.list_groups() end
  if #t.args == 2 then return db.list_group_items(t.args[2]) end
  _M.print_err("Invalid Arguments. See standup --help")
end

function _M.run_add_opt(t)
  if #t.args == 2 then
    local name = t.args[2]
    print("Creating group " .. name)
    return db.add_group(name)
  end
  if #t.args == 3 then
    return db.add_group_item(t.args[2], t.args[3])
  end
  _M.print_err("Invalid Arguments. See standup --help")
end

function _M.run_clean_opt(t)
  if #t.args == 2 then
    local name = t.args[2]
    return db.clean_group(name)
  end
  _M.print_err("Invalid Arguments. See standup --help")
end

function _M.run_rm_opt(t)
  if #t.args == 2 then
    return db.rm_group(t.args[2])
  end
  if #t.args == 3 then
    return db.rm_group_item(t.args[2], t.args[3])
  end
  _M.print_err("Invalid Arguments. See standup --help")
end

return _M
