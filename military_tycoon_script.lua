-- ═══ LOAD NEXUSUI ═══
local NexusUI = loadstring(readfile("NexusUI.lua") or game:HttpGet("https://raw.githubusercontent.com/asfahjfchj-gif/-/refs/heads/main/NexusUI.lua"))()

-- ═══ LOADING SCREEN ═══
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Loading GUI
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingGui"
loadingGui.ResetOnSpawn = false
loadingGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loadingGui.DisplayOrder = 9999

if gethui then loadingGui.Parent = gethui() else loadingGui.Parent = PlayerGui end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 200)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = loadingGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(130, 90, 255)
stroke.Thickness = 2
stroke.Transparency = 0.5
stroke.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "✦ Military Tycoon"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "NexusUI Premium Edition"
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = Color3.fromRGB(160, 160, 190)
subtitle.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0, 80)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Инициализация..."
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.TextColor3 = Color3.fromRGB(130, 90, 255)
statusLabel.Parent = mainFrame

local progressBarBg = Instance.new("Frame")
progressBarBg.Size = UDim2.new(0.8, 0, 0, 8)
progressBarBg.Position = UDim2.new(0.1, 0, 0, 110)
progressBarBg.BackgroundColor3 = Color3.fromRGB(32, 32, 48)
progressBarBg.BorderSizePixel = 0
progressBarBg.Parent = mainFrame

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, 4)
progressCorner.Parent = progressBarBg

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(130, 90, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBg

local progressCorner2 = Instance.new("UICorner")
progressCorner2.CornerRadius = UDim.new(0, 4)
progressCorner2.Parent = progressBar

-- Анимация загрузки
local function UpdateLoading(progress, status)
    statusLabel.Text = status
    local tween = game:GetService("TweenService"):Create(progressBar, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(progress, 0, 1, 0)})
    tween:Play()
end

task.spawn(function()
    UpdateLoading(0.1, "Загрузка UI...")
    task.wait(0.3)
    UpdateLoading(0.3, "Инициализация сервисов...")
    task.wait(0.2)
    UpdateLoading(0.5, "Подготовка ESP...")
    task.wait(0.2)
    UpdateLoading(0.7, "Настройка визуалов...")
    task.wait(0.2)
    UpdateLoading(0.9, "Финализация...")
    task.wait(0.3)
    UpdateLoading(1.0, "Готово!")
    task.wait(0.2)
    
    -- Плавное скрытие
    local tweenService = game:GetService("TweenService")
    tweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundTransparency = 1
    }):Play()
    tweenService:Create(title, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    tweenService:Create(subtitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    tweenService:Create(statusLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    tweenService:Create(progressBarBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    loadingGui:Destroy()
end)

-- ═══ CREATE WINDOW ═══
local Window = NexusUI:CreateWindow({
    Name = "Military Tycoon | XENO",
    LoadingTitle = "✦ Military Tycoon Cheat",
    LoadingSubtitle = "NexusUI Premium Edition",
    ToggleKey = Enum.KeyCode.RightControl,
})

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = workspace.CurrentCamera
end)

-- ================== STATE ==================
local selectedTarget = nil
local aimbotEnabled = true
local silentAimEnabled = false
local smoothness = 0.25
local fov = 150
local aimPart = "Head"
local constantTP = false
local holdingRMB = false

-- ESP Settings
local espEnabled = true
local chamsEnabled = true
local boxEnabled = true
local skeletonEnabled = false
local nameEnabled = true
local showDistance = true
local showHealth = true
local boxColor = Color3.fromRGB(255, 50, 50)
local maxESPDistance = 500

-- Highlight Colors
local visibleColor = Color3.fromRGB(0, 255, 100)
local occludedColor = Color3.fromRGB(100, 100, 100)
local outlineColor = Color3.fromRGB(255, 255, 255)

-- Low Health
local lowHealthEnabled = true
local lowHealthThreshold = 30
local lowHealthNotified = {}

-- Extra Visuals
local tracersEnabled = false
local tracerColor = Color3.fromRGB(255, 255, 255)
local showFov = false
local fovColor = Color3.fromRGB(255, 255, 255)

-- Hitbox Expander
local hitboxEnabled = false
local hitboxScale = 1.5

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Color = fovColor
FOVCircle.Visible = false

-- ================== ESP + CHAMS + SKELETON ==================
local ESPObjects = {}
local ChamsHighlights = {}
local SkeletonLines = {}

local espRaycastParams = RaycastParams.new()
espRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
espRaycastParams.IgnoreWater = true

-- Оптимизированная проверка видимости (кэширование)
local lastVisibilityCheck = {}
local lastCheckTime = {}
local VISIBILITY_CACHE_TIME = 0.1

local function IsVisible(character)
    if not character or not character:FindFirstChild("Head") then return false end
    
    local now = tick()
    local charId = character:GetFullName()
    
    -- Кэш проверки видимости
    if lastVisibilityCheck[charId] ~= nil and (now - lastCheckTime[charId]) < VISIBILITY_CACHE_TIME then
        return lastVisibilityCheck[charId]
    end
    
    local myChar = LocalPlayer.Character
    espRaycastParams.FilterDescendantsInstances = myChar and {myChar} or {}

    local origin = Camera.CFrame.Position
    local targetPos = character.Head.Position
    local direction = (targetPos - origin)

    local result = workspace:Raycast(origin, direction, espRaycastParams)

    local isVisible = not result or result.Instance:IsDescendantOf(character)
    lastVisibilityCheck[charId] = isVisible
    lastCheckTime[charId] = now
    
    return isVisible
end

local function GetSkeletonJoints(character)
    local joints = {}
    local head = character:FindFirstChild("Head")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local upperTorso = character:FindFirstChild("UpperTorso")
    local lowerTorso = character:FindFirstChild("LowerTorso")
    local leftUpperArm = character:FindFirstChild("LeftUpperArm")
    local rightUpperArm = character:FindFirstChild("RightUpperArm")
    local leftLowerArm = character:FindFirstChild("LeftLowerArm")
    local rightLowerArm = character:FindFirstChild("RightLowerArm")
    local leftUpperLeg = character:FindFirstChild("LeftUpperLeg")
    local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
    local leftLowerLeg = character:FindFirstChild("LeftLowerLeg")
    local rightLowerLeg = character:FindFirstChild("RightLowerLeg")

    joints["Head"] = head and head.Position
    joints["UpperTorso"] = upperTorso and upperTorso.Position or hrp and hrp.Position
    joints["LowerTorso"] = lowerTorso and lowerTorso.Position or hrp and hrp.Position
    joints["LeftUpperArm"] = leftUpperArm and leftUpperArm.Position
    joints["RightUpperArm"] = rightUpperArm and rightUpperArm.Position
    joints["LeftLowerArm"] = leftLowerArm and leftLowerArm.Position
    joints["RightLowerArm"] = rightLowerArm and rightLowerArm.Position
    joints["LeftUpperLeg"] = leftUpperLeg and leftUpperLeg.Position
    joints["RightUpperLeg"] = rightUpperLeg and rightUpperLeg.Position
    joints["LeftLowerLeg"] = leftLowerLeg and leftLowerLeg.Position
    joints["RightLowerLeg"] = rightLowerLeg and rightLowerLeg.Position
    joints["HumanoidRootPart"] = hrp and hrp.Position

    return joints
end

local function CreateLine()
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = Color3.fromRGB(255, 255, 255)
    line.Transparency = 0.5
    line.Visible = false
    return line
end

-- ═══ HITBOX EXPANDER ═══
local function SetHitboxScale(character, scale)
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        head.Size = Vector3.new(2, 2, 2) * scale
    end
end

local function ApplyHitboxes()
    if not hitboxEnabled then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            SetHitboxScale(plr.Character, hitboxScale)
        end
    end
end

local function ResetHitboxes()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            SetHitboxScale(plr.Character, 1)
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        if hitboxEnabled then
            SetHitboxScale(char, hitboxScale)
        end
    end)
end)

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

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = tracerColor
    tracer.Transparency = 1
    tracer.Visible = false

    ESPObjects[player] = {Box = box, Name = name, Tracer = tracer}

    -- Skeleton Lines
    local skeleton = {}
    local connections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"}
    }
    for i = 1, #connections do
        skeleton[i] = CreateLine()
    end
    SkeletonLines[player] = skeleton

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
        
        -- Применяем хитбокс при создании
        if hitboxEnabled then
            SetHitboxScale(character, hitboxScale)
        end
    end
end

local function UpdateSkeleton(player, joints)
    local skeleton = SkeletonLines[player]
    if not skeleton or not skeletonEnabled then
        if skeleton then
            for i = 1, #skeleton do
                skeleton[i].Visible = false
            end
        end
        return
    end

    local connections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"}
    }

    for i, conn in ipairs(connections) do
        local fromJoint = joints[conn[1]]
        local toJoint = joints[conn[2]]
        local line = skeleton[i]

        if fromJoint and toJoint then
            local fromPos, fromOnScreen = Camera:WorldToViewportPoint(fromJoint)
            local toPos, toOnScreen = Camera:WorldToViewportPoint(toJoint)

            if fromOnScreen and toOnScreen then
                line.From = Vector2.new(fromPos.X, fromPos.Y)
                line.To = Vector2.new(toPos.X, toPos.Y)
                line.Color = boxColor
                line.Visible = true
            else
                line.Visible = false
            end
        else
            line.Visible = false
        end
    end
end

-- Оптимизация: обновляем ESP не каждый кадр
local lastESPUpdate = 0
local ESP_UPDATE_RATE = 1 / 30  -- 30 FPS вместо 60

local function UpdateESP()
    local now = tick()
    if (now - lastESPUpdate) < ESP_UPDATE_RATE then return end
    lastESPUpdate = now
    
    for player, objects in pairs(ESPObjects) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local root = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")

            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local dist = localRoot and (localRoot.Position - root.Position).Magnitude or math.huge

            -- Low Health Check
            if lowHealthEnabled and humanoid then
                local health = humanoid.Health
                if health <= lowHealthThreshold and not lowHealthNotified[player] then
                    lowHealthNotified[player] = true
                    NexusUI:Notify({
                        Title = "⚠️ Low Health",
                        Content = player.DisplayName .. " has " .. math.floor(health) .. " HP!",
                        Duration = 3,
                        Image = "warning"
                    })
                elseif health > lowHealthThreshold then
                    lowHealthNotified[player] = nil
                end
            end

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

                objects.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                objects.Tracer.To = Vector2.new(pos.X, pos.Y)
                objects.Tracer.Color = tracerColor
                objects.Tracer.Visible = tracersEnabled

                -- Update Skeleton
                if skeletonEnabled then
                    local joints = GetSkeletonJoints(character)
                    UpdateSkeleton(player, joints)
                else
                    UpdateSkeleton(player, {})
                end
            else
                objects.Box.Visible = false
                objects.Name.Visible = false
                objects.Tracer.Visible = false
                if SkeletonLines[player] then
                    for i = 1, #SkeletonLines[player] do
                        SkeletonLines[player][i].Visible = false
                    end
                end
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
        if ESPObjects[plr].Tracer then ESPObjects[plr].Tracer:Remove() end
        ESPObjects[plr] = nil
    end
    if SkeletonLines[plr] then
        for i = 1, #SkeletonLines[plr] do
            SkeletonLines[plr][i]:Remove()
        end
        SkeletonLines[plr] = nil
    end
    if ChamsHighlights[plr] then
        ChamsHighlights[plr]:Destroy()
        ChamsHighlights[plr] = nil
    end
    if selectedTarget == plr then selectedTarget = nil end
    lowHealthNotified[plr] = nil
end)

RunService.RenderStepped:Connect(UpdateESP)

-- ================== AIMBOT + SILENT AIM ==================
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holdingRMB = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then holdingRMB = false end
end)

local aimbotRaycastParams = RaycastParams.new()
aimbotRaycastParams.FilterType = Enum.RaycastFilterType.Exclude
aimbotRaycastParams.IgnoreWater = true

local function GetClosestTarget()
    local closestDist = math.huge
    local closestTarget = nil
    local myChar = LocalPlayer.Character
    local myHead = myChar and myChar:FindFirstChild("Head")

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(aimPart) then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health <= 0 then continue end

            local pos = Camera:WorldToScreenPoint(plr.Character[aimPart].Position)
            local distFromCenter = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude

            if distFromCenter < fov and distFromCenter < closestDist then
                if myHead then
                    aimbotRaycastParams.FilterDescendantsInstances = {myChar, plr.Character}
                    local raycastResult = workspace:Raycast(myHead.Position, plr.Character[aimPart].Position - myHead.Position, aimbotRaycastParams)
                    if not raycastResult or raycastResult.Instance:IsDescendantOf(plr.Character) then
                        closestDist = distFromCenter
                        closestTarget = plr
                    end
                end
            end
        end
    end

    return closestTarget, closestDist
end

RunService.RenderStepped:Connect(function()
    local target = selectedTarget

    if target and target.Character and target.Character:FindFirstChild(aimPart) then
        local pos = Camera:WorldToScreenPoint(target.Character[aimPart].Position)
        local distFromCenter = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
        if distFromCenter > fov then target = nil end
    end

    if not target then
        target = GetClosestTarget()
    end

    if silentAimEnabled and target and target.Character and target.Character:FindFirstChild(aimPart) then
        local targetPos = target.Character[aimPart].Position
        local screenPoint = Camera:WorldToScreenPoint(targetPos)
        if screenPoint.Z > 0 then
            getgenv().SilentAimTarget = targetPos
        end
    end

    if aimbotEnabled and holdingRMB and target and target.Character and target.Character:FindFirstChild(aimPart) then
        local targetPos = target.Character[aimPart].Position
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), smoothness)
    end

    if showFov then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = mousePos
        FOVCircle.Radius = fov
        FOVCircle.Color = fovColor
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
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
Visuals:CreateToggle({Name = "Skeleton ESP", CurrentValue = skeletonEnabled, Callback = function(v) skeletonEnabled = v end})
Visuals:CreateToggle({Name = "ESP Enabled", CurrentValue = espEnabled, Callback = function(v) espEnabled = v end})
Visuals:CreateColorPicker({Name = "ESP Color", CurrentColor = boxColor, Callback = function(color) boxColor = color end})
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

Visuals:CreateDivider()
Visuals:CreateSection("Notifications")

Visuals:CreateToggle({Name = "Low Health Alert", CurrentValue = lowHealthEnabled, Callback = function(v) lowHealthEnabled = v end})
Visuals:CreateSlider({Name = "Low Health Threshold", Range = {10, 100}, Increment = 5, CurrentValue = lowHealthThreshold, Callback = function(v) lowHealthThreshold = v end})

Visuals:CreateDivider()
Visuals:CreateSection("Extra Visuals")

Visuals:CreateToggle({Name = "Show FOV Circle", CurrentValue = showFov, Callback = function(v) showFov = v end})
Visuals:CreateColorPicker({Name = "FOV Circle Color", CurrentColor = fovColor, Callback = function(color) fovColor = color end})
Visuals:CreateToggle({Name = "Show Tracers", CurrentValue = tracersEnabled, Callback = function(v) tracersEnabled = v end})
Visuals:CreateColorPicker({Name = "Tracer Color", CurrentColor = tracerColor, Callback = function(color) tracerColor = color end})

-- Combat
Combat:CreateSection("Aimbot Settings")

Combat:CreateToggle({Name = "Aimbot (зажми ПКМ)", CurrentValue = aimbotEnabled, Callback = function(v) aimbotEnabled = v end})
Combat:CreateToggle({Name = "Silent Aim", CurrentValue = silentAimEnabled, Callback = function(v) silentAimEnabled = v end})
Combat:CreateSlider({Name = "Smoothness", Range = {0.05, 1}, Increment = 0.05, CurrentValue = smoothness, Callback = function(v) smoothness = v end})
Combat:CreateSlider({Name = "FOV", Range = {50, 400}, Increment = 10, CurrentValue = fov, Callback = function(v) fov = v end})
Combat:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "Torso", "HumanoidRootPart"},
    CurrentOption = "Head",
    Callback = function(opt) aimPart = opt end
})
Combat:CreateLabel("Hold RIGHT MOUSE BUTTON to aim at target")

Combat:CreateDivider()
Combat:CreateSection("Hitbox Expander")

Combat:CreateToggle({
    Name = "Увеличить хитбоксы",
    CurrentValue = hitboxEnabled,
    Callback = function(v)
        hitboxEnabled = v
        if v then
            ApplyHitboxes()
        else
            ResetHitboxes()
        end
    end
})

Combat:CreateSlider({
    Name = "Размер хитбокса",
    Range = {1, 5},
    Increment = 0.1,
    CurrentValue = hitboxScale,
    Callback = function(v)
        hitboxScale = v
        if hitboxEnabled then
            ApplyHitboxes()
        end
    end
})

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

    NexusUI:Notify({Title = "Список обновлён", Content = "Игроков: " .. #targetDropdownOptions, Duration = 2})
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
                NexusUI:Notify({Title = "Цель выбрана", Content = selectedTarget.Name, Duration = 2})
            end
        end
    end
})

TargetsTab:CreateDivider()
TargetsTab:CreateSection("Teleport Actions")

TargetsTab:CreateButton({
    Name = "TP к цели (разово)",
    Callback = function()
        if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                NexusUI:Notify({Title = "Teleport", Content = "Teleported to " .. selectedTarget.Name, Duration = 2})
            end
        else
            NexusUI:Notify({Title = "Teleport", Content = "No target selected!", Duration = 3})
        end
    end
})

TargetsTab:CreateToggle({
    Name = "Постоянный TP на цель",
    CurrentValue = false,
    Callback = function(v)
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
    end
})

-- Movement
local walkSpeedEnabled = false
local walkSpeed = 16
local jumpPowerEnabled = false
local jumpPower = 50
local infiniteJumpEnabled = false

Movement:CreateSection("Character Modifiers")

Movement:CreateToggle({Name = "WalkSpeed Modifier", CurrentValue = walkSpeedEnabled, Callback = function(v) walkSpeedEnabled = v end})
Movement:CreateSlider({Name = "WalkSpeed", Range = {16, 200}, Increment = 1, CurrentValue = walkSpeed, Callback = function(v) walkSpeed = v end})
Movement:CreateToggle({Name = "JumpPower Modifier", CurrentValue = jumpPowerEnabled, Callback = function(v) jumpPowerEnabled = v end})
Movement:CreateSlider({Name = "JumpPower", Range = {50, 300}, Increment = 5, CurrentValue = jumpPower, Callback = function(v) jumpPower = v end})

Movement:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = infiniteJumpEnabled,
    Callback = function(v) infiniteJumpEnabled = v end
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Movement:CreateDivider()
Movement:CreateSection("Fly Status")

local flyEnabled = false
local flySpeed = 2
local flyKeys = {}
local flyPart

Movement:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        flyEnabled = v
        local character = LocalPlayer.Character
        if character then
            flyPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
            flyPart.Anchored = flyEnabled
        end
    end
})

Movement:CreateSlider({Name = "Fly Speed", Range = {1, 10}, Increment = 1, CurrentValue = flySpeed, Callback = function(v) flySpeed = v end})

UserInputService.InputBegan:Connect(function(input)
    if flyEnabled then flyKeys[input.KeyCode] = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if flyEnabled then flyKeys[input.KeyCode] = nil end
end)

RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if walkSpeedEnabled then humanoid.WalkSpeed = walkSpeed end
        if jumpPowerEnabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = jumpPower
        end
    end

    if not flyEnabled then return end
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

NexusUI:Notify({Title = "✦ Чит загружен", Content = "ESP + Hitbox + Optimized", Duration = 4, Image = "success"})
