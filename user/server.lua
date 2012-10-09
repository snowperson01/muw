-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

server = {}

-------------------------------------------------------------------------------

function server:create()
  -- load the issue file
  self.issue = dofile(WORLD_D.."text/issue")
  -- make sure it loaded ok
  if not self.issue or type(self.issue) ~= "string" then
    error("could not load issue file")
  end
  -- load message of the day
  self.motd = dofile(WORLD_D.."text/motd")
  -- make sure it loaded ok
  if not self.motd or type(self.motd) ~= "string" then
    error("could not load motd file")
  end
  -- create the server socket
  local socket, e = bind(HOST, PORT)
  -- make sure socket opened ok
  if not socket then
    error("could not bind server socket: "..e)
  else
    -- keep the socket in server
    self.socket = socket
    -- set the timeout value for socket operations
    self.socket:timeout(0.00001)
    -- log the bind
    log("server up on "..HOST..":"..PORT)
  end
  -- create a table for clients
  self.clients = {n = 0}
end

function server:destroy()
  -- copy the clients
  local clients = copy(self.clients)
  -- loop through each client
  for i = 1, clients.n do
    -- destroy the client
    clients[i]:destroy()
  end
  -- close the server socket
  self.socket:close()
  -- all done
  log("shutdown complete")
end

-------------------------------------------------------------------------------

function server:add_client(c)
  -- link client to server
  c.parent = self
  -- add client to server
  tinsert(self.clients, c)
end

function server:rem_client(c)
  for i = 1, self.clients.n do
    if c == self.clients[i] then
      -- unlink client from server
      c.parent = nil
      -- remove client from server
      return tremove(self.clients, i)
    end
  end
end

function server:get_client()
end

-------------------------------------------------------------------------------

function server:output(str, ...)
  -- are there any clients we should ignore?
  if arg.n > 0 then
    -- loop through each client on the server
    for i = 1, self.clients.n do
      -- if they are in the ignore list, don't send the string to them
      if not isin(self.clients[i], arg) then
        -- they are not in the list, send them the string
        self.clients[i]:output(str)
      end
    end
  -- just send the string to every client
  else
    -- loop through each client on the server
    for i = 1, self.clients.n do
      -- send the string to this client
      self.clients[i]:output(str)
    end
  end
end

-------------------------------------------------------------------------------

function server:update()
  -- check for new connection
  local socket, e = self.socket:accept()
  -- was there an incoming connection?
  if socket then
    -- create a new client and add it
    self:add_client(client:create(socket))
  end
  -- copy the clients
  local clients = copy(self.clients)
  -- loop through each client
  for i = 1, clients.n do
    -- update the client
    clients[i]:update()
  end
end
