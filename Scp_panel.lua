-- SCP Tactical Panel | Roblox Studio -- LocalScript em StarterPlayerScripts -- ESP local por equipe + interface móvel e minimizável

local Players = game:GetService("Players") local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("SCPTacticalPanel") if old then old:Destroy() end

local gui = Instance.new("ScreenGui") gui.Name = "SCPTacticalPanel" gui.ResetOnSpawn = false gui.Parent = playerGui

local panel = Instance.new("Frame") panel.Size = UDim2.fromOffset(290, 330) panel.Position = UDim2.new(0.5, -145, 0.5, -165) panel.BackgroundColor3 = Color3.fromRGB(38, 32, 72) panel.Parent = gui Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextButton") title.Size = UDim2.new(1, 0, 0, 44) title.BackgroundColor3 = Color3.fromRGB(78, 62, 140) title.Text = "SCP TACTICAL [ — ]" title.TextColor3 = Color3.new(1, 1, 1) title.Font = Enum.Font.GothamBold title.TextSize = 16 title.Parent = panel Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Arrastar painel por toque ou mouse local dragging = false local dragStart, startPosition

title.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPosition = panel.Position end end)

UserInputService.InputChanged:Connect(function(input) if dragging and ( input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch ) then local delta = input.Position - dragStart panel.Position = UDim2.new( startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y ) end end)

UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

local minimized = false title.Activated:Connect(function() minimized = not minimized for _, obj in ipairs(panel:GetChildren()) do if obj ~= title then obj.Visible = not minimized end end panel.Size = minimized and UDim2.fromOffset(290, 44) or UDim2.fromOffset(290, 330) title.Text = minimized and "SCP TACTICAL [ + ]" or "SCP TACTICAL [ — ]" end)

local teams = { Guards = {color = Color3.fromRGB(100, 200, 255), enabled = false}, MTF = {color = Color3.fromRGB(40, 80, 180), enabled = false}, SCP = {color = Color3.fromRGB(255, 100, 190), enabled = false} }

local highlights = {}

local function clearHighlight(target) if highlights[target] then highlights[target]:Destroy() highlights[target] = nil end end

local function updateTarget(target) clearHighlight(target) if target == player or not target.Character or not target.Team then return end

local config = teams[target.Team.Name] if not config or not config.enabled then return end local h = Instance.new("Highlight") h.Name = "TeamHighlight" h.Adornee = target.Character h.FillColor = config.color h.OutlineColor = config.color h.FillTransparency = 0.8 h.Parent = target.Character highlights[target] = h 

end

local function refresh() for _, target in ipairs(Players:GetPlayers()) do updateTarget(target) end end

local function makeButton(text, y, color, callback) local b = Instance.new("TextButton") b.Size = UDim2.new(1, -24, 0, 40) b.Position = UDim2.fromOffset(12, y) b.BackgroundColor3 = Color3.fromRGB(68, 58, 105) b.TextColor3 = Color3.new(1, 1, 1) b.Font = Enum.Font.Gotham b.TextSize = 14 b.Text = text .. ": OFF" b.Parent = panel Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

local enabled = false b.Activated:Connect(function() enabled = not enabled b.Text = text .. (enabled and ": ON" or ": OFF") b.BackgroundColor3 = enabled and color or Color3.fromRGB(68, 58, 105) callback(enabled) end) return b 

end

makeButton("ESP Guards", 54, teams.Guards.color, function(v) teams.Guards.enabled = v refresh() end)

makeButton("ESP MTF", 100, teams.MTF.color, function(v) teams.MTF.enabled = v refresh() end)

makeButton("ESP SCP", 146, teams.SCP.color, function(v) teams.SCP.enabled = v refresh() end)

makeButton("Voo - demonstração", 192, Color3.fromRGB(130, 100, 210), function(v) warn("Voo demonstrativo:", v, "- integre ao sistema de movimento do seu jogo.") end)

makeButton("Noclip - demonstração", 238, Color3.fromRGB(130, 100, 210), function(v) warn("Noclip demonstrativo:", v, "- implemente apenas no ambiente de testes.") end)

local function connectPlayer(target) target.CharacterAdded:Connect(function() task.wait(0.5) updateTarget(target) end) target:GetPropertyChangedSignal("Team"):Connect(function() updateTarget(target) end) if target.Character then updateTarget(target) end end

for _, target in ipairs(Players:GetPlayers()) do connectPlayer(target) end

Players.PlayerAdded:Connect(connectPlayer) Players.PlayerRemoving:Connect(clearHighlight)

print("SCP Tactical Panel iniciado.")

