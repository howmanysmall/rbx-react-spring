local rbxts_include = script:FindFirstAncestor("rbxts_include")
local node_modules = script:FindFirstAncestor("node_modules")
local include = rbxts_include or (node_modules and node_modules.Parent) or script.Parent

assert(include, "Could not find rbxts_include from " .. script:GetFullName())
assert(include:FindFirstChild("Promise"), "Could not find Promise from " .. include:GetFullName())

return require(include.Promise)
