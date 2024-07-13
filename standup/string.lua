local str_rep = string.rep

local _M = {}

function _M.print_line()
 print(str_rep('-', 40))
end

function _M.print_heading(heading)
  print('\n' .. heading)
  _M.print_line()
end

return _M
