-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function cmd_save(self, args)
  -- save player's mobile
  if self.client then
    -- open file for updating
    local fp = openfile(MOBILE_D..self.id, "w+")
    -- check if the file opened
    if not fp then
      error("could not open file "..MOBILE_D..self.id)
    else
      -- open table constructor
      write(fp, "return\n{\n")
      -- descriptions
      write(fp, "  name = "..format("%q", self.name)..",\n")
      write(fp, "  short = "..format("%q", self.short)..",\n")
      write(fp, "  long = "..format("%q", self.long)..",\n")
      write(fp, "  gender = \""..self.gender.."\",\n")

      -- flags
      write(fp, "  flags = \""..self.flags[1].."\",\n")

      -- money
      write(fp, "  money = "..self.money..",\n")

      -- open objects table
      write(fp, "  objects =\n  {")
      -- save the name of each object in inventory
      for i = 1, self.objects.n do
        write(fp, "\n    \""..self.objects[i].id.."\",")
      end
      -- close objects table
      write(fp, "\n  },\n")

      -- where we saved
      write(fp, "  sector = \""..self.parent.id.."\",\n")
      -- our password
      write(fp, "  passwd = "..format("%q", self.client.passwd)..",\n")

      -- close table constructor
      write(fp, "}")
      -- save and close file
      closefile(fp)
    end
    -- send the output
    self:output("Saved...")
  end
end
