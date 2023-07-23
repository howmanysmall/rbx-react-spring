--!optimize 2
local util = require(script.Parent.util)
local getValuesFromType = require(script.Parent.utility.getValuesFromType)
local getTypeFromValues = require(script.Parent.utility.getTypeFromValues)

local helpers = {}
helpers.getValuesFromType = getValuesFromType
helpers.getTypeFromValues = getTypeFromValues

local DEFAULT_PROPS = table.freeze({
	"config";
	"immediate";
})

local RESERVED_PROPS = table.freeze({
	config = 1;
	from = 1;
	to = 1;
	loop = 1;
	reset = 1;
	immediate = 1;
	default = 1;
	delay = 1;

	-- Internal props
	keys = 1;
})

function helpers.getDefaultProps(props)
	local defaults = {}
	for _, key in DEFAULT_PROPS do
		if props[key] then
			defaults[key] = props[key]
		end
	end

	return defaults
end

--[[
    Extract any properties whose keys are *not* reserved for customizing your
    animations
]]
local function getForwardProps(props)
	local forward = {}

	local count = 0
	for prop, value in props do
		if not RESERVED_PROPS[prop] then
			forward[prop] = value
			count += 1
		end
	end

	if count > 0 then
		return forward
	end
end

-- Clone the given `props` and move all non-reserved props into the `to` prop
function helpers.inferTo(props)
	local to = getForwardProps(props)
	if to then
		local out = {
			to = to;
		}

		for key, value in props do
			if not to[key] then
				out[key] = value
			end
		end

		return out
	end

	return table.clone(props)
end

-- Find keys with defined values
local function findDefined(values, keys: {string})
	for key, value in values do
		if value then
			if not table.find(keys, key) then
				table.insert(keys, key)
			end
		end
	end
end

--[[
    Return a new object based on the given `props`.

    All non-reserved props are moved into the `to` prop object.
    The `keys` prop is set to an array of affected keys, or `null` if all keys are affected.
]]
function helpers.createUpdate(props)
	props = helpers.inferTo(props)
	local to = props.to
	local from = props.from

	-- Collect the keys affected by this update
	local keys = {}

	if type(to) == "table" then
		findDefined(to, keys)
	end

	if type(from) == "table" then
		findDefined(from, keys)
	end

	props.keys = keys
	return props
end

function helpers.createLoopUpdate(props, loop)
	if loop == nil then
		loop = props.loop
	end

	local continueLoop = true
	if type(loop) == "function" then
		continueLoop = loop()
	end

	if continueLoop then
		local overrides = type(loop) == "table" and loop
		local reset = not overrides or overrides.reset

		local nextProps = table.clone(props)
		nextProps.loop = loop
		-- Avoid updating default props when looping
		nextProps.default = false
		-- Never loop the `pause` prop
		nextProps.pause = nil
		-- Ignore the "from" prop except on reset
		nextProps.from = reset and props.from
		nextProps.reset = reset
		if type(overrides) == "table" then
			nextProps = util.merge(nextProps, overrides)
		end

		return helpers.createUpdate(nextProps)
	end
end

return helpers
