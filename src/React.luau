local root = script.Parent.Parent
local packages = if root:FindFirstChild("React") then root else root:FindFirstChild("ReactLua")

if not packages then
	root = root.Parent
	packages = if root:FindFirstChild("React") then root else root:FindFirstChild("ReactLua")
end

assert(packages, `Could not find React or ReactLua in {root:GetFullName()}`)

type React = typeof(require(packages.React))

export type Context<T> = typeof((function()
	local React = require(packages.React)
	return {} :: React.Context<T>
end)())

return require(packages.React) :: React
