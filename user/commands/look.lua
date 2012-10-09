-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_look(self, args)
  -- get arguments
  args = tokenize(args)
  -- check first argument
  if not args[1] or args[1] == "" then
    -- try lookat trigger
    if not self.parent:trigger("lookat", self) then
      -- buffer for output
      local buffer
      -- title and description
      buffer = "{Y}( {W}"..self.parent.name.." {Y}){X}\r\n"
      buffer = buffer..self.parent.short
      -- loop through each object
      for i = 1, self.parent.objects.n do
        -- show the short description of the object
        buffer = buffer.." {G}"..self.parent.objects[i].short.."{X}"
      end
      -- loop through each mobile
      for i, mob in self.parent.mobiles do
        -- ignore n, don't show us
        if i ~= "n" and mob ~= self then
          -- show the short description of the mobile
          buffer = buffer.." {P}"..mob.short.."{X}"
        end
      end
      -- does this room have any portals?
      if getn(self.parent.portals) > 0 then
        -- print portal bracket thingy
        buffer = buffer.."\r\n{Y}( {W}"
        -- print the name of each portal
        for i = 1, getn(self.parent.portals) do
          buffer = buffer..self.parent.portals[i][1].." "
        end
        -- cap off the portal list
        buffer = buffer.."{Y}){X}"
      end
      -- send the output
      self:output(buffer)
    end
  -- look at or in something
  else
    -- check if first argument is "in"
    if args[1] == "in" then
      -- check for second argument
      if not args[2] or args[2] == "" then
        self:output("What do you want to look in?")
      else
        -- search for the object
        local obj = self.parent:get_object(args[2]) or self:get_object(args[2])
        -- did we find anything?
        if not obj then
          self:output("You don't see that anywhere.")
        -- can this object contain other objects?
        elseif not obj.objects then
          self:output(cap(obj.name).." is not a container.")
        -- print the contents of this object
        else
          -- is it closed?
          if obj.flags:isset(fCLOSED) then
            self:output(cap(obj.name).." is closed.")
          else
            -- try lookin trigger
            if not obj:trigger("lookin", self) then
              local buffer = "{W}"..cap(obj.name).." contains:{X}"
              -- print the short description of each object
              for i = 1, obj.objects.n do
                buffer = buffer.."\r\n  "..obj.objects[i].name
              end
              -- send the output
              self:output(buffer)
              self.parent:output(cap(self.name).." looks in "..obj.name..".", self)
            end
          end
        end
      end
    else
      -- first, try a portal
      local entity = self.parent:get_portal(args[1])
      -- did we find anything?
      if not entity then
        -- check for a mobile, an object in the sector, then an object in our inventory
        local entity = self.parent:get_mobile(args[1]) or self.parent:get_object(args[1]) or self:get_object(args[1])
        -- did we find one?
        if not entity or entity == self then
          self:output("You don't see that anywhere.")
        else
          -- send the output
          self.parent:output(cap(self.name).." looks at "..entity.name..".", self, entity)
          entity:output(cap(self.name).." looks at you.")
          -- try lookat trigger
          if not entity:trigger("lookat", self) then
            -- print its long description
            self:output(entity.long)
          end
        end
      else
        -- show sector we looked at the portal
        self.parent:output(cap(self.name).." looks "..entity[1]..".", self)
        -- does this portal have a description?
        if not entity[3] or entity[3] == "" then
          self:output("You don't see anything significant there.")
        else
          -- send the description
          self:output(entity[3])
        end
      end
    end
  end
end
