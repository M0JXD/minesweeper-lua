# Lua Minesweeper

This is my attempt at using Lua to make the classic game Minesweeper for as many platforms as I can.

## Platforms

- Plain Lua via CLI
- Desktop/Mobile via LÖVE

### Intended Platforms

- PS2 via Enceladus
- Wii via LuafWii or Wiilove
- Textadept
- TBD...

## Game Design

The core logic of Lua Minesweeper is platform independent and implemented in *logic.lua*.

Each platform has a folder within the source tree, which has an implementation README and platform specific Lua code.
For the most part that is just requiring the logic file and implementing a UI around it.

There is a Makeile which makes the release folders that are ready to run on each platform.

## License

Under the GPLv3 as it has dependencies (e.g. Enceladus) that are GPLv3.

## Platforms I might add

- Dreamcast via ANTIRUINS
- ROBLOX
- PSP via Lua Player Plus PSP
- REAPER
- PICO-8
- (Neo)Vim
- If I'm willing to look at developing my own LuaPlayer(s), I could maybe support PSX, N64 etc.
- Note to self: Check out KallistiOS and its possible GC support

## TODO

- Use a minifier when "building".
