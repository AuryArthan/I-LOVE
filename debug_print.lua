
DebugPr = {
}

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
			love.graphics.print(Board.Squares[i][j], posx+(i-1)*12, posy+(Game.Gridsize-j+1)*12)
		end
	end
end

