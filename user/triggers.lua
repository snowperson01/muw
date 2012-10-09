-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function trigger(self, ttype, ...)
  -- check if we have this trigger
  if self["t_"..ttype] then
    -- pass the args to the trigger function
    return self["t_"..ttype](self, arg)
  end
end
