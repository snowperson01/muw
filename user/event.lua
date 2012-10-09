-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

event = {{n = 0}}

-------------------------------------------------------------------------------

function event:queue(time, ent, fun, ...)
  -- create an event table
  local evt = {time, ent, fun, arg}
  -- add it to our events
  tinsert(self[1], evt)
  -- return a reference
  return evt
end

function event:dequeue(evt)
  -- loop through the events
  for i = 1, self[1].n do
    -- compare references
    if evt == self[1][i] then
      -- remove the event
      return tremove(self[1], i)
    end
  end
end

-------------------------------------------------------------------------------

function event:update()
  -- copy the events
  local events = copy(self[1])
  -- loop through each event
  for i = 1, events.n do
    -- decrement the tick
    events[i][1] = events[i][1] - 1
    -- is this event ripe now?
    if events[i][1] <= 0 then
      -- execute it
      events[i][3](events[i][2], events[i][4])
      -- dequeue it
      self:dequeue(events[i])
    end
  end
end
