-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_go(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    self:output("Where do you want to go?")
  else
    -- search for the portal
    local ptl = self.parent:get_portal(args[1])
    -- did we find it?
    if not ptl then
      self:output("You can't go there.")
    else
      -- search for the sector it leads to
      local sec = world:get_sector(ptl[2])
      -- did we find it?
      if not sec then
        self:output("An invisible barrier blocks the way.")
      else
        -- try leave trigger on the sector
        if self.parent:trigger("leave", self, ptl[1]) then
          return not nil
        end
        -- try leave trigger on the objects
        local objects = copy(self.parent.objects)
        for i = 1, objects.n do
          if objects[i]:trigger("leave", self, ptl[1]) then
            return not nil
          end
        end
        -- try leave trigger on the mobiles
        local mobiles = copy(self.parent.mobiles)
        for i = 1, mobiles.n do
          if mobiles[i]:trigger("leave", self, ptl[1]) then
            return not nil
          end
        end
        -- are we fighting?
        if self.enemy then
          -- are we ready?
          if self.energy < 100 then
            self:output("You are not ready.")
            -- break
            return not nil
          else
            -- clear enemy links
            self.enemy:set_enemy(nil)
            self:set_enemy(nil)
          end
        end
        -- tell this sector we are leaving
        self.parent:output(cap(self.name).." goes "..ptl[1]..".", self)
        -- take us out of this sector
        self.parent:rem_mobile(self)
        -- put us in the new one
        sec:add_mobile(self)
        -- tell the new sector we have arrived
        self.parent:output(cap(self.name).." arrives"..from(ptl[1]), self)
        -- take a look around
        self:command("look")
        -- try the arrive trigger on the sector
        self.parent:trigger("arrive", self)
        -- and on the objects
        objects = copy(self.parent.objects)
        for i = 1, objects.n do
          objects[i]:trigger("arrive", self)
        end
        -- and the mobiles
        mobiles = copy(self.parent.mobiles)
        for i = 1, mobiles.n do
          mobiles[i]:trigger("arrive", self)
        end
      end
    end
  end
end
