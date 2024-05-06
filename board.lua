
Board = {
	Squares = nil;
	Attacked = nil;
}

-- piece numbers
--[[
0	empty
1 	up
2	down
3	left
4	right
5	player1
6	player2
7	player3
8	player4
9	goal
--]]

function Board:init()
	
	-- initialize board squares
	self.Squares = {}
	for i=1,Game.Gridsize do
		self.Squares[i] = {}
		for j=1,Game.Gridsize do
			self.Squares[i][j] = 0
		end
	end
	-- arrange pieces
	for i=1,Game.Gridsize/2 do
		self.Squares[Game.Gridsize+1-i][i] = 1
		self.Squares[Game.Gridsize+1-i][Game.Gridsize+1-i] = 3
		self.Squares[i][Game.Gridsize+1-i] = 2
		self.Squares[i][i] = 4
	end
	-- arrange player pieces
	self.Squares[(Game.Gridsize+1)/2][1] = 5
	self.Squares[(Game.Gridsize+1)/2][Game.Gridsize] = 6
	self.Squares[1][(Game.Gridsize+1)/2] = 7
	self.Squares[Game.Gridsize][(Game.Gridsize+1)/2] = 8
	-- place the goal in the center
	self.Squares[(Game.Gridsize+1)/2][(Game.Gridsize+1)/2] = 9
    
    -- initialize attacked squares
    self.Attacked = {}
    for i=1,Game.Gridsize do
		self.Attacked[i] = {}
		for j=1,Game.Gridsize do
			self.Attacked[i][j] = 0		-- initialize to 0
		end
	end
	Board:compute_attacked()
	
end

function Board:compute_attacked()
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			piece = self.Squares[i][j]
			if 1 <= piece and piece <= 4 then
				ii,jj = Board:piece_attacks({i,j}, piece)
				self.Attacked[ii][jj] = self.Attacked[ii][jj] + 1
			end
		end
	end
end

-- which square the piece 'piece' is attacking from square 'sq'
function Board:piece_attacks(sq, piece)
	i = sq[1]
	j = sq[2]
	if piece == 1 then
		j = j + 1
	elseif piece == 2 then
		j = j - 1
	elseif piece == 3 then
		i = i - 1
	elseif piece == 4 then
		i = i + 1
	end
	return i,j
end

-- updates the attacked squares caused by a potential move sq1 -> sq2
function Board:update_attacked(sq1, sq2)
	if Board:minor_piece_present(sq1) then
		piece_before = self.Squares[sq1[1]][sq1[2]]
		piece_after = Board:piece_orientation(sq1, sq2)
		-- which square to decrease the attacked value
		i,j = Board:piece_attacks(sq1, piece_before)
		self.Attacked[i][j] = self.Attacked[i][j] - 1
		-- which square to increase the attacked value
		i,j = Board:piece_attacks(sq2, piece_after)
		self.Attacked[i][j] = self.Attacked[i][j] + 1
	end
end

-- returns the orientation of a minor piece after a move sq1 -> sq2
function Board:piece_orientation(sq1, sq2)
	if sq2[2] == sq1[2]+1 then
		return 1				-- up
	elseif sq2[2] == sq1[2]-1 then
		return 2				-- down
	elseif sq2[1] == sq1[1]-1 then
		return 3				-- left
	elseif sq2[1] == sq1[1]+1 then
		return 4				-- right
	end
end

function Board:move_piece(sq1, sq2)
	Board:update_attacked(sq1, sq2)
	piece = self.Squares[sq1[1]][sq1[2]]
	if Board:minor_piece_present(sq1) then
		piece = Board:piece_orientation(sq1, sq2)
	end	
	self.Squares[sq2[1]][sq2[2]] = piece
	self.Squares[sq1[1]][sq1[2]] = 0
end

function Board:inbounds(sq)
	if sq[1] >= 1 and sq[1] <= Game.Gridsize and sq[2] >= 1 and sq[2] <= Game.Gridsize then
		return true
	end
	return false
end

function Board:empty_square(sq)
	return self.Squares[sq[1]][sq[2]] == 0 or self.Squares[sq[1]][sq[2]] == 9
end

function Board:piece_present(sq)
	return not Board:empty_square(sq)
end

function Board:player_present(sq)
	if 5 <= Board.Squares[sq[1]][sq[2]] and Board.Squares[sq[1]][sq[2]] <= 8 then
		return true
	end
	return false
end

function Board:minor_piece_present(sq)
	if 1 <= Board.Squares[sq[1]][sq[2]] and Board.Squares[sq[1]][sq[2]] <= 4 then
		return true
	end
	return false
end

function Board:move_is_backward(sq1, sq2)
	if self.Squares[sq1[1]][sq1[2]] == 1 and sq2[2] == sq1[2]-1 then
		return true
	elseif self.Squares[sq1[1]][sq1[2]] == 2 and sq2[2] == sq1[2]+1 then
		return true
	elseif self.Squares[sq1[1]][sq1[2]] == 3 and sq2[1] == sq1[1]+1 then
		return true
	elseif self.Squares[sq1[1]][sq1[2]] == 4 and sq2[1] == sq1[1]-1 then
		return true
	end
	return false
end

function Board:move_legality(sq1, sq2)
	if math.abs(sq1[1]-sq2[1])+math.abs(sq1[2]-sq2[2]) ~= 1 then				-- if the move is not to adjacent square
		return false
	elseif not Board:inbounds(sq2) then											-- if square is out of bounds
		return false
	elseif Board:piece_present(sq2) then										-- if the square is occupied
		return false
	elseif Board:move_is_backward(sq1, sq2) then								-- if moving backwards
		return false
	elseif Board:player_present(sq1) and self.Attacked[sq2[1]][sq2[2]] > 0 then	-- if a player tries to move to an atacked square
		return false
	end
	return true
end

function Board:draw_pieces()
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			if self.Squares[i][j] == 1 then		-- up
				love.graphics.draw(Textures.PieceU, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 2 then	-- down
				love.graphics.draw(Textures.PieceD, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 3 then	-- left
				love.graphics.draw(Textures.PieceL, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 4 then	-- right
				love.graphics.draw(Textures.PieceR, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 5 then	-- player1
				love.graphics.draw(Textures.Player1, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 6 then	-- player2
				love.graphics.draw(Textures.Player2, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 7 then	-- player3
				love.graphics.draw(Textures.Player3, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 8 then	-- player4
				love.graphics.draw(Textures.Player4, Utility:sq_coordinates({i,j}))
			elseif self.Squares[i][j] == 9 then	--goal
				love.graphics.draw(Textures.Goal, Utility:sq_coordinates({i,j}))
			end
		end
	end
end

function Board:draw_attacked()
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			if self.Attacked[i][j] > 0 then
				love.graphics.draw(Textures.Attacked, Utility:sq_coordinates({i,j}))
			end
		end
	end
end

