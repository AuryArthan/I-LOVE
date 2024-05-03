
Utility = {
}

function Utility:deepcopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = type(v) == "table" and deepcopy(v) or v
    end
    return copy
end

function Utility:sq_coordinates(pos)
	return Game.A1_coord[1]+(pos[1]-1)*Game.SqSize, Game.A1_coord[2]-(pos[2]-1)*Game.SqSize
end
