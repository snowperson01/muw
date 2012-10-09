-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_quit(self, args)
  -- tell server to disconnect us
  self.client.state = "DISCONNECT"
end
