-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_items(self, args)
  -- buffer for output
  local buffer = "{W}You are carrying:{X}"
  -- list each item in our inventory
  for i = 1, getn(self.objects) do
    buffer = buffer.."\r\n  "..self.objects[i].name
  end
  -- send the output
  self:output(buffer)
end
