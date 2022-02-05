-- v0.1
-- interpreterK

local ThemeManager = {
	ThemeAreas = {
		"Text Color",
		"Background Color",
		"Selection Color",
		"Selection Background Color",
		"Operator Color",
		"Number Color",
		"String Color",
		"Comment Color",
		"Keyword Color",
		"Error Color",
		"Warning Color",
		"Find Selection Background Color",
		"Matching Word Background Color",
		"Built-in Function Color",
		"Whitespace Color",
		"Current Line Highlight Color",
		"Debugger Current Line Color",
		"Debugger Error Line Color",
		"Method Color",
		"Property Color",
		"\"nil\" Color",
		"Bool Color",
		"\"function\" Color",
		"\"local\" Color",
		"\"self\" Color",
		"Luau Keyword Color",
		"Function Name Color",
		"\"TODO\" Color",
		"Ruler Color",
		"Bracket Color",
		"Primary Text Color",
		"Secondary Text Color",
		"Menu Item Background Color",
		"Selected Menu Item Background Color",
		"Script Editor Scrollbar Background Color",
		"Script Editor Scrollbar Handle Color",
		"Documentation Code Block Background Color"
	}
}
ThemeManager.__index = ThemeManager

local Selection = game:GetService("Selection")
local insert = table.insert
local concat = table.concat

local function dcall(f)
	local b, e = pcall(f)
	if not b then
		print(e)
	end
end

function ThemeManager:Compile(S)
	local Grab = require(S)
	for i,v in next, Grab do
		dcall(function()
			settings().Studio[i] = v
		end)
		if i == "Theme" then
			settings().Studio:GetPropertyChangedSignal("Theme"):Wait() --Prevents a rare crash for grapejuice linux
		end
	end
end

function ThemeManager:Import()
	local S = Selection:Get()[1]
	if S and S:IsA("ModuleScript") then
		self:Compile(S)
	end
end

function ThemeManager:Export()
	local Studio = settings().Studio
	local StudioThemes = Studio:GetAvailableThemes()

	local newCfg = Instance.new("ModuleScript")
	local Theme = (Studio.Theme == StudioThemes[1] and "settings().Studio:GetAvailableThemes()[1]" or "settings().Studio:GetAvailableThemes()[2]")
    local Source = {"return {\n   ['Theme'] = "..Theme..","}

    for i = 1, #self.ThemeAreas do
        dcall(function()
            local c = Studio[self.ThemeAreas[i]]
            insert(Source, [[   [']]..self.ThemeAreas[i]..[['] = Color3.new(]]..c.r..[[, ]]..c.g..[[, ]]..c.b..[[),]])
        end)
        if i == #self.ThemeAreas then
            insert(Source, "}")
        end
    end
    newCfg.Name = "StudioTheme"
    newCfg.Source = concat(Source, '\n')
    newCfg.Parent = workspace
    print("Current theme exported. Module generated in ->", newCfg:GetFullName())
end

return ThemeManager