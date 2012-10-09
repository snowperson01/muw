CC=gcc
CFLAGS=-Wall -O2

# directory where lua is
LUA=/usr/local
LUAINC=-I$(LUA)/include
LUALIB=-L$(LUA)/lib

# do not change these
CFLAGS+=$(LUAINC)
LDFLAGS=$(LUALIB)

LDLIBS=-llualib -llua -lm

TARGET=lua

OBJS=lua.o muwlib.o luasocket.o


.SUFFIXES: .c .o

.c.o:
	$(CC) $(CFLAGS) -c $<

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

clean:
	rm -f $(OBJS) $(TARGET)
