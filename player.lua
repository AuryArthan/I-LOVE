
Player = {}

-- function that finds a move to recommend
function Player:recommend_move()
	--local newBoard = Board:new()
	--local copyBoard = mainBoard:copy()
	moves = mainBoard:list_legal_moves() -- all legal moves
	return moves[math.random(1, #moves)] -- just placeholder
end

