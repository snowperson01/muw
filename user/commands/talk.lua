-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_talk(self, args)
  -- get arguments
  args = tokenize(args)
  -- check argument
  if not args[1] or args[1] == "" then
    self:output("Who do you want to talk to?")
  else
    -- search for the mobile
    local mob = self.parent:get_mobile(args[1])
    -- did we find anyone?
    if not mob then
      self:output("You don't see them here.")
    else
      -- try talk trigger
      if not mob:trigger("talk", self) then
        self:output(cap(mob.name).." doesn't have anything to say.")
      end
    end
  end
end
