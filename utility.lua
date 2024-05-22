
-- copies square 'sq' and returns the copy
function square_copy(sq)
	return {sq[1], sq[2]}
end

-- compares squares 'sq1' and 'sq2'
function square_compare(sq1, sq2)
	if sq1 and sq2 then
		if sq1[1] ~= sq2[1] then return false end
		if sq1[2] ~= sq2[2] then return false end
		return true
	end
	return false
end

-- checks if square 'sq' is inbounds
function inbounds(sq)
	if sq[1] >= 1 and sq[1] <= Game.Gridsize and sq[2] >= 1 and sq[2] <= Game.Gridsize then
		return true
	end
	return false
end

-- returns neighboring squares (does not check whether they are inbounds)
function neighbors(sq)
	return {{sq[1],sq[2]+1},{sq[1],sq[2]-1},{sq[1]-1,sq[2]},{sq[1]+1,sq[2]}}	-- UDLR
end

-- returns second neighboring squares (does not check whether they are inbounds)
function second_neighbors(sq)
	return {{sq[1],sq[2]+2}, {sq[1]+1,sq[2]+1}, {sq[1]+2,sq[2]}, {sq[1]+1,sq[2]-1}, {sq[1],sq[2]-2}, {sq[1]-1,sq[2]-1}, {sq[1]-2,sq[2]}, {sq[1]-1,sq[2]+1}}
end

-- finds the index of the largest element
function max_index(lst)
	if #lst == 0 then return nil end
	local max = lst[1]
	local index = 1
	for i=2,#lst do
		if lst[i] > max then
			max = lst[i]
			index = i 
		end
	end
	return index
end

-- sums up the elements of a list
function sum(lst)
    local total = 0
    for i = 1,#lst do
        total = total + lst[i]
    end
    return total
end
