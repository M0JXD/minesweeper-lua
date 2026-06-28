--[[ Lua Minesweeper Game Logic

-- Game Types --

Beginner: 8x8 with 10 mines
Intermediate: 16x16 with 40 mines
Expert: 30x16 with 99 mines

-- Board Data --

The main board is represented by a 2D Matrix.
Each 'cell' contains a value reprenting what it is:

Internally, it uses:

nil for hidden cell
0 for a revealed cell with no adjacent mines
A number a revealed cell with 'n' adjacent mines
'F' for a user flagged cell with no mine
'FM' for a user flagged cell with a mine
'M' for a  mine

Externally, this is simplified to:

nil for a hidden cell
0 for a revealed cell with no adjacent mines
A number a revealed cell with 'n' adjacent mines
'F' for a user flagged cell
'M' mines upon game failure (user must check if board contains mines)

-- API --

It offers a very simple end user API. All functions return the simplified plottable board.

swpr.get_details(mode) - returns the columns, rows and a blank board (handy for first plots) for a mode.
swpr.setup_game(x, y, mode) - Sets up a new game based on the mode and first sweep (where a mine must never be)
swpr.sweep_cell(x, y) - Sweep from selected cell
swpr.toggle_flag(x, y) - Toggle the flag for a cell
swpr.get_board() - Get the internal simplified and easily plottable Minesweeper matrix of just nil, numbers or 'F'

--]]

local M = {}

-- Internal Data --

local board = {}
board.mode = 'beginner'
board.columns = 8
board.rows = 8

-- Functions --

local function detect_win()
	for i = 1, board.rows do
		for k = 1, board.columns do
			-- If any cell is nil or incorrectly flagged then it can't be so
			if board[k][i] == nil or board[k][i] == 'F' then return false end
		end
	end
	-- If we get here every cell must be revealed, a number, or a mine
	-- i.e. winning scenario
	return true
end

local function check_mine(x, y)
	if board[x][y] == 'M' or board[x][y] == 'FM' then return true end
	return false
end

function M.get_details(mode)
	local rows = (mode == 'beginner' or mode == 'b') and 8 or 16
	local columns = (mode == 'expert' or mode == 'e') and 30 or rows
	local blank_board = {}
	for i = 1, columns do blank_board[i] = {} end
	return columns, rows, blank_board
end

-- Setup a board based on the first click spot and the game mode
function M.setup_game(mv_x, mv_y, mode)
	local columns, rows = M.get_details(mode)
	local mines = (mode == 'beginner' or mode == 'b') and 10 or
		(mode == 'intermediate' or mode == 'i') and 40 or 99

	for i = 1, columns do board[i] = {} end

	local amount = 0
	math.randomseed(os.time())
	while true do
		local x = math.random(1, columns)
		local y = math.random(1, rows)

		-- TODO: Would be nice to avoid placing any near the first click
		-- So a bit of a sweep can happen on the first go
		-- which is more informative for the player
		if board[x][y] == nil and not (x == mv_x and y == mv_y) then
			board[x][y] = 'M'
			amount = amount + 1
		end
		if amount == mines then break end
	end
	board.mode = mode
	board.columns = columns
	board.row = rows

	return M.sweep_cell(mv_x, mv_y)
end

-- Toggles flag on a cell
function M.toggle_flag(x, y)
	if board[x][y] == 'M' then
		board[x][y] = 'FM'
	elseif board[x][y] == 'F' then
		board[x][y] = nil
	elseif board[x][y] == 'FM' then
		board[x][y] = 'M'
	else -- must be a nil cell
		board[x][y] = 'F'
	end
	return M.get_board(false)
end

-- Choose a cell to "sweep"
function M.sweep_cell(x, y)
	if board[x][y] == 'M' then
		return M.get_board(true)
	elseif board[x][y] == nil then
		local count = 0
		-- LuaFormatter off
		-- Check if any surrounding mines
		-- North-West
		if x-1 > 0 and y-1 > 0 then if check_mine(x-1,y-1) then count = count + 1 end end
		-- North
		if y-1 > 0 then if check_mine(x,y-1) then count = count + 1 end end
		-- North-East
		if x+1 <= board.columns and y-1 > 0 then if check_mine(x+1,y-1) then count = count + 1 end end
		-- East
		if x+1 <= board.columns then if check_mine(x+1,y) then count = count + 1 end end
		-- South-East
		if x+1 <= board.columns and y+1 <= board.rows then if check_mine(x+1,y+1) then count = count + 1 end end
		-- South
		if y+1 <= board.rows then if check_mine(x,y+1) then count = count + 1 end end
		-- South-West
		if x-1 > 0 and y+1 <= board.rows then if check_mine(x-1,y+1) then count = count + 1 end end
		-- West
		if x-1 > 0 then if check_mine(x-1,y) then count = count + 1 end end

		board[x][y] = count
		-- If none, call the next ones to be revealed...
		if count == 0 then
			-- North-West
			if x-1 > 0 and y-1 > 0 then M.sweep_cell(x-1, y-1) end
			-- North
			if y-1 > 0 then M.sweep_cell(x, y-1) end
			-- North-East
			if x+1 <= board.columns and y-1 > 0 then M.sweep_cell(x+1, y-1) end
			-- East
			if x+1 <= board.columns then M.sweep_cell(x+1, y) end
			-- South-East
			if x+1 <= board.columns and y+1 <= board.rows then M.sweep_cell(x+1, y+1) end
			-- South
			if y+1 <= board.rows then M.sweep_cell(x, y+1) end
			-- South-West
			if x-1 > 0 and y+1 <= board.rows then M.sweep_cell(x-1, y+1) end
			-- West
			if x-1 > 0 then M.sweep_cell(x-1, y) end
		end
		-- LuaFormatter on
	end
	return M.get_board(false)
end

-- Returns the board for plotting by losing mine data
function M.get_board(hit_mine)
	local win = detect_win()
	local col, row, simple_board = M.get_details(board.mode)
	for i = 1, row do
		for k = 1, col do
			if win and (board[k][i] == 'FM' or board[k][i] == 'M') then
				simple_board[k][i] = 'M'
			elseif board[k][i] == 'FM' or board[k][i] == 'F' then
				simple_board[k][i] = 'F'
			elseif hit_mine and (board[k][i] == 'M' or simple_board[k][i] == 'F') then
				simple_board[k][i] = 'M'
			elseif not hit_mine and board[k][i] == 'M' then
				simple_board[k][i] = nil
			else
				simple_board[k][i] = board[k][i]
			end
		end
	end
	return simple_board, win
end

return M
