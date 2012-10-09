/*---------------------------------------------------------------------------*/
/* Multi User World                                                          */
/* Copyright (C) 2001 Jason Clow                                             */
/*---------------------------------------------------------------------------*/

#include <stdio.h>
#include "lua.h"
#include "lualib.h"
#include "luasocket.h"
#include "muwlib.h"


int main(int argc, char *argv[])
{
  /* initialize Lua */
  lua_State *L = lua_open(0);

  /* open libraries */
  lua_baselibopen(L);
  lua_iolibopen(L);
  lua_strlibopen(L);
  lua_mathlibopen(L);
  lua_socketlibopen(L);
  lua_muwlibopen(L);

  /* execute the specified file */
  return lua_dofile(L, argv[1]);
}
