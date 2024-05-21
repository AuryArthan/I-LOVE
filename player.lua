
Player = {}


-- function that finds a move to recommend
function Player:recommend_move()
	local active_player = Board.Turn
	local legal_moves = Board:list_legal_moves()		-- all legal moves
	local scores = {}
	for m=1,#legal_moves do								-- loop over them
		local testBoard = Board:copy()								-- make a test board copy
		testBoard:make_move(legal_moves[m][1], legal_moves[m][2])	-- make the move
		scores[m] = Player:state_score(active_player, testBoard)	-- evaluate the state 	
	end
	return legal_moves[max_index(scores)] 
end

-- function that evaluates the board state (returns score between -1 and 1)
function Player:state_score(player, board)
	if board:win_check() then return 1 end
	local score = 0
	score = score + Player:free_adjacent_squares(player, board)/4/2						-- free squares around the player are good
	for p=1,4 do
		if p ~= player and board.PlayerAlive[p] == 1 then
			score = score - Player:free_adjacent_squares(p, board)/4/2/board:live_num()	-- free squares around opponents are bad
		end
	end
	return score
end

-- count free adjacent squares
function Player:free_adjacent_squares(player, board)
	local cnt = 0
	local pos = board.PlayerPos[player]
	local adjacents = {{pos[1],pos[2]+1}, {pos[1],pos[2]-1}, {pos[1]+1,pos[2]}, {pos[1]-1,pos[2]}}
	for i=1,4 do
		if inbounds(adjacents[i]) then
			if board:empty_square(adjacents[i]) and board:attacked(adjacents[i]) == 0 then cnt = cnt+1 end
		end
	end
	return cnt
end

-- count free secondary squares (distance 2)
function Player:free_secondary_squares(player, board)
	local cnt = 0
	local pos = board.PlayerPos[player]
	local secondary = {{pos[1],pos[2]+2}, {pos[1]+1,pos[2]+1}, {pos[1]+2,pos[2]}, {pos[1]+1,pos[2]-1}, {pos[1],pos[2]-2}, {pos[1]-1,pos[2]-1}, {pos[1]-2,pos[2]}, {pos[1]-1,pos[2]+1}}
	for i=1,8 do
		if inbounds(secondary[i]) then
			if board:empty_square(secondary[i]) and board:attacked(secondary[i]) == 0 then cnt = cnt+1 end
		end
	end
	return cnt
end

-- count potential attacks
function Player:potential_attacks(player, board)
	local cnt = 0
	local pos = board.PlayerPos[player]
	local p_positions = {{pos[1],pos[2]+2}, {pos[1],pos[2]-2}, {pos[1]-2,pos[2]}, {pos[1]+2,pos[2]}}	-- positions from which the piece can attack (UDLR)
	local adjacents = {{pos[1],pos[2]+1}, {pos[1],pos[2]-1}, {pos[1]-1,pos[2]}, {pos[1]+1,pos[2]}}		-- adjacent squares (UDLR)
	for i=1,4 do
		if inbounds(p_positions[i]) then
			if board:minor_piece_present(p_positions[i]) then											-- if there is a minor piece in the right position
				if board:empty_square(adjacents[i]) then												-- if the square in between is empty
					if board:square_value(p_positions[i]) ~= i+4 then cnt = cnt+1 end					-- if the pices is not facing outward
				end
			end
		end
	end
	return cnt
end

-- distance of the player to the center
function Player:distance_center(player, board)
	local pos = board.PlayerPos[player]
	return math.abs(pos[1]-(Game.Gridsize+1)/2)+math.abs(pos[2]-(Game.Gridsize+1)/2)
end
