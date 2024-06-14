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
	if Game.Newgame then
		Game:newgame_update()
	elseif Game.Paused then
		Game:pause_update()
	else
		Game:update(dt)
	end
end

function love.draw()
	Game:renderGame()
end

