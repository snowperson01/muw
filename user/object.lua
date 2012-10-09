-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

object = {}

-------------------------------------------------------------------------------

function object:create(file)
  -- create the new object
  local obj = ((type(file) == "string" and dofile(OBJECT_D..file)) or file)
  -- make sure it loaded
  if not obj or type(obj) ~= "table" then
    return nil
  else
    -- set the object id
    obj.id = ((type(file) == "string" and file) or "???")
    -- inherit methods
    inherit(obj, object)
    -- set up flags
    obj.flags = flags:create(obj.flags)
    -- set up triggers
    obj.trigger = trigger
    -- load objects
    if obj.objects then
      -- copy the object id's
      local objects = obj.objects
      -- create a table for objects
      obj.objects = {n = 0}
      -- loop through the object id's
      for i = 1, getn(objects) do
        -- create the object
        local objin = object:create(objects[i])
        -- check if it loaded
        if not objin or type(objin) ~= "table" then
          error(obj.id..": error loading object "..objects[i])
        else
          -- add object to object
          obj:add_object(objin)
        end
      end
    end
    -- return the new object 
    return obj
  end
end

function object:destroy()
  if self.objects then
    -- copy the objects
    local objects = copy(self.objects)
    -- loop through the objects
    for i = 1, objects.n do
      -- destroy the object
      objects[i]:destroy()
    end
  end
  -- remove object from parent
  self.parent:rem_object(self)
end

-------------------------------------------------------------------------------

function object:add_object(obj)
  if self.objects then
    -- link object to object
    obj.parent = self
    -- add object to object
    tinsert(self.objects, obj)
  end
end

function object:rem_object(obj)
  if self.objects then
    -- loop through the objects
    for i = 1, self.objects.n do
      -- compare references
      if obj == self.objects[i] then
        -- unlink object from object
        obj.parent = nil
        -- remove object from object
        return tremove(self.objects, i)
      end
    end
  end
end

function object:get_object(str)
  if self.objects then
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
end

-------------------------------------------------------------------------------

function object:output()
end
