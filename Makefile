# Makefile for Lua Minesweeper

all: lua love ps2

lua:
	mkdir -p build/lua
	cp src/logic.lua src/lua/* build/lua

ps2: build/ps2 build/ps2/minesweeper/minesweeper.lua

build/ps2:
	mkdir -p build
	wget -O ./build/enceladus.tar.gz -q https://github.com/DanielSant0s/Enceladus/releases/download/latest/Enceladus.tar.gz
	tar -xzf ./build/enceladus.tar.gz -C ./build && rm ./build/enceladus.tar.gz
	mv ./build/Enceladus ./build/ps2
	rm -r ./build/ps2/lua_intellisense ./build/ps2/mesh ./build/ps2/pads && rm ./build/ps2/enceladus.elf
	echo "dofile('minesweeper/minesweeper.lua')" > ./build/ps2/System/system.lua

build/ps2/minesweeper/minesweeper.lua: src/ps2/minesweeper.lua
	mkdir -p build/ps2/minesweeper
	cp src/logic.lua src/ps2/* build/ps2/minesweeper
	cp assets/*.png build/ps2/minesweeper

love: src/love/main.lua
	mkdir -p build/love/src/assets
	cp assets/*.png build/love/src/assets
	cp src/logic.lua src/love/* build/love/src
	(cd build/love/src && zip -9 -r ../minesweeper.love .)
	rm -r build/love/src

clean:
	rm -r build
