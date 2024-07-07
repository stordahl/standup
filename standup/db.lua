local os           = os
local table_sort   = table.sort
local sql          = require('lsqlite3')
local string       = require('standup.string')
local utils        = require('standup.utils')
local standup_dir  = os.getenv("HOME") .. '/.standup/'
local db_file_name = 'standup.sqlite'
local db_file_path = standup_dir .. db_file_name
local inspect      = require('inspect')

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
  db:exec[=[ PRAGMA foreign_keys = ON; ]=]
  db:exec[=[
    CREATE TABLE IF NOT EXISTS groups(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name STRING
    );
    INSERT INTO groups (name) VALUES('1:1');
    INSERT INTO groups (name) VALUES('standup');
  ]=]
  db:exec[=[
    CREATE TABLE IF NOT EXISTS items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      content STRING,
      group_id INTEGER,
      FOREIGN KEY(group_id) REFERENCES groups(id)
    );
    INSERT INTO items (content, group_id) VALUES('promotion',1);
    INSERT INTO items (content, group_id) VALUES('code review issues',1);
    INSERT INTO items (content, group_id) VALUES('deploying late', 2);
  ]=]
  db:close()
  print("Database Successfully created in " .. standup_dir)
end

function _M.list_groups()
  local heading = '\nListing all groups...'

  local db = sql.open(db_file_path)

  print(heading)
  string.print_line()

  for rows in db:nrows('SELECT * FROM groups') do
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
  local db = sql.open(db_file_path)
  local heading = '\nListing all items in group ' .. group_name .. '...'

  print(heading)
  string.print_line()
  local group_id = 0

  db:exec('select id from groups where name =\'' .. group_name .. '\'', function(_, _, values, _)
    group_id = values[1]
  end)

  for rows in db:nrows('SELECT * FROM items WHERE group_id = \'' .. group_id .. '\'') do
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
  local db = sql.open(db_file_path)
  local query = "INSERT INTO groups(name) VALUES(?)"
  local stmt = db:prepare(query)
  stmt:bind_values(name)
  stmt:step()
  stmt:finalize()
  db:close()
end

function _M.add_group_item(group_name, content)
  local db = sql.open(db_file_path)
  local heading = '\nAdding item to group ' .. group_name .. '...'
  print(heading)
  local group_id = 0
  for rows in db:nrows('select id from groups where name = \'' .. group_name .. '\'') do
    for _, v in pairs(rows) do
      group_id = v
    end
  end
  local query = "insert into items(content, group_id) VALUES(?,?)"
  local stmt = db:prepare(query)
  stmt:bind_values(content, group_id)
  stmt:step()
  stmt:finalize()
  db:close()
end

function _M.clean_group(group_name)
  local db = sql.open(db_file_path)
  local heading = '\nCleaning group ' .. group_name .. '...'
  print(heading)
  local group_id = 0
  for rows in db:nrows('select id from groups where name = \'' .. group_name .. '\'') do
    for _, v in pairs(rows) do
      group_id = v
    end
  end
  db:exec('delete from items where group_id = \'' .. group_id .. '\'')
  db:close()
end


return _M
