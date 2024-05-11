
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
				Game:move_proposal(self.SelSq, self.HighSq)
			else													-- if no square is selected
				Game:select_proposal(self.HighSq)
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


-- handle a proposed square selection
function Game:select_proposal(sq)
	if Board:empty_square(sq) then																		-- if the square is empty
		return
	elseif Board:player_present(sq) and Board.Squares[sq[1]][sq[2]] ~= Board.Turn then					-- if a player tries to select another players piece
		return
	elseif Board:minor_piece_present(sq) then
		if Board:marked_square(sq) and not Utility:tuple_compare(sq,Board.MarkedSqs[Board.Turn]) then	-- if a player tries to select another player's marked piece
			return
		end
	end
	self.SelSq = Utility:tuple_copy(sq)
	Sounds.SelSound:play()
end

-- handle a proposed move
function Game:move_proposal(sq1, sq2)
	if Board:move_legality(sq1, sq2) then			-- if move is legal, make it
		Board:make_move(sq1, sq2)
		Sounds.SnapSound:play()
		self.SelSq = nil
	else
		Game:select_proposal(sq2)					-- if move is not legal then try to select the end square
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
	Board:draw_attacked()
	
	-- draw marked squares
	for i=1,4 do
		if Board.MarkedSqs[i] then
			if Board.Squares[Board.MarkedSqs[i][1]][Board.MarkedSqs[i][2]] ~= i then
				love.graphics.draw(Textures.MarkedSqs[i], Utility:sq_coordinates(Board.MarkedSqs[i]))
			end
		end
	end
	
	-- debug print
	DebugPr:dpad_print(DPAD, 15, 30)
	DebugPr:buttons_print(A, B, 42, 30)
	DebugPr:asdelays_print(ASDelay, 85, 30)
	DebugPr:board_print(10, 60)
	DebugPr:board_attacked_print(10, 165)
	DebugPr:piece_present_print(380, 165)
	DebugPr:player_turn(375, 30)
	
end
