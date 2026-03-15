local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Military Tycoon | XENO",
    LoadingTitle = "Military Tycoon Cheat",
    LoadingSubtitle = "by Senior Scripter",
    ConfigurationSaving = {Enabled = false}
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================== STATE ==================
local selectedTarget = nil
local aimbotEnabled = true
local smoothness = 0.25
local fov = 150
local aimPart = "Head"
local constantTP = false
local holdingRMB = false

-- ESP Settings
local espEnabled = true
local chamsEnabled = true
local boxEnabled = true
local nameEnabled = true
local showDistance = true
local showHealth = true
local boxColor = Color3.fromRGB(255, 50, 50)
local maxESPDistance = 500

-- Highlight Colors
local visibleColor = Color3.fromRGB(0, 255, 100)
local occludedColor = Color3.fromRGB(100, 100, 100)
local outlineColor = Color3.fromRGB(255, 255, 255)

-- ================== ESP + CHAMS ==================
local ESPObjects = {}
local ChamsHighlights = {}

local function IsVisible(character)
    if not character or not character:FindFirstChild("Head") then return false end
    local origin = Camera.CFrame.Position
    local targetPos = character.Head.Position
    local direction = (targetPos - origin)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character or {}}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, raycastParams)

    if not result then return true end
    return result.Instance:IsDescendantOf(character)
end

local function CreateESPAndChams(player)
    if player == LocalPlayer then return end

    -- Box ESP (Drawing API)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 0.9
    box.Color = boxColor

    local name = Drawing.new("Text")
    name.Size = 15
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)

    ESPObjects[player] = {Box = box, Name = name}

    -- Chams (Highlight)
    local character = player:WaitForChild("Character", 5)
    if character then
        local highlight = Instance.new("Highlight")
        highlight.Name = "Chams"
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = outlineColor
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character
        highlight.Parent = character

        ChamsHighlights[player] = highlight
    end
end

local function UpdateESP()
    for player, objects in pairs(ESPObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")

            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dist = localRoot and (localRoot.Position - root.Position).Magnitude or math.huge

            if onScreen and dist <= maxESPDistance and espEnabled then
                local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
                local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = (top.Y - bottom.Y)
                local width = height * 0.6

                objects.Box.Size = Vector2.new(width, height)
                objects.Box.Position = Vector2.new(pos.X - width/2, pos.Y - height/2)
                objects.Box.Visible = boxEnabled
                objects.Box.Color = boxColor

                if nameEnabled then
                    local text = player.DisplayName
                    if showDistance then text = text .. " [" .. math.floor(dist) .. "m]" end
                    if showHealth and humanoid then text = text .. " " .. math.floor(humanoid.Health) .. "hp" end
                    
                    objects.Name.Text = text
                    objects.Name.Position = Vector2.new(pos.X, pos.Y - height/2 - 18)
                    objects.Name.Visible = true
                else
                    objects.Name.Visible = false
                end
            else
                objects.Box.Visible = false
                objects.Name.Visible = false
            end

            -- Chams + Visibility Check
            local highlight = ChamsHighlights[player]
            if highlight and character and chamsEnabled then
                local visible = IsVisible(character)
                if visible then
                    highlight.FillColor = visibleColor
                    highlight.OutlineColor = outlineColor
                else
                    highlight.FillColor = occludedColor
                    highlight.OutlineColor = outlineColor
                end
                highlight.Adornee = character
                highlight.Enabled = true
            elseif highlight then
                highlight.Enabled = false
            end
        else
            if objects.Box then objects.Box.Visible = false end
            if objects.Name then objects.Name.Visible = false end
        end
    end
end

-- Создание для всех игроков
for _, plr in pairs(Players:GetPlayers()) do
    CreateESPAndChams(plr)
end

Players.PlayerAdded:Connect(CreateESPAndChams)

Players.PlayerRemoving:Connect(function(plr)
    if ESPObjects[plr] then
        if ESPObjects[plr].Box then ESPObjects[plr].Box:Remove() end
        if ESPObjects[plr].Name then ESPObjects[plr].Name:Remove() end
        ESPObjects[plr] = nil
    end
    if ChamsHighlights[plr] then
        ChamsHighlights[plr]:Destroy()
        ChamsHighlights[plr] = nil
    end
    if selectedTarget == plr then selectedTarget = nil end
end)

RunService.RenderStepped:Connect(UpdateESP)

-- ================== Aimbot (только ПКМ) ==================
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holdingRMB = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holdingRMB = false end
end)

RunService.RenderStepped:Connect(function()
    if not aimbotEnabled or not holdingRMB then return end

    local target = selectedTarget
    
    -- Проверка текущей цели
    if target and target.Character and target.Character:FindFirstChild(aimPart) then
        local pos = Camera:WorldToScreenPoint(target.Character[aimPart].Position)
        local distFromCenter = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
        if distFromCenter > fov then target = nil end
    end

    -- Поиск ближайшей цели если нет текущей
    if not target then
        local closestDist = math.huge
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(aimPart) then
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health <= 0 then continue end
                
                local pos = Camera:WorldToScreenPoint(plr.Character[aimPart].Position)
                local distFromCenter = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                
                if distFromCenter < fov and distFromCenter < closestDist then
                    local localChar = LocalPlayer.Character
                    local myHead = localChar and localChar:FindFirstChild("Head")
                    if myHead then
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterDescendantsInstances = {localChar, plr.Character}
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        local raycastResult = workspace:Raycast(myHead.Position, plr.Character[aimPart].Position - myHead.Position, raycastParams)
                        if not raycastResult or raycastResult.Instance:IsDescendantOf(plr.Character) then
                            closestDist = distFromCenter
                            target = plr
                        end
                    end
                end
            end
        end
    end

    -- Поворот камеры
    if target and target.Character and target.Character:FindFirstChild(aimPart) then
        local targetPos = target.Character[aimPart].Position
        local currentLookVector = Camera.CFrame.LookVector
        local direction = (targetPos - Camera.CFrame.Position).Unit
        local dot = currentLookVector:Dot(direction)
        local angle = math.deg(math.acos(math.clamp(dot, -1, 1)))
        
        if angle <= 180 then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), smoothness)
        end
    end
end)

-- ================== GUI ==================
local Visuals = Window:CreateTab("Visuals", "eye")
local Combat = Window:CreateTab("Combat", "sword")
local TargetsTab = Window:CreateTab("Targets", "target")
local Movement = Window:CreateTab("Movement", "run")

-- Visuals
Visuals:CreateSection("ESP Settings")

Visuals:CreateToggle({Name = "Box ESP", CurrentValue = boxEnabled, Callback = function(v) boxEnabled = v end})

Visuals:CreateToggle({Name = "ESP Enabled", CurrentValue = espEnabled, Callback = function(v) espEnabled = v end})

Visuals:CreateColorPicker({Name = "Box Color", CurrentColor = boxColor, Callback = function(color) boxColor = color end})

Visuals:CreateToggle({Name = "Show Names", CurrentValue = nameEnabled, Callback = function(v) nameEnabled = v end})

Visuals:CreateToggle({Name = "Show Distance", CurrentValue = showDistance, Callback = function(v) showDistance = v end})

Visuals:CreateToggle({Name = "Show Health", CurrentValue = showHealth, Callback = function(v) showHealth = v end})

Visuals:CreateSlider({Name = "Max ESP Distance", Range = {100, 1000}, Increment = 50, CurrentValue = maxESPDistance, Callback = function(v) maxESPDistance = v end})

Visuals:CreateDivider()

Visuals:CreateSection("Chams Settings")

Visuals:CreateToggle({Name = "Chams Enabled", CurrentValue = chamsEnabled, Callback = function(v) chamsEnabled = v end})

Visuals:CreateColorPicker({Name = "Visible Color", CurrentColor = visibleColor, Callback = function(color) visibleColor = color end})

Visuals:CreateColorPicker({Name = "Occluded Color", CurrentColor = occludedColor, Callback = function(color) occludedColor = color end})

Visuals:CreateColorPicker({Name = "Outline Color", CurrentColor = outlineColor, Callback = function(color) outlineColor = color end})

-- Combat
Combat:CreateSection("Aimbot Settings")

Combat:CreateToggle({Name = "Aimbot (зажми ПКМ)", CurrentValue = aimbotEnabled, Callback = function(v) aimbotEnabled = v end})

Combat:CreateSlider({Name = "Smoothness", Range = {0.05, 1}, Increment = 0.05, CurrentValue = smoothness, Callback = function(v) smoothness = v end})

Combat:CreateSlider({Name = "FOV", Range = {50, 400}, Increment = 10, CurrentValue = fov, Callback = function(v) fov = v end})

Combat:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(opt) aimPart = opt end
})

Combat:CreateLabel("Hold RIGHT MOUSE BUTTON to aim at target")

-- Targets
TargetsTab:CreateSection("Player List")

local targetDropdownOptions = {}

local function RefreshTargets()
    targetDropdownOptions = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then 
            local dist = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and 
                         math.floor((LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude) or 0
            table.insert(targetDropdownOptions, plr.Name .. " [" .. dist .. "m]")
        end
    end
    
    if #targetDropdownOptions == 0 then
        targetDropdownOptions = {"No players"}
    end
    
    if targetDropdown then
        targetDropdown:SetOptions(targetDropdownOptions)
    end
    
    Rayfield:Notify({Title = "Список обновлён", Content = "Игроков: " .. #targetDropdownOptions, Duration = 2})
end

TargetsTab:CreateButton({Name = "🔄 Обновить список игроков", Callback = RefreshTargets})

local targetDropdown
targetDropdown = TargetsTab:CreateDropdown({
    Name = "Выбрать цель",
    Options = targetDropdownOptions,
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "targetSelect",
    Callback = function(opt)
        local playerName = opt[1] or opt
        if playerName and playerName ~= "No players" then
            playerName = playerName:match("^(%S+)")
            selectedTarget = Players:FindFirstChild(playerName)
            if selectedTarget then
                Rayfield:Notify({Title = "Цель выбрана", Content = selectedTarget.Name, Duration = 2})
            end
        end
    end
})

TargetsTab:CreateDivider()

TargetsTab:CreateSection("Teleport Actions")

TargetsTab:CreateButton({Name = "TP к цели (разово)", Callback = function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            Rayfield:Notify({Title = "Teleport", Content = "Teleported to " .. selectedTarget.Name, Duration = 2})
        end
    else
        Rayfield:Notify({Title = "Teleport", Content = "No target selected!", Duration = 3})
    end
end})

TargetsTab:CreateToggle({Name = "Постоянный TP на цель", CurrentValue = false, Callback = function(v)
    constantTP = v
    if v and selectedTarget then
        task.spawn(function()
            while constantTP and selectedTarget and selectedTarget.Character do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                end
                task.wait(0.03)
            end
        end)
    end
end})

-- Movement
Movement:CreateSection("Movement Settings")

local flyEnabled = false
local flySpeed = 2
local flyKeys = {}
local flyPart

Movement:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v)
    flyEnabled = v
    local character = LocalPlayer.Character
    if character then
        flyPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
        flyPart.Anchored = flyEnabled
    end
end})

Movement:CreateSlider({Name = "Fly Speed", Range = {1, 10}, Increment = 1, CurrentValue = flySpeed, Callback = function(v) flySpeed = v end})

UserInputService.InputBegan:Connect(function(input)
    if flyEnabled then flyKeys[input.KeyCode] = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if flyEnabled then flyKeys[input.KeyCode] = nil end
end)

RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if not character or not flyEnabled then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local moveDir = Vector3.new(0,0,0)
    local cam = Camera.CFrame
    if flyKeys[Enum.KeyCode.W] then moveDir = moveDir + cam.LookVector end
    if flyKeys[Enum.KeyCode.S] then moveDir = moveDir - cam.LookVector end
    if flyKeys[Enum.KeyCode.A] then moveDir = moveDir - cam.RightVector end
    if flyKeys[Enum.KeyCode.D] then moveDir = moveDir + cam.RightVector end
    if flyKeys[Enum.KeyCode.Space] then moveDir = moveDir + Vector3.new(0,1,0) end
    if flyKeys[Enum.KeyCode.LeftShift] then moveDir = moveDir - Vector3.new(0,1,0) end
    if moveDir.Magnitude > 0 then
        hrp.CFrame = hrp.CFrame + moveDir.Unit * flySpeed
    end
end)

-- Init
task.spawn(function()
    task.wait(0.5)
    RefreshTargets()
end)

Rayfield:Notify({Title = "Чит загружен", Content = "ESP + Chams + Aimbot + Fly активны", Duration = 2})
