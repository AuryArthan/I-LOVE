
Utility = {
}

function Utility:sq_coordinates(pos)
	return Game.A1_coord[1]+(pos[1]-1)*Game.SqSize, Game.A1_coord[2]-(pos[2]-1)*Game.SqSize
end
