--!optimize 2
local createBezier = require(script.createBezier)
local EasingFunctions = require(script.EasingFunctions)

local Constants = {}
Constants.createBezier = createBezier
Constants.easingFunctions = EasingFunctions
Constants.easings = EasingFunctions

Constants.config = {
	default = {
		friction = 26;
		tension = 170;
	};

	gentle = {
		friction = 14;
		tension = 120;
	};

	wobbly = {
		friction = 12;
		tension = 180;
	};

	stiff = {
		friction = 20;
		tension = 210;
	};

	slow = {
		friction = 60;
		tension = 280;
	};

	molasses = {
		friction = 120;
		tension = 280;
	};

	snappy = {
		friction = 20;
		mass = 0.5;
		tension = 400;
	};
}

table.freeze(Constants)
return Constants
