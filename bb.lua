-- Military Tycoon Script - Fast Load Version (No GUI)
-- Hotkeys: INS=ESP, DEL=Chams, HOME=Aimbot, END=Target, PGUP=TP, PGDN=AutoTP, F=Fly, R=Reload Target List

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
local showNames = true
local showDistance = true
local showHealth = true
local boxColor = Color3.fromRGB(255, 50, 50)
local maxESPDistance = 500

-- Highlight Colors
local visibleColor = Color3.fromRGB(0, 255, 100)
local occludedColor = Color3.fromRGB(100, 100, 100)
local outlineColor = Color3.fromRGB(255, 255, 255)

-- Fly
local flyEnabled = false
local flySpeed = 2
local flyKeys = {}

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

                if showNames then
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
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, targetPos), smoothness)
    end
end)

-- ================== HOTKEYS ==================
local function PrintStatus(func, status)
    print(func .. ": " .. tostring(status))
end

local function GetPlayerList()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local dist = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and
                         math.floor((LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude) or 0
            table.insert(list, plr.Name .. " [" .. dist .. "m]")
        end
    end
    return list
end

local function SelectRandomTarget()
    local players = Players:GetPlayers()
    local available = {}
    for _, plr in pairs(players) do
        if plr ~= LocalPlayer and plr.Character then
            table.insert(available, plr)
        end
    end
    if #available > 0 then
        selectedTarget = available[math.random(1, #available)]
        print("Target selected: " .. selectedTarget.Name)
    else
        print("No available targets!")
    end
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.Insert then
        espEnabled = not espEnabled
        PrintStatus("ESP", espEnabled)
    elseif input.KeyCode == Enum.KeyCode.Delete then
        chamsEnabled = not chamsEnabled
        PrintStatus("Chams", chamsEnabled)
    elseif input.KeyCode == Enum.KeyCode.Home then
        aimbotEnabled = not aimbotEnabled
        PrintStatus("Aimbot", aimbotEnabled)
    elseif input.KeyCode == Enum.KeyCode.End then
        SelectRandomTarget()
    elseif input.KeyCode == Enum.KeyCode.PageUp then
        if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                print("Teleported to " .. selectedTarget.Name)
            end
        else
            print("No target selected!")
        end
    elseif input.KeyCode == Enum.KeyCode.PageDown then
        constantTP = not constantTP
        PrintStatus("Auto TP", constantTP)
        if constantTP and selectedTarget then
            task.spawn(function()
                while constantTP and selectedTarget and selectedTarget.Character do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                    end
                    task.wait(0.03)
                end
            end)
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        PrintStatus("Fly", flyEnabled)
        if flyEnabled then
            local character = LocalPlayer.Character
            if character then
                local flyPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
                flyPart.Anchored = true
            end
        end
    elseif input.KeyCode == Enum.KeyCode.R then
        local players = GetPlayerList()
        print("Players: " .. #players)
        for _, p in pairs(players) do print("  - " .. p) end
    elseif input.KeyCode == Enum.KeyCode.KeypadPlus then
        flySpeed = math.min(flySpeed + 1, 10)
        print("Fly Speed: " .. flySpeed)
    elseif input.KeyCode == Enum.KeyCode.KeypadMinus then
        flySpeed = math.max(flySpeed - 1, 1)
        print("Fly Speed: " .. flySpeed)
    elseif input.KeyCode == Enum.KeyCode.LeftBracket then
        fov = math.max(fov - 10, 50)
        print("FOV: " .. fov)
    elseif input.KeyCode == Enum.KeyCode.RightBracket then
        fov = math.min(fov + 10, 400)
        print("FOV: " .. fov)
    end
end)

-- Fly movement
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

print([[
=====================================
Military Tycoon Script - LOADED
=====================================
HOTKEYS:
  Insert     - Toggle ESP
  Delete     - Toggle Chams
  Home       - Toggle Aimbot
  End        - Select Random Target
  PageUp     - Teleport to Target
  PageDown   - Auto Teleport
  F          - Toggle Fly
  R          - Show Players
  +/- (Numpad) - Fly Speed
  [/]        - FOV
=====================================
]])
