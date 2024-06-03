
-- delayed autoshift initial delay and time between shifts
local DAS_INIT_TIME = 12
local DAS_MOVE_TIME = 3

-- phasing out background music
local MUSIC_PHASE_OUT = false
local PHASE_OUT_DURATION = 2
local PHASE_OUT_TIMER = 0

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
	NumPlayers = nil;
	NumLivePlayers = nil;
	Gridsize = nil;
	SqSize = nil;
	A1_coord = nil;
	HighSq = nil;
	SelSq = nil;
	TimeoutTimer = nil;
	Paused = nil;
	GameOver = nil;
	MoveLog = nil;
	HumanPlayers = {nil,nil,nil,nil};
}


function Game:init()

	-- set theme
	self.Theme = "JAP"
	
	-- set 2-player or 4-player mode
	self.NumPlayers = 2
	
	-- set number of alive players
	self.NumLivePlayers = self.NumPlayers
	
	-- set which players are human (not AI)
	self.HumanPlayers = {true, false, false, false}
	
	-- set gridsize
	self.Gridsize = 7
	
	-- set size of square in pixels
	self.SqSize = 30 --24 --20
	
	-- set coordinates of A1
	self.A1_coord = {137,213} --{131,219} --{129,225}
	
	-- set highlighted square (default A1)
	self.HighSq = {1,1}
	
	-- set timeout timer to 0
	self.TimeoutTimer = 0
	
	-- set paused to false
	self.Paused = false
	
	-- set game-over variable to false
	self.GameOver = false
	
	-- initialize the move log
	self.MoveLog = {}
	
	-- random number seed
	math.randomseed(os.time())
	
end

local DPAD = {false,false,false,false}	-- U,D,L,R
local ASDelay = {-1,-1,-1,-1}	-- autoshift delay for up, down, left, right
local A  = false		-- A button
local B  = false		-- B button
local startB = false	-- start button
function Game:update(dt)
	
	-- check if its timeout
	if Game.TimeoutTimer > 0 then
		Game.TimeoutTimer = Game.TimeoutTimer-dt
		return
	end
	
	-- check if its the AI's turn
	if self.HumanPlayers[Board.Turn] == false then
		local move = Player:recommend_move()			-- get move from AI
		Game:move_proposal(move[1], move[2])
	end
	
	-- get the inputs
	local CUR_DPAD = {love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_UP),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_DOWN),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_LEFT),love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_RIGHT)}
    local CUR_A = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_A)
    local CUR_B = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_B)
    local CUR_startB = love.joystick.isDown(1, RETRO_DEVICE_ID_JOYPAD_START)
	
	-- handle potential phasing out of music
	Game:phase_out_music(dt)
	
	-- start press
	if CUR_startB and not startB then	-- press-down
		startB = true
		self.Paused = not self.Paused
	end
	if not CUR_startB and startB then	-- press-up
		startB = false
	end
	
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
		if square_compare(self.HighSq, self.SelSq) then		-- if you press A on the selected square you deselect it
			self.SelSq = nil
			Sounds.DeSelSound:play()
		else
			if self.SelSq then									-- if a move is proposed
				Game:move_proposal(self.SelSq, self.HighSq)
			else												-- if no square is selected
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
	
	-- if its AI's turn set timeout 1s so it doesnt move too fast
	if self.HumanPlayers[Board.Turn] == false then self.TimeoutTimer = 1 end

end

-- handle the game ending
function Game:end_game()
	self.GameOver = true
	MUSIC_PHASE_OUT = true
	PHASE_OUT_TIMER = PHASE_OUT_DURATION
	Sounds.WinSound:play()
end

-- handle phasing out background music
function Game:phase_out_music(dt)
	if MUSIC_PHASE_OUT then
		PHASE_OUT_TIMER = PHASE_OUT_TIMER-dt
		if PHASE_OUT_TIMER <= 0 then
			Sounds.BackMusic:stop()
			MUSIC_PHASE_OUT = false
		else Sounds.BackMusic:setVolume(PHASE_OUT_TIMER/PHASE_OUT_DURATION) end
	end
end

-- handle a proposed square selection
function Game:select_proposal(sq)
	if Board:empty_square(sq) then																-- if the square is empty
		return
	elseif Board:square_value(sq) == -1 then													-- if the square hosts a dead player
		return
	elseif Board:player_present(sq) and Board.Squares[sq[1]][sq[2]] ~= Board.Turn then			-- if a player tries to select another players piece
		return
	elseif Board:minor_piece_present(sq) then
		if Board:marked_square(sq) and not square_compare(sq,Board.MarkedSqs[Board.Turn]) then	-- if a player tries to select another player's marked piece
			return
		end
	end
	self.SelSq = square_copy(sq)
	Sounds.SelSound:play()
end

-- handle a proposed move
function Game:move_proposal(sq1, sq2)
	if Board:move_legality(sq1, sq2) then									-- if move is legal, make it
		Board:make_move(sq1, sq2)												-- make move
		self.MoveLog[#self.MoveLog+1] = {square_copy(sq1), square_copy(sq2)}	-- record move in log
		Sounds.SnapSound:play()													-- play sound
		self.SelSq = nil														-- unselect square
		if self.NumLivePlayers ~= sum(Board.PlayerAlive) then					-- check if anyone died
			Sounds.DeathSound:play()												-- play death sound
			self.NumLivePlayers = sum(Board.PlayerAlive)
		end
		if Board:win_check() then Game:end_game() end							-- check if the player won
	else
		Game:select_proposal(sq2)											-- if move is not legal then try to select the end square
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

-- renders player turn
function Game:renderPlayerTurn(posx, posy)
	love.graphics.print("PLAYER TURN: ", posx, posy)
	love.graphics.draw(Textures.Players[Board.Turn], posx+72, posy-10)
end

-- renders the winner at the end of the game
function Game:renderWinner(posx, posy)
	love.graphics.print("PLAYER      WINS!", posx, posy)
	love.graphics.draw(Textures.Players[Board.Turn], posx+40, posy-10)
end

-- coordinates of A1 square in pixels on screen
function Game:sq_coordinates(sq)
	return self.A1_coord[1]+(sq[1]-1)*self.SqSize, self.A1_coord[2]-(sq[2]-1)*self.SqSize
end

function Game:renderGame()

	-- draw background
	love.graphics.draw(Textures.Background, 0, 0)
	
	-- draw grid
	love.graphics.draw(Textures.Grid, 0, 0)

	-- draw highlighed squares
	if self.SelSq then
		love.graphics.draw(Textures.Selected, Game:sq_coordinates(self.SelSq))
		for i=-1,1 do
			for j = -1,1 do
				if Board:move_legality(self.SelSq, {self.SelSq[1]+i, self.SelSq[2]+j}) then
					love.graphics.draw(Textures.MoveOption, Game:sq_coordinates({self.SelSq[1]+i,self.SelSq[2]+j}))
				end
			end
		end
	end
	love.graphics.draw(Textures.Highlighter, Game:sq_coordinates(self.HighSq))
	
	-- draw pieces
	Board:draw_pieces()
	Board:draw_attacked()
	
	-- draw marked squares
	for i=1,4 do
		if Board.MarkedSqs[i] then
			if Board:square_value(Board.MarkedSqs[i]) ~= -1 then	-- do not plot the mark on dead players
				love.graphics.draw(Textures.MarkedSqs[i], Game:sq_coordinates(Board.MarkedSqs[i]))
			end
		end
	end
	
	-- draw hud
	if self.GameOver == false then 
		Game:renderPlayerTurn(11, 45)
	else
		Game:renderWinner(11, 45) 
	end
	
	-- if paused over-draw paused background
	if self.Paused then
		love.graphics.draw(Textures.Pause_back, 0, 0)
	end
	
	-- debug print
	--DebugPr:dpad_print(DPAD, 15, 30)
	--DebugPr:buttons_print(A, B, 42, 30)
	--DebugPr:asdelays_print(ASDelay, 85, 30)
	--DebugPr:board_print(10, 60)
	--DebugPr:board_attacked_print(10, 165)
	--DebugPr:piece_present_print(380, 165)
	--DebugPr:player_turn(375, 30)
	--DebugPr:player_pos(375, 60)
	--DebugPr:human_player(10, 80)
	--DebugPr:legal_moves(375, 10)
	--DebugPr:distance_center(10, 160)
	--Player:shortest_path(Board); DebugPr:shortest_path(380, 165)
	--DebugPr:move_log(375, 10)
	--DebugPr:free_adjacents_print(10, 70)
	--DebugPr:potential_attacks_print(10, 160)
	DebugPr:move_scores(365, 10)
	DebugPr:in_between_squares(5, 75)
	
end
