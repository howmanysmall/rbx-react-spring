--!native
--!optimize 2
local Packages = require(script.Parent.Parent.Packages)
local useSprings = require(script.Parent.useSprings)
local util = require(script.Parent.Parent.util)
local React = Packages.React

local function useTrail(length: number, propsArg, deps: {any}?)
	local isFn = type(propsArg) == "function"

	local props = React.useMemo(function()
		if isFn then
			return propsArg
		end

		local newProps = table.create(length)
		local currentDelay = 0
		for i, v in propsArg do
			local prop = util.merge({delay = 0.1}, v)
			local delayAmount = prop.delay
			prop.delay = currentDelay
			currentDelay += delayAmount
			newProps[i] = prop
		end

		return newProps

		-- Need to pass {{}} because useMemo doesn't support nil dependency yet
	end, deps or {{}})

	-- TODO: Calculate delay for api methods as well
	local styles, api = useSprings(length, props, deps)

	local modifiedApi = React.useRef({}).current

	-- Return api with modified api.start
	if isFn then
		-- We can't just copy as we want to guarantee the returned api doesn't change its reference
		table.clear(modifiedApi)
		for key, value in api do
			modifiedApi[key] = value
		end

		modifiedApi.start = function(startFn)
			local currentDelay = 0
			api.start(function(i)
				local startProps = util.merge({delay = 0.1}, startFn(i))
				local delayAmount = startProps.delay
				startProps.delay = currentDelay
				currentDelay += delayAmount
				return startProps
			end)
		end

		return styles, modifiedApi
	end

	return styles
end

return useTrail
