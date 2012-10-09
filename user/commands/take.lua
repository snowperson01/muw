-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_take(self, args)
  -- get arguments
  args = tokenize(args)
  -- check arguments
  if not args[1] or args[1] == "" then
    self:output("What do you want to take?")
  else
    -- search for the object
    local obj = self.parent:get_object(args[1])
    -- did we find anything?
    if not obj then
      self:output("You don't see that here.")
    else
      -- check if object is fixed
      if obj.flags:isset(fFIXED) then
        self:output("You can't take that.")
      else
        if not obj:trigger("take", self) then
          -- take object out of sector
          obj.parent:rem_object(obj)
          -- put object in objects
          self:add_object(obj)
          -- send the output
          self:output("You take "..obj.name..".")
          self.parent:output(cap(self.name).." takes "..obj.name..".", self)
        end
      end
    end
  end
end
