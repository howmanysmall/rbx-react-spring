--!optimize 2
local Packages = require(script.Parent.Parent.Packages)
local Promise = Packages.Promise
local React = Packages.React

local Controller = require(script.Parent.Parent.Controller)
local util = require(script.Parent.Parent.util)

local function useSprings(length: number, props: {any} | (index: number) -> {[string]: any}, deps: {any}?)
	local isImperative = React.useRef(nil)
	local ctrls = React.useRef({}).current
	local stylesList = React.useRef({}).current
	local apiList = React.useRef({}).current

	if type(props) == "table" then
		assert(
			isImperative.current == nil or isImperative.current == false,
			"useSprings detected a change from imperative to declarative. This is not supported."
		)

		isImperative.current = false
	elseif type(props) == "function" then
		assert(
			isImperative.current == nil or isImperative.current == true,
			"useSprings detected a change from declarative to imperative. This is not supported."
		)

		isImperative.current = true
	else
		error("Expected table or function for useSprings, got " .. typeof(props))
	end

	React.useEffect(function()
		if isImperative.current == false then
			for i, spring in ctrls do
				local startProps = util.merge(props[i], {
					reset = if props[i].reset then props[i].reset else false;
				})

				spring:start(util.merge({default = true}, startProps))
			end
		end
	end, deps)

	-- Create new controllers when "length" increases, and destroy
	-- the affected controllers when "length" decreases
	React.useMemo(function()
		if length > #ctrls then
			for i = #ctrls + 1, length do
				local styles, api = Controller.new(if type(props) == "table" then props[i] else props(i))
				ctrls[i] = api
				stylesList[i] = styles
			end
		else
			-- Clean up any unused controllers
			for i = length + 1, #ctrls do
				ctrls[i]:stop()
				ctrls[i] = nil
				stylesList[i] = nil
				apiList[i] = nil
			end
		end
	end, {length})

	React.useMemo(function()
		if isImperative.current then
			if #ctrls > 0 then
				for apiName, value in getmetatable(ctrls[1]) do
					if type(value) == "function" and apiName ~= "new" then
						apiList[apiName] = function(apiProps: (index: number) -> any | any)
							local promises = {}
							for i, spring in ctrls do
								table.insert(promises, Promise.new(function(resolve)
									local result = spring[apiName](
										spring,
										if type(apiProps) == "function" then apiProps(i) else apiProps
									)

									-- Some results might be promises
									if result and result.await then
										result:await()
									end

									resolve()
								end))
							end

							return Promise.all(promises)
						end
					end
				end
			end
		end
		-- Need to pass {{}} because useMemo doesn't support nil dependency yet
	end, deps or {{}})

	-- Cancel the animations of all controllers on unmount
	React.useEffect(function()
		return function()
			for _, ctrl in ctrls do
				ctrl:stop()
			end
		end
	end, {})

	if isImperative.current then
		return stylesList, apiList
	end

	return stylesList
end

return useSprings
