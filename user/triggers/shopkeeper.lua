-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

-- type: create (mobile)
-- vars: mobile.forsale = table (objects the mobile is selling)
-- note: creates the objects the mobile will be selling

function shopkeeper_create(self, arg)
  -- load objects
  if not self.forsale then
    -- create a table for objects
    self.forsale = {n = 0}
  else
    -- copy the object id's
    local objects = self.forsale
    -- create a table for objects
    self.forsale = {n = 0}
    -- loop through the object id's
    for index, value in objects do
      -- create the object
      local obj = object:create(objects[index])
      -- check if it loaded
      if not obj or type(obj) ~= "table" then
        error(file..": error loading object "..objects[index])
      else
        -- link object to mobile
        obj.parent = self
        -- add object to mobile
        tinsert(self.forsale, obj)
      end
    end
  end
end


-- type: talk (mobile)
-- vars:
-- note:

function shopkeeper_talk(self, arg)
  local mob = arg[1]
  -- send the output
  mob:output(cap(self.name).." says, \"Hello! May I help you?\"")
  -- break
  return not nil
end


-- type: command (mobile)
-- vars: mobile.forsale = table (objects the mobile is selling)
-- note: provides commands "buy" and "sell"

function shopkeeper_command(self, arg)
  local mob = arg[1] -- the mob that entered the command
  local cmd = strlower(arg[2] or "") -- the command that was entered
  local args = strlower(arg[3] or "") -- any arguments passed with the command
  -- check command
  if strfind("buy", cmd, 1, 1) == 1 then
    -- get arguments
    args = tokenize(args)
    -- check first argument
    if not args[1] or args[1] == "" then
      -- buffer for output
      local buffer = "{W}"..cap(self.name).." has for sale:{X}"
      -- list their inventory
      for i = 1, self.forsale.n do
        buffer = buffer.."\n  "..self.forsale[i].name..", $"..self.forsale[i].value
      end
      -- send the output
      mob:output(buffer)
    else
      local obj
      -- find the object
      for i = 1, self.forsale.n do
        if strfind(self.forsale[i].name, args[1], 1, 1) then
          obj = self.forsale[i]; break
        end
      end
      -- did we find anything?
      if not obj then
        mob:output(heshe(self).." doesn't sell that.")
      else
        -- check if we can afford it
        if mob.money < obj.value then
          mob:output("You don't have enough money.")
        else
          -- subtract the money
          mob.money = mob.money - obj.value
          -- clone the object and give it to us
          mob:add_object(object:create(obj.id))
          -- send the output
          mob:output("You buy "..obj.name..".")
          mob.parent:output(cap(mob.name).." buys "..obj.name..".", mob)
        end
      end
    end
    -- break
    return not nil
  elseif strfind("sell", cmd, 1, 1) == 1 then
    -- get arguments
    args = tokenize(args)
    -- check first argument
    if not args[1] or args[1] == "" then
      if mob.objects.n == 0 then
        mob:output("You don't have anything to sell.")
      else
        -- list the value of all our goods
        local buffer = "{W}The value of your items are:{X}"
        -- loop through each item
        for i = 1, mob.objects.n do
          buffer = buffer.."\n  "..mob.objects[i].name..", $"..round((mob.objects[i].value or 0) / 2)
        end
        -- send the buffer to the player
        mob:output(buffer)
      end
    else
      -- search for the object to sell
      local obj = mob:get_object(args[1])
      -- did we find anything?
      if not obj then
        mob:output("You don't seem to have that.")
      else
        -- is it worth anything?
        if not obj.value or obj.value == 0 then
          mob:output(cap(self.name).." says, \"I don't want that!\"")
        else
          -- reimburse half the value
          mob.money = mob.money + round(obj.value / 2)
          -- send the output
          mob:output("You sell "..obj.name..".")
          mob.parent:output(cap(mob.name).." sells "..obj.name..".", mob)
          -- destroy the object
          obj:destroy()
        end
      end
    end
    -- break
    return not nil
  else
    -- continue
    return nil
  end
end
