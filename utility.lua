
Utility = {
}

function Utility:deepcopy(orig)
    local copy = {}
    for k, v in pairs(orig) do
        copy[k] = type(v) == "table" and deepcopy(v) or v
    end
    return copy
end

function Utility:deepcompare(t1, t2)
    if type(t1) ~= type(t2) then return false end
    if type(t1) ~= "table" then return t1 == t2 end
    local mt1, mt2 = getmetatable(t1), getmetatable(t2)
    if mt1 ~= mt2 then return false end
    for k, v in pairs(t1) do
        if not deepcompare(v, t2[k]) then return false end
    end
    for k, v in pairs(t2) do
        if not deepcompare(v, t1[k]) then return false end
    end
    return true
end

function Utility:sq_coordinates(pos)
	return Game.A1_coord[1]+(pos[1]-1)*Game.SqSize, Game.A1_coord[2]-(pos[2]-1)*Game.SqSize
end

