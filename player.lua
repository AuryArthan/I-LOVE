
Player = {}

-- finds the index of the largest element
function max_index(lst)
	if #lst == 0 then return nil end
	local max = lst[1]
	local index = 1
	for i=2,#lst do
		if lst[i] > max then
			max = lst[i]
			index = i 
		end
	end
	return index
end

-- function that finds a move to recommend
function Player:recommend_move()
	active_player = Board.Turn
	local legal_moves = Board:list_legal_moves()		-- all legal moves
	local scores = {}
	for m=1,#legal_moves do								-- loop over them
		local testBoard = Board:copy()								-- make a test board copy
		testBoard:make_move(legal_moves[m][1], legal_moves[m][2])	-- make the move
		scores[m] = Player:state_score(active_player, testBoard)	-- evaluate the state 	
	end
	return legal_moves[max_index(scores)] 
end

-- function that evaluates the board state
function Player:state_score(player, board)
	--local num_legal_moves = #board:list_legal_moves()	-- number of legal moves
	return Player:free_adjacent_squares(player, board)
end


-- count free adjacent squares
function Player:free_adjacent_squares(player, board)
	local cnt = 0
	local pos = board.PlayerPos[player]
	local adjacents = {{pos[1],pos[2]+1}, {pos[1],pos[2]-1}, {pos[1]+1,pos[2]}, {pos[1],pos[2]-1}}
	for i=1,4 do
		if board:inbounds(adjacents[i]) then
			if board:empty_square(adjacents[i]) then cnt = cnt+1 end
		end
	end
	return cnt
end
