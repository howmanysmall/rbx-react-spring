--!native
--!optimize 2

local constants = require(script.constants)

local ReactSpring = {
	useSpring = require(script.hooks.useSpring);
	useSprings = require(script.hooks.useSprings);
	useTrail = require(script.hooks.useTrail);

	Controller = require(script.Controller);

	config = constants.config;
	createBezier = constants.createBezier;
	easings = constants.easings;
}

return table.freeze(ReactSpring)
