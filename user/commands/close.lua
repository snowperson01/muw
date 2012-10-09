-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_close(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    self:output("What do you want to close?")
  else
    -- search for the object (items, sector)
    local obj = self:get_object(args[1]) or self.parent:get_object(args[1])
    -- did we find anything?
    if not obj then
      self:output("You don't see that anywhere.")
    -- found something
    else
      -- is it already closed?
      if obj.flags:isset(fCLOSED) then
        self:output(cap(obj.name).." is already closed.")
      else
        -- is it open, then?
        if not obj.flags:isset(fOPEN) then
          -- not open or closed, then it can't be closed at all
          self:output("You can't close "..obj.name..".")
        -- it's open, try to close it
        else
          -- try close trigger
          if not obj:trigger("close", self) then
            -- remove the open flag
            obj.flags:unset(fOPEN)
            -- set the closed flag
            obj.flags:set(fCLOSED)
            -- send the output
            self:output("You close "..obj.name..".")
            self.parent:output(cap(self.name).." closes "..obj.name..".", self)
          end
        end
      end
    end
  end
end
