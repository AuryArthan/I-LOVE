
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
