-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_put(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    self:output("What do you want to put, and where?")
  else
    -- find the object
    local obj = self:get_object(args[1])
    -- did we find anything?
    if not obj then
      self:output("You do not seem to have that.")
    else
      -- check second argument
      if not args[2] or args[2] == "" then
        self:output("What do you want to put that in?")
      else
        -- find container using second arg (items, sector)
        local ctr = self:get_object(args[2]) or self.parent:get_object(args[2])
        -- did we find anything?
        if not ctr then
          self:output("You do not see that anywhere.")
        else
          -- check if it's a container
          if not ctr.objects then
            self:output("You can't put anything in "..ctr.name..".")
          else
            -- is it closed?
            if ctr.flags:isset(fCLOSED) then
              self:output(cap(ctr.name).." is closed.")
            else
              if not ctr:trigger("put", self, obj) then
                -- take object out of our inventory
                self:rem_object(obj)
                -- put object into container
                ctr:add_object(obj)
                -- send the output
                self:output("You put "..obj.name.." in "..ctr.name..".")
                self.parent:output(cap(self.name).." puts "..obj.name.." in "..ctr.name..".", self)
              end
            end
          end
        end
      end
    end
  end
end
