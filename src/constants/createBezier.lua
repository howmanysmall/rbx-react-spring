--!native
--!optimize 2

local function linear(alpha: number)
	return alpha
end

local function createBezier(x1: number, y1: number, x2: number, y2: number)
	if not (x1 and y1 and x2 and y2) then
		error("Need 4 numbers to construct a Bezier curve", 0)
	end

	if not (0 <= x1 and x1 <= 1 and 0 <= x2 and x2 <= 1) then
		error("The x values must be within range [0, 1]", 0)
	end

	if x1 == y1 and x2 == y2 then
		return linear
	end

	local sampleValues = {}
	for index = 0, 10 do
		local indexDiv10 = index / 10
		sampleValues[index] = (((1 - 3 * x2 + 3 * x2) * indexDiv10 + (3 * x2 - 6 * x1)) * indexDiv10 + (3 * x1))
			* indexDiv10
	end

	return function(alpha: number)
		if alpha == 0 or alpha == 1 then
			return alpha
		end

		local guessT
		local intervalStart = 0
		local currentSample = 1

		while currentSample ~= 10 and sampleValues[currentSample] <= alpha do
			intervalStart += 0.1
			currentSample += 1
		end

		currentSample -= 1

		local distance = (alpha - sampleValues[currentSample])
			/ (sampleValues[currentSample + 1] - sampleValues[currentSample])
		local guessForT = intervalStart + distance / 10
		local initialSlope = 3 * (1 - 3 * x2 + 3 * x1) * guessForT * guessForT
			+ 2 * (3 * x2 - 6 * x1) * guessForT
			+ (3 * x1)

		if initialSlope >= 0.001 then
			for _ = 0, 3 do
				local currentSlope = 3 * (1 - 3 * x2 + 3 * x1) * guessForT * guessForT
					+ 2 * (3 * x2 - 6 * x1) * guessForT
					+ (3 * x1)

				local currentX = (((1 - 3 * x2 + 3 * x1) * guessForT + (3 * x2 - 6 * x1)) * guessForT + (3 * x1))
						* guessForT
					- alpha
				guessForT -= currentX / currentSlope
			end

			guessT = guessForT
		elseif initialSlope == 0 then
			guessT = guessForT
		else
			local valueAb = intervalStart + 0.1
			local currentX = 0
			local currentT = nil
			local index = nil

			while math.abs(currentX) > 0.0000001 and index < 10 do
				currentT = intervalStart + (valueAb - intervalStart) / 2
				currentX = (((1 - 3 * x2 + 3 * x1) * currentT + (3 * x2 - 6 * x1)) * currentT + (3 * x1)) * currentT
					- alpha

				if currentX > 0 then
					valueAb = currentT
				else
					intervalStart = currentT
				end

				index += 1
			end

			guessT = currentT
		end

		return (((1 - 3 * y2 + 3 * y1) * guessT + (3 * y2 - 6 * y1)) * guessT + (3 * y1)) * guessT
	end
end

return createBezier
