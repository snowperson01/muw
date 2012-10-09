-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_emote(self, args)
  -- check first argument
  if not args or args == "" then
    self:output("What do you want to emote?")
  else
    -- send the output
    self.parent:output(cap(self.name).." "..args)
    -- try emote trigger on sector
    if not self.parent:trigger("emote", self, args) then
      -- try it on the objects
      local objects = copy(self.parent.objects)
      for i = 1, objects.n do
        if objects[i]:trigger("emote", self, args) then
          return not nil
        end
      end
      -- try it on the mobiles
      local mobiles = copy(self.parent.mobiles)
      for i = 1, mobiles.n do
        if mobiles[i]:trigger("emote", self, args) then
          return not nil
        end
      end
    end
  end
end
