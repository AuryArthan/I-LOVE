
-- delayed autoshift initial delay and time between shifts
local DAS_INIT_TIME = 12
local DAS_MOVE_TIME = 3

-- libretro joypad buttons const
RETRO_DEVICE_ID_JOYPAD_B        = 1
RETRO_DEVICE_ID_JOYPAD_Y        = 2
RETRO_DEVICE_ID_JOYPAD_SELECT   = 3
RETRO_DEVICE_ID_JOYPAD_START    = 4
RETRO_DEVICE_ID_JOYPAD_UP       = 5
RETRO_DEVICE_ID_JOYPAD_DOWN     = 6
RETRO_DEVICE_ID_JOYPAD_LEFT     = 7
RETRO_DEVICE_ID_JOYPAD_RIGHT    = 8
RETRO_DEVICE_ID_JOYPAD_A        = 9
RETRO_DEVICE_ID_JOYPAD_X        = 10
RETRO_DEVICE_ID_JOYPAD_L        = 11
RETRO_DEVICE_ID_JOYPAD_R        = 12
RETRO_DEVICE_ID_JOYPAD_L2       = 13
RETRO_DEVICE_ID_JOYPAD_R2       = 14
RETRO_DEVICE_ID_JOYPAD_L3       = 15
RETRO_DEVICE_ID_JOYPAD_R3       = 16


Game = {
	Theme = nil;
	Gridsize = nil;
	SqSize = nil;
	A1_coord = nil;
	HighSq = nil;
	SelSq = nil;
}


function Game:init()

	-- set theme
	self.Theme = "JAP"
	
	-- set gridsize
	self.Gridsize = 9
	
	-- set size of square in pixels
	self.SqSize = 24
	
	-- set coordinates of A1
	self.A1_coord = {133,221}
	
	-- set highlighted square (default A1)
	self.HighSq = {1,1}
	
end


local DPAD = {false,false,false,false} -- U,D,L,R
local A  = false
local B  = false
local ASDelay = {-1,-1,-1,-1} -- autoshift delay for up, down, left, right
function Game:update()
	local CUR_DPAD = {love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_LEFT),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_RIGHT)}
    local CUR_A = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_A)
    local CUR_B = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_B)
	
	-- DPAD press-down/press-up events
	for d=1,4 do
		if CUR_DPAD[d] and not DPAD[d] then -- press-down
			Game:moveHighlighter(d)
			DPAD[d] = true
			ASDelay[d] = DAS_INIT_TIME
		end
		if not CUR_DPAD[d] and DPAD[d] then -- press-up
			DPAD[d] = false
			ASDelay[d] = -1
		end
	end
	
	-- delayed autoshift
	for d=1,4 do
		if DPAD[d] then
			if ASDelay[d] == 0 then
				Game:moveHighlighter(d)
				ASDelay[d] = DAS_MOVE_TIME
			else
				ASDelay[d] = ASDelay[d]-1
			end
		end
	end
	
	-- A button
	if CUR_A and not A then		-- press down
		A = true
		if Utility:tuple_compare(self.HighSq, self.SelSq) then		-- if you press A on the selected square you deselect it
			self.SelSq = nil
			Sounds.DeSelSound:play()
		else
			if self.SelSq then										-- if a move is proposed
				if Board:move_legality(self.SelSq, self.HighSq) then	-- if move is legal, make it
					Board:move_piece(self.SelSq, self.HighSq)
					Sounds.SnapSound:play()
					self.SelSq = nil
				else													-- if move is not legal and there is a piece highlighted, then select it
					if Board:piece_present(self.HighSq) then
						self.SelSq = Utility:tuple_copy(self.HighSq)
						Sounds.SelSound:play()
					end
				end
			else													-- if no square is selected
				if Board:piece_present(self.HighSq) then
					self.SelSq = Utility:tuple_copy(self.HighSq)
					Sounds.SelSound:play()
				end
			end
		end
	end
	if not CUR_A and A then		-- press up
		A = false
	end
	
	-- B button
	if CUR_B and not B then		-- press down
		B = true
		if self.SelSq then
			self.SelSq = nil
			Sounds.DeSelSound:play()
		end
	end
	if not CUR_B and B then		-- press up
		B = false
	end
	
end


-- move highlighted square
function Game:moveHighlighter(dir)
	if dir == 1 and self.HighSq[2] < self.Gridsize then
		self.HighSq[2] = self.HighSq[2]+1 -- up
		Sounds.TicSound:play()
	elseif dir == 2 and self.HighSq[2] > 1 then
		self.HighSq[2] = self.HighSq[2]-1 -- down 
		Sounds.TicSound:play()
	elseif dir == 3 and self.HighSq[1] > 1 then
		self.HighSq[1] = self.HighSq[1]-1 -- left
		Sounds.TicSound:play()
	elseif dir == 4 and self.HighSq[1] < self.Gridsize then
		self.HighSq[1] = self.HighSq[1]+1 -- right
		Sounds.TicSound:play()
	end
end


function Game:renderGame()

	-- draw background
	love.graphics.draw(Textures.Background, 0, 0)
	
	-- draw grid
	love.graphics.draw(Textures.Grid, 0, 0)

	-- draw highlighed squares
	if self.SelSq then
		love.graphics.draw(Textures.Selected, Utility:sq_coordinates(self.SelSq))
		for i=-1,1 do
			for j = -1,1 do
				if Board:move_legality(self.SelSq, {self.SelSq[1]+i, self.SelSq[2]+j}) then
					love.graphics.draw(Textures.MoveOption, Utility:sq_coordinates({self.SelSq[1]+i,self.SelSq[2]+j}))
				end
			end
		end
	end
	love.graphics.draw(Textures.Highlighter, Utility:sq_coordinates(self.HighSq))
	
	-- draw pieces
	Board:draw_pieces()
	
	-- debug print
	DebugPr:dpad_print(DPAD, 15, 30)
	DebugPr:buttons_print(A, B, 42, 30)
	DebugPr:asdelays_print(ASDelay, 85, 30)
	DebugPr:board_print(10, 70)
	DebugPr:board_attacked_print(370, 70)
	
end
