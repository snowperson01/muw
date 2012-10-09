-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

-- sector flags

-- object flags
fOPEN = "o"
fCLOSED = "c"
fFIXED = "f"

-- mobile flags


-------------------------------------------------------------------------------

flags = {}

-------------------------------------------------------------------------------

function flags:create(f)
  local _flags = {}
  _flags[1] = (f or "")
  for i, v in flags do
    if type(v) == "function" then
      _flags[i] = v
    end
  end
  return _flags
end

function flags:set(f)
  if not self:isset(f) then
    self[1] = self[1]..f
  end
end

function flags:unset(f)
  if self:isset(f) then
    self[1], junk = gsub(self[1], "("..f..")", "")
  end
end

function flags:isset(f)
  return strfind(self[1], f, 1, 1)
end
