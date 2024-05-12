require("game")
require("board")
require("textures")
require("sounds")
require("debug_print")

function love.conf(t)
	t.width = 480
	t.height = 272
end

function love.load()
	Game:init()
	Board:init()
	Textures:init()
	Sounds:init()
end

function love.update(dt)
	Game:update()
end

function love.draw()
	Game:renderGame()
end

