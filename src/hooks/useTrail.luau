--!native
--!optimize 2

local React = require(script.Parent.Parent.Parent.React)
local useSprings = require(script.Parent.useSprings)
local util = require(script.Parent.Parent.util)

local function useTrail(length: number, propertiesArgument, dependencies: {any}?)
	local isFunction = type(propertiesArgument) == "function"

	local props = React.useMemo(function()
		if isFunction then
			return propertiesArgument
		end

		local newProps = table.create(length)
		local currentDelay = 0
		for key, value in propertiesArgument do
			local property = util.merge({delay = 0.1}, value)
			local delayAmount = property.delay
			property.delay = currentDelay
			currentDelay += delayAmount
			newProps[key] = property
		end

		return newProps

		-- Need to pass {{}} because useMemo doesn't support nil dependency yet
	end, dependencies or {{}})

	-- TODO: Calculate delay for api methods as well
	local styles, api = useSprings(length, props, dependencies)

	local modifiedApi = React.useRef({}).current

	-- Return api with modified api.start
	if isFunction then
		-- We can't just copy as we want to guarantee the returned api doesn't change its reference
		table.clear(modifiedApi)
		for key, value in api do
			modifiedApi[key] = value
		end

		modifiedApi.start = function(startFunction)
			local currentDelay = 0
			api.start(function(index)
				local startProperties = util.merge({delay = 0.1}, startFunction(index))
				local delayAmount = startProperties.delay
				startProperties.delay = currentDelay
				currentDelay += delayAmount
				return startProperties
			end)
		end

		return styles, modifiedApi
	end

	return styles
end

return useTrail
