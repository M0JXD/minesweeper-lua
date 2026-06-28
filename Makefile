# Makefile for Lua Minesweeper

all: lua love ps2

lua:
	mkdir -p build/lua
	cp src/logic.lua src/platforms/lua/* build/lua

ps2: build/ps2 build/ps2/minesweeper/minesweeper.lua

build/ps2:
	mkdir -p build
	wget -O ./build/enceladus.tar.gz -q https://github.com/DanielSant0s/Enceladus/releases/download/latest/Enceladus.tar.gz
	tar -xzf ./build/enceladus.tar.gz -C ./build && rm ./build/enceladus.tar.gz
	mv ./build/Enceladus ./build/ps2
	rm -r ./build/ps2/lua_intellisense ./build/ps2/mesh ./build/ps2/pads && rm ./build/ps2/enceladus.elf
	echo "dofile(\"minesweeper/minesweeper.lua\")" > ./build/ps2/System/system.lua

build/ps2/minesweeper/minesweeper.lua: src/platforms/ps2/minesweeper.lua
	mkdir -p build/ps2/minesweeper
	cp src/logic.lua src/platforms/ps2/* build/ps2/minesweeper

love: src/platforms/love/main.lua
	mkdir -p build/love/assets
	cp assets/*.png build/love/assets
	cp src/logic.lua src/platforms/love/* build/love

clean:
	rm -r build
