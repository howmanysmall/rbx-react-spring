--!optimize 2
local Oklab = require(script.Parent.Oklab)

-- stylua: ignore
type AnimationType =
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

local function getTypeFromValues(dataType: string, values: {number})
	local firstValue = values[1]

	-- The reason we go in this weird order is
	-- optimization reasons solely.
	if dataType == "number" then
		return firstValue
	elseif dataType == "Color3" then
		return Oklab.From(values)
	elseif dataType == "UDim" then
		return UDim.new(firstValue, values[2])
	elseif dataType == "UDim2" then
		return UDim2.new(firstValue, values[2], values[3], values[4])
	elseif dataType == "Vector2" then
		return Vector2.new(firstValue, values[2])
	elseif dataType == "Vector3" then
		return Vector3.new(firstValue, values[2], values[3])
	elseif dataType == "CFrame" then
		return CFrame.new(firstValue, values[2], values[3])
			* CFrame.fromAxisAngle(Vector3.new(values[4], values[5], values[6]).Unit, values[7])
	elseif dataType == "ColorSequenceKeypoint" then
		return ColorSequenceKeypoint.new(values[4], Oklab.From(values, false))
	elseif dataType == "DateTime" then
		return DateTime.fromUnixTimestampMillis(firstValue)
	elseif dataType == "NumberRange" then
		return NumberRange.new(firstValue, values[2])
	elseif dataType == "NumberSequenceKeypoint" then
		return NumberSequenceKeypoint.new(values[2], firstValue, values[3])
	elseif dataType == "PhysicalProperties" then
		return PhysicalProperties.new(firstValue, values[2], values[3], values[4], values[5])
	elseif dataType == "Ray" then
		return Ray.new(Vector3.new(firstValue, values[2], values[3]), Vector3.new(values[4], values[5], values[6]))
	elseif dataType == "Rect" then
		return Rect.new(firstValue, values[2], values[3], values[4])
	elseif dataType == "Region3" then
		local Position = (CFrame.new(firstValue, values[2], values[3]) * CFrame.fromAxisAngle(
			Vector3.new(values[4], values[5], values[6]).Unit,
			values[7]
		)).Position

		local HalfSize = Vector3.new(values[8] / 2, values[9] / 2, values[10] / 2)
		return Region3.new(Position - HalfSize, Position + HalfSize)
	elseif dataType == "Region3int16" then
		return Region3int16.new(
			Vector3int16.new(firstValue, values[2], values[3]),
			Vector3int16.new(values[4], values[5], values[6])
		)
	elseif dataType == "Vector2int16" then
		return Vector2int16.new(firstValue, values[2])
	elseif dataType == "Vector3int16" then
		return Vector3int16.new(firstValue, values[2], values[3])
	else
		error("Unsupported type: " .. dataType)
	end
end

return getTypeFromValues
