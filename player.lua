
Player = {
}

-- function that finds a move to recommend
function Player:recommend_move()
	moves = Board:list_legal_moves() -- all legal moves
	return moves[1] -- just placeholder
end
