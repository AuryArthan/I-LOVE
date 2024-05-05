
Sounds = {
	BackMusic = nil;
	TicSound = nil;
	SnapSound = nil;
	SelSound = nil;
	DeSelSound = nil;
}

function Sounds:init()
	
	-- load sounds and music
	self.TicSound = love.audio.newSource("assets/themes/"..Game.Theme.."/tic.wav", "static")
	self.SnapSound = love.audio.newSource("assets/themes/"..Game.Theme.."/snap.wav", "static"); self.SnapSound:setVolume(3)
	self.SelSound = love.audio.newSource("assets/themes/"..Game.Theme.."/select.wav", "static")
	self.DeSelSound = love.audio.newSource("assets/themes/"..Game.Theme.."/deselect.wav", "static")
	self.BackMusic = love.audio.newSource("assets/themes/"..Game.Theme.."/background_music.ogg", "stream")
	
	-- set background music
	self.BackMusic:setVolume(0.4)
	self.BackMusic:play()
	self.BackMusic:setLooping(true)
	
end
