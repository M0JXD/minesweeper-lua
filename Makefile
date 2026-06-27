# Makefile for Lua Minesweeper

all: build lua love textadept ps2 wii

build:
	-mkdir -p build

lua: build
	mkdir -p build/lua
	cp src/logic.lua src/platforms/lua/* build/lua

ps2: build build/ps2 build/ps2/minesweeper

build/ps2:
	wget -O ./build/enceladus.tar.gz -q https://github.com/DanielSant0s/Enceladus/releases/download/latest/Enceladus.tar.gz
	tar -xzf ./build/enceladus.tar.gz -C ./build && rm ./build/enceladus.tar.gz
	-mv ./build/Enceladus ./build/ps2
	-rm -r ./build/ps2/lua_intellisense ./build/ps2/mesh ./build/ps2/pads && rm ./build/ps2/enceladus.elf
	echo "dofile(\"minesweeper/minesweeper.lua\")" > ./build/ps2/System/system.lua

build/ps2/minesweeper: src/platforms/ps2/minesweeper.lua
	mkdir -p build/ps2/minesweeper
	cp src/logic.lua src/platforms/ps2/* build/ps2/minesweeper

love: build

textadept: build

wii: build

clean:
	rm -r build
