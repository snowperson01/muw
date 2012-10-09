-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

-- type: command (object)
-- vars:
-- note:

function computer_command(self, arg)
  local mob = arg[1]
  local cmd = arg[2]
  local args = arg[3]
  -- check command
  if strfind("echo", cmd, 1, 1) == 1 then
    -- check argument
    if not args or args == "" then
      mob:output("What do you want to echo to the sector?")
    else
      -- send the output
      mob.parent:output(args.."{X}")
    end
    -- break
    return not nil
  elseif strfind("goto", cmd, 1, 1) == 1 then
    -- get arguments
    args = tokenize(args)
    -- check first argument
    if not args[1] or args[1] == "" then
      mob:output("Who do you want to go to?")
    else
      local plr
      -- search for the player
      for i = 1, server.clients.n do
        -- make sure they are playing the game
        if server.clients[i].state == "PLAYING" then
          -- compare names
          if args[1] == server.clients[i].mobile.name then
            plr = server.clients[i].mobile; break
          end
        end
      end
      -- did we find them?
      if not plr then
        mob:output("Cannot find that player.")
      elseif plr == mob then
        mob:output("You already are where you are...")
      else
        -- remove us from our sector
        mob.parent:rem_mobile(mob)
        -- add us to their sector
        plr.parent:add_mobile(mob)
        -- send the output
        mob.parent:output("* Pop! *", mob)
      end
    end
    -- break
    return not nil
  elseif strfind("notice", cmd, 1, 1) == 1 then
    -- check argument
    if not args or args == "" then
      mob:output("What notice do you want to send?")
    else
      -- loop through the clients
      for i = 1, server.clients.n do
        -- are they playing?
        if server.clients[i].state == "PLAYING" then
          -- send the output
          server.clients[i]:output("{Y}[{W}Notice{Y}]:{W} "..args.."{X}")
        end
      end
    end
    -- break
    return not nil
  elseif strfind("shutdow", cmd, 1, 1) == 1 then
    -- send the output
    mob:output("If you want to shutdown, type the whole command.")
    -- break
    return not nil
  elseif strfind("shutdown", cmd, 1, 1) == 1 then
    -- log who shut the game down
    log("shutdown by "..mob.name)
    -- stop the game, begin shutting down
    running = nil
    -- break
    return not nil
  elseif strfind("uptime", cmd, 1, 1) == 1 then
    -- buffer for output, show uptime in seconds
    local buffer = "Uptime:    "..(time() - boottime).." sec\r\n"
    -- show amount of cpu time use
    buffer = buffer.."CPU Time:  "..clock().." sec\r\n"
    -- calculate cpu load
    buffer = buffer.."CPU Usage: "..round((clock() / (time() - boottime)) * 100, 2).."%"
    -- send the output
    mob:output(buffer)
    -- break
    return not nil
  elseif strfind("wecho", cmd, 1, 1) == 1 then
    -- check argument
    if not args or args == "" then
      mob:output("What do you want to echo to the world?")
    else
      -- loop through the clients
      for i = 1, server.clients.n do
        -- are they playing?
        if server.clients[i].state == "PLAYING" then
          -- send the output
          server.clients[i]:output(args.."{X}")
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
