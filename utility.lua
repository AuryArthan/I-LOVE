
Utility = {
}

function Utility:tuple_copy(t)
	return {t[1], t[2]}
end

function Utility:tuple_compare(t1, t2)
	if t1 and t2 then
		if t1[1] ~= t2[1] then
			return false
		end
		if t1[2] ~= t2[2] then
			return false
		end
		return true
	end
	return false
end

function Utility:sq_coordinates(pos)
	return Game.A1_coord[1]+(pos[1]-1)*Game.SqSize, Game.A1_coord[2]-(pos[2]-1)*Game.SqSize
end
