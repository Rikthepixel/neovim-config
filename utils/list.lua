local list_utils = {}

function list_utils.find(list, fn)
	for index, value in ipairs(list) do
		local is_found = fn(value, index, list)
        if is_found then
            return value, index
        end
	end
    return nil, -1
end

return list_utils