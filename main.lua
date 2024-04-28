require("board")

function love.conf(t)
	t.width = 480
	t.height = 272
end

function love.load()
	Board:init()
end

function love.update(dt)
end

function love.draw()
	Board:renderGame()
end

