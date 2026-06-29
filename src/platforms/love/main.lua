--[[ Lua Minesweeper - LÖVE Platform

The game's 'native' resolution is 512*640, which makes cell sizes:

Beginner: 64px
Intermediate: 32px
Expert: ~17.66px

--]]

local swpr = require('logic')
local cell_imgs, start_menu, arrow
local mode, size, scale = 0, 64
local columns, rows, board, situation, hover_x, hover_y

local function draw_menu()
	love.graphics.draw(start_menu)
	love.graphics.draw(arrow, 110, 340 + mode)
end

local function draw_game()
	local image
	for k = 0, rows - 1 do
		for i = 0, columns - 1 do
			if hover_x == i + 1 and hover_y == k + 1 and board[i + 1][k + 1] == nil then
				image = 12
			elseif hover_x == i + 1 and hover_y == k + 1 and board[i + 1][k + 1] == 'F' then
				image = 13
			elseif board[i + 1][k + 1] == nil then
				image = 10
			elseif board[i + 1][k + 1] == 'M' then
				image = 14
				if situation ~= 'win' then situation = 'lost' end
			elseif board[i + 1][k + 1] == 'F' then
				image = 11
			else
				image = board[i + 1][k + 1] + 1
			end
			love.graphics.drawLayer(cell_imgs, image, (i * size), 640 - (size * rows) + (k * size),
				0, scale, scale)

		end
	end
end

function menu_mousemoved(x, y, dx, dy, istouch)
	if y < 420 then
		mode = 0
	elseif y < 540 then
		mode = 105
	else
		mode = 205
	end
end

function menu_mousepressed(x, y, button, istouch, presses)
	if y < 420 then
		mode = 'b'
	elseif y < 540 then
		mode = 'i'
	else
		mode = 'e'
	end
	size = mode == 'b' and 64 or mode == 'i' and 32 or 17.666
	scale = size / 320
	situation = 'new'
	columns, rows, board = swpr.get_details(mode)
	love.draw = draw_game
	love.mousemoved = game_mousemoved
	love.mousepressed = game_mousepressed
end

function game_mousemoved(x, y, dx, dy, istouch)
	if situation == 'lost' or situation == true or y < 640 - (size * rows) then return end
	hover_x = math.floor(x / size) + 1
	hover_y = math.floor((y - (640 - (size * rows))) / size) + 1
end

function game_mousepressed(x, y, button, istouch, presses)
	if situation == 'lost' or situation == true or y < 640 - (size * rows) then return end
	local grid_x = math.floor(x / size) + 1
	local grid_y = math.floor((y - (640 - (size * rows))) / size) + 1

	if button == 1 then
		if situation == 'new' then
			board, situation = swpr.setup_game(grid_x, grid_y, mode)
		else
			board, situation = swpr.sweep_cell(grid_x, grid_y)
		end
	elseif button == 2 then
		if situation ~= 'new' then board, situation = swpr.toggle_flag(grid_x, grid_y) end
	end
end

love.mousemoved = menu_mousemoved
love.mousepressed = menu_mousepressed

function love.load()
	love.window.setTitle('Lua Minesweeper - LÖVE Platform')
	success = love.window.setMode(512, 640)

	start_menu = love.graphics.newImage('assets/start_menu.png')
	arrow = love.graphics.newImage('assets/arrow.png')
	cell_imgs = love.graphics.newArrayImage{
		-- LuaFormatter off
		'assets/open.png',
		'assets/1.png',
		'assets/2.png',
		'assets/3.png',
		'assets/4.png',
		'assets/5.png',
		'assets/6.png',
		'assets/7.png',
		'assets/8.png',
		'assets/hidden.png',
		'assets/flag.png',
		'assets/hidden_hover.png',
		'assets/flag_hover.png',
		'assets/mine.png'
		-- LuaFormatter on
	}
end

love.draw = draw_menu
