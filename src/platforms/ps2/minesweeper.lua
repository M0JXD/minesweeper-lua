--[[ Minesweeper UI for Enceladus on PS2



Screen.setMode(NTSC, 640, 448, CT24, INTERLACED, FIELD)

--]]

local swpr = require('logic')

Font.fmLoad()

local function menu()

	return choice
end


-- START --

while true do
	Screen.clear()

	Screen.flip()
	Screen.waitVblankStart()
end

System.exitToBrowser()
