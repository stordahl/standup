local os           = os
local table_sort   = table.sort
local sql          = require('lsqlite3')
local string       = require('standup.string')
local utils        = require('standup.utils')
local standup_dir  = os.getenv("HOME") .. '/.standup/'
local db_file_name = 'standup.sqlite'
local db_file_path = standup_dir .. db_file_name

local _M = {}

function _M.init_db()
  if utils.file_exists(db_file_path) then
    print("DB already exists. Aborting!")
    return
  end
  print("Creating a database in " .. standup_dir)
  os.execute("mkdir " .. standup_dir)
  os.execute("cd " .. standup_dir)
  local db = sql.open(db_file_path)
  db:exec(_M.queries.enable_foreign_keys)
  db:exec(_M.queries.create_groups_table)
  db:exec(_M.queries.create_items_table)
  db:close()
  print("Database Successfully created in " .. standup_dir)
end

function _M.list_groups()
  string.print_heading('Listing all groups...')

  local db = sql.open(db_file_path)

  for rows in db:nrows(_M.queries.select_all_groups) do
    table_sort(rows, function(a,b) return a < b end)
    for k, v in pairs(rows) do
      print(k .. "\t", v)
    end
    string.print_line()
  end
  print("\n")
  db:close()
end

function _M.list_group_items(group_name)
  string.print_heading('Listing all items in group ' .. group_name .. '...')

  local db = sql.open(db_file_path)

  for rows in db:nrows(_M.queries.list_items(group_name)) do
    table_sort(rows, function(a,b) return a < b end)
    local id = 0
    local content = ''
    for k, v in pairs(rows) do
      if k == 'content' then content = v end
      if k == 'id' then id = v end
    end
    print('- ['.. id .. '] ' .. content)
  end
  print("\n")
  db:close()
end

function _M.add_group(name)
  print('Creating group ' .. name .. '...')
  local db = sql.open(db_file_path)
  local stmt = db:prepare(_M.queries.insert_group)
  stmt:bind_values(name)
  stmt:step()
  stmt:finalize()
  db:close()
end

function _M.add_group_item(group_name, content)
  print('Adding item to group ' .. group_name .. '...')

  local db = sql.open(db_file_path)

  local stmt = db:prepare(_M.queries.insert_item)
  stmt:bind_values(content, group_name)
  stmt:step()
  stmt:finalize()
  db:close()
end

function _M.clean_group(group_name)
  print('Cleaning group ' .. group_name .. '...')

  local db = sql.open(db_file_path)

  db:exec(_M.queries.delete_items_by_group(group_name))
  db:close()
end

function _M.rm_group(group_name)
  print('Removing group ' .. group_name .. '...')

  local db = sql.open(db_file_path)
  db:exec(_M.queries.delete_group(group_name))
  db:close()
end

function _M.rm_group_item(group_name, item_id)
  print('Removing item '.. item_id .. ' from group ' .. group_name .. '...')

  local db = sql.open(db_file_path)
  db:exec(_M.queries.delete_item_by_id(item_id))
  db:close()
end

_M.queries = {
  enable_foreign_keys = [=[ pragma foreign_keys = on; ]=],
  create_groups_table = [=[
    create table if not exists groups(
      id integer primary key autoincrement,
      name text not null
    );
    insert into groups (name) values('1:1');
    insert into groups (name) values('standup');
  ]=],
  create_items_table = [=[
    create table if not exists items(
      id integer primary key autoincrement,
      content text,
      group_name text,
      foreign key(group_name) references groups(name)
    );
    insert into items (content, group_name) values('promotion','1:1');
    insert into items (content, group_name) values('code review issues','1:1');
    insert into items (content, group_name) values('deploying late', 'standup');
  ]=],
  delete_item_by_id = function(item_id) return 'delete from items where id = \'' .. item_id .. '\'' end,
  delete_items_by_group = function(group_name) return 'delete from items where group_name = \'' .. group_name .. '\'' end,
  delete_group = function(group_name) return 'delete from groups where name = \'' .. group_name .. '\'' end,
  insert_item = 'insert into items(content, group_name) values(?,?)',
  insert_group = 'insert into groups(name) values(?)',
  list_items = function(group_name) return 'select * from items where group_name = \'' .. group_name .. '\'' end,
  select_all_groups = 'select * from groups'
}

return _M
