-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_get(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    self:output("What do you want to get, and from where?")
  else
    -- check for second argument
    if not args[2] or args[2] == "" then
      self:output("What do you want to get that from?")
    else
      -- find container using second arg (items, sector)
      local ctr = self:get_object(args[2]) or self.parent:get_object(args[2])
      -- did we find anything?
      if not ctr then
        self:output("You don't see that anywhere.")
      else
        -- check if this is a container
        if not ctr.objects then
          self:output(cap(ctr.name).." is not a container.")
        else
          -- is it closed?
          if ctr.flags:isset(fCLOSED) then
            self:output(cap(ctr.name).." is closed.")
          else
            -- find object in container using first arg
            local obj = ctr:get_object(args[1])
            -- did we find anything?
            if not obj then
              self:output("You don't see that in "..ctr.name..".")
            else
              -- try get trigger
              if not ctr:trigger("get", self, obj) then
                -- take the object out of the container
                ctr:rem_object(obj)
                -- put the object into our inventory
                self:add_object(obj)
                -- send outputs
                self:output("You get "..obj.name.." from "..ctr.name..".")
                self.parent:output(cap(self.name).." gets "..obj.name.." from "..ctr.name..".", self)
              end
            end
          end
        end
      end
    end
  end
end
