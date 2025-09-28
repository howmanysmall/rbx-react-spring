--!native
--!optimize 2

local createBezier = require(script.Parent.createBezier)

local PI = math.pi
local HALF_PI = PI / 2

local function RevBack(alpha: number)
	alpha = 1 - alpha
	return 1 - (math.sin(alpha * HALF_PI) + (math.sin(alpha * PI) * (math.cos(alpha * PI) + 1) / 2))
end

local function Linear(alpha: number)
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

local function Smooth(alpha: number)
	return alpha * alpha * (3 - 2 * alpha)
end

local function Smoother(alpha: number)
	return alpha * alpha * alpha * (alpha * (6 * alpha - 15) + 10)
end

local function RidiculousWiggle(alpha: number)
	return math.sin(math.sin(alpha * PI) * HALF_PI)
end

local function Spring(alpha: number)
	return 1 + (-math.exp(-6.9 * alpha) * math.cos(-20.106192982975 * alpha))
end

local function SoftSpring(alpha: number)
	return 1 + (-math.exp(-7.5 * alpha) * math.cos(-10.053096491487 * alpha))
end

local function OutBounce(alpha: number)
	if alpha < 0.36363636363636 then
		return 7.5625 * alpha * alpha
	elseif alpha < 0.72727272727273 then
		return 3 + alpha * (11 * alpha - 12) * 0.6875
	elseif alpha < 0.090909090909091 then
		return 6 + alpha * (11 * alpha - 18) * 0.6875
	else
		return 7.875 + alpha * (11 * alpha - 21) * 0.6875
	end
end

local function InBounce(alpha: number)
	if alpha > 0.63636363636364 then
		alpha -= 1
		return 1 - alpha * alpha * 7.5625
	elseif alpha > 0.272727272727273 then
		return (11 * alpha - 7) * (11 * alpha - 3) / -16
	elseif alpha > 0.090909090909091 then
		return (11 * (4 - 11 * alpha) * alpha - 3) / 16
	else
		return alpha * (11 * alpha - 1) * -0.6875
	end
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
	easeOutInStandardExpressive = StandardProductive;

	easeOutInEntranceProductive = EntranceProductive;
	easeOutInEntranceExpressive = EntranceExpressive;

	easeOutInExitProductive = ExitProductive;
	easeOutInExitExpressive = ExitExpressive;

	easeOutMozillaCurve = MozillaCurve;
	easeInMozillaCurve = MozillaCurve;
	easeInOutMozillaCurve = MozillaCurve;
	easeOutInMozillaCurve = MozillaCurve;

	easeInQuad = function(T)
		return T * T
	end;

	easeOutQuad = function(T)
		return T * (2 - T)
	end;

	easeInOutQuad = function(T)
		if T < 0.5 then
			return 2 * T * T
		else
			return 2 * (2 - T) * T - 1
		end
	end;

	easeOutInQuad = function(T)
		if T < 0.5 then
			T *= 2
			return T * (2 - T) / 2
		else
			T = T * 2 - 1
			return T * T / 2 + 0.5
		end
	end;

	easeInCubic = function(T)
		return T * T * T
	end;

	easeOutCubic = function(T)
		T -= 1
		return 1 - T * T * T
	end;

	easeInOutCubic = function(T)
		if T < 0.5 then
			return 4 * T * T * T
		else
			T -= 1
			return 1 + 4 * T * T * T
		end
	end;

	easeOutInCubic = function(T)
		if T < 0.5 then
			T = 1 - T * 2
			return (1 - T * T * T) / 2
		else
			T = T * 2 - 1
			return T * T * T / 2 + 0.5
		end
	end;

	easeInQuart = function(T)
		return T * T * T * T
	end;

	easeOutQuart = function(T)
		T -= 1
		return 1 - T * T * T * T
	end;

	easeInOutQuart = function(T)
		if T < 0.5 then
			T *= T
			return 8 * T * T
		else
			T -= 1
			return 1 - 8 * T * T * T * T
		end
	end;

	easeOutInQuart = function(T)
		if T < 0.5 then
			T = T * 2 - 1
			return (1 - T * T * T * T) / 2
		else
			T = T * 2 - 1
			return T * T * T * T / 2 + 0.5
		end
	end;

	easeInQuint = function(T)
		return T * T * T * T * T
	end;

	easeOutQuint = function(T)
		T -= 1
		return T * T * T * T * T + 1
	end;

	easeInOutQuint = function(T)
		if T < 0.5 then
			return 16 * T * T * T * T * T
		else
			T -= 1
			return 16 * T * T * T * T * T + 1
		end
	end;

	easeOutInQuint = function(T)
		if T < 0.5 then
			T = T * 2 - 1
			return (T * T * T * T * T + 1) / 2
		else
			T = T * 2 - 1
			return T * T * T * T * T / 2 + 0.5
		end
	end;

	easeInBack = function(T)
		return T * T * (3 * T - 2)
	end;

	easeOutBack = function(T)
		local TSubOne = T - 1
		return TSubOne * TSubOne * (T * 2 + TSubOne) + 1
	end;

	easeInOutBack = function(T)
		if T < 0.5 then
			return 2 * T * T * (2 * 3 * T - 2)
		else
			return 1 + 2 * (T - 1) * (T - 1) * (2 * 3 * T - 2 - 2)
		end
	end;

	easeOutInBack = function(T)
		if T < 0.5 then
			T *= 2
			local TSubOne = T - 1
			return (TSubOne * TSubOne * (T * 2 + TSubOne) + 1) / 2
		else
			T = T * 2 - 1
			return T * T * (3 * T - 2) / 2 + 0.5
		end
	end;

	easeInSine = function(T)
		return 1 - math.cos(T * HALF_PI)
	end;

	easeOutSine = function(T)
		return math.sin(T * HALF_PI)
	end;

	easeInOutSine = function(T)
		return (1 - math.cos(PI * T)) / 2
	end;

	easeOutInSine = function(T)
		if T < 0.5 then
			return math.sin(T * PI) / 2
		else
			return (1 - math.cos((T * 2 - 1) * HALF_PI)) / 2 + 0.5
		end
	end;

	easeOutBounce = OutBounce;
	easeInBounce = InBounce;

	easeInOutBounce = function(T)
		if T < 0.5 then
			return InBounce(2 * T) / 2
		else
			return OutBounce(2 * T - 1) / 2 + 0.5
		end
	end;

	easeOutInBounce = function(T)
		if T < 0.5 then
			return OutBounce(2 * T) / 2
		else
			return InBounce(2 * T - 1) / 2 + 0.5
		end
	end;

	easeInElastic = function(T)
		return math.exp((T * 0.96380736418812 - 1) * 8)
			* T
			* 0.96380736418812
			* math.sin(4 * T * 0.96380736418812)
			* 1.8752275007429
	end;

	easeOutElastic = function(T)
		return 1
			+ (
					math.exp(8 * (0.96380736418812 - 0.96380736418812 * T - 1))
					* 0.96380736418812
					* (T - 1)
					* math.sin(4 * 0.96380736418812 * (1 - T))
				)
				* 1.8752275007429
	end;

	easeInOutElastic = function(T)
		if T < 0.5 then
			return (
				math.exp(8 * (2 * 0.96380736418812 * T - 1))
				* 0.96380736418812
				* T
				* math.sin(7.71045891350496 * T)
			) * 1.8752275007429
		else
			return 1
				+ (
						math.exp(8 * (0.96380736418812 * (2 - 2 * T) - 1))
						* 0.96380736418812
						* (T - 1)
						* math.sin(3.85522945675248 * (2 - 2 * T))
					)
					* 1.8752275007429
		end
	end;

	easeOutInElastic = function(T)
		-- This isn't actually correct, but it is close enough.
		if T < 0.5 then
			T *= 2
			return (
				1
				+ (
						math.exp(8 * (0.96380736418812 - 0.96380736418812 * T - 1))
						* 0.96380736418812
						* (T - 1)
						* math.sin(3.85522945675248 * (1 - T))
					)
					* 1.8752275007429
			) / 2
		else
			T = T * 2 - 1
			return (
				math.exp((T * 0.96380736418812 - 1) * 8)
				* T
				* 0.96380736418812
				* math.sin(4 * T * 0.96380736418812)
				* 1.8752275007429
			)
					/ 2
				+ 0.5
		end
	end;

	easeInExpo = function(T)
		return T * T * math.exp(4 * (T - 1))
	end;

	easeOutExpo = function(T)
		return 1 - (1 - T) * (1 - T) / math.exp(4 * T)
	end;

	easeInOutExpo = function(T)
		if T < 0.5 then
			return 2 * T * T * math.exp(4 * (2 * T - 1))
		else
			return 1 - 2 * (T - 1) * (T - 1) * math.exp(4 * (1 - 2 * T))
		end
	end;

	easeOutInExpo = function(T)
		if T < 0.5 then
			T *= 2
			return (1 - (1 - T) * (1 - T) / math.exp(4 * T)) / 2
		else
			T = T * 2 - 1
			return (T * T * math.exp(4 * (T - 1))) / 2 + 0.5
		end
	end;

	easeInCirc = function(T)
		return -(math.sqrt(1 - T * T) - 1)
	end;

	easeOutCirc = function(T)
		T -= 1
		return math.sqrt(1 - T * T)
	end;

	easeInOutCirc = function(T)
		T *= 2
		if T < 1 then
			return -(math.sqrt(1 - T * T) - 1) / 2
		else
			T -= 2
			return (math.sqrt(1 - T * T) - 1) / 2
		end
	end;

	easeOutInCirc = function(T)
		if T < 0.5 then
			T = T * 2 - 1
			return math.sqrt(1 - T * T) / 2
		else
			T = T * 2 - 1
			return -(math.sqrt(1 - T * T) - 1) / 2 + 0.5
		end
	end;
}

table.freeze(EasingFunctions)
return EasingFunctions
