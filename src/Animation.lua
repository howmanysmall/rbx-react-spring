--!native
--!optimize 2

local AnimationConfig = require(script.Parent.AnimationConfig)
local helpers = require(script.Parent.helpers)

local Animation = {}
Animation.__index = Animation

type animationType =
	number
	| CFrame
	| Color3
	| DateTime
	| NumberRange
	| NumberSequenceKeypoint
	| PhysicalProperties
	| Ray
	| Rect
	| Region3
	| Region3int16
	| UDim
	| UDim2
	| Vector2
	| Vector2int16
	| Vector3
	| Vector3int16

function Animation.new(props, key: string)
	local length = #helpers.getValuesFromType(if props.from then props.from[key] else props.to[key])

	return setmetatable({
		values = helpers.getValuesFromType(if props.from then props.from[key] else props.to[key]);
		toValues = helpers.getValuesFromType(if props.to then props.to[key] else props.from[key]);
		fromValues = helpers.getValuesFromType(if props.from then props.from[key] else props.to[key]);
		type = typeof(if props.from then props.from[key] else props.to[key]);
		config = AnimationConfig:mergeConfig(props.config or {});
		immediate = props.immediate;

		v0 = table.create(length, nil);
		lastPosition = helpers.getValuesFromType(if props.from then props.from[key] else props.to[key]);
		lastVelocity = table.create(length);
		done = table.create(length, false);
		elapsedTime = table.create(length, 0);
		durationProgress = table.create(length, 0);
	}, Animation)
end

-- Set the current value. Returns `true` if the value changed
function Animation:setValue(index: number, value)
	self.lastPosition[index] = value
	if self.values[index] == value then
		return false
	end

	self.values[index] = value
	return true
end

function Animation:mergeProps(props)
	if props then
		self.config = AnimationConfig:mergeConfig(props.config or {})
		self.immediate = if props.immediate ~= nil then props.immediate else self.immediate

		self.done = table.create(#self.values, false)
		self.elapsedTime = table.create(#self.values, 0)
		self.durationProgress = table.create(#self.values, 0)
	end
end

function Animation:getValue()
	return helpers.getTypeFromValues(self.type, self.values)
end

function Animation:stop()
	for i, v in self.values do
		self.lastPosition[i] = v
		self.lastVelocity[i] = nil
		self.v0[i] = nil
		self.elapsedTime = table.create(#self.values, 0)
		self.durationProgress = table.create(#self.values, 0)
	end
end

return Animation
