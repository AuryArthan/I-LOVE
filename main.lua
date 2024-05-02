require("game")
require("board")
require("utility")

function love.conf(t)
	t.width = 480
	t.height = 272
end

function love.load()
	font = love.graphics.newImageFont("assets/font_basic.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/=.,!?:;()[]&#%\"\'")
	love.graphics.setFont(font)
	Game:init()
	Board:init()
end

function love.update(dt)
	Game:update()
end

function love.draw()
	Game:renderGame()
end

