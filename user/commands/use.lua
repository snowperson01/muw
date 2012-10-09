-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_use(self, args)
  -- get arguments
  args = tokenize(args)
  -- check argument
  if not args[1] or args[1] == "" then
    self:output("What do you want to use?")
  else
    -- search for the object
    local obj = self:get_object(args[1])
    -- did we find anything?
    if not obj then
      self:output("You don't seem to have that.")
    else
      -- remove first argument
      tremove(args, 1)
      -- try use trigger
      if not obj:trigger("use", self, args) then
        self:output("You can't use that.")
      end
    end
  end
end
