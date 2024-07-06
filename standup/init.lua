local standup   = require 'standup.core'
local utils = require 'standup.utils'

local args       = arg

-- Attempt to retrieve a CLI argument option
local opt = standup.get_opt(args)

-- If no argument, or a `help` option -> print help message
if #args == 0 or (opt and opt == 'help') then standup.run_help_opt() return end

if opt then standup.run_opt { opt = opt, args = args } return end

