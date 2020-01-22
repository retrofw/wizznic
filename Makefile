#
# Wizznic for the RetroFW
#
# by pingflood; 2019
#

TARGET = wizznic/wizznic.dge

CHAINPREFIX := /opt/mipsel-RetroFW-linux-uclibc
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)gcc
STRIP = $(CROSS_COMPILE)strip

SYSROOT     := $(shell $(CC) --print-sysroot)
SDL_CFLAGS  := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS    := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

DEFS = -DGP2X -DIS_LITTLE_ENDIAN -D_REENTRANT #-DGP2X_ASM

INCS =  -I.

CFLAGS= $(SDL_CFLAGS) -O2 #-fstrength-reduce -fthread-jumps -fexpensive-optimizations -fomit-frame-pointer -frename-registers -pipe -ffast-math
# CFLAGS= $(SDL_CFLAGS) -mips32 -O3 -fstrength-reduce -fthread-jumps -fexpensive-optimizations -fomit-frame-pointer -frename-registers -pipe -G 0 -ffast-math
LDFLAGS= $(SDL_LIBS) $(CFLAGS)
LIBS = -lSDL -lSDL_image -lSDL_mixer -lpng -lm -lz -lpthread

OBJS = src/board.o src/cursor.o src/draw.o src/input.o src/main.o src/menu.o src/sprite.o src/text.o src/ticks.o \
src/sound.o src/game.o src/player.o src/list.o src/levels.o src/wiz.o src/pixel.o src/stars.o src/levelselector.o \
src/leveleditor.o

MYCC = $(CC) $(CFLAGS) $(INCS) $(DEFS)

########################################################################

all: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(TARGET) $(LIBS)
	$(STRIP) $(TARGET)

.c.o:
	$(MYCC) -c $< -o $@

clean:
	rm -f src/*.o $(TARGET)

ipk: all
	@rm -rf /tmp/.wizznic-ipk/ && mkdir -p /tmp/.wizznic-ipk/root/home/retrofw/games/wizznic /tmp/.wizznic-ipk/root/home/retrofw/apps/gmenu2x/sections/games
	@cp -r \
	wizznic/data \
	wizznic/packs \
	wizznic/wizznic.dge \
	wizznic/wizznic.man.txt \
	wizznic/wizznic.png \
	/tmp/.wizznic-ipk/root/home/retrofw/games/wizznic
	@cp wizznic/wizznic.lnk /tmp/.wizznic-ipk/root/home/retrofw/apps/gmenu2x/sections/games
	@sed "s/^Version:.*/Version: $$(date +%Y%m%d)/" wizznic/control > /tmp/.wizznic-ipk/control
	@cp wizznic/conffiles /tmp/.wizznic-ipk/
	@tar --owner=0 --group=0 -czvf /tmp/.wizznic-ipk/control.tar.gz -C /tmp/.wizznic-ipk/ control conffiles
	@tar --owner=0 --group=0 -czvf /tmp/.wizznic-ipk/data.tar.gz -C /tmp/.wizznic-ipk/root/ .
	@echo 2.0 > /tmp/.wizznic-ipk/debian-binary
	@ar r wizznic/wizznic.ipk /tmp/.wizznic-ipk/control.tar.gz /tmp/.wizznic-ipk/data.tar.gz /tmp/.wizznic-ipk/debian-binary

opk: all
	@mksquashfs \
	wizznic/default.retrofw.desktop \
	wizznic/wizznic.dge \
	wizznic/data \
	wizznic/wizznic.png \
	wizznic/wizznic.man.txt \
	wizznic/packs \
	wizznic/wizznic.opk \
	-all-root -noappend -no-exports -no-xattrs
