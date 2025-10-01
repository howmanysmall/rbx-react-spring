--!native
--!optimize 2

local createBezier = require(script.Parent.createBezier)

local PI = math.pi
local HALF_PI = PI / 2

-- Reversed Back easing (starts with overshoot, ends smoothly).
local function RevBack(alpha: number): number
	alpha = 1 - alpha
	return 1 - (math.sin(alpha * HALF_PI) + (math.sin(alpha * PI) * (math.cos(alpha * PI) + 1) / 2))
end

local function Linear(alpha: number): number
	return alpha
end

-- @specs https://material.io/guidelines/motion/duration-easing.html#duration-easing-natural-easing-curves
local Sharp = createBezier(0.4, 0, 0.6, 1)
local Standard = createBezier(0.4, 0, 0.2, 1) -- used for moving.
local Acceleration = createBezier(0.4, 0, 1, 1) -- used for exiting.
local Deceleration = createBezier(0, 0, 0.2, 1) -- used for entering.

-- @specs https://developer.microsoft.com/en-us/fabric#/styles/web/motion#basic-animations
local FabricStandard = createBezier(0.8, 0, 0.2, 1) -- used for moving.
local FabricAccelerate = createBezier(0.9, 0.1, 1, 0.2) -- used for exiting.
local FabricDecelerate = createBezier(0.1, 0.9, 0.2, 1) -- used for entering.

-- @specs https://docs.microsoft.com/en-us/windows/uwp/design/motion/timing-and-easing
local UWPAccelerate = createBezier(0.7, 0, 1, 0.5)

-- @specs https://www.ibm.com/design/language/elements/motion/basics

-- Productivity and Expression are both essential to an interface. Reserve Expressive motion for occasional, important moments to better capture user’s attention, and offer rhythmic break to the productive experience.
-- Use standard-easing when an element is visible from the beginning to end of a motion. Tiles expanding and table rows sorting are good examples.
local StandardProductive = createBezier(0.2, 0, 0.38, 0.9)
local StandardExpressive = createBezier(0.4, 0.14, 0.3, 1)

-- Use entrance-easing when adding elements to the view such as a modal or toaster appearing, or moving in response to users’ input, such as dropdown opening or toggle. An element quickly appears and slows down to a stop.
local EntranceProductive = createBezier(0, 0, 0.38, 0.9)
local EntranceExpressive = createBezier(0, 0, 0.3, 1)

-- Use exit-easing when removing elements from view, such as closing a modal or toaster. The element speeds up as it exits from view, implying that its departure from the screen is permanent.
local ExitProductive = createBezier(0.2, 0, 1, 0.9)
local ExitExpressive = createBezier(0.4, 0.14, 1, 1)

-- @specs https://design.firefox.com/photon/motion/duration-and-easing.html
local MozillaCurve = createBezier(0.07, 0.95, 0, 1)

local function Smooth(alpha: number): number
	return alpha ^ 2 * (3 - 2 * alpha)
end

local function Smoother(alpha: number): number
	return alpha ^ 3 * (alpha * (6 * alpha - 15) + 10)
end

local function RidiculousWiggle(alpha: number): number
	return math.sin(math.sin(alpha * PI) * HALF_PI)
end

local function Spring(alpha: number): number
	return 1 + (-math.exp(-6.9 * alpha) * math.cos(-20.106192982975 * alpha))
end

local function SoftSpring(alpha: number): number
	return 1 + (-math.exp(-7.5 * alpha) * math.cos(-10.053096491487 * alpha))
end

-- Standard bounce easing with piecewise polynomial segments at 4/11, 8/11, 10/11 thresholds.
local function OutBounce(alpha: number): number
	if alpha < 4 / 11 then
		return 7.5625 * alpha ^ 2
	end

	if alpha < 8 / 11 then
		return 3 + alpha * (11 * alpha - 12) * 0.6875
	end

	if alpha < 10 / 11 then
		return 6 + alpha * (11 * alpha - 18) * 0.6875
	end

	return 7.875 + alpha * (11 * alpha - 21) * 0.6875
end

local function InBounce(alpha: number): number
	if alpha > 0.63636363636364 then
		alpha -= 1
		return 1 - alpha ^ 2 * 7.5625
	end

	if alpha > 0.272727272727273 then
		return (11 * alpha - 7) * (11 * alpha - 3) / -16
	end

	if alpha > 0.090909090909091 then
		return (11 * (4 - 11 * alpha) * alpha - 3) / 16
	end

	return alpha * (11 * alpha - 1) * -0.6875
end

local EasingFunctions = {
	linear = Linear;

	easeOutSmooth = Smooth;
	easeInSmooth = Smooth;
	easeInOutSmooth = Smooth;
	easeOutInSmooth = Smooth;

	easeOutSmoother = Smoother;
	easeInSmoother = Smoother;
	easeInOutSmoother = Smoother;
	easeOutInSmoother = Smoother;

	easeOutRidiculousWiggle = RidiculousWiggle;
	easeInRidiculousWiggle = RidiculousWiggle;
	easeInOutRidiculousWiggle = RidiculousWiggle;
	easeOutInRidiculousWiggle = RidiculousWiggle;

	easeOutRevBack = RevBack;
	easeInRevBack = RevBack;
	easeInOutRevBack = RevBack;
	easeOutInRevBack = RevBack;

	easeOutSpring = Spring;
	easeInSpring = Spring;
	easeInOutSpring = Spring;
	easeOutInSpring = Spring;

	easeOutSoftSpring = SoftSpring;
	easeInSoftSpring = SoftSpring;
	easeInOutSoftSpring = SoftSpring;
	easeOutInSoftSpring = SoftSpring;

	easeInSharp = Sharp;
	easeInOutSharp = Sharp;
	easeOutSharp = Sharp;
	easeOutInSharp = Sharp;

	easeInAcceleration = Acceleration;
	easeInOutAcceleration = Acceleration;
	easeOutAcceleration = Acceleration;
	easeOutInAcceleration = Acceleration;

	easeInStandard = Standard;
	easeInOutStandard = Standard;
	easeOutStandard = Standard;
	easeOutInStandard = Standard;

	easeInDeceleration = Deceleration;
	easeInOutDeceleration = Deceleration;
	easeOutDeceleration = Deceleration;
	easeOutInDeceleration = Deceleration;

	easeInFabricStandard = FabricStandard;
	easeInOutFabricStandard = FabricStandard;
	easeOutFabricStandard = FabricStandard;
	easeOutInFabricStandard = FabricStandard;

	easeInFabricAccelerate = FabricAccelerate;
	easeInOutFabricAccelerate = FabricAccelerate;
	easeOutFabricAccelerate = FabricAccelerate;
	easeOutInFabricAccelerate = FabricAccelerate;

	easeInFabricDecelerate = FabricDecelerate;
	easeInOutFabricDecelerate = FabricDecelerate;
	easeOutFabricDecelerate = FabricDecelerate;
	easeOutInFabricDecelerate = FabricDecelerate;

	easeInUWPAccelerate = UWPAccelerate;
	easeInOutUWPAccelerate = UWPAccelerate;
	easeOutUWPAccelerate = UWPAccelerate;
	easeOutInUWPAccelerate = UWPAccelerate;

	easeInStandardProductive = StandardProductive;
	easeInStandardExpressive = StandardExpressive;

	easeInEntranceProductive = EntranceProductive;
	easeInEntranceExpressive = EntranceExpressive;

	easeInExitProductive = ExitProductive;
	easeInExitExpressive = ExitExpressive;

	easeOutStandardProductive = StandardProductive;
	easeOutStandardExpressive = StandardExpressive;

	easeOutEntranceProductive = EntranceProductive;
	easeOutEntranceExpressive = EntranceExpressive;

	easeOutExitProductive = ExitProductive;
	easeOutExitExpressive = ExitExpressive;

	easeInOutStandardProductive = StandardProductive;
	easeInOutStandardExpressive = StandardExpressive;

	easeInOutEntranceProductive = EntranceProductive;
	easeInOutEntranceExpressive = EntranceExpressive;

	easeInOutExitProductive = ExitProductive;
	easeInOutExitExpressive = ExitExpressive;

	easeOutInStandardProductive = StandardProductive;
	easeOutInStandardExpressive = StandardExpressive;

	easeOutInEntranceProductive = EntranceProductive;
	easeOutInEntranceExpressive = EntranceExpressive;

	easeOutInExitProductive = ExitProductive;
	easeOutInExitExpressive = ExitExpressive;

	easeOutMozillaCurve = MozillaCurve;
	easeInMozillaCurve = MozillaCurve;
	easeInOutMozillaCurve = MozillaCurve;
	easeOutInMozillaCurve = MozillaCurve;

	easeInQuad = function(alpha: number): number
		return alpha ^ 2
	end;

	easeOutQuad = function(alpha: number): number
		return alpha * (2 - alpha)
	end;

	easeInOutQuad = function(alpha: number): number
		return if alpha < 0.5 then 2 * alpha ^ 2 else 2 * (2 - alpha) * alpha - 1
	end;

	easeOutInQuad = function(alpha: number): number
		if alpha < 0.5 then
			alpha *= 2
			return alpha * (2 - alpha) / 2
		end

		return (alpha * 2 - 1) ^ 2 / 2 + 0.5
	end;

	easeInCubic = function(alpha: number): number
		return alpha ^ 3
	end;

	easeOutCubic = function(alpha: number): number
		return 1 - (alpha - 1) ^ 3
	end;

	easeInOutCubic = function(alpha: number): number
		if alpha < 0.5 then
			return 4 * alpha ^ 3
		end

		alpha -= 1
		return 1 + 4 * alpha ^ 3
	end;

	easeOutInCubic = function(alpha: number): number
		if alpha < 0.5 then
			alpha = 1 - alpha * 2
			return (1 - alpha ^ 3) / 2
		end

		alpha = alpha * 2 - 1
		return alpha ^ 3 / 2 + 0.5
	end;

	easeInQuart = function(alpha: number): number
		return alpha * alpha * alpha * alpha
	end;

	easeOutQuart = function(alpha: number): number
		alpha -= 1
		return 1 - alpha * alpha * alpha * alpha
	end;

	easeInOutQuart = function(alpha: number): number
		if alpha < 0.5 then
			alpha ^= 2
			return 8 * alpha ^ 2
		end

		alpha -= 1
		return 1 - 8 * alpha * alpha * alpha * alpha
	end;

	easeOutInQuart = function(alpha: number): number
		if alpha < 0.5 then
			alpha = alpha * 2 - 1
			return (1 - alpha * alpha * alpha * alpha) / 2
		end

		alpha = alpha * 2 - 1
		return alpha * alpha * alpha * alpha / 2 + 0.5
	end;

	easeInQuint = function(alpha: number): number
		return alpha * alpha * alpha * alpha * alpha
	end;

	easeOutQuint = function(alpha: number): number
		alpha -= 1
		return alpha * alpha * alpha * alpha * alpha + 1
	end;

	easeInOutQuint = function(alpha: number): number
		if alpha < 0.5 then
			return 16 * alpha * alpha * alpha * alpha * alpha
		end

		alpha -= 1
		return 16 * alpha * alpha * alpha * alpha * alpha + 1
	end;

	easeOutInQuint = function(alpha: number): number
		if alpha < 0.5 then
			alpha = alpha * 2 - 1
			return (alpha * alpha * alpha * alpha * alpha + 1) / 2
		end

		alpha = alpha * 2 - 1
		return alpha * alpha * alpha * alpha * alpha / 2 + 0.5
	end;

	-- Back easing with custom overshoot (not standard s=1.70158).
	easeInBack = function(alpha: number): number
		return alpha ^ 2 * (3 * alpha - 2)
	end;

	easeOutBack = function(alpha: number): number
		local decrease = alpha - 1
		return decrease ^ 2 * (alpha * 2 + decrease) + 1
	end;

	easeInOutBack = function(alpha: number): number
		return if alpha < 0.5
			then 2 * alpha ^ 2 * (2 * 3 * alpha - 2)
			else 1 + 2 * (alpha - 1) ^ 2 * (2 * 3 * alpha - 2 - 2)
	end;

	easeOutInBack = function(alpha: number): number
		if alpha < 0.5 then
			alpha *= 2
			local decrease = alpha - 1
			return (decrease ^ 2 * (alpha * 2 + decrease) + 1) / 2
		end

		alpha = alpha * 2 - 1
		return alpha ^ 2 * (3 * alpha - 2) / 2 + 0.5
	end;

	easeInSine = function(alpha: number): number
		return 1 - math.cos(alpha * HALF_PI)
	end;

	easeOutSine = function(alpha: number): number
		return math.sin(alpha * HALF_PI)
	end;

	easeInOutSine = function(alpha: number): number
		return (1 - math.cos(PI * alpha)) / 2
	end;

	easeOutInSine = function(alpha: number): number
		return if alpha < 0.5 then math.sin(alpha * PI) / 2 else (1 - math.cos((alpha * 2 - 1) * HALF_PI)) / 2 + 0.5
	end;

	easeOutBounce = OutBounce;
	easeInBounce = InBounce;

	easeInOutBounce = function(alpha: number): number
		return if alpha < 0.5 then InBounce(2 * alpha) / 2 else OutBounce(2 * alpha - 1) / 2 + 0.5
	end;

	easeOutInBounce = function(alpha: number): number
		return if alpha < 0.5 then OutBounce(2 * alpha) / 2 else InBounce(2 * alpha - 1) / 2 + 0.5
	end;

	-- Canonical Penner elastic easing functions, ensuring exact 0->0 and 1->1 endpoints.
	easeInElastic = function(alpha: number): number
		if alpha == 0 or alpha == 1 then
			return alpha
		end
		return -2 ^ (10 * (alpha - 1)) * math.sin((alpha - 1 - 0.075) * (2 * math.pi) / 0.3)
	end;

	easeOutElastic = function(alpha: number): number
		if alpha == 0 or alpha == 1 then
			return alpha
		end
		return 1 + 2 ^ (-10 * alpha) * math.sin((alpha - 0.075) * (2 * math.pi) / 0.3)
	end;

	easeInOutElastic = function(alpha: number): number
		if alpha == 0 or alpha == 1 then
			return alpha
		end
		alpha *= 2
		if alpha < 1 then
			return -0.5 * 2 ^ (10 * (alpha - 1)) * math.sin((alpha - 1 - 0.075) * (2 * math.pi) / 0.3)
		else
			alpha -= 1
			return 0.5 * 2 ^ (-10 * alpha) * math.sin((alpha - 0.075) * (2 * math.pi) / 0.3) + 1
		end
	end;

	easeOutInElastic = function(alpha: number): number
		if alpha == 0 or alpha == 1 then
			return alpha
		end
		if alpha < 0.5 then
			alpha *= 2
			return 0.5 * (1 + 2 ^ (-10 * alpha) * math.sin((alpha - 0.075) * (2 * math.pi) / 0.3))
		else
			alpha = alpha * 2 - 1
			return 0.5 * (-2 ^ (10 * (alpha - 1)) * math.sin((alpha - 1 - 0.075) * (2 * math.pi) / 0.3)) + 0.5
		end
	end;

	easeInExpo = function(alpha: number): number
		return alpha ^ 2 * math.exp(4 * (alpha - 1))
	end;

	easeOutExpo = function(alpha: number): number
		return 1 - (1 - alpha) ^ 2 / math.exp(4 * alpha)
	end;

	easeInOutExpo = function(alpha: number): number
		return if alpha < 0.5
			then 2 * alpha ^ 2 * math.exp(4 * (2 * alpha - 1))
			else 1 - 2 * (alpha - 1) ^ 2 * math.exp(4 * (1 - 2 * alpha))
	end;

	easeOutInExpo = function(alpha: number): number
		if alpha < 0.5 then
			alpha *= 2
			return (1 - (1 - alpha) ^ 2 / math.exp(4 * alpha)) / 2
		end

		alpha = alpha * 2 - 1
		return (alpha ^ 2 * math.exp(4 * (alpha - 1))) / 2 + 0.5
	end;

	easeInCirc = function(alpha: number): number
		return -(math.sqrt(1 - alpha ^ 2) - 1)
	end;

	easeOutCirc = function(alpha: number): number
		alpha -= 1
		return math.sqrt(1 - alpha ^ 2)
	end;

	easeInOutCirc = function(alpha: number): number
		alpha *= 2
		if alpha < 1 then
			return -(math.sqrt(1 - alpha ^ 2) - 1) / 2
		end

		alpha -= 2
		return (math.sqrt(1 - alpha ^ 2) - 1) / 2
	end;

	easeOutInCirc = function(alpha: number): number
		if alpha < 0.5 then
			alpha = alpha * 2 - 1
			return math.sqrt(1 - alpha ^ 2) / 2
		end

		alpha = alpha * 2 - 1
		return -(math.sqrt(1 - alpha ^ 2) - 1) / 2 + 0.5
	end;
}

return table.freeze(EasingFunctions)
