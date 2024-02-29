local formatter_utils = {}

function formatter_utils.make_switch(default, conditions)
	return function(...)
        for _, condition in ipairs(conditions) do
            if condition[1](...) then
                return condition[2](...)
            end
        end
        return default(...)
    end
end

return formatter_utils