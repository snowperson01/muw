-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

mobile = {}

-------------------------------------------------------------------------------

function mobile:create(file)
  -- create the new mobile
  local mob = ((type(file) == "string" and dofile(MOBILE_D..file)) or file)
  -- make sure it loaded
  if not mob or type(mob) ~= "table" then
    return nil
  else
    -- set the mobile id
    mob.id = ((type(file) == "string" and file) or "???")
    -- inherit methods
    inherit(mob, mobile)
    -- set up flags
    mob.flags = flags:create(mob.flags)
    -- set up triggers
    mob.trigger = trigger
    -- load objects
    if not mob.objects then
      -- create a table for objects
      mob.objects = {n = 0}
    else
      -- copy the object id's
      local objects = mob.objects
      -- create a table for objects
      mob.objects = {n = 0}
      -- loop through the object id's
      for index, value in objects do
        -- create the object
        local obj = object:create(objects[index])
        -- check if it loaded
        if not obj or type(obj) ~= "table" then
          error(file..": error loading object "..objects[index])
        else
          mob:add_object(obj)
        end
      end
    end
    -- money
    mob.money = mob.money or 0
    -- queue the first update
    mob._update = event:queue(1, mob, mob.update)
    -- try create trigger
    mob:trigger("create")
    -- return the new mobile
    return mob
  end
end

function mobile:destroy()
  -- copy the objects
  local objects = copy(self.objects)
  -- loop through the objects
  for i = 1, objects.n do
    -- destroy the object
    objects[i]:destroy()
  end
  -- remove ourself from our parent
  if self.parent and type(self.parent) == "table" then
    self.parent:rem_mobile(self)
  end
  -- dequeue our update
  event:dequeue(self._update)
end

-------------------------------------------------------------------------------

function mobile:add_object(obj)
  -- link object to mobile
  obj.parent = self
  -- add object to mobile
  tinsert(self.objects, obj)
end

function mobile:rem_object(obj)
  -- loop through the objects
  for i = 1, self.objects.n do
    -- compare references
    if obj == self.objects[i] then
      -- unlink object from mobile
      obj.parent = nil
      -- remove object from mobile
      return tremove(self.objects, i)
    end
  end
end

function mobile:get_object(str)
  -- not case sensitive
  str = strlower(str)
  -- loop through the objects
  for i = 1, self.objects.n do
    -- check for a match in the name
    if strfind(self.objects[i].name, str, 1, 1) then
      -- return the object
      return self.objects[i]
    end
  end
end

-------------------------------------------------------------------------------

function mobile:command(str)
  local cmd, args
  -- command shortcuts
  if strsub(str, 1, 1) == "'" then
    -- shortcut for say command
    cmd, args = "say", trim(strsub(str, 2))
  elseif strsub(str, 1, 1) == ";" then
    -- shortcut for emote command
    cmd, args = "emote", trim(strsub(str, 2))
  else
    -- separate the command and args
    cmd, args = next_token(str)
  end
  -- search the command table
  for i = 1, getn(commands) do
    if strfind(commands[i][1], cmd, 1, 1) == 1 then
      -- run the command
      return commands[i][2](self, args)
    end
  end
  -- search the socials table
  for i = 1, getn(socials) do
    if strfind(socials[i][1], cmd, 1, 1) == 1 then
      -- run the social command
      return social(self, socials[i], args)
    end
  end
  -- try command trigger on sector
  if self.parent:trigger("command", self, cmd, args) then
    return nil
  end
  -- try command trigger on objects
  for i = 1, self.objects.n do
    if self.objects[i]:trigger("command", self, cmd, args) then
      return nil
    end
  end
  -- try command trigger on objects in sector
  for i = 1, self.parent.objects.n do
    if self.parent.objects[i]:trigger("command", self, cmd, args) then
      return nil
    end
  end
  -- try command trigger on mobiles in sector
  for i = 1, self.parent.mobiles.n do
    if self.parent.mobiles[i]:trigger("command", self, cmd, args) then
      return nil
    end
  end
  -- command not found
  self:output("Unknown command. Type 'commands' for a list.")
end

-------------------------------------------------------------------------------

function mobile:output(str)
  -- is this a player?
  if self.client then
    self.client:output(str)
  end
end

-------------------------------------------------------------------------------

function mobile:update()
  -- queue another update
  self._update = event:queue(1, self, self.update)
end
