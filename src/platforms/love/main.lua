--[[ Lua Minesweeper - LÖVE Platform

The game's "native" resolution is 512*640, which makes cell sizes:

Beginner: 64px
Intermediate: 32px
Expert: ~16px

--]]

local swpr = require('logic')
local cell_imgs
local mode, size, scale = 'b', 64
local columns, rows, board = swpr.get_details(mode)

function love.load()
	love.window.setTitle('Lua Minesweeper - LÖVE Platform')
	success = love.window.setMode(512, 640)
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

function love.draw()
	for i = 0, columns - 1 do
		for k = 0, rows - 1 do
			love.graphics.drawLayer(cell_imgs, 10, (i * size), 640 - (size * rows) + (k * size), 0,
				scale, scale)
		end
	end
end

function love.update()
	size = mode == 'b' and 64 or mode == 'i' and 32 or 16
	scale = size / 320
end
