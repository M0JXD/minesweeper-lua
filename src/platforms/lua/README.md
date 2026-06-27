# Lua Minesweeper - Lua Platform

The Lua platform is a box standard Lua script with no additional dependencies.
It simply queries you on the next move and reprints the board in plain text. Please use a monospace font in your terminal!

## How to play

At the start, choose from `beginner`, `intermediate` or `expert` modes.
To sweep a cell, enter it's coordinate, e.g. `H7`.
To flag a cell, prefix the coordinate with a `#`, e.g. `#B6`.

## Board layout

Beginner mode looks like this:

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
- `#` is a unswept hidden cell
- `.` is a clear cell
- `F` is a user flag
- Numbers are... the numbers
- `*` for Mines upon losing.

## Credits

Inspiration for which ASCII characters to use: https://www.asciiart.eu/ascii-games/minigames/ascii-minesweeper
