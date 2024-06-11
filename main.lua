require("game")
require("board")
require("player")
require("utility")
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
	if Game.Paused then Game:pause_update() end
	if not Game.Paused then Game:update(dt) end
end

function love.draw()
	Game:renderGame()
end

