-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

HOST = "localhost"              -- hostname to bind server to
PORT = 2000                     -- port to listen on

-------------------------------------------------------------------------------

TPS = 5                         -- ticks per second
IDLE = minutes(15)              -- max time a client can idle

-------------------------------------------------------------------------------

WORLD_D = "../world/"           -- the base directory for data files

REGION_D = WORLD_D.."regions/"  -- where region/sector files are
OBJECT_D = WORLD_D.."objects/"  -- where object files are
MOBILE_D = WORLD_D.."mobiles/"  -- where mobile files are

LOG_D = WORLD_D.."text/logs/"   -- log files
