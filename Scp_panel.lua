-- SCP Tactical Panel -- LocalScript para um jogo próprio no Roblox Studio

local Players = game:GetService("Players") local Teams = game:GetService("Teams") local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui") gui.Name = "SCPTacticalPanel" gui.ResetOnSpawn = false gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame") panel.Size = UDim2.fromOffset(290, 300) panel.Position = UDim2.new(0.5, -145, 0.5, -150) panel.BackgroundColor3 = Color3.fromRGB(40, 35, 75) panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel") title.Size = UDim2.new(1, 0, 0, 48) title.BackgroundColor3 = Color3.fromRGB(75, 60, 135) title.Text = "SCP TACTICAL" title.TextColor3 = Color3.new(1, 1, 1) title.TextSize = 20 title.Font = Enum.Font.GothamBold title.Parent = panel

Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local settings = { Guards = { color = Color3.fromRGB(100, 200, 255), enabled = false }, MTF = { color = Color3.fromRGB(40, 80, 180), enabled = false }, SCP = { color = Color3.fromRGB(255, 100, 190), enabled = false } }

local highlights = {}

local function removeHighlight(target) if highlights[target] then highlights[target]:Destroy() highlights[target] = nil end end

local function updatePlayer(target) removeHighlight(target)

if target == player or not target.Character then return end local team = target.Team if not team then return end local config = settings[team.Name] if not config or not config.enabled then return end local highlight = Instance.new("Highlight") highlight.Name = "SCPTeamESP" highlight.Adornee = target.Character highlight.FillColor = config.color highlight.OutlineColor = config.color highlight.FillTransparency = 0.8 highlight.OutlineTransparency = 0 highlight.Parent = target.Character highlights[target] = highlight 

end

local function refreshAll() for _, target in ipairs(Players:GetPlayers()) do updatePlayer(target) end end

local function addButton(name, y) local config = settings[name] local button = Instance.new("TextButton")

button.Size = UDim2.new(1, -24, 0, 48) button.Position = UDim2.fromOffset(12, y) button.BackgroundColor3 = Color3.fromRGB(75, 65, 115) button.TextColor3 = Color3.new(1, 1, 1) button.TextSize = 15 button.Font = Enum.Font.Gotham button.Text = name .. ": OFF" button.Parent = panel Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8) button.Activated:Connect(function() config.enabled = not config.enabled button.Text = name .. (config.enabled and ": ON" or ": OFF") button.BackgroundColor3 = config.enabled and config.color or Color3.fromRGB(75, 65, 115) refreshAll() end) 

end

addButton("Guards", 60) addButton("MTF", 120) addButton("SCP", 180)

local function connectPlayer(target) target.CharacterAdded:Connect(function() task.wait(0.5) updatePlayer(target) end)

target:GetPropertyChangedSignal("Team"):Connect(function() updatePlayer(target) end) if target.Character then updatePlayer(target) end 

end

for _, target in ipairs(Players:GetPlayers()) do connectPlayer(target) end

Players.PlayerAdded:Connect(connectPlayer)

Players.PlayerRemoving:Connect(function(target) removeHighlight(target) end)

print("SCP Tactical carregado!")

