
Textures = {
	Background = nil;
	Grid7 = nil;
	Grid9 = nil;
	Grid11 = nil;
	Highlighter = nil;
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
	self.Background = love.graphics.newImage("assets/back.png")
	
	-- load piece textures
	self.Highlighter = love.graphics.newImage("assets/highlighter.png")
	self.PieceU = love.graphics.newImage("assets/piece_u.png")
	self.PieceD = love.graphics.newImage("assets/piece_d.png")
	self.PieceL = love.graphics.newImage("assets/piece_l.png")
	self.PieceR = love.graphics.newImage("assets/piece_r.png")
	self.Goal = love.graphics.newImage("assets/goal.png")
	
	-- load grid
	self.Grid7 = love.graphics.newImage("assets/grid7.png")
	self.Grid9 = love.graphics.newImage("assets/grid9.png")
	self.Grid11 = love.graphics.newImage("assets/grid11.png")
	
end
