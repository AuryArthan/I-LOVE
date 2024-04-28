
Board = {
	Background = nil;
}

function Board:init()

	-- load background
	self.Background = love.graphics.newImage("assets/back.png")
	
	-- load grid
	self.Grid7 = love.graphics.newImage("assets/grid7.png")
	self.Grid9 = love.graphics.newImage("assets/grid9.png")
	self.Grid11 = love.graphics.newImage("assets/grid11.png")

end

function Board:renderGame()

	-- draw background
	love.graphics.draw(self.Background, 0, 0)
	
	-- draw grid
	love.graphics.draw(self.Grid9, 0, 0)

end
