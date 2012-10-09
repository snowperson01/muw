-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

-- thanks go out to Reuben Thomas and Pedro Miller Rabinovitch
-- for help with these couple of string functions

-- trims the spaces of either end of a string
function trim(s)
  return gsub(s, "%s*(.*)%s*$", "%1", 1)
end

-- cuts the first part of a string off and returns two separate strings
function chop(s, p)
  local s2, z
  z, z, p, s2 = strfind(s, "("..p..")(.*)")
  return s2 or s, p
end

function next_token(s)
  -- replace spaces between quotes with \1
  s = gsub(s, "\"(.-)\"", function(l) return "\""..gsub(l, " ", "\1").."\"" end)
  s = gsub(s, "\'(.-)\'", function(l) return "\'"..gsub(l, " ", "\1").."\'" end)
  -- take the next space-delimited token off the string  
  local a, b = chop(s, "%S+")
  -- put the spaces back
  a = gsub(a or "", "\1", " ")
  b = gsub(b or "", "\1", " ")
  -- remove quotes from b
  b = gsub(b or "", "\"(.-)\"", function(l) return l end)
  b = gsub(b or "", "\'(.-)\'", function(l) return l end)
  -- return the trimmed tokens
  return trim(b or ""), trim(a or "")
end

function tokenize(s)
  -- replace the spaces between two 's with a non-space character
  s = gsub(s, "\'(.-)\'", function(l) return gsub(l, " ", "\1") end)
  -- do the same for quotation marks
  s = gsub(s, "\"(.-)\"", function(l) return gsub(l, " ", "\1") end)
  -- a table to store the list of words
  local words = {}
  -- break the string up and store it in the table
  gsub(s, "(%S+)", function(l) l = gsub(l, "\1", " "); tinsert(%words, l) end)
  -- return the broken string
  return words
end

-- capitalize the first character of a string
function cap(s)
  return strupper(strsub(s, 1, 1))..strsub(s, 2)
end

-- add an 's' or 'es' or 'ses' at the end of a word
function plz(s)
  -- get the last character
  local x = strsub(s, strlen(s))
  -- ends with an s, put on ses (gas -> gasses)
  if x == "s" then
    s = s.."ses"
  elseif x == "S" then
    s = s.."SES"
  -- ends with an h, put on es (slash -> slashes)
  elseif x == "h" then
    s = s.."es"
  elseif x == "H" then
    s = s.."ES"
  -- ends with a y, change to ies (parry -> parries)
  elseif x == "y" then
    s = strsub(s, 1, strlen(s) - 1).."ies"
  elseif x == "Y" then
    s = strsub(s, 1, strlen(s) - 1).."IES"
  -- some other consonant, put on s (hit -> hits)
  else
    -- is it lowercase?
    if strlower(s) == s then
      s = s.."s"
    -- is it uppercase?
    elseif strupper(s) == s then
      s = s.."S"
    end
  end
  -- return the new string
  return s
end

-- ansi color code parser
function parse_color(c)
  if     c == "r" then return "\027[0;31m" -- dark red
  elseif c == "g" then return "\027[0;32m" -- dark green
  elseif c == "y" then return "\027[0;33m" -- brown
  elseif c == "b" then return "\027[0;34m" -- dark blue
  elseif c == "p" then return "\027[0;35m" -- purple
  elseif c == "c" then return "\027[0;36m" -- dark cyan
  elseif c == "w" then return "\027[0;37m" -- white
  elseif c == "R" then return "\027[1;31m" -- bright red
  elseif c == "G" then return "\027[1;32m" -- bright green
  elseif c == "Y" then return "\027[1;33m" -- yellow
  elseif c == "B" then return "\027[1;34m" -- bright blue
  elseif c == "P" then return "\027[1;35m" -- pink
  elseif c == "C" then return "\027[1;36m" -- bright cyan
  elseif c == "W" then return "\027[1;37m" -- bright white
  elseif c == "x" then return "\027[1;30m" -- dark grey (black)
  elseif c == "X" then return "\027[0m"    -- light grey (normal)
  elseif c == "!" then return "\a"         -- beep!
  else                 return c            -- usually { or }
  end
end

-- strip color codes from a string
function strip_color(s)
  return gsub
  (
    s, "{(.-)}",
    function(c)
      if c == "{" then
        return "{"
      elseif c == "}" then
        return "}"
      else
        return ""
      end
    end
  )
end

-- gives back a number with 0 or d places after the decimal
function round(v, n)
  -- let n default as zero
  if not n then
    n = 0
  end
  -- use format to truncate the number
  return tonumber(format("%."..n.."f", v))
end

-- check if a string contains only [Aa-Zz]
function isletter(s)
  for i = 1, strlen(s) do
    -- get the numerical value of this letter
    local b = strbyte(s, i)
    -- check for a-z, A-Z
    if (b < strbyte("a") or b > strbyte("z")) and (b < strbyte("A") or b > strbyte("Z")) then
      return nil
    end
  end
  -- it's all letters
  return not nil
end

-- check for instance of "value" in "table"
function isin(value, table)
  for i, v in table do
    if value == v then
      return not nil
    end
  end
  return nil
end

-- shallow copy a table
function copy(table)
  local t = {}
  for i, v in table do
    t[i] = v
  end
  return t
end

-- inherit methods from another table
function inherit(to, from)
  for index, value in from do
    if type(value) == "function" then
      to[index] = to[index] or value
    end
  end
end

-- dofile() on files in a given directory
function dofiles(dir)
  -- get the list of files
  local files = lsdir(dir)
  -- do each file
  for i = 1, files.n do
    dofile(dir.."/"..files[i])
  end
end

-------------------------------------------------------------------------------

-- a somewhat realistic dice roll
function dice(num, die)
  local result = 0
  -- roll the dice one at a time, and add the results
  for i = 1, num do
    result = result + random(1, die)
  end
  return result
end

-- render a meter for x/max
function meter(value, outof, on, off, color1, color2)
  -- calculate how many 'units' to draw
  value = max(0, min(10, round((value / outof)  * 10)))
  -- draw the meter units
  local buffer = color1..strrep(on, value)
  -- draw the blank units
  buffer = buffer..color2..strrep(off, (((value < 10) and (10 - value)) or 0))
  -- return the meter string
  return buffer
end

-- calculate the number of ticks in a given number of real seconds
function seconds(s)
  return TPS * s
end

-- calculate the number of ticks in a given number of real minutes
function minutes(m)
  return m * seconds(60)
end

-- calculate the number of ticks in a given number of real hours
function hours(h)
  return h * minutes(60)
end

-- return the opposite direction, used by cmd_go
function from(direction)
  if direction == "north" then
    return " from the south."
  elseif direction == "east" then
    return " from the west."
  elseif direction == "south" then
    return " from the north."
  elseif direction == "west" then
    return " from the east."
  elseif direction == "up" then
    return " from below."
  elseif direction == "down" then
    return " from above."
  else
    return "."
  end
end
