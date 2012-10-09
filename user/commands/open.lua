-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_open(self, args)
  -- get arguments
  args = tokenize(args)
  -- check arguments
  if not args[1] or args[1] == "" then
    self:output("What do you want to open?")
  else
    -- search for object (items, sector)
    local obj = self:get_object(args[1]) or self.parent:get_object(args[1])
    -- did we find anything?
    if not obj then
      self:output("You do not see that anywhere.")
    else
      -- is it already open?
      if obj.flags:isset(fOPEN) then
        self:output(cap(obj.name).." is already open.")
      else
        -- is it closed, then?
        if not obj.flags:isset(fCLOSED) then
          -- it's not open/closeable
          self:output("You can't open "..obj.name..".")
        else
          -- try open trigger
          if not obj:trigger("open", self) then
            -- unset the closed flag
            obj.flags:unset(fCLOSED)
            -- set the open flag
            obj.flags:set(fOPEN)
            -- send the output
            self:output("You open "..obj.name..".")
            self.parent:output(cap(self.name).." opens "..obj.name..".", self)
          end
        end
      end
    end
  end
end
