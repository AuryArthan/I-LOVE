
Sounds = {
	BackMusic = nil;
	TicSound = nil;
	SnapSound = nil;
	SelSound = nil;
	DeSelSound = nil;
	DeathSound = nil;
	WinSound = nil;
}

function Sounds:init()
	
	-- load sounds and music
	self.TicSound = love.audio.newSource("assets/tic.wav", "static")
	self.SelSound = love.audio.newSource("assets/select.wav", "static")
	self.DeSelSound = love.audio.newSource("assets/deselect.wav", "static")
	self.SnapSound = love.audio.newSource("assets/themes/"..Game.Theme.."/snap.ogg", "static"); self.SnapSound:setVolume(3)
	self.DeathSound = love.audio.newSource("assets/themes/"..Game.Theme.."/death.ogg", "static"); 
	self.WinSound = love.audio.newSource("assets/themes/"..Game.Theme.."/win.ogg", "static"); 
	self.BackMusic = love.audio.newSource("assets/themes/"..Game.Theme.."/background_music.ogg", "stream")
	
	-- set background music
	self.BackMusic:setVolume(0.4)
	self.BackMusic:play()
	self.BackMusic:setLooping(true)
	
end
