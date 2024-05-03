
Textures = {
	Background = nil;
	Grid = nil;
	Highlighter = nil;
	Selected = nil;
	MoveOption = nil;
	PieceU = nil;
	PieceD = nil;
	PieceL = nil;
	PieceR = nil;
	Goal = nil;
}

function Textures:init()

	-- load font
	font = love.graphics.newImageFont("assets/font_basic.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/=.,!?:;()[]&#%\"\'")
	love.graphics.setFont(font)
	
	-- load background
	self.Background = love.graphics.newImage("assets/themes/"..Game.Theme.."/back.png")
	
	-- load highlighters
	self.Highlighter = love.graphics.newImage("assets/themes/"..Game.Theme.."/highlighter.png")
	self.Selected = love.graphics.newImage("assets/themes/"..Game.Theme.."/selected.png")
	self.MoveOption = love.graphics.newImage("assets/themes/"..Game.Theme.."/move_option.png")
	
	-- load piece textures
	self.PieceU = love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_u.png")
	self.PieceD = love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_d.png")
	self.PieceL = love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_l.png")
	self.PieceR = love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_r.png")
	self.Player1 = love.graphics.newImage("assets/themes/"..Game.Theme.."/player1.png")
	self.Player2 = love.graphics.newImage("assets/themes/"..Game.Theme.."/player2.png")
	self.Player3 = love.graphics.newImage("assets/themes/"..Game.Theme.."/player3.png")
	self.Player4 = love.graphics.newImage("assets/themes/"..Game.Theme.."/player4.png")
	self.Goal = love.graphics.newImage("assets/themes/"..Game.Theme.."/goal.png")
	
	-- load grid
	self.Grid = love.graphics.newImage("assets/themes/"..Game.Theme.."/grid"..Game.Gridsize..".png")
	
end
