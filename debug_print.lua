
DebugPr = {}

-- dpad print
function DebugPr:dpad_print(DPAD, posx, posy)
	love.graphics.print("DPAD", posx-1, posy-10)
	-- dpad with []
	love.graphics.print("[", posx+5, posy)
	love.graphics.print("]", posx+10, posy)
	love.graphics.print("[", posx+5, posy+10)
	love.graphics.print("]", posx+10, posy+10)
	love.graphics.print("[", posx, posy+5)
	love.graphics.print("]", posx+5, posy+5)
	love.graphics.print("[", posx+10, posy+5)
	love.graphics.print("]", posx+15, posy+5)
	-- dpad pressed with .
	if DPAD[1] == true then
		love.graphics.print(".", posx+10-2, posy-2)
	end
	if DPAD[2] == true then
		love.graphics.print(".", posx+10-2, posy+10-2)
	end
	if DPAD[3] == true then
		love.graphics.print(".", posx+5-2, posy+5-2)
	end
	if DPAD[4] == true then
		love.graphics.print(".", posx+15-2, posy+5-2)
	end
end

-- button pressed print
function DebugPr:buttons_print(A, B, posx, posy)
	love.graphics.print("A[", posx, posy)
	love.graphics.print("]", posx+11, posy)
	love.graphics.print("B[", posx, posy+10)
	love.graphics.print("]", posx+11, posy+10)
	if A == true then
		love.graphics.print(".", posx+9, posy-2)
	end
	if B == true then
		love.graphics.print(".", posx+9, posy+8)
	end
end
	
-- ASDelays print
function DebugPr:asdelays_print(ASDelay, posx, posy)
	love.graphics.print("ASDelays", posx-20, posy-10)
	-- ASDelays
	love.graphics.print(ASDelay[1], posx, posy)
	love.graphics.print(ASDelay[2], posx, posy+20)
	love.graphics.print(ASDelay[3], posx-10, posy+10)
	love.graphics.print(ASDelay[4], posx+10, posy+10)
end

-- board print
function DebugPr:board_print(posx, posy)
	love.graphics.print("Board", posx, posy)
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			love.graphics.print(Board.Squares[i][j], posx+(i-1)*10, posy+(Game.Gridsize-j+1)*10)
		end
	end
end

-- board attacked print
function DebugPr:board_attacked_print(posx, posy)
	love.graphics.print("Attacked", posx, posy)
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			love.graphics.print(Board.Attacked[i][j], posx+(i-1)*10, posy+(Game.Gridsize-j+1)*10)
		end
	end
end

-- free adjacent squares print
function DebugPr:free_adjacents_print(posx, posy)
	love.graphics.print("Free adjacents", posx, posy)
	for p=1,4 do
		love.graphics.print(" Player "..p..":", posx, posy+p*13)
		if Board.PlayerAlive[p] then
			love.graphics.print(Player:free_adjacent_squares(p, Board), posx+61, posy+p*13)
		end
	end
end

-- piece_present print
function DebugPr:piece_present_print(posx, posy)
	love.graphics.print("piece_present()", posx, posy)
	for i=1,Game.Gridsize do
		for j=1,Game.Gridsize do
			if Board:piece_present({i,j}) then
				love.graphics.print("1", posx+(i-1)*10, posy+(Game.Gridsize-j+1)*10)
			else
				love.graphics.print("0", posx+(i-1)*10, posy+(Game.Gridsize-j+1)*10)
			end
		end
	end
end

-- player position print
function DebugPr:player_pos(posx, posy)
	love.graphics.print("Player positions", posx, posy)
	for i=1,4 do
		love.graphics.print(i .. " : " .. " ( " .. Board.PlayerPos[i][1] .. " , " .. Board.PlayerPos[i][2] .. " ) ", posx+5, posy+12*i)
	end
end

-- player turn print
function DebugPr:player_turn(posx, posy)
	love.graphics.print("Player turn: " .. Board.Turn, posx, posy)
end

-- human player print
function DebugPr:human_player(posx, posy)
	love.graphics.print("Human turn: " .. tostring(Game.HumanPlayers[Board.Turn]), posx, posy)
end

-- legal moves print
function DebugPr:legal_moves(posx, posy)
	love.graphics.print("Legal moves: ", posx, posy)
	moves = Board:list_legal_moves()
	for i,m in ipairs(moves) do
		love.graphics.print(i .. ": ("..moves[i][1][1]..","..moves[i][1][2].. ") - ("..moves[i][2][1]..","..moves[i][2][2]..")", posx+1, posy+7*i)
	end
end
