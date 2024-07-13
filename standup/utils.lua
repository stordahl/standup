local io           = io
local io_open      = io.open
local io_popen     = io.popen
local io_close     = io.close
local str_gsub     = string.gsub

local _M = {}

function _M.file_exists(path)
  local f = io_open(path, 'r')
  if f ~= nil then io_close(f) return true
  else return false end
end

-- https://stackoverflow.com/a/326715/6817428
function _M.os_capture_exec(cmd)
  local f = assert(io_popen(cmd, 'r'))
  local s = assert(f:read('*a'))

  f:close()

  s = str_gsub(s, '^%s+', '')
  s = str_gsub(s, '%s+$', '')
  s = str_gsub(s, '[\n\r]+', ' ')

  return s
end

function _M.get_rockspec_filename()
  return _M.os_capture_exec('find *.rockspec')
end

function _M.get_version()
  local rockspec = {}
  local chunk, err = loadfile(_M.get_rockspec_filename(), 't', rockspec)

  if not err and chunk then
    chunk()
    return rockspec['version']
  end
end

function _M.get_table_keys(t)
  local _table = {}
  for k,_ in pairs(t) do
    table.insert(_table, k)
  end
  return _table
end

return _M
