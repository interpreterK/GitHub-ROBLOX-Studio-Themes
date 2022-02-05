--[[
	Plugin made by interpreterK
	Plugin based off of: https://github.com/primer/github-vscode-theme
]]

--[[
	TODO's:
	[/] Colorblind themes
	[/] High Contrast themes
	[X] Light mode themes
]]

local Toolbar = plugin:CreateToolbar("GitHub Color Themes")
local Button = Toolbar:CreateButton("Theme Selector", "Stylize your ROBLOX Studio code editor with GitHub themes.", 'rbxassetid://8720483150')

local Dark = script:WaitForChild("Dark")
local Dark_default = script:WaitForChild("Dark_default")
local Dark_dimmed = script:WaitForChild("Dark_dimmed")
local Light = script:WaitForChild("Light")
local ThemeManager = script:WaitForChild("ThemeManager")
local body = script:WaitForChild("body")

local Studio = settings().Studio

local Manager = require(ThemeManager)

local WindowInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 750, 245, 401, 205)
local Window = plugin:CreateDockWidgetPluginGui("Window", WindowInfo)
Window.Title = "GitHub Themes"
body.Parent = Window

-- Body/UI Actions
local function Enter_Leave(Obj)
	Obj.MouseEnter:Connect(function()
		plugin:GetMouse().Icon = 'rbxasset://SystemCursors/PointingHand'
	end)
	Obj.MouseLeave:Connect(function()
		plugin:GetMouse().Icon = 'rbxasset://SystemCursors/Arrow'
	end)
end

local DarkB = body.Dark
local Dark_Select = DarkB.Select
local Dark_defaultB = body.Dark_default
local Dark_default_Select = Dark_defaultB.Select
local Dark_dimmedB = body.Dark_dimmed
local Dark_dimmed_Select = Dark_dimmedB.Select
local LightB = body.Light
local Light_Select = LightB.Select

local Export = body.Export
local Import = body.Import

body.BackgroundColor3 = Studio["Background Color"]
Studio:GetPropertyChangedSignal("Background Color"):Connect(function()
	body.BackgroundColor3 = Studio["Background Color"]
end)

Dark_Select.MouseButton1Click:Connect(function()
	Manager:Compile(Dark)
end)
Dark_default_Select.MouseButton1Click:Connect(function()
	Manager:Compile(Dark_default)
end)
Dark_dimmed_Select.MouseButton1Click:Connect(function()
	Manager:Compile(Dark_dimmed)
end)
Light_Select.MouseButton1Click:Connect(function()
    Manager:Compile(Light)
end)
Export.MouseButton1Click:Connect(function()
    Manager:Export()
end)
Import.MouseButton1Click:Connect(function()
    Manager:Import()
end)

Enter_Leave(Export)
Enter_Leave(Import)
Enter_Leave(Dark_dimmed_Select)
Enter_Leave(Dark_default_Select)
Enter_Leave(Dark_Select)
Enter_Leave(Light_Select)
--

Button.Click:Connect(function()
	Window.Enabled = not Window.Enabled
end)