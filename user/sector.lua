-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

sector = {}

-------------------------------------------------------------------------------

function sector:create(file)
  -- create the new sector
  local sec = ((type(file) == "string" and dofile(REGION_D..file)) or file)
  -- make sure it loaded
  if not sec or type(sec) ~= "table" then
    return nil
  else
    -- set the sector id
    sec.id = ((type(file) == "string" and file) or "???")
    -- inherit methods
    inherit(sec, sector)
    -- set up flags
    sec.flags = flags:create(sec.flags)
    -- set up triggers
    sec.trigger = trigger
    -- load objects
    if not sec.objects then
      -- create a table for objects
      sec.objects = {n = 0}
    else
      -- copy the object id's
      local objects = sec.objects
      -- create a table for objects
      sec.objects = {n = 0}
      -- loop through the object id's
      for i = 1, getn(objects) do
        -- create the object
        local obj = object:create(objects[i])
        -- check if it loaded
        if not obj or type(obj) ~= "table" then
          error(sec.id..": error loading object "..objects[i])
        else
          -- add object to sector
          sec:add_object(obj)
        end
      end
    end
    -- load mobiles
    if not sec.mobiles then
      -- create a table for mobiles
      sec.mobiles = {n = 0}
    else
      -- copy the mobile id's
      local mobiles = sec.mobiles
      -- create a table for mobiles
      sec.mobiles = {n = 0}
      -- loop through the mobile id's
      for i = 1, getn(mobiles) do
        -- load the mobile
        local mob = mobile:create(mobiles[i])
        -- check if it loaded
        if not mob or type(mob) ~= "table" then
          error(sec.id..": error loading mobile "..mobiles[i])
        else
          -- add mobile to sector
          sec:add_mobile(mob)
        end
      end
    end
    -- return the new sector
    return sec
  end
end

function sector:destroy()
  -- copy the objects
  local objects = copy(self.objects)
  -- loop through the objects
  for i = 1, objects.n do
    -- destroy the object
    objects[i]:destroy()
  end
  -- copy the mobiles
  local mobiles = copy(self.mobiles)
  -- loop through the mobiles
  for i = 1, mobiles.n do
    -- destroy the mobile
    mobiles[i]:destroy()
  end
  -- remove ourself from our parent
  self.parent:rem_sector(self)
end

-------------------------------------------------------------------------------

function sector:get_portal(str)
  -- not case sensitive
  str = strlower(str)
  -- loop through the portals
  for i = 1, getn(self.portals) do
    -- compare the names
    if str == self.portals[i][1] then
      -- return the portal
      return self.portals[i]
    end
  end
end

-------------------------------------------------------------------------------

function sector:add_object(obj)
  -- link object to sector
  obj.parent = self
  -- add object to sector
  tinsert(self.objects, obj)
end

function sector:rem_object(obj)
  -- loop through the objects
  for i = 1, self.objects.n do
    -- compare references
    if obj == self.objects[i] then
      -- unlink object from sector
      obj.parent = nil
      -- remove object from sector
      return tremove(self.objects, i)
    end
  end
end

function sector:get_object(str)
  -- not case sensitive
  str = strlower(str)
  -- loop through the objects
  for i = 1, self.objects.n do
    -- check for a match in the short description
    if strfind(self.objects[i].short, str, 1, 1) then
      -- return the object
      return self.objects[i]
    end
  end
end

-------------------------------------------------------------------------------

function sector:add_mobile(mob)
  -- link mobile to sector
  mob.parent = self
  -- add mobile to sector
  tinsert(self.mobiles, mob)
end

function sector:rem_mobile(mob)
  -- loop through the mobiles
  for i = 1, self.mobiles.n do
    -- compare references
    if mob == self.mobiles[i] then
      -- unlink mobile from sector
      mob.parent = nil
      -- remove mobile from sector
      return tremove(self.mobiles, i)
    end
  end
end

function sector:get_mobile(str)
  -- not case sensitive
  str = strlower(str)
  -- loop through the mobiles
  for i = 1, self.mobiles.n do
    -- check for a match in the short description
    if strfind(self.mobiles[i].short, str, 1, 1) then
      -- return the mobile
      return self.mobiles[i]
    end
  end
end

-------------------------------------------------------------------------------

function sector:output(str, ...)
  -- are there any mobiles we should ignore?
  if arg.n > 0 then
    -- loop through each mobile in this sector
    for i = 1, self.mobiles.n do
      -- if they are in the ignore list, don't send the string to them
      if not isin(self.mobiles[i], arg) then
        -- they are not in the list, send them the string
        self.mobiles[i]:output(str)
      end
    end
  -- just send the string to every mobile
  else
    -- loop through all the mobiles
    for i = 1, self.mobiles.n do
      -- send the output to this mobile
      self.mobiles[i]:output(str)
    end
  end
end
