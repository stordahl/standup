local os           = os
local table_sort   = table.sort
local sql          = require('lsqlite3')
local string       = require('standup.string')
local utils        = require('standup.utils')
local inspect      = require('inspect')
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
  --_M.init_groups_table(db)
  --_M.init_items_table(db)
  db:close()
  print("Database Successfully created in " .. standup_dir)
end

function _M.init_groups_table(db)
  db:exec[=[
    CREATE TABLE groups(
      id INTEGER PRIMARY KEY,
      name STRING
    );
    INSERT INTO groups VALUES(1,"1:1");
    INSERT INTO groups VALUES(2,"standup");
  ]=]
end

function _M.init_items_table(db)
  db:exec[=[
    CREATE TABLE items(
      id INTEGER PRIMARY KEY,
      content STRING,
      group_id INTEGER,
      FOREIGN KEY(group_id) REFERENCES groups(id)
    );
    INSERT INTO items VALUES(1,"promotion",1);
    INSERT INTO items VALUES(2,"code review issues",1);
    INSERT INTO items VALUES(3,"deploying late", 2);
  ]=]
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

function _M.list_group_items(group_id)
  local db = sql.open(db_file_path)
  local group_name = ""

  for names in db:rows('SELECT name FROM groups WHERE id = ' .. group_id) do
    group_name = names[1]
  end

  local heading = '\nListing all items in group ' .. group_name .. '...'

  print(heading)
  string.print_line()

  for rows in db:nrows('SELECT * FROM items WHERE group_id = ' .. group_id) do
    table_sort(rows, function(a,b) return a < b end)
    for k, v in pairs(rows) do
      if k == "content" then print("- " .. v) end
    end
  end
  print("\n")
  db:close()
end

function _M.add_group()

end

return _M
