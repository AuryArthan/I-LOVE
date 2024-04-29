
Board = {
	Background = nil;
	Highlighter = nil;
	Gridsize = nil;
	SqSize = nil;
	A1_pos = nil;
	HighSq = nil;
}

function Board:init()

	-- load background
	self.Background = love.graphics.newImage("assets/back.png")
	
	-- load piece textures
	self.Highlighter = love.graphics.newImage("assets/highlighter.png")
	
	-- load grid
	self.Grid7 = love.graphics.newImage("assets/grid7.png")
	self.Grid9 = love.graphics.newImage("assets/grid9.png")
	self.Grid11 = love.graphics.newImage("assets/grid11.png")
	
	-- set gridsize
	self.Gridsize = 9

	-- set size of square in pixels
	self.SqSize = 24
	
	-- set coordinates of A1
	self.A1_pos = {133,221}
	
	-- set highlighted square (default A1)
	self.HighSq = {3,6}
	
end

function Board:renderGame()

	-- draw background
	love.graphics.draw(self.Background, 0, 0)
	
	-- draw grid
	love.graphics.draw(self.Grid9, 0, 0)

	-- draw highlighed square
	love.graphics.draw(self.Highlighter, self.A1_pos[1]+(self.HighSq[1]-1)*self.SqSize, self.A1_pos[2]-(self.HighSq[2]-1)*self.SqSize)
	
end
