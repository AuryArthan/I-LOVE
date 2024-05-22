
Textures = {
	Background = nil;
	Grid = nil;
	Highlighter = nil;
	Selected = nil;
	MoveOption = nil;
	PiecesUDLR = {nil,nil,nil,nil};
	Players = {nil,nil,nil,nil};
	PlayerDead = nil;
	MarkedSqs = {nil,nil,nil,nil};
	Goal = nil;
}

function Textures:init()

	-- load font
	font = love.graphics.newImageFont("assets/font.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/=.,!?:;()[]&#%\"\'_|")
	love.graphics.setFont(font)
	
	-- load background
	self.Background = love.graphics.newImage("assets/themes/"..Game.Theme.."/back.png")
	
	-- load highlighters
	self.Highlighter = love.graphics.newImage("assets/highlighter.png")
	self.Selected = love.graphics.newImage("assets/selected.png")
	self.MoveOption = love.graphics.newImage("assets/move_option.png")
	self.Attacked = love.graphics.newImage("assets/themes/"..Game.Theme.."/attacked.png")
	self.MarkedSqs = {love.graphics.newImage("assets/themes/"..Game.Theme.."/marked_p1.png"),love.graphics.newImage("assets/themes/"..Game.Theme.."/marked_p2.png"),love.graphics.newImage("assets/themes/"..Game.Theme.."/marked_p3.png"),love.graphics.newImage("assets/themes/"..Game.Theme.."/marked_p4.png")}
	
	-- load piece textures
	self.PiecesUDLR = {love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_u_7.png"), love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_d.png"), love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_l.png"), love.graphics.newImage("assets/themes/"..Game.Theme.."/piece_r.png")}
	self.Players = {love.graphics.newImage("assets/themes/"..Game.Theme.."/player1_7.png"), love.graphics.newImage("assets/themes/"..Game.Theme.."/player2.png"), love.graphics.newImage("assets/themes/"..Game.Theme.."/player3.png"), love.graphics.newImage("assets/themes/"..Game.Theme.."/player4.png")}
	self.PlayerDead = love.graphics.newImage("assets/themes/"..Game.Theme.."/player_dead.png")
	self.Goal = love.graphics.newImage("assets/themes/"..Game.Theme.."/goal.png")
	
	-- load grid
	self.Grid = love.graphics.newImage("assets/themes/"..Game.Theme.."/grid"..Game.Gridsize..".png")
	
end
