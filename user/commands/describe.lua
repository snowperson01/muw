-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_describe(self, args)
  -- check for argument
  if not args or args == "" then
    self:output("{W}Your current description is:{X}\r\n  "..self.long)
  else
    -- set the long description
    self.long = args.."{X}"
    -- show the description to them
    self:output("{W}Your new description is:{X}\r\n  "..self.long)
  end
end
