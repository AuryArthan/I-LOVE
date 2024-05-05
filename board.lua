
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
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			if self.Squares[i][j] == 1 and j < Game.Gridsize then		-- up attacked
				self.Attacked[i][j+1] = self.Attacked[i][j+1]+1
			elseif self.Squares[i][j] == 2 and j > 1 then				-- down attacked
				self.Attacked[i][j-1] = self.Attacked[i][j-1]+1
			elseif self.Squares[i][j] == 3 and i > 1 then				-- left attacked
				self.Attacked[i-1][j] = self.Attacked[i-1][j]+1
			elseif self.Squares[i][j] == 4 and i < Game.Gridsize then	-- right attacked
				self.Attacked[i+1][j] = self.Attacked[i+1][j]+1
			end
		end
	end
	
end

function Board:move_piece(sq1, sq2)
	Board.Squares[sq2[1]][sq2[2]] = Board.Squares[sq1[1]][sq1[2]]
	Board.Squares[sq1[1]][sq1[2]] = 0
end

function Board:piece_present(sq)
	if Board.Squares[sq[1]][sq[2]] == 0 or Board.Squares[sq[1]][sq[2]] == 9 then
		return false
	end
	return true
end

function Board:inbounds(sq)
	if sq[1] >= 1 and sq[1] <= Game.Gridsize and sq[2] >= 1 and sq[2] <= Game.Gridsize then
		return true
	end
	return false
end

function Board:move_legality(sq1, sq2)
	if math.abs(sq1[1]-sq2[1])+math.abs(sq1[2]-sq2[2]) ~= 1 then		-- if the move is not to adjacent square
		return false
	elseif not Board:inbounds(sq2) then									-- if square is out of bounds
		return false
	--elseif Board.piece_present(sq2) then								-- if the square is occupied
	--	return false
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
