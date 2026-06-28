--[[ Lua Minesweeper - LÖVE Platform

The game's "native" resolution is 512*640, which makes cell sizes:

Beginner: 64px
Intermediate: 32px
Expert: ~16px

--]]

local swpr = require('logic')
local cell_imgs, start_menu, arrow
local mode, size, scale = 0, 64
local columns, rows, board

local function draw_menu()
	love.graphics.draw(start_menu)
	love.graphics.draw(arrow, 110, 340 + mode)
end

local function draw_game()
	for i = 0, columns - 1 do
		for k = 0, rows - 1 do
			love.graphics.drawLayer(cell_imgs, 10, (i * size), 640 - (size * rows) + (k * size), 0,
				scale, scale)
		end
	end
end

function menu_mousemoved(x, y, dx, dy, istouch)
	if y < 420 then mode = 0
	elseif y < 540 then mode = 105
	else mode = 205 end
end

function menu_mousepressed(x, y, button, istouch, presses)
	if y < 420 then mode = 'b'
	elseif y < 540 then mode = 'i'
	else mode = 'e' end
	columns, rows, board = swpr.get_details(mode)
	love.draw = draw_game
	love.mousemoved = game_mousemoved
	love.mousepressed = game_mousepressed
end

function game_mousemoved(x, y, dx, dy, istouch)

end

function game_mousepressed(x, y, button, istouch, presses)

end

love.mousemoved = menu_mousemoved
love.mousepressed = menu_mousepressed

function love.load()
	love.window.setTitle('Lua Minesweeper - LÖVE Platform')
	success = love.window.setMode(512, 640)

	start_menu = love.graphics.newImage("assets/start_menu.png")
	arrow = love.graphics.newImage("assets/arrow.png")
	cell_imgs = love.graphics.newArrayImage{
		-- LuaFormatter off
		"assets/open.png",
		"assets/1.png",
		"assets/2.png",
		"assets/3.png",
		"assets/4.png",
		"assets/5.png",
		"assets/6.png",
		"assets/7.png",
		"assets/8.png",
		"assets/hidden.png",
		"assets/flag.png",
		"assets/hidden_hover.png",
		"assets/flag_hover.png",
		"assets/mine.png"
		-- LuaFormatter on
	}
end

love.draw = draw_menu

function love.update()
	size = mode == 'b' and 64 or mode == 'i' and 32 or 16
	scale = size / 320
end
