-- Lua Minesweeper for the Lua platform

local swpr = require('logic')
local colors = require('ansicolors')
local markers = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ$%&!'

local function clear_screen()
	local clear_cmd = package.config:sub(1, 1) == '/' and 'clear' or 'cls'
	os.execute(clear_cmd)
end

function interpret_move(move)
	local x, y, type
	if move:find('#') then
		type = 'flag'
	else
		type = 'sweep'
	end
	x = markers:find(move:match('%a'):upper())
	y = tonumber(move:match('%d+'))
	if x == nil or y == nil then type = 'bad' end
	if move == 'q' or move == 'quit' then type = 'q' end
	return x, y, type
end

local function plot_cells(x, y, board)
	local fail = false
	local top_ref = y > 9 and '  ' or ' '
	for i = 1, x do top_ref = top_ref .. ' ' .. markers:sub(i, i) end
	io.write(colors('%{dim}' ..top_ref) .. '\n')

	for i = 1, y do
		local row = ((i < 10 and y > 9) and ' ' or '') .. colors('%{dim}' .. i) .. ' '
		for k = 1, x do
			if board[k][i] == nil then
				row = row .. colors('%{bright}#') .. ' '
			elseif board[k][i] == 0 then
				row = row .. colors('%{dim}.') .. ' '
			elseif board[k][i] == 'M' then
				fail = true
				row = row .. colors('%{bright red}*') .. ' '
			elseif board[k][i] == 1 then
				row = row .. colors('%{blue}1') .. ' '
			elseif board[k][i] == 2 then
				row = row .. colors('%{green}2') .. ' '
			elseif board[k][i] == 3 then
				row = row .. colors('%{yellow}3') .. ' '
			elseif board[k][i] == 4 then
				row = row .. colors('%{magenta}4') .. ' '
			elseif board[k][i] == 5 then
				row = row .. colors('%{red}5') .. ' '
			elseif board[k][i] == 6 then
				row = row .. colors('%{cyan}6') .. ' '
			elseif board[k][i] == 7 then
				row = row .. colors('%{dim magenta}7') .. ' '
			elseif board[k][i] == 8 then
				row = row .. colors('%{dim white}8') .. ' '
			elseif board[k][i] == 'F' then
				row = row .. colors('%{bright yellow}F') .. ' '
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
local valid, win = false, false
repeat
	local mv_x, mv_y, type = interpret_move(io.read())
	if type == 'sweep' then
		board = swpr.setup_game(mv_x, mv_y, mode)
		valid = true
	elseif type == 'q' then
		io.write('\nQuitting Lua Minesweeper, goodbye!\n ')
		os.exit()
	else
		io.write('Invalid input! Try again: ')
	end
until valid
if type == 'q' or type == 'quit' then os.exit() end
clear_screen()

repeat
	clear_screen()
	io.write('  Lua Minesweeper\n\n')
	local fail = plot_cells(columns, rows, board)
	if fail then
		io.write('\nYou lost :(\n')
		os.exit()
	end

	io.write('\nEnter your next move: ')
	local valid = false
	repeat
		mv_x, mv_y, type = interpret_move(io.read())
		if type == 'flag' then
			board, win = swpr.toggle_flag(mv_x, mv_y)
			valid = true
		elseif type == 'sweep' then
			board, win = swpr.sweep_cell(mv_x, mv_y)
			valid = true
		elseif type == 'q' then break
		else
			io.write('Invalid input! Try again: ')
		end
	until valid
until type == 'q' or win

if win then
	clear_screen()
	io.write('  Lua Minesweeper\n\n')
	plot_cells(columns, rows, board)
	io.write('\nYou won! :)\n ')
else
	io.write('\nQuitting Lua Minesweeper, goodbye!\n ')
end
