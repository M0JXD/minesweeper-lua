# Lua Minesweeper - Lua Platform

The Lua platform is a box standard Lua script to be run in a Lua interpreter, outputting to the console. In colour no less! (should that be supported by your terminal).
It should be compatible with most Lua versions and LuaJIT. Please open an issue if you have issues with a version!
It simply queries you on the next move and reprints the board. Please use a monospace font in your terminal!

## How to play

At the start, choose from `beginner`, `intermediate` or `expert` modes. Shorthands `b`, `i` and `e` can be used.
To sweep from a cell, enter it's coordinate, e.g. `H7`. "yx" style coordinates should also work if you're a psychopath.
To toggle the flag on a cell, prefix or postfix the coordinate with a `#`, e.g. `#B6`.
Quit at anytime with `q` or `quit`.

## Board layout

An example beginner mode game looks like this:

```
  Lua Minesweeper

  A B C D E F G H
1 . . . . . . 1 F
2 1 1 1 . . . 1 1
3 # # 2 1 1 . . .
4 # # # F 1 . . .
5 # # # # 2 . 1 1
6 # # # # 2 1 2 F
7 # # # # # # # #
8 # # # # # # # #

Enter your next move: 
```

Where:

- The lines of letters and numbers show the coordinate system
- `#` is an unswept hidden cell
- `.` is a clear cell
- `F` is a flag
- Numbers are... the numbers of adjacent mines
- `*` for the mines upon losing or winning

## Credits

Inspiration for which ASCII characters to use: https://www.asciiart.eu/ascii-games/minigames/ascii-minesweeper
Ansicolors library: https://github.com/kikito/ansicolors.lua
