--[[ Lua Minesweeper - Enceladus (PS2) Platform

WidthxHeight = 640x448

Chosen sizes:
Beginner: 48px
Intermediate: 24px
Expert: 20px

--]]

local swpr = require('minesweeper/logic')
local mode, situation = 'b', 'start'
local columns, rows, board = swpr.get_details(mode)
local hover_x, hover_y, size = 1, 1, 48
local pad, oldpad, main_loop
local start_menu = Graphics.loadImage('minesweeper/start_menu.png')
local arrow = Graphics.loadImage('minesweeper/arrow.png')
local cell_imgs = {
	Graphics.loadImage('minesweeper/open.png'), Graphics.loadImage('minesweeper/1.png'),
	Graphics.loadImage('minesweeper/2.png'), Graphics.loadImage('minesweeper/3.png'),
	Graphics.loadImage('minesweeper/4.png'), Graphics.loadImage('minesweeper/5.png'),
	Graphics.loadImage('minesweeper/6.png'), Graphics.loadImage('minesweeper/7.png'),
	Graphics.loadImage('minesweeper/8.png'), Graphics.loadImage('minesweeper/hidden.png'),
	Graphics.loadImage('minesweeper/flag.png'), Graphics.loadImage('minesweeper/hidden_hover.png'),
	Graphics.loadImage('minesweeper/flag_hover.png'), Graphics.loadImage('minesweeper/mine.png')
}

local function game()
	if Pads.check(pad, PAD_CROSS) and not Pads.check(oldpad, PAD_CROSS) then
		if situation == 'start' then
			board, situation = swpr.setup_game(hover_x, hover_y, mode)
		else
			board, situation = swpr.sweep_cell(hover_x, hover_y)
		end
	elseif Pads.check(pad, PAD_SQUARE) and not Pads.check(oldpad, PAD_SQUARE) then
		if situation ~= 'start' then
			board, situation = swpr.toggle_flag(hover_x, hover_y)
		end
	elseif Pads.check(pad, PAD_UP) and not Pads.check(oldpad, PAD_UP) then
		hover_y = hover_y > 1 and hover_y - 1 or 1
	elseif Pads.check(pad, PAD_DOWN) and not Pads.check(oldpad, PAD_DOWN) then
		hover_y = hover_y < columns and hover_y + 1 or hover_y
	elseif Pads.check(pad, PAD_LEFT) and not Pads.check(oldpad, PAD_LEFT) then
		hover_x = hover_x > 1 and hover_x - 1 or 1
	elseif Pads.check(pad, PAD_RIGHT) and not Pads.check(oldpad, PAD_RIGHT) then
		hover_x = hover_x < rows and hover_x + 1 or hover_x
	end

	local centering = (640 - (columns * size)) / 2
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
				if situation ~= true then situation = false end
			elseif board[i + 1][k + 1] == 'F' then
				image = 11
			else
				image = board[i + 1][k + 1] + 1
			end
			if mode == 'b' then
				Graphics.drawImage(cell_imgs[image], centering + (i * size),
					(448 - (size * rows)) + (k * size))
			else
				Graphics.drawScaleImage(cell_imgs[image], centering + (i * size),
					(448 - (size * rows)) + (k * size), size, size)
			end
		end
	end
end

local function menu()
	Graphics.drawImage(start_menu, 0, 0)
	Graphics.drawImage(arrow, 165, 148 + (mode == 'b' and 0 or mode == 'i' and 105 or 205))
	if Pads.check(pad, PAD_CROSS) and not Pads.check(oldpad, PAD_CROSS) then
		situation = 'start'
		size = mode == 'b' and 48 or mode == 'i' and 24 or 20
		Graphics.freeImage(start_menu)
		Graphics.freeImage(arrow)
		columns, rows, board = swpr.get_details(mode)
		main_loop = game
	elseif Pads.check(pad, PAD_DOWN) and not Pads.check(oldpad, PAD_DOWN) then
		mode = mode == 'b' and 'i' or 'e'
	elseif Pads.check(pad, PAD_UP) and not Pads.check(oldpad, PAD_UP) then
		mode = mode == 'e' and 'i' or 'b'
	end
end

main_loop = menu

while true do
	Screen.clear()
	oldpad = pad
	pad = Pads.get()
	main_loop()
	Screen.waitVblankStart()
	Screen.flip()
end
