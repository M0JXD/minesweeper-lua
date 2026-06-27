-- Lua Minesweeper for the Lua platform
-- TODO: Utilise Terminal colours?

local swpr = require('logic')
local markers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ$%&!'

local function clear_screen()
	local clear_cmd = package.config:sub(1, 1) == '/' and 'clear' or 'cls'
	os.execute(clear_cmd)
end

-- TODO: Stop this failing and crashing on invalid inputs
function interpret_move(move)
	local x, y, type
	if move == 'q' or move == 'quit' then type = 'q' end
	if move:find('#') then
		type = 'flag'
	else
		type = 'sweep'
	end
	x = markers:find(move:match('%a'):upper())
	y = tonumber(move:match('%d'))
	return x, y, type
end

local function plot_cells(x, y, board)
	local fail = false
	local top_ref = y > 9 and '  ' or ' '
	for i = 1, x do top_ref = top_ref .. ' ' .. markers:sub(i, i) end
	io.write(top_ref .. '\n')

	for i = 1, y do
		local row = ((i < 10 and y > 9) and ' ' or '') .. i .. ' '
		for k = 1, x do
			if board[k][i] == nil then
				row = row .. '# '
			elseif board[k][i] == 0 then
				row = row .. '. '
			elseif board[k][i] == 'M' then
				fail = true
				row = row .. '* '
			else
				row = row .. board[k][i] .. ' '
			end
		end
		io.write(row .. '\n')
	end
	return fail
end

clear_screen()
io.write('Welcome to Lua Minesweeper! Choose an option: ')

local mode = io.read()
mode = mode:lower()
repeat
	if mode == 'b' or mode == 'beginner' then
		break
	elseif mode == 'i' or mode == 'intermediate' then
		break
	elseif mode == 'e' or mode == 'expert' then
		break
	elseif mode == 'q' or mode == 'quit' then
		os.exit()
	elseif mode == 'h' or mode == 'help' then
		print('\n===== Lua Minesweeper Help =====')
		print('beginner (b)     - Start a beginner game.')
		print('intermediate (i) - Start an intermediate game.')
		print('expert (e)       - Start an expert game.')
		print('quit (h)         - Quit Lua Minesweeper.')
		print('help (h)         - Show this help text.')
		print(
			'To play the game, enter coordinates starting with the (X axis) letter, e.g. "H7" or "!16".')
		print('To place a flag, prefix the coordinate with a # symbol, e.g. "#H7" or "#!16"')
		io.write('\nChoose an option: ')
	else
		io.write("Invalid option selected! Please try again: ")
	end
	mode = io.read()
until false

io.write("Starting a game of Minesweeper!\n\n")
local columns, rows, board = swpr.get_details(mode)
plot_cells(columns, rows, board)
io.write('\nEnter your first move: ')
local mv_x, mv_y, type = interpret_move(io.read())
if type == 'flag' then
	board = swpr.toggle_flag(mv_x, mv_y)
elseif type == 'sweep' then
	board = swpr.setup_game(mv_x, mv_y, mode)
end

if type == 'q' or type == 'quit' then os.exit() end
local win

clear_screen()

-- TODO: Detect winning scenario (probably should be told to us by logic)
repeat
	clear_screen()
	io.write('  Lua Minesweeper\n\n')
	local fail = plot_cells(columns, rows, board)
	if fail then
		io.write('\nYou lost :(\n')
		os.exit()
	end

	io.write('\nEnter your next move: ')
	mv_x, mv_y, type = interpret_move(io.read())
	if type == 'flag' then
		board, win = swpr.toggle_flag(mv_x, mv_y)
	elseif type == 'sweep' then
		board, win = swpr.sweep_cell(mv_x, mv_y)
	end
until type == 'q' or win

if win then
	io.write('\nYou won! :)\n ')
else
	io.write('\nQuitting Lua Minesweeper, goodbye!\n ')
end

