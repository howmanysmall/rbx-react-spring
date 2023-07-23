--!optimize 2
local function map(dictionary, fn)
	local new = {}

	for key, value in dictionary do
		local newValue, newKey = fn(value, key)
		new[newKey or key] = newValue
	end

	return new
end

return map
