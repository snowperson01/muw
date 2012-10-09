-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

region = {}

-------------------------------------------------------------------------------

function region:create(file)
  -- create the new region
  local rgn = {}
  -- set the region id
  rgn.id = file
  -- inherit methods
  inherit(rgn, region)
  -- create a table for sectors
  rgn.sectors = {n = 0}
  -- list the sectors
  local sectors = lsdir(REGION_D..rgn.id)
  -- loop through each entry
  for i = 1, sectors.n do
    -- load the sector
    local sec = sector:create(rgn.id.."/"..sectors[i])
    -- check if it loaded
    if not sec or type(sec) ~= "table" then
      error(rgn.id..": error loading sector "..sectors[i])
    else
      -- add sector to region
      rgn:add_sector(sec)
    end
  end
  -- return the new region
  return rgn
end

function region:destroy()
  -- copy the sectors
  local sectors = copy(self.sectors)
  -- loop through each sector
  for i = 1, sectors.n do
    -- destroy the sector
    sectors[i]:destroy()
  end
  -- remove ourself from our parent
  self.parent:rem_region(self)
end

-------------------------------------------------------------------------------

function region:add_sector(sec)
  -- link sector to region
  sec.parent = self
  -- add sector to region
  tinsert(self.sectors, sec)
end

function region:rem_sector(sec)
  -- loop through all the sectors
  for i = 1, self.sectors.n do
    -- compare references
    if sec == self.sectors[i] then
      -- unlink sector from region
      sec.parent = nil
      -- remove the sector
      return tremove(self.sectors, i)
    end
  end
end

function region:get_sector(str)
  -- loop through the sectors
  for i = 1, self.sectors.n do
    -- compare id strings
    if str == self.sectors[i].id then
      -- return the sector
      return self.sectors[i]
    end
  end
end

-------------------------------------------------------------------------------

function region:output(str, ...)
  if arg.n > 0 then
    for i = 1, server.clients.n do
      if not isin(server.clients[i].mobile, arg) then
        if server.clients[i].state == "PLAYING" then
          if self == server.clients[i].parent.parent then
            server.clients[i]:output(str)
          end
        end
      end
    end
  else
    for i = 1, server.clients.n do
      if server.clients[i].state == "PLAYING" then
        if self == server.clients[i].parent.parent then
          server.clients[i]:output(str)
        end
      end
    end
  end
end
