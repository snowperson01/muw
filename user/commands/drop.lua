-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_drop(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    self:output("What do you want to drop?")
  else
    -- search for the object
    local obj = self:get_object(args[1])
    -- did we find anything?
    if not obj then
      self:output("You don't seem to have that.")
    else
      -- try drop trigger
      if not obj:trigger("drop", self) then
        -- remove object from inventory
        self:rem_object(obj)
        -- put object in the sector
        self.parent:add_object(obj)
        -- send the output
        self:output("You drop "..obj.name..".")
        self.parent:output(cap(self.name).." drops "..obj.name..".", self)
      end
    end
  end
end
