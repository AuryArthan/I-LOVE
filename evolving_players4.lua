require("board")
require("player")
require("utility")

-- number of players
N = 200
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
		self.weights[i] = self.weights[i]*(1+(math.random()-0.5)/15)		-- small mutation
		if math.random() < 0.5 then
			self.weights[i] = self.weights[i]*(1+(math.random()-0.5)/8)		-- bigger mutation
		end
		if math.random() < 0.2 then
			self.weights[i] = self.weights[i]*(1+(math.random()-0.5)/3.5)	-- big mutation
		end
		if math.random() < 0.1 then
			self.weights[i] = self.weights[i]*(1+(math.random()-0.5)/1.5)	-- huge mutation
		end
	end
end

-- initialize players
players = {}
for n = 1,N do
	players[n] = {weights = {3,1,5,6,4,4,5,2}; ShortestPathlength = nil; score = 0}
	setmetatable(players[n], { __index = Player })
	for r = 2,50 do players[n]:mutate_player() end
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
local file = io.open("trained_players4/output.txt", "w")
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
	-- the top 20 reproduce and have 9 mutated offspring each
	for p = 1,20 do
		players[20+p] = players[p]:copy()
		players[40+p] = players[p]:copy()
		players[60+p] = players[p]:copy()
		players[80+p] = players[p]:copy()
		players[100+p] = players[p]:copy()
		players[120+p] = players[p]:copy()
		players[140+p] = players[p]:copy()
		players[160+p] = players[p]:copy()
		players[180+p] = players[p]:copy()
		-- 1st three offspring single mutation
		players[20+p]:mutate_player()	
		players[40+p]:mutate_player()
		players[60+p]:mutate_player()
		-- 2nd three offspring double mutation
		for r = 1,2 do
			players[80+p]:mutate_player()
			players[100+p]:mutate_player()
			players[120+p]:mutate_player()
		end
		-- 3rd three offspring tripple mutation
		for r = 1,3 do
			players[140+p]:mutate_player()
			players[160+p]:mutate_player()
			players[170+p]:mutate_player()
		end
	end
	-- write the top 20 to a file
	file = io.open("trained_players4/output.txt", "a")
	for p = 1,20 do
		file:write("gen "..gen.."  index "..p.."  score "..players[p].score.."  { ")
		for w = 1,8 do
			file:write(players[p].weights[w].." ")
		end
		file:write("}\n")
	end
	file:close()
end
