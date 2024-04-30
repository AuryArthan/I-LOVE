require("board")

function love.conf(t)
	t.width = 480
	t.height = 272
end

function love.load()
	font = love.graphics.newImageFont("assets/font_basic.png", " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/=.,!?:;()&#%\"\'")
	love.graphics.setFont(font)
	Board:init()
end

function love.update(dt)
	Board:update()
end

function love.draw()
	Board:renderGame()
	love.graphics.print(" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-*/=.,!?:;()&#%\"\'", -5, 6)
	love.graphics.print("Sean Arthan", 30, 60)
	love.graphics.print("Sentence. Exlamation! Question? And then, the comma: Here; There; etc.", 30, 80)
	love.graphics.print("Apostrophe\' and then quatations \"", 30, 100)
end

