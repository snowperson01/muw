-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_socials(self, args)
  -- buffer for output
  local buffer = "{W}Available socials:{X}\r\n "
  -- loop through the social table
  for i = 1, getn(socials) do
    buffer = buffer.." "..socials[i][1]
  end
  -- send the output
  self:output(buffer)
end
