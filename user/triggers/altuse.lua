-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

-- type: command (object)
-- vars:
-- note:

function eat_command(self, arg)
  local mob = arg[1]
  local cmd = arg[2]
  local args = arg[3]
  -- check command
  if strfind("eat", cmd, 1, 1) == 1 then
    -- get arguments
    args = tokenize(args)
    -- check arguments
    if not args[1] or args[1] == "" then
      mob:output("What do you want to eat?")
    else
      -- check for match in the name
      if strfind(self.name, args[1], 1, 1) then
        -- redirect to our use trigger
        self:trigger("use", mob)
      else
        mob:output("You can't eat that.")
      end
    end
    -- break
    return not nil
  else
    -- continue
    return nil
  end
end


-- type: command (object)
-- vars:
-- note:

function drink_command(self, arg)
  local mob = arg[1]
  local cmd = arg[2]
  local args = arg[3]
  -- check command
  if strfind("drink", cmd, 1, 1) == 1 then
    -- get arguments
    args = tokenize(args)
    -- check arguments
    if not args[1] or args[1] == "" then
      mob:output("What do you want to drink?")
    else
      -- check for match in the name
      if strfind(self.name, args[1], 1, 1) then
        -- redirect to our use trigger
        self:trigger("use", mob)
      else
        mob:output("You can't drink that.")
      end
    end
    -- break
    return not nil
  else
    -- continue
    return nil
  end
end
