--!native
--!optimize 2
--!strict

--[[
	Provides functions for converting Color3s into Oklab space, for more
	perceptually uniform colour blending.

	See: https://bottosson.github.io/posts/oklab/
]]

local Oklab = {}

-- Converts a Color3 in RGB space to an array in Oklab space.
function Oklab.To(color: Color3): {number}
	local r, g, b = color.R, color.G, color.B
	local l = r * 0.4122214708 + g * 0.5363325363 + b * 0.0514459929
	local m = r * 0.2119034982 + g * 0.6806995451 + b * 0.1073969566
	local s = r * 0.0883024619 + g * 0.2817188376 + b * 0.6299787005

	local rootL = l ^ (1 / 3)
	local rootM = m ^ (1 / 3)
	local rootS = s ^ (1 / 3)

	return {
		rootL * 0.2104542553 + rootM * 0.7936177850 - rootS * 0.0040720468;
		rootL * 1.9779984951 - rootM * 2.4285922050 + rootS * 0.4505937099;
		rootL * 0.0259040371 + rootM * 0.7827717662 - rootS * 0.8086757660;
	}
end

-- Converts an array in CIELAB space to a Color3 in RGB space.
-- The Color3 will be clamped by default unless specified otherwise.
function Oklab.From(array: {number}, unclamped: boolean?): Color3
	local x, y, z = array[1], array[2], array[3]
	local rootL = x + y * 0.3963377774 + z * 0.2158037573
	local rootM = x - y * 0.1055613458 - z * 0.0638541728
	local rootS = x - y * 0.0894841775 - z * 1.2914855480

	local l = rootL * rootL * rootL
	local m = rootM * rootM * rootM
	local s = rootS * rootS * rootS

	local red = l * 4.0767416621 - m * 3.3077115913 + s * 0.2309699292
	local green = l * -1.2684380046 + m * 2.6097574011 - s * 0.3413193965
	local blue = l * -0.0041960863 - m * 0.7034186147 + s * 1.7076147010

	if not unclamped then
		red = math.clamp(red, 0, 1)
		green = math.clamp(green, 0, 1)
		blue = math.clamp(blue, 0, 1)
	end

	return Color3.new(red, green, blue)
end

table.freeze(Oklab)
return Oklab
