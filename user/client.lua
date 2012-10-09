-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

client = {}

------------------------------------------------------------------------------

function client:create(socket)
  -- create a new client table
  local c = {}
  -- copy all the methods from the global client
  for i, v in self do
    c[i] = v
  end
  -- keep the socket in client
  c.socket = socket
  -- set timeout value for socket operations
  c.socket:timeout(0.00001)
  -- get our ip address
  c.ip = c.socket:getpeername()
  -- log connection
  log("new connection from "..c.ip)
  -- initialize idle counter
  c.idle = 0
  -- initialize input state
  c.state = "GET NAME"
  -- send greeting
  c:output(server.issue)
  -- send a prompt for their name
  c:output("What is your name?")
  -- return the new client object
  return c
end

function client:destroy()
  -- is this a valid player?
  if self.mobile then
    -- are they fighting?
    if self.mobile.enemy then
      self.mobile.enemy:set_enemy(nil)
      self.mobile:set_enemy(nil)
    end
    -- call the mobile's destructor
    self.mobile:destroy()
  end
  -- log the disconnection
  log("closing connection to "..self.ip)
  -- disconnect their socket
  self.socket:close()
  -- remove ourself from our parent
  self.parent:rem_client(self)
end

-------------------------------------------------------------------------------

function client:output(str)
  self.socket:send("\r\n\r\n"..gsub(str, "{(.-)}", parse_color))
end

-------------------------------------------------------------------------------

function client:update()
  -- kick off client with disconnected state
  if self.state == "DISCONNECT" then
    -- destroy this client
    self:destroy()
  else
    -- get input
    local input, error = self.socket:receive("*l")
    -- non-fatal failure of receive
    if input and error then
      -- client disconnected from server
      if error == "closed" then
        self.state = "DISCONNECT"
      -- client did not send a full line
      elseif error == "timeout" then
        -- increment idle counter
        self.idle = self.idle + 1
        -- have they been idle too long?
        if self.idle > IDLE then
          -- kick them off
          self.state = "DISCONNECT"
        end
      end
    -- received input, process it
    elseif input and not error then
      -- reset idle counter
      self.idle = 0
      -- strip color codes
      input = strip_color(input)
      -- parse command
      if self.state == "PLAYING" then
        -- try to parse the command
        self.mobile:command(input)
      -- get name
      elseif self.state == "GET NAME" then
        -- check if their name is long enough
        if strlen(input) < 3 then
          self:output("That name is too short! Enter another one.")
        -- only allow letters in the name
        elseif not isletter(input) then
          self:output("Invalid name! Enter another.")
        else
          -- capitalize their name
          input = cap(input)
          -- check if the name is in use
          local found = nil
          -- loop through each client
          for i = 1, self.parent.clients.n do
            -- compare names on clients with active mobiles
            if self.parent.clients[i].mobile and input == self.parent.clients[i].mobile.name then
              found = not nil; break
            end
          end
          -- was the name found?
          if found then
            self:output("That name is being used. Enter another.")
          else
            -- try to load their playerfile
            self.mobile = mobile:create("players/"..input)
            -- check if it loaded
            if not self.mobile then
              -- a new player, load the newbie template
              self.mobile = mobile:create("players/NEWBIE")
              -- set the name (newbie's is blank)
              self.mobile.name = input
              -- modify the id
              self.mobile.id = "players/"..self.mobile.name
              -- generate the short description
              self.mobile.short = self.mobile.name.." is standing here."
              -- prompt for confirmation of name
              self:output("Your name is "..self.mobile.name.."?")
              self.state = "CONFIRM NAME"
            else
              -- prompt for password
              self:output("What is your password, "..self.mobile.name.."?")
              self.state = "CHECK PASSWORD"
            end
            -- copy password from the mobile
            self.passwd = self.mobile.passwd
            self.mobile.passwd = nil
          end
        end
      -- check password
      elseif self.state == "CHECK PASSWORD" then
        -- compare the passwords
        if input ~= self.passwd then
          -- disconnect them
          self:output("Wrong password!")
          self.state = "DISCONNECT"
        else
          -- send the message of the day
          self:output(self.parent.motd)
          self.state = "SHOW MOTD"
        end
      -- display message of the day
      elseif self.state == "SHOW MOTD" then
        -- link client to player
        self.mobile.client = self
        -- add the player to the sector where they last saved
        world:get_sector(self.mobile.sector):add_mobile(self.mobile)
        -- look at the sector
        self.mobile:command("look")
        self.state = "PLAYING"
      -- confirm name (new player)
      elseif self.state == "CONFIRM NAME" then
        -- lowercase answer
        input = strlower(input)
        -- check answer
        if not input or input == "" then
          self:output("Please answer 'yes' or 'no'.")
        elseif strfind("yes", input, 1, 1) == 1 then
          -- prompt for password
          self:output("Choose a password, at least 3 characters long.")
          self.state = "GET PASSWORD"
        elseif strfind("no", input, 1, 1) == 1 then
          self:output("Well, what is your name then?")
          -- erase thier mobile
          self.mobile = nil
        else
          self:output("Please answer 'yes' or 'no'.")
        end
      -- get password (new player)
      elseif self.state == "GET PASSWORD" then
        -- check the new password
        if strlen(input) < 3 then
          self:output("Your password must be at least 3 characters long! Enter another one.")
        else
          -- set their password
          self.passwd = input
          -- prompt for confirmation
          self:output("Ok, now enter your password again.")
          self.state = "CONFIRM PASSWORD"
        end
      -- confirm password (new player)
      elseif self.state == "CONFIRM PASSWORD" then
        -- compare passwords
        if input ~= self.passwd then
          self:output("The passwords do not match! Enter a new one.")
          -- start over
          self.state = "GET PASSWORD"
        else
          -- prompt for gender
          self:output("Are you male, female, or neither?")
          self.state = "GET GENDER"
        end
      -- get gender (new player)
      elseif self.state == "GET GENDER" then
        -- lowercase input
        input = strlower(input)
        -- check answer
        if not input or input == "" then
          self:output("Please answer 'male', 'female', or 'neither'.")
        elseif strfind("male", input, 1, 1) == 1 then
          -- set gender as male
          self.mobile.gender = "male"
          -- display message of the day
          self:output(self.parent.motd)
          self.state = "SHOW MOTD"
        elseif strfind("female", input, 1, 1) == 1 then
          -- set gender as female
          self.mobile.gender = "female"
          -- display message of the day
          self:output(self.parent.motd)
          self.state = "SHOW MOTD"
        elseif strfind("neither", input, 1, 1) == 1 then
          -- set gender as none
          self.mobile.gender = "none"
          -- display message of the day
          self:output(self.parent.motd)
          self.state = "SHOW MOTD"
        else
          self:output("Please answer 'male', 'female', or 'neither'.")
        end
      -- xxx client has an unknown state. disconnect them
      else
        log("unkown state "..(self.state or "nil"))
        self.state = "DISCONNECT"
      end
    else
      -- xxx other possibilities of socket:receive()?
      log("receive: '"..(input or "nil").."', '"..(error or "nil").."'")
    end
  end
end
