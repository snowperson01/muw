-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_who(self, args)
  -- buffer for output
  local buffer = "{W}Players online:{X}"
  -- list players that are online and playing
  for i = 1, server.clients.n do
    if server.clients[i].state == "PLAYING" then
      local mob = server.clients[i].mobile
      -- show player's name
      buffer = buffer.."\r\n  "..mob.name
      -- show ip address
      buffer = buffer.." ({x}"..server.clients[i].ip
      -- show idle time
      buffer = buffer..", idle "..round(server.clients[i].idle / TPS).."s{X})"
    end
  end
  -- send the output
  self:output(buffer)
end
