-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_shout(self, args)
  -- check argument
  if not args or args == "" then
    self:output("What do you want to shout?")
  else
    -- send the output
    self:output("You shout, \""..args.."\"")
    self.parent:output(cap(self.name).." shouts, \""..args.."\"", self)
    -- send the text to other sectors in this region
    for i = 1, self.parent.parent.sectors.n do
      if self.parent.parent.sectors[i] ~= self.parent then
        self.parent.parent.sectors[i]:output("Someone shouts, \""..args.."\"")
      end
    end
    -- try speech trigger on sector
    if not self.parent:trigger("speech", self, args) then
      -- try it on the objects
      local objects = copy(self.parent.objects)
      for i = 1, objects.n do
        if objects[i]:trigger("speech", self, args) then
          return not nil
        end
      end
      -- try it on the mobiles
      local mobiles = copy(self.parent.mobiles)
      for i = 1, mobiles.n do
        if mobiles[i]:trigger("speech", self, args) then
          return not nil
        end
      end
    end
  end
end
