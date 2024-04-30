require("board")

function love.conf(t)
	t.width = 480
	t.height = 272
end

function love.load()
	font = love.graphics.newImageFont("assets/font_basic.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/=.,!?:;()[]&#%\"\'")
	love.graphics.setFont(font)
	Board:init()
end

function love.update(dt)
	Board:update()
end

function love.draw()
	Board:renderGame()
end

