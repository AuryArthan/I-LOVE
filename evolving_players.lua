require("board")
require("player")

-- number of players
N = 300

-- random seed
math.randomseed(os.time())

-- mutate player
function Player:mutate_player()
	for i = 1,8 do
		self.weights[i] = self.weights[i]*(1+(math.random()-0.5)/10)
	end
end

-- initialize players
players = {}
player_scores = {}
for n = 1,N do
	players[n] = {weights = {3,1,5,6,4,4,5,2}; ShortestPathlength = nil;}
	setmetatable(players[n], { __index = Player })
	players[n]:mutate_player()
	player_scores[n] = 0
end

Game = {NumPlayers = nil; NumLivePlayers = nil; Gridsize = nil; HumanPlayers = {nil,nil,nil,nil};}
-- minimal game init
function Game:init_min()
	self.NumPlayers = 2
	self.NumLivePlayers = self.NumPlayers
	self.HumanPlayers = {false, false, false, false}
	self.Gridsize = 9
end

-- play game function
function play_game(pl1,pl2)
	Game:init_min()
	Board:init()
	return 0
end

-- each pair of players play two games (one as p1, and one as p2)
for p1 = 1,N do
	print("p1 = "..p1)
	for p2 = 1,N do
		if p1 ~= p2 then
			local outcome = play_game(players[p1],players[p2])
			player_scores[p1] = player_scores[p1] + outcome
			player_scores[p2] = player_scores[p2] - outcome
			outcome = play_game(players[p2],players[p1])
			player_scores[p2] = player_scores[p2] + outcome
			player_scores[p1] = player_scores[p1] - outcome
		end
	end
end
