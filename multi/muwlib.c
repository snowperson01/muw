/*---------------------------------------------------------------------------*/
/* Multi User World                                                          */
/* Copyright (C) 2001 Jason Clow                                             */
/*---------------------------------------------------------------------------*/

#include <ctype.h>
#include <errno.h>
#include <unistd.h>
#include <sys/time.h>
#include <dirent.h>
#include <arpa/telnet.h>

#include "lua.h"
#include "lauxlib.h"
#include "muwlib.h"


static int lua_sleep(lua_State *L)
{
  int sleeptime = luaL_check_int(L, 1);
  struct timeval delay;

  delay.tv_sec = sleeptime / 1000000;
  delay.tv_usec = sleeptime - (delay.tv_sec * 1000000);

  select(0, NULL, NULL, NULL, &delay);

  return 0;
}

static int lua_time(lua_State *L)
{
  struct timeval current_time;

  gettimeofday(&current_time, NULL);

  lua_pushnumber(L, current_time.tv_sec);
  lua_pushnumber(L, current_time.tv_usec);
  
  return 2;
}

static int lua_lsdir(lua_State *L)
{
  const char *directory = luaL_check_string(L, 1);
  DIR *d;
  struct dirent *de;
  int i;

  if(!(d = opendir(directory)))
    lua_pushnil(L);
  else
  {
    lua_newtable(L);

    for(de = readdir(d), i = 1; de; de = readdir(d))
      if(isalnum(de->d_name[0]))
      {
        lua_pushstring(L, de->d_name);
        lua_rawseti(L, 2, i++);
      }

    lua_pushstring(L, "n");
    lua_pushnumber(L, i - 1);
    lua_settable(L, 2);

    closedir(d);
  }
  
  return 1;
}

static const struct luaL_reg muwlib[] =
{
  {"sleep", lua_sleep},
  {"time", lua_time},
  {"lsdir", lua_lsdir}
};

void lua_muwlibopen(lua_State *L)
{
  luaL_openl(L, muwlib);

  lua_pushstring(L, MUW_VERSION);
  lua_setglobal(L, "MUW_VERSION");
}
