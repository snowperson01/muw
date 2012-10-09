-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

-- type: talk (mobile)
-- vars: mobile.cost = number (cost to stay at inn)
-- note:

function innkeeper_talk(self, arg)
  local mob = arg[1]
  -- send the output
  mob:output(cap(self.name).." says, \"Howdy! $"..self.cost.." per night! Wanna stay?\"")
  -- break
  return not nil
end


-- type: command (mobile)
-- vars: mobile.cost = number (cost to stay at inn)
-- note:

function innkeeper_command(self, arg)
  local mob = arg[1]
  local cmd = arg[2]
  local args = arg[3]
  -- check command
  if strfind("stay", cmd, 1, 1) == 1 then
    -- do we have enough money?
    if mob.money < self.cost then
      mob:output(cap(self.name).." says, \"You don't have enough money!\"")
    else
      -- subtract the money
      mob.money = mob.money - self.cost
      -- send the output
      mob:output("You stay and rest...")
      mob:output(cap(self.name).." says, \"Thank you, come again!\"")
    end
    -- break
    return not nil
  else
    -- continue
    return nil
  end
end
