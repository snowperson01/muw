-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

world = {}

-------------------------------------------------------------------------------

function world:create()
  -- create a table for regions
  self.regions = {n = 0}
  -- list the region directory
  local entries = lsdir(REGION_D)
  -- loop through each entry
  for i = 1, entries.n do
    -- load the region
    local rgn = region:create(entries[i])
    -- check if it loaded
    if not rgn or type(rgn) ~= "table" then
      error("world: error loading region "..entries[i])
    else
      -- add region to world
      self:add_region(rgn)
    end
  end
end

function world:destroy()
  -- copy the regions
  local regions = copy(self.regions)
  -- loop through each region
  for i = 1, regions.n do
    -- destroy the region
    regions[i]:destroy()
  end
end

-------------------------------------------------------------------------------

function world:add_region(rgn)
  -- link region to world
  rgn.parent = self
  -- add region to world
  tinsert(self.regions, rgn)
end

function world:rem_region(rgn)
  -- loop through the regions
  for i = 1, self.regions.n do
    -- compare references
    if rgn == self.regions[i] then
      -- unlink region from world
      rgn.parent = nil
      -- remove region from world
      return tremove(self.regions, i)
    end
  end
end

function world:get_region(str)
  -- loop through the regions
  for i = 1, self.regions.n do
    -- compare id strings
    if str == self.regions[i].id then
      -- return the region
      return self.regions[i]
    end
  end
end

-------------------------------------------------------------------------------

function world:get_sector(str)
  -- extract the region id string
  local junk, rid = chop(str, "%w+")
  -- search for the region
  local rgn = self:get_region(rid)
  -- does the region exist?
  if not rgn then
    return nil
  else
    -- search for the sector
    local sec = rgn:get_sector(str)
    -- does the sector exist?
    if not sec then
      return nil
    else
      -- return the sector
      return sec
    end
  end
end

-------------------------------------------------------------------------------

function world:output(str, ...)
  if arg.n > 0 then
    for i = 1, server.clients.n do
      if not isin(server.clients[i].mobile, arg) then
        if server.clients[i].state == "PLAYING" then
          server.clients[i]:output(str)
        end
      end
    end
  else
    for i = 1, server.clients.n do
      if server.clients[i].state == "PLAYING" then
        server.clients[i].mobile:output(str)
      end
    end
  end
end
