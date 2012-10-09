-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_commands(self, args)
  -- buffer for output
  local buffer = "{W}Available commands:{X}\r\n "
  -- loop through the main command table
  for i = 1, getn(commands) do
    -- show the command name
    buffer = buffer.." "..commands[i][1]
  end
  -- send the output
  self:output(buffer)
end
