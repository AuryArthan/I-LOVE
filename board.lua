
Board = {
	Background = nil;
	Highlighter = nil;
	Gridsize = nil;
	SqSize = nil;
	A1_pos = nil;
	HighSq = nil;
}

function Board:init()

	-- load background
	self.Background = love.graphics.newImage("assets/back.png")
	
	-- load piece textures
	self.Highlighter = love.graphics.newImage("assets/highlighter.png")
	
	-- load grid
	self.Grid7 = love.graphics.newImage("assets/grid7.png")
	self.Grid9 = love.graphics.newImage("assets/grid9.png")
	self.Grid11 = love.graphics.newImage("assets/grid11.png")
	
	-- set gridsize
	self.Gridsize = 9

	-- set size of square in pixels
	self.SqSize = 24
	
	-- set coordinates of A1
	self.A1_pos = {133,221}
	
	-- set highlighted square (default A1)
	self.HighSq = {3,6}
	
end


local DPAD = {false,false,false,false} -- U,D,L,R
local A  = false
local B  = false
function Board:update()
	local CUR_DPAD = {love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_LEFT),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_RIGHT)}
    local CUR_A = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_A)
    local CUR_B = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_B)
	
	for d=0,4 do
		if CUR_DPAD[d] and not DPAD[d] then
			Board:onEventStart(d)
			DPAD[d] = true
		end
		if not CUR_DPAD[d] and DPAD[d] then
			DPAD[d] = false
		end
	end

end


-- process key down event
function Board:onEventStart(command)
	if command == 0 then
		self.HighSq[2] = self.HighSq[2]+1
	elseif command == 1 then
		self.HighSq[2] = self.HighSq[2]-1
	elseif command == 2 then
		self.HighSq[1] = self.HighSq[1]-1
	elseif command == 3 then
		self.HighSq[1] = self.HighSq[1]+1
	end
end


function Board:renderGame()

	-- draw background
	love.graphics.draw(self.Background, 0, 0)
	
	-- draw grid
	love.graphics.draw(self.Grid9, 0, 0)

	-- draw highlighed square
	love.graphics.draw(self.Highlighter, self.A1_pos[1]+(self.HighSq[1]-1)*self.SqSize, self.A1_pos[2]-(self.HighSq[2]-1)*self.SqSize)
	
end
