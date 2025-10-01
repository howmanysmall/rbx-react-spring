--!native
--!optimize 2

local Oklab = require(script.Parent.Oklab)

type AnimationType =
	| CFrame
	| Color3
	| ColorSequenceKeypoint
	| DateTime
	| number
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

	-- The reason we go in this weird order is optimization reasons solely.
	if dataType == "number" then
		return firstValue
	end

	if dataType == "Color3" then
		return Oklab.From(values)
	end

	if dataType == "UDim" then
		return UDim.new(firstValue, values[2])
	end

	if dataType == "UDim2" then
		return UDim2.new(firstValue, values[2], values[3], values[4])
	end

	if dataType == "Vector2" then
		return Vector2.new(firstValue, values[2])
	end

	if dataType == "Vector3" then
		return Vector3.new(firstValue, values[2], values[3])
	end

	if dataType == "CFrame" then
		return CFrame.new(firstValue, values[2], values[3])
			* CFrame.fromAxisAngle(Vector3.new(values[4], values[5], values[6]).Unit, values[7])
	end

	if dataType == "ColorSequenceKeypoint" then
		return ColorSequenceKeypoint.new(values[4], Oklab.From(values, false))
	end

	if dataType == "DateTime" then
		return DateTime.fromUnixTimestampMillis(firstValue)
	end

	if dataType == "NumberRange" then
		return NumberRange.new(firstValue, values[2])
	end

	if dataType == "NumberSequenceKeypoint" then
		return NumberSequenceKeypoint.new(values[2], firstValue, values[3])
	end

	if dataType == "PhysicalProperties" then
		return PhysicalProperties.new(firstValue, values[2], values[3], values[4], values[5])
	end

	if dataType == "Ray" then
		return Ray.new(Vector3.new(firstValue, values[2], values[3]), Vector3.new(values[4], values[5], values[6]))
	end

	if dataType == "Rect" then
		return Rect.new(firstValue, values[2], values[3], values[4])
	end

	if dataType == "Region3" then
		local position = (CFrame.new(firstValue, values[2], values[3]) * CFrame.fromAxisAngle(
			(vector.normalize(vector.create(values[4], values[5], values[6])) :: unknown) :: Vector3,
			values[7]
		)).Position

		local halfSize = vector.create(values[8] / 2, values[9] / 2, values[10] / 2)
		return Region3.new(position - halfSize, position + halfSize)
	end

	if dataType == "Region3int16" then
		return Region3int16.new(
			Vector3int16.new(firstValue, values[2], values[3]),
			Vector3int16.new(values[4], values[5], values[6])
		)
	end

	if dataType == "Vector2int16" then
		return Vector2int16.new(firstValue, values[2])
	end

	if dataType == "Vector3int16" then
		return Vector3int16.new(firstValue, values[2], values[3])
	end

	error("Unsupported type: " .. dataType)
end

return getTypeFromValues
