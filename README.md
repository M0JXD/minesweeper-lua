# Lua Minesweeper

This is my attempt at using Lua to make the classic game Minesweeper for as many platforms as I can.

## Supported Platforms

- Plain Lua
- Desktop/Mobile via LÖVE
- PS2 via Enceladus
- Wii via LuafWii or Wiilove
- Textadept
- TBD...

## Game Design

The core logic of Lua Minesweeper is platform independent and implemented in *logic.lua*.

Each platform has a folder within the source tree, which has an implementation README and platform specific Lua code.
For the most part that is just requiring the logic file and implementing a UI around it.

There is a Makeile which makes the release folders that are ready to run on each platform.

## Platforms I might add

- TUI (library not chosen yet)
- ROBLOX
- Dreamcast via ANTIRUINS
- PSP via Lua Player Plus PSP
- REAPER
- PICO-8
- (Neo)Vim

### May have to make my own LuaPlayer for these:

- PlayStation (with PSn00bSDK?)
- Nintendo 64
- GameCube 
- MegaDrive (maybe a *very* slimmed down LuaPlayer can be made with Marsdev/SGDK?)
- SNES via PVSnesLib

## TODO

- Use a minifier when "building".
