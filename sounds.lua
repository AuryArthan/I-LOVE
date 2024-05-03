
Sounds = {
	BackMusic = nil;
	TicSound = nil;
}

function Sounds:init()
	
	-- load sounds and music
	self.TicSound = love.audio.newSource("assets/themes/"..Game.Theme.."/tic.wav", "static")
	self.BackMusic = love.audio.newSource("assets/themes/"..Game.Theme.."/background_music.wav", "stream")
	
	-- set background music
	self.BackMusic:setVolume(0.4)
	self.BackMusic:play()
	self.BackMusic:setLooping(true)
	
end
