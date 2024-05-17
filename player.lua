
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
	local legal_moves = Board:list_legal_moves()	-- all legal moves
	local scores = {}
	for m=1,#legal_moves do							-- loop over them
		local testBoard = Board:copy()								-- make a test board copy
		--testBoard.Squares[1][1]=1
		--Board.Squares[2][1]=1
		testBoard:write_to_square({1,4},1)
		Board:write_to_square({1,3},1)
		--testBoard:make_move(legal_moves[m][1], legal_moves[m][2])	-- make the move
	--	score[m] = Player:state_score(active_player, testBoard)		-- evaluate the state 	
	end
	--return moves[max_index(score)] -- just placeholder
	return moves[math.random(1, #moves)] -- just placeholder
end

-- function that evaluates the board state
function Player:state_score(player, board)
	local num_legal_moves = #Board:list_legal_moves()	-- number of legal moves
	return num_legal_moves
end
