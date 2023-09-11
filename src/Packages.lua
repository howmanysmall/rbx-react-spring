--!optimize 2
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TS = (function()
	local UsingGlobal = _G[script]
	if type(UsingGlobal) == "table" and type(UsingGlobal.import) == "function" then
		return UsingGlobal
	else
		local function FindInclude(Root: Instance)
			local Parent = Root
			local Include = Parent:FindFirstChild("include")
			if not Include then
				while not Include do
					Parent = Parent.Parent
					if not Parent then
						return nil
					end

					Include = Parent:FindFirstChild("include")
				end
			end

			return Include
		end

		local rbxts_include = FindInclude(script) or ReplicatedStorage:FindFirstChild("rbxts_include")
		assert(rbxts_include, "Missing rbxts_include?")
		return require(rbxts_include.RuntimeLib)
	end
end)()

assert(type(TS) == "table", "Missing TS?")
assert(type(TS.Promise) == "table", "Missing TS.Promise?")
assert(type(TS.import) == "function", "Missing TS.import?")
assert(type(TS.getModule) == "function", "Missing TS.getModule?")
local React = TS.import(script, TS.getModule(script, "@rbxts", "RoactTS"))

return {
	Promise = TS.Promise;
	React = React;
}
