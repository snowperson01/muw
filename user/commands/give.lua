-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_give(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    self:output("What do you want to give, and to who?")
  else
    -- are we giving money?
    if tonumber(args[1]) then
      -- check for second argument
      if not args[2] or args[2] == "" then
        self:output("Who do you want to give that to?")
      else
        -- find mobile using second argument
        local mob = self.parent:get_mobile(args[2])
        -- did we find anyone?
        if not mob then
          self:output("You don't see them here.")
        -- is it us?
        elseif mob == self then
          self:output("You already have it.")
        else
          -- figure out how much we're giving (#)
          local amt = round(tonumber(args[1]))
          -- can we afford it?
          if amt > self.money then
            self:output("You don't have that much money.")
          else
            -- transfer the funds
            self.money = self.money - amt
            mob.money = mob.money + amt
            -- send the output
            self:output("You give $"..amt.." to "..mob.name..".")
            mob:output(cap(self.name).." gives you $"..amt..".")
            self.parent:output(cap(self.name).." gives "..mob.name.." some money.", self, mob)
            -- try give trigger
            mob:trigger("give", self, amt)
          end
        end
      end
    -- we are giving an object
    else
      -- find the object
      local obj = self:get_object(args[1])
      -- did we find anything?
      if not obj then
        self:output("You don't seem to have that.")
      else
        -- check for second argument
        if not args[2] or args[2] == "" then
          self:output("Who do you want to give that to?")
        else
          -- find mobile using second argument
          local mob = self.parent:get_mobile(args[2])
          -- did we find anyone?
          if not mob then
            self:output("You don't see them here.")
          -- is it us?
          elseif mob == self then
            self:output("You already have it.")
          else
            -- try give trigger
            if not obj:trigger("give", self, mob) then
              -- remove the object from our inventory
              self:rem_object(obj)
              -- put the object in their inventory
              mob:add_object(obj)
              -- send the outputs
              self:output("You give "..obj.name.." to "..mob.name..".")
              mob:output(cap(self.name).." gives you "..obj.name..".")
              self.parent:output(cap(self.name).." gives "..mob.name.." "..obj.name..".", self, mob)
              -- try give trigger
              mob:trigger("give", self, obj)
            end
          end
        end
      end
    end
  end
end
