require("board")
require("player")
require("utility")

-- number of players
N = 180
-- number of generations
Ngen = 50

-- random seed
math.randomseed(os.time())

-- copy player (just weights really)
function Player:copy()
	local copy = {weights = {}; ShortestPathlength = nil; score = 0}
	for i = 1,#self.weights do
		copy.weights[i] = self.weights[i]
	end
	setmetatable(copy, { __index = Player })
	return copy
end

-- mutate player
function Player:mutate_player()
	for i = 1,8 do
		self.weights[i] = self.weights[i]*(1+(math.random()-0.5)/20)
	end
end

-- initialize players
players = {}
for n = 1,N do
	players[n] = {weights = {3,1,5,6,4,4,5,2}; ShortestPathlength = nil; score = 0}
	setmetatable(players[n], { __index = Player })
	for r = 1,6 do players[n]:mutate_player() end
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

-- init output file
local file = io.open("trained_players/output.txt", "w")
file:close()
-- generation loop
for gen = 1,Ngen do
	-- set player scores to 0
	for p = 1,N do players[p].score = 0 end
	-- each pair of players play two games (one as p1, and one as p2)
	for p1 = 1,N do
		for p2 = p1+1,N do
			print("gen "..gen.."\tplayers "..p1..","..p2)
			local outcome = play_game(players[p1],players[p2])
			print("\t\toutcome = "..outcome)
			players[p1].score = players[p1].score + outcome
			players[p2].score = players[p2].score - outcome
			outcome = play_game(players[p2],players[p1])
			players[p2].score = players[p2].score + outcome
			players[p1].score = players[p1].score - outcome
			print("\t\toutcome = "..outcome)
		end
	end
	-- sort them
	table.sort(players, function(a,b) return a.score > b.score end)
	-- the top 60 reproduce and have 2 mutated offspring each
	for p = 1,60 do
		players[60+p] = players[p]:copy()
		players[120+p] = players[p]:copy()
		players[60+p]:mutate_player()							-- 1st offspring single mutation
		for r = 1,2 do players[120+p]:mutate_player() end		-- 2nd offspring double mutation
	end
	-- write the top 60 to a file
	file = io.open("trained_players/output.txt", "a")
	for p = 1,60 do
		file:write("gen "..gen.."  index "..p.."  score "..players[p].score.."  { ")
		for w = 1,8 do
			file:write(players[p].weights[w].." ")
		end
		file:write("}\n")
	end
	file:close()
end
