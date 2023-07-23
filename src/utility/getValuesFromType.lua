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

local function getValuesFromType(data)
	local dataType = typeof(data)

	if dataType == "number" then
		return {data}
	elseif dataType == "Color3" then
		return Oklab.To(data)
	elseif dataType == "UDim" then
		return {data.Scale, data.Offset}
	elseif dataType == "UDim2" then
		return {data.X.Scale, data.X.Offset, data.Y.Scale, data.Y.Offset}
	elseif dataType == "Vector2" or dataType == "Vector2int16" then
		return {data.X, data.Y}
	elseif dataType == "Vector3" or dataType == "Vector3int16" then
		return {data.X, data.Y, data.Z}
	elseif dataType == "CFrame" then
		local Axis, Angle = data:ToAxisAngle()
		return {data.X, data.Y, data.Z, Axis.X, Axis.Y, Axis.Z, Angle}
	elseif dataType == "ColorSequenceKeypoint" then
		local array = Oklab.To(data.Value)
		array[4] = data.Time
		return array
	elseif dataType == "DateTime" then
		return {data.UnixTimestampMillis}
	elseif dataType == "NumberRange" then
		return {data.Min, data.Max}
	elseif dataType == "NumberSequenceKeypoint" then
		return {data.Value, data.Time, data.Envelope}
	elseif dataType == "PhysicalProperties" then
		return {data.Density, data.Friction, data.Elasticity, data.FrictionWeight, data.ElasticityWeight}
	elseif dataType == "Ray" then
		local origin, direction = data.Origin, data.Direction
		return {origin.X, origin.Y, origin.Z, direction.X, direction.Y, direction.Z}
	elseif dataType == "Rect" then
		local min = data.Min
		local max = data.Max
		return {min.X, min.Y, max.X, max.Y}
	elseif dataType == "Region3" then
		local coordinateFrame = data.CFrame
		local axis, angle = coordinateFrame:ToAxisAngle()
		local size = data.Size

		-- stylua: ignore
		return {
			coordinateFrame.X, coordinateFrame.Y, coordinateFrame.Z,
			axis.X, axis.Y, axis.Z,
			angle,
			size.X, size.Y, size.Z,
		}
	elseif dataType == "Region3int16" then
		local min = data.Min
		local max = data.Max
		return {min.X, min.Y, min.Z, max.X, max.Y, max.Z}
	else
		error("Unsupported type: " .. dataType)
	end
end

return getValuesFromType
