
Board = {
	Squares = nil;
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
