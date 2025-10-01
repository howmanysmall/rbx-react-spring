--!native
--!optimize 2

local useSprings = require(script.Parent.useSprings)

local function useSpring(properties, dependencies: {any}?)
	local isFunction = type(properties) == "function"
	local styles, api = useSprings(
		1,
		if isFunction then properties else {properties},
		if isFunction then dependencies or {} else dependencies
	)
	return styles[1], api
end

return useSpring
