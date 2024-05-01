
Board = {
	Gridsize = nil;
	Squares = nil;
}

function Board:init()

	-- set gridsize
	self.Gridsize = 9
	
	-- initialize board squares
	self.Squares = {}
	for i=1,self.Gridsize do
		self.Squares[i] = {}
		for j=1,self.Gridsize do
			self.Squares[i][j] = 0
		end
	end
	-- arrange pieces
	for i=1,self.Gridsize do
		self.Squares[i][i] = 1
	end
    
end
