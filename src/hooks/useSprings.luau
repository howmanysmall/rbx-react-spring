--!native
--!optimize 2

local Controller = require(script.Parent.Parent.Controller)
local Promise = require(script.Parent.Parent.Promise)
local React = require(script.Parent.Parent.Parent.React)
local util = require(script.Parent.Parent.util)

local function useSprings(length: number, properties: {any} | (index: number) -> {[string]: any}, dependencies: {any}?)
	local isImperative = React.useRef(nil)
	local controls = React.useRef({}).current
	local stylesList = React.useRef({}).current
	local apiList = React.useRef({}).current

	if type(properties) == "table" then
		assert(
			isImperative.current == nil or isImperative.current == false,
			"useSprings detected a change from imperative to declarative. This is not supported."
		)

		isImperative.current = false
	elseif type(properties) == "function" then
		assert(
			isImperative.current == nil or isImperative.current == true,
			"useSprings detected a change from declarative to imperative. This is not supported."
		)

		isImperative.current = true
	else
		error("Expected table or function for useSprings, got " .. typeof(properties))
	end

	React.useEffect(function()
		if isImperative.current == false then
			for key, spring in controls do
				local startProperties = util.merge(properties[key], {
					reset = if properties[key].reset then properties[key].reset else false,
				})

				spring:start(util.merge({default = true}, startProperties))
			end
		end
	end, dependencies)

	-- Create new controllers when "length" increases, and destroy
	-- the affected controllers when "length" decreases
	React.useMemo(function()
		if length > #controls then
			for index = #controls + 1, length do
				local styles, api =
					Controller.new(if type(properties) == "table" then properties[index] else properties(index))
				controls[index] = api
				stylesList[index] = styles
			end
		else
			-- Clean up any unused controllers
			for index = length + 1, #controls do
				controls[index]:stop()
				controls[index] = nil
				stylesList[index] = nil
				apiList[index] = nil
			end
		end
	end, {length})

	React.useMemo(function()
		if isImperative.current then
			if #controls > 0 then
				for apiName, value in getmetatable(controls[1]) do
					if type(value) == "function" and apiName ~= "new" then
						apiList[apiName] = function(apiProperties: (index: number) -> any | any)
							local promises = table.create(#controls)
							for index, spring in controls do
								promises[index] = Promise.new(function(resolve)
									local result = spring[apiName](
										spring,
										if type(apiProperties) == "function"
											then apiProperties(index)
											else apiProperties
									)

									-- Some results might be promises
									if result and result.await then
										result:await()
									end

									resolve()
								end)
							end

							return Promise.all(promises)
						end
					end
				end
			end
		end
		-- Need to pass {{}} because useMemo doesn't support nil dependency yet
	end, dependencies or {{}})

	-- Cancel the animations of all controllers on unmount
	React.useEffect(function()
		return function()
			for _, control in controls do
				control:stop()
			end
		end
	end, {})

	if isImperative.current then
		return stylesList, apiList
	end

	return stylesList
end

return useSprings
