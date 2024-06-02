require("board")
require("player")
require("utility")

-- number of players
N = 10

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
	for r = 1,5 do players[n]:mutate_player() end
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
	for m = 1,80 do
		--if m%10 == 0 then print("\t\tmove "..m) end
		-- player 1
		local move = pl1:recommend_move()
		Board:make_move(move[1], move[2])
		if Board:win_check() then return 1 end
		-- player 2
		move = pl2:recommend_move()
		Board:make_move(move[1], move[2])
		if Board:win_check() then return -1 end
	end
	return 0	-- if 80 moves nothing happens call it a draw
end

-- each pair of players play two games (one as p1, and one as p2)
for p1 = 1,N do
	for p2 = p1+1,N do
		print("p1,p2 = "..p1..","..p2)
		local outcome = play_game(players[p1],players[p2])
		print("\toutcome = "..outcome)
		player_scores[p1] = player_scores[p1] + outcome
		player_scores[p2] = player_scores[p2] - outcome
		outcome = play_game(players[p2],players[p1])
		player_scores[p2] = player_scores[p2] + outcome
		player_scores[p1] = player_scores[p1] - outcome
		print("\toutcome = "..outcome)
	end
end
