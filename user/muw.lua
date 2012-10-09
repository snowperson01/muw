#!../multi/lua

-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

dofile("support.lua")
dofile("options.lua")

dofile("event.lua")
dofile("flags.lua")
dofiles("triggers")
dofile("triggers.lua")

dofile("client.lua")
dofile("server.lua")

dofile("world.lua")
dofile("region.lua")
dofile("sector.lua")
dofile("object.lua")
dofile("mobile.lua")

dofiles("commands")
dofile("commands.lua")
dofile("socials.lua")

-- called by error() before bailing
function _ALERT(message)
  log(message)
  exit()
end

-- formats messages with date/time
function log(message)
  write(logfile, "("..date("%m.%d.%H.%M")..") "..message.."\n")
  write("("..date("%m.%d.%H.%M")..") "..message.."\n")
  flush(logfile)
end

-- PROGRAM START --------------------------------------------------------------

logfile = openfile(LOG_D..date("%m.%d.%H.%M"), "w+")
if not logfile then
  error("could not open logfile")
end

randomseed(time())
boottime = time()

world:create()
server:create()

running = not nil

while running do
  -- tables for timers
  local before = {}
  local after = {}
  -- get time before update
  before[1], before[2] = time()
  -- update the server
  server:update()
  -- update the events
  event:update()
  -- get time after update
  after[1], after[2] = time()
  -- calculate the amount of time left to sleep
  local naptime = (1000000 / TPS) - (1000000 * (after[1] - before[1])) - (after[2] - before[2])
  -- nap time, beddy bye!
  sleep(max(1, naptime))
end

server:destroy()
world:destroy()

-- PROGRAM END ----------------------------------------------------------------
