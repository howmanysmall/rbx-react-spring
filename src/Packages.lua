--!optimize 2
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local rbxts_include = ReplicatedStorage:FindFirstChild("rbxts_include")
-- 	or script.Parent.Parent.Parent:FindFirstChild("include")

-- assert(rbxts_include, "Missing rbxts_include?")

-- local TS = require(rbxts_include.RuntimeLib)

local TS = _G[script]
assert(TS, "Missing TS?")
local React = TS.import(script, TS.getModule(script, "@rbxts", "RoactTS"))

return {
	Promise = TS.Promise;
	React = React;
}
