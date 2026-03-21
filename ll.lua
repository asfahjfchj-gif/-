-- // Ultimate Hack (V8) - TARGET MODAL & LOOP TP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local guiParent
pcall(function() guiParent = game:GetService("CoreGui") end)
if not guiParent then guiParent = LocalPlayer:WaitForChild("PlayerGui") end

-- // Settings
local Settings = {
    ESP = { Enabled = false, ShowName = false, ShowHP = false, ShowDistance = false, Chams = false, Tracers = false, GlowEffect = false, RainbowChams = false, DmgIndicator = false, VisibleColor = Color3.fromRGB(0, 255, 150), HiddenColor = Color3.fromRGB(255, 50, 50) },
    Aimbot = { Enabled = false, ShowFOV = true, Radius = 150, Smoothing = 5, TargetPart = "Head", SmartAim = false, WallCheck = false, Prediction = false, PredictFactor = 0.15, SilentAim = false },
    Combat = { NoRecoil = false },
    Hitbox = { Enabled = false, Size = 6, Transparency = 0.5 },
    Movement = { Fly = false, Speed = 50, Noclip = false, InfJump = false, BHop = false, JumpPowerOn = false, JumpPowerVal = 50, AntiVoid = false, CFrameSpeed = false, CFrameSpeedVal = 2, TPtoMouse = false, Spider = false, AntiKnockback = false, LagSpeed = false, LagSpeedVal = 5, WalkSpeedOn = false, WalkSpeedVal = 16 },
    TP = { SpectateIndex = 1, LoopTP = false, TargetPlayer = nil, Spectating = false, SpectateTarget = nil },
    Rage = { Spinbot = false, AntiAim = false },
    World = { Fullbright = false, XRay = false, FOV = 70 },
    Misc = { TeamCheck = false, ChatSpam = false, SpamText = "Rivals Premium Cheat!" },
    Config = { AntiAFK = true, AutoRespawn = true },
    Protection = { AntiScreenshot = false, AntiKick = false, AntiLag = false },
    PerfGuard = { Enabled = false, MinFPS = 30 },
    Theme = { Current = "Default" }
}

-- // LOCALIZATION (EN)
local Locale = {
    on = "ON", off = "OFF",
    header = "    ULTIMATE HACK  ·  V8",
    players_header = "    PLAYERS  ·  TARGET",
    tab_visuals = "◈  Visuals", tab_combat = "⊕  Combat", tab_movement = "►  Movement",
    tab_world = "○  World", tab_rage = "◆  Rage", tab_protection = "🛡  Protection", tab_settings = "≡  Settings",
    rejoin = "Rejoin", server_hop = "Server Hop",
    hide_menu = "Hide Menu (Panic Button - HOME)", anti_afk = "Anti-AFK",
    team_check = "TeamCheck (Ignore Team)", save_config = "Save Config",
    load_config = "Load Config", saved = "Saved!", loaded = "Loaded!",
    esp_main = "◈ ESP (Main)", esp_names = "  ├ Names", esp_distance = "  ├ Distance",
    esp_hp = "  ├ HP (Health)", esp_chams = "  ├ Chams (Fill)", esp_tracers = "  └ Tracers (Lines)",
    show_fov = "Show FOV Circle", glow_effect = "Glow Effect",
    rainbow_chams = "Rainbow Chams",
    dmg_indicator = "Damage Indicator (-HP)",
    aimbot = "Aimbot (RMB)", silent_aim = "Silent Aim",
    no_recoil = "No Recoil",
    wallcheck = "Aimbot WallCheck (Walls)",
    aim_target = "Aimbot Target", aim_target_head = "Head", aim_target_body = "Body",
    aim_speed = "Aimbot Speed (Lower = faster)", aim_fov = "Aimbot FOV Radius",
    prediction = "Aimbot Prediction", predict_power = "Prediction Power",
    smart_aim = "Smart Aim",
    hitbox = "Hitbox Expander", hitbox_size = "Head Size",
    noclip = "Noclip", fly = "Fly", fly_speed = "Fly Speed", fly_minus = "  -  ", fly_plus = "  +  ", fly_reset = "Reset 10", inf_jump = "Infinite Jump",
    bhop = "BHop",
    jumppower_hack = "JumpPower Hack", jumppower = "JumpPower", cframe_speed = "CFrame Speed",
    cframe_power = "CFrame Speed Power", anti_void = "Anti-Void",
    spider = "Spider (Wall Walk)", anti_kb = "Anti-Knockback",
    tp_mouse = "TP to Mouse (X)",
    lag_speed = "Lag Speed (Ping)",
    lag_speed_power = "Lag Speed Power",
    walk_speed = "WalkSpeed Hack", walk_speed_val = "WalkSpeed",
    fullbright = "Fullbright", fov_camera = "Camera FOV",
    open_target = "◆  Open Target Window", stop_spectate = "Stop Spectate (Own Character)",
    spinbot = "Spinbot", anti_aim = "Anti-Aim (Head Desync)", god_mode = "God Mode (Respawn to cancel)",
    anti_kick = "Anti-Kick", anti_ss = "Anti-Screenshot", anti_lag = "Anti-Lag (Remove Effects)",
    search = "Search...", selected = "Selected", selected_none = "None",
    loop_tp = "Loop TP", spectate = "Spectate", tp_to = "TP to Player",
    notify_rejoin = "Rejoining in 2 sec...", notify_search_server = "Searching server...",
    notify_no_server = "⚠ No free server found", notify_server_error = "⚠ Server list error",
    notify_esp_on = "ESP Enabled", notify_esp_off = "ESP Disabled",
    notify_esp_first = "⚠ Enable ESP first!",
    notify_team_on = "TeamCheck: Teammates ignored", notify_team_off = "TeamCheck: All players are enemies",
    notify_wallcheck = "WallCheck: Aimbot won't aim through walls",
    notify_silent = "Silent Aim: Bullets hit target invisibly",
    notify_smart_aim = "Smart Aim: Aimbot picks visible body part",
    notify_anti_kick = "Anti-Kick: Kick attempts will be blocked",
    notify_anti_kick_blocked = "Anti-Kick: Kick blocked!",
    notify_anti_ss = "GUI hidden from screenshots",
    notify_anti_lag = "Anti-Lag: Removed %d effects",
    notify_auto_respawn = "Auto-Respawn: Settings restored!",
    notify_anti_aim = "Anti-Aim: Your head hitbox is desynced for enemies",
    tab_binds = "⌨  Binds", tab_theme = "🎨  Theme",
    perf_guard = "⚡ Performance Guard", perf_guard_fps = "Min FPS Threshold",
    notify_perf_on = "PerfGuard: Auto-optimize at low FPS",
    notify_perf_triggered = "⚡ PerfGuard: Low FPS! Disabled heavy effects",
    sort_distance = "📏 Dist", sort_name = "A-Z", sort_hp = "❤ HP", sort_visible = "👁 Vis",
    bind_menu = "Menu Toggle", bind_fly = "Fly Toggle", bind_panic = "Panic Hide", bind_tp_mouse = "TP to Mouse",
    bind_press_key = "[Press any key...]",
    theme_default = "Default", theme_neon = "Neon", theme_terminal = "Terminal", theme_toxic = "Toxic", theme_clean = "Clean",
    notify_theme = "Theme: %s",
    notify_bind_set = "Bind: %s → %s",
}

local function L(key) return Locale[key] or key end

local UserBinds = { Menu = Enum.KeyCode.Insert, Fly = Enum.KeyCode.None, Panic = Enum.KeyCode.Home, TPMouse = Enum.KeyCode.X }
local espObjects, isVisibleCache, RGBObjects, smartAimCache = {}, {}, {}, {}
local isRmbDown, isLmbDown = false, false
local FlyVars = { bg = nil, bv = nil, ctrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0} }
local lagSpeedCounter = 0
local lagSpeedNextTick = math.random(3, 8)
local rainbowHue = 0
local dmgCache = {}
local dmgLabels = {}
local spiderBV = nil
local currentFPS = 60
local perfGuardTriggered = false
local currentSortMode = "distance"
local listeningBind = nil
local Themes = {
    Default = { bg = Color3.fromRGB(12, 12, 18), header = Color3.fromRGB(24, 24, 30), accent = Color3.fromRGB(130, 90, 220), btn = Color3.fromRGB(30, 30, 40), btnActive = Color3.fromRGB(130, 70, 220), text = Color3.fromRGB(220, 220, 235), stroke = Color3.fromRGB(200, 200, 220), leftMenu = Color3.fromRGB(16, 16, 22), grad1 = Color3.fromRGB(20, 18, 30), grad2 = Color3.fromRGB(10, 10, 16) },
    Neon = { bg = Color3.fromRGB(5, 5, 15), header = Color3.fromRGB(10, 10, 25), accent = Color3.fromRGB(0, 255, 100), btn = Color3.fromRGB(10, 20, 15), btnActive = Color3.fromRGB(0, 180, 80), text = Color3.fromRGB(0, 255, 150), stroke = Color3.fromRGB(0, 200, 100), leftMenu = Color3.fromRGB(5, 10, 8), grad1 = Color3.fromRGB(5, 15, 10), grad2 = Color3.fromRGB(2, 5, 5) },
    Terminal = { bg = Color3.fromRGB(0, 5, 0), header = Color3.fromRGB(5, 15, 5), accent = Color3.fromRGB(0, 255, 0), btn = Color3.fromRGB(5, 15, 5), btnActive = Color3.fromRGB(0, 180, 0), text = Color3.fromRGB(0, 255, 0), stroke = Color3.fromRGB(0, 180, 0), leftMenu = Color3.fromRGB(0, 8, 0), grad1 = Color3.fromRGB(0, 12, 0), grad2 = Color3.fromRGB(0, 4, 0) },
    Toxic = { bg = Color3.fromRGB(10, 15, 5), header = Color3.fromRGB(15, 25, 5), accent = Color3.fromRGB(180, 255, 0), btn = Color3.fromRGB(20, 30, 10), btnActive = Color3.fromRGB(140, 200, 0), text = Color3.fromRGB(200, 255, 50), stroke = Color3.fromRGB(150, 220, 0), leftMenu = Color3.fromRGB(12, 18, 4), grad1 = Color3.fromRGB(15, 22, 5), grad2 = Color3.fromRGB(5, 10, 2) },
    Clean = { bg = Color3.fromRGB(25, 25, 30), header = Color3.fromRGB(35, 35, 42), accent = Color3.fromRGB(100, 130, 255), btn = Color3.fromRGB(40, 40, 50), btnActive = Color3.fromRGB(80, 110, 220), text = Color3.fromRGB(240, 240, 255), stroke = Color3.fromRGB(150, 150, 180), leftMenu = Color3.fromRGB(30, 30, 38), grad1 = Color3.fromRGB(32, 32, 40), grad2 = Color3.fromRGB(20, 20, 28) },
}
local TeleportService = game:GetService("TeleportService")

local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Settings.Config and Settings.Config.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

local supportDrawing = pcall(function() return Drawing.new("Line") end)
LocalPlayer.CharacterAdded:Connect(function(char)
    if Settings.Config and Settings.Config.AutoRespawn then
        task.wait(1)
        SendNotify(L("notify_auto_respawn"))
        if Settings.Movement and Settings.Movement.Fly then FlyVars.bg = nil; FlyVars.bv = nil end
    end
end)

local function IsEnemy(targetPlayer)
    if not targetPlayer then return false end
    if Settings.Misc.TeamCheck and LocalPlayer.Team ~= nil and targetPlayer.Team == LocalPlayer.Team then return false end
    return true
end

-- Smart Aim: body parts by priority (cache computed in background thread)
local smartAimParts = {
    {"Head"},
    {"UpperTorso", "Torso", "LowerTorso"},
    {"RightUpperArm", "RightLowerArm", "RightHand", "Right Arm"},
    {"LeftUpperArm", "LeftLowerArm", "LeftHand", "Left Arm"},
    {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"},
    {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"},
}

task.spawn(function()
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    while task.wait(0.15) do
        local char = LocalPlayer.Character
        local myHead = char and char:FindFirstChild("Head")
        if myHead then
            rayParams.FilterDescendantsInstances = {char, Camera}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local dir = head.Position - myHead.Position
                        local res = Workspace:Raycast(myHead.Position, dir, rayParams)
                        isVisibleCache[player] = (not res or res.Instance:IsDescendantOf(player.Character))
                    end
                    -- Smart Aim: cache best visible body part
                    if Settings.Aimbot.SmartAim then
                        local eChar = player.Character
                        local visibleGroups = {}
                        local visibleCount = 0
                        for groupIdx, group in ipairs(smartAimParts) do
                            for _, partName in ipairs(group) do
                                local part = eChar:FindFirstChild(partName)
                                if part and part:IsA("BasePart") then
                                    local d = part.Position - myHead.Position
                                    local r = Workspace:Raycast(myHead.Position, d, rayParams)
                                    if not r or r.Instance:IsDescendantOf(eChar) then
                                        visibleGroups[groupIdx] = part
                                        visibleCount = visibleCount + 1
                                        break
                                    end
                                end
                            end
                        end
                        if visibleCount >= 4 and visibleGroups[1] then
                            smartAimCache[player] = visibleGroups[1]
                        else
                            local found = nil
                            for i = 1, #smartAimParts do
                                if visibleGroups[i] then found = visibleGroups[i]; break end
                            end
                            smartAimCache[player] = found
                        end
                    end
                end
            end
        end
    end
end)

-- Rainbow Chams hue cycle
task.spawn(function()
    while task.wait(0.03) do
        rainbowHue = (rainbowHue + 0.005) % 1
    end
end)

-- Damage Indicator tracker
task.spawn(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum then dmgCache[player] = hum.Health end
        end
    end
    while task.wait(0.1) do
        if not Settings.ESP.DmgIndicator then continue end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local head = char and char:FindFirstChild("Head")
            if hum and head then
                local prevHP = dmgCache[player] or hum.Health
                local diff = prevHP - hum.Health
                dmgCache[player] = hum.Health
                if diff > 0.5 then
                    local bg = Instance.new("BillboardGui")
                    bg.Size = UDim2.new(0, 80, 0, 30)
                    bg.StudsOffset = Vector3.new(math.random(-2,2), 4 + math.random(0,2), 0)
                    bg.AlwaysOnTop = true; bg.Parent = head
                    local lbl = Instance.new("TextLabel", bg)
                    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
                    lbl.Text = "-" .. math.floor(diff)
                    lbl.TextColor3 = Color3.fromRGB(255, 60, 60)
                    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 16
                    lbl.TextStrokeTransparency = 0.3
                    TweenService:Create(bg, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {StudsOffset = bg.StudsOffset + Vector3.new(0, 3, 0)}):Play()
                    TweenService:Create(lbl, TweenInfo.new(1.2), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
                    task.delay(1.3, function() bg:Destroy() end)
                end
            end
        end
    end
end)


-- Anti-Kick protection
task.spawn(function()
    task.wait(2)
    if Settings.Protection then
        local oldKick = LocalPlayer.Kick
        if oldKick then
            pcall(function()
                local mt = getrawmetatable(game)
                if mt and setreadonly then
                    setreadonly(mt, false)
                    local oldNamecall = mt.__namecall
                    mt.__namecall = newcclosure(function(self, ...)
                        if Settings.Protection.AntiKick and getnamecallmethod() == "Kick" and self == LocalPlayer then
                            SendNotify(L("notify_anti_kick_blocked"))
                            return
                        end
                        return oldNamecall(self, ...)
                    end)
                    setreadonly(mt, true)
                end
            end)
        end
    end
end)

local function ClearESP(player)
    if espObjects[player] then
        if espObjects[player].bg then espObjects[player].bg:Destroy() end
        if espObjects[player].hl then espObjects[player].hl:Destroy() end
        if espObjects[player].glow then espObjects[player].glow:Destroy() end
        if espObjects[player].tracer then espObjects[player].tracer:Remove() end
        if espObjects[player].tracerLine then espObjects[player].tracerLine:Destroy() end
        if espObjects[player].hpBg then espObjects[player].hpBg:Destroy() end
        espObjects[player] = nil
    end
end
Players.PlayerRemoving:Connect(ClearESP)

local screenGui = Instance.new("ScreenGui", guiParent)
screenGui.Name = "UltimateHack_Tabs"
screenGui.ResetOnSpawn = false

-- FOV Circle
local function SendNotify(msg) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="Ultimate Hack", Text=msg, Duration=3}) end) end


local fovCircle
if supportDrawing then
    fovCircle = Drawing.new("Circle"); fovCircle.Thickness = 1.5; fovCircle.Color = Color3.fromRGB(255, 255, 255); fovCircle.Filled = false
else
    fovCircle = Instance.new("Frame", screenGui); fovCircle.BackgroundTransparency = 1
    local stroke = Instance.new("UIStroke", fovCircle); stroke.Thickness = 1.5; stroke.Color = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
end


local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not IsEnemy(player) then ClearESP(player); continue end
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if character and humanoid and humanoid.Health > 0 and rootPart then
            if not espObjects[player] then
                -- Main BillboardGui container
                local bg = Instance.new("BillboardGui")
                bg.Size = UDim2.new(0, 160, 0, 52)
                bg.StudsOffset = Vector3.new(0, 3.2, 0)
                bg.AlwaysOnTop = true
                -- Background panel
                local panel = Instance.new("Frame", bg)
                panel.Size = UDim2.new(1, 0, 1, 0)
                panel.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
                panel.BackgroundTransparency = 0.45
                panel.BorderSizePixel = 0
                Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 6)
                local panelStroke = Instance.new("UIStroke", panel)
                panelStroke.Thickness = 1; panelStroke.Transparency = 0.5
                -- Accent line top
                local accent = Instance.new("Frame", panel)
                accent.Size = UDim2.new(1, 0, 0, 2); accent.Position = UDim2.new(0, 0, 0, 0)
                accent.BackgroundTransparency = 0; accent.BorderSizePixel = 0
                Instance.new("UICorner", accent).CornerRadius = UDim.new(0, 6)
                -- Name label
                local nameL = Instance.new("TextLabel", panel)
                nameL.Size = UDim2.new(1, -8, 0, 16); nameL.Position = UDim2.new(0, 4, 0, 4)
                nameL.BackgroundTransparency = 1; nameL.Font = Enum.Font.GothamBold; nameL.TextSize = 12
                nameL.TextStrokeTransparency = 0.4; nameL.TextXAlignment = Enum.TextXAlignment.Left
                -- Distance label
                local distL = Instance.new("TextLabel", panel)
                distL.Size = UDim2.new(1, -8, 0, 12); distL.Position = UDim2.new(0, 4, 0, 20)
                distL.BackgroundTransparency = 1; distL.Font = Enum.Font.GothamSemibold; distL.TextSize = 10
                distL.TextStrokeTransparency = 0.5; distL.TextXAlignment = Enum.TextXAlignment.Left
                distL.TextColor3 = Color3.fromRGB(180, 180, 200)
                -- HP bar background
                local hpBg = Instance.new("Frame", panel)
                hpBg.Size = UDim2.new(1, -8, 0, 5); hpBg.Position = UDim2.new(0, 4, 0, 35)
                hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40); hpBg.BackgroundTransparency = 0.3; hpBg.BorderSizePixel = 0
                Instance.new("UICorner", hpBg).CornerRadius = UDim.new(1, 0)
                -- HP bar fill
                local hpFill = Instance.new("Frame", hpBg)
                hpFill.Size = UDim2.new(1, 0, 1, 0)
                hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100); hpFill.BorderSizePixel = 0
                Instance.new("UICorner", hpFill).CornerRadius = UDim.new(1, 0)
                -- HP text
                local hpText = Instance.new("TextLabel", hpBg)
                hpText.Size = UDim2.new(1, 0, 1, 8); hpText.Position = UDim2.new(0, 0, 0, -1)
                hpText.BackgroundTransparency = 1; hpText.Font = Enum.Font.GothamBold; hpText.TextSize = 8
                hpText.TextColor3 = Color3.new(1,1,1); hpText.TextStrokeTransparency = 0.3
                -- Highlight
                local hl = Instance.new("Highlight"); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                -- Glow Highlight (separate, for Neon glow effect)
                local glow = Instance.new("Highlight"); glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                glow.FillTransparency = 0.7; glow.OutlineTransparency = 0
                espObjects[player] = { bg = bg, panel = panel, panelStroke = panelStroke, accent = accent, nameL = nameL, distL = distL, hpBg = hpBg, hpFill = hpFill, hpText = hpText, hl = hl, glow = glow }
            end
            local data = espObjects[player]
            local isVisible = isVisibleCache[player] or false
            local col = isVisible and Settings.ESP.VisibleColor or Settings.ESP.HiddenColor

            -- Determine what to show
            local showAnything = Settings.ESP.Enabled and (Settings.ESP.ShowName or Settings.ESP.ShowHP or Settings.ESP.ShowDistance)
            local showName = Settings.ESP.Enabled and Settings.ESP.ShowName
            local showHP = Settings.ESP.Enabled and Settings.ESP.ShowHP
            local showDist = Settings.ESP.Enabled and Settings.ESP.ShowDistance

            -- Dynamic panel height
            local panelH = 6
            if showName then panelH = panelH + 16 end
            if showDist then panelH = panelH + 14 end
            if showHP then panelH = panelH + 10 end
            data.bg.Size = UDim2.new(0, 160, 0, panelH)

            -- Accent / stroke color
            data.accent.BackgroundColor3 = col
            data.panelStroke.Color = col

            -- Positioning elements dynamically
            local yOff = 4
            -- Name
            if showName then
                data.nameL.Visible = true
                data.nameL.Position = UDim2.new(0, 4, 0, yOff)
                data.nameL.Text = player.DisplayName ~= player.Name and (player.DisplayName .. "  ·  " .. player.Name) or player.Name
                data.nameL.TextColor3 = col
                yOff = yOff + 16
            else data.nameL.Visible = false end
            -- Distance
            if showDist then
                data.distL.Visible = true
                data.distL.Position = UDim2.new(0, 4, 0, yOff)
                local dist = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                data.distL.Text = "📏 " .. dist .. " m"
                yOff = yOff + 14
            else data.distL.Visible = false end
            -- HP bar
            if showHP then
                data.hpBg.Visible = true
                data.hpBg.Position = UDim2.new(0, 4, 0, yOff)
                local hpFrac = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                data.hpFill.Size = UDim2.new(hpFrac, 0, 1, 0)
                -- HP bar color: green -> yellow -> red
                local hpColor
                if hpFrac > 0.5 then hpColor = Color3.fromRGB(math.floor((1 - hpFrac) * 2 * 255), 255, 50)
                else hpColor = Color3.fromRGB(255, math.floor(hpFrac * 2 * 255), 50) end
                data.hpFill.BackgroundColor3 = hpColor
                data.hpText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                data.hpText.Visible = true
                yOff = yOff + 10
            else data.hpBg.Visible = false; data.hpText.Visible = false end

            if showAnything then
                data.bg.Parent = rootPart; data.bg.Enabled = true; data.panel.Visible = true
            else data.bg.Parent = nil; data.bg.Enabled = false end

            -- Chams (only if ESP is on)
            if Settings.ESP.Chams and Settings.ESP.Enabled then
                local chamsCol = col
                if Settings.ESP.RainbowChams then chamsCol = Color3.fromHSV(rainbowHue, 1, 1) end
                data.hl.Parent = character; data.hl.FillColor = chamsCol; data.hl.OutlineColor = chamsCol; data.hl.FillTransparency = 0.5; data.hl.OutlineTransparency = 0
            else data.hl.Parent = nil end

            -- Glow Effect
            if Settings.ESP.GlowEffect and Settings.ESP.Enabled then
                local glowCol = Settings.ESP.RainbowChams and Color3.fromHSV(rainbowHue, 1, 1) or col
                data.glow.Parent = character; data.glow.FillColor = glowCol; data.glow.OutlineColor = glowCol; data.glow.FillTransparency = 0.85; data.glow.OutlineTransparency = 0.2
            else data.glow.Parent = nil end

            -- Tracers
            if Settings.ESP.Tracers and Settings.ESP.Enabled then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    if supportDrawing then
                        if not data.tracer then data.tracer = Drawing.new("Line"); data.tracer.Thickness = 1.5; data.tracer.Transparency = 1 end
                        data.tracer.Visible = true; data.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); data.tracer.To = Vector2.new(pos.X, pos.Y); data.tracer.Color = col
                    else
                        if not data.tracerLine then local tl = Instance.new("Frame", screenGui); tl.BackgroundColor3 = col; tl.BorderSizePixel = 0; tl.AnchorPoint = Vector2.new(0.5, 0.5); data.tracerLine = tl end
                        local from = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); local to = Vector2.new(pos.X, pos.Y); local dstLine = (from - to).Magnitude
                        data.tracerLine.Size = UDim2.new(0, 2, 0, dstLine); data.tracerLine.Position = UDim2.new(0, (from.X + to.X) / 2, 0, (from.Y + to.Y) / 2); data.tracerLine.Rotation = math.deg(math.atan2(to.Y - from.Y, to.X - from.X)) + 90; data.tracerLine.Visible = true; data.tracerLine.BackgroundColor3 = col
                    end
                else if data.tracer then data.tracer.Visible = false end; if data.tracerLine then data.tracerLine.Visible = false end end
            else if data.tracer then data.tracer.Visible = false end; if data.tracerLine then data.tracerLine.Visible = false end end
        else ClearESP(player) end
    end
    if not Settings.ESP.Enabled then for p, _ in pairs(espObjects) do ClearESP(p) end end
end

-- Smart Aim: logic moved to background thread (smartAimCache)

local function GetClosestTarget()
    local maxDist = Settings.Aimbot.Radius
    local target, partToAim = nil, nil
    local mouseLoc = UserInputService:GetMouseLocation()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not IsEnemy(player) then continue end
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
            local part
            if Settings.Aimbot.SmartAim and smartAimCache[player] then
                part = smartAimCache[player]
            else
                part = char:FindFirstChild(Settings.Aimbot.TargetPart)
                if part and Settings.Aimbot.WallCheck and not isVisibleCache[player] then part = nil end
            end
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - mouseLoc).Magnitude
                    if dist < maxDist then maxDist, target, partToAim = dist, player, part end
                end
            end
        end
    end
    return target, partToAim
end

-- // GUI INTERFACE (TABBED)
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 380)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
mainFrame.BackgroundTransparency = 0.25
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
local mainStroke = Instance.new("UIStroke", mainFrame); mainStroke.Color = Color3.fromRGB(130, 90, 220); mainStroke.Transparency = 0.6; mainStroke.Thickness = 1.2
table.insert(RGBObjects, mainStroke)
local mainGrad = Instance.new("UIGradient", mainFrame)
mainGrad.Color = ColorSequence.new(Color3.fromRGB(20,18,30), Color3.fromRGB(10,10,16))
mainGrad.Rotation = 135

local header = Instance.new("TextLabel", mainFrame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
header.BackgroundTransparency = 0.15
header.Text = L("header")
header.TextColor3 = Color3.fromRGB(220, 220, 235)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.TextXAlignment = Enum.TextXAlignment.Left
header.TextTransparency = 0.1
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)
local headerGrad = Instance.new("UIGradient", header)
headerGrad.Color = ColorSequence.new(Color3.fromRGB(30,25,45), Color3.fromRGB(18,18,22))
headerGrad.Rotation = 90
local accentLine = Instance.new("Frame", header)
accentLine.Size = UDim2.new(1, 0, 0, 1)
accentLine.Position = UDim2.new(0, 0, 1, -1)
accentLine.BackgroundColor3 = Color3.fromRGB(130, 90, 220)
accentLine.BackgroundTransparency = 0.3
accentLine.BorderSizePixel = 0

local leftMenu = Instance.new("Frame", mainFrame)
leftMenu.Size = UDim2.new(0, 150, 1, -45)
leftMenu.Position = UDim2.new(0, 5, 0, 40)
leftMenu.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
leftMenu.BackgroundTransparency = 0.4
Instance.new("UICorner", leftMenu).CornerRadius = UDim.new(0, 8)
local leftStroke = Instance.new("UIStroke", leftMenu); leftStroke.Color = Color3.fromRGB(255,255,255); leftStroke.Transparency = 0.92; leftStroke.Thickness = 1
local leftLayout = Instance.new("UIListLayout", leftMenu); leftLayout.SortOrder = Enum.SortOrder.LayoutOrder; leftLayout.Padding = UDim.new(0, 4)

local rightContent = Instance.new("Frame", mainFrame)
rightContent.Size = UDim2.new(1, -165, 1, -45)
rightContent.Position = UDim2.new(0, 160, 0, 40)
rightContent.BackgroundTransparency = 1

local activeTab = nil
local tabs, contents = {}, {}

local function SelectTab(tabName)
    if activeTab == tabName then return end
    activeTab = tabName
    for name, btn in pairs(tabs) do
        local isActive = (name == tabName)
        TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = isActive and Color3.fromRGB(130, 70, 220) or Color3.fromRGB(28, 28, 35), BackgroundTransparency = isActive and 0.3 or 0.8}):Play()
        if contents[name] then
            contents[name].Visible = isActive
        end
    end
end

local tabOrder = 0
local function CreateTab(name)
    tabOrder = tabOrder + 1
    local btn = Instance.new("TextButton", leftMenu)
    btn.Size = UDim2.new(1, -8, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(28, 28, 35); btn.BackgroundTransparency = 0.8; btn.TextColor3 = Color3.fromRGB(210, 210, 225); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 13; btn.Text = "  " .. name; btn.TextXAlignment = Enum.TextXAlignment.Left; btn.LayoutOrder = tabOrder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", btn); st.Color = Color3.fromRGB(255,255,255); st.Transparency = 0.92; st.Thickness = 1
    btn.MouseEnter:Connect(function() if activeTab ~= name then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play(); TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.7}):Play() end end)
    btn.MouseLeave:Connect(function() if activeTab ~= name then TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.8}):Play(); TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.92}):Play() end end)
    tabs[name] = btn
    
    local scrollFrame = Instance.new("ScrollingFrame", rightContent)
    scrollFrame.Size = UDim2.new(1, 0, 1, 0); scrollFrame.BackgroundTransparency = 1; scrollFrame.ScrollBarThickness = 3; scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(130, 90, 220); scrollFrame.Visible = false
    local layout = Instance.new("UIListLayout", scrollFrame); layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0, 5)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10) end)
    contents[name] = scrollFrame
    btn.MouseButton1Click:Connect(function() SelectTab(name) end)
    return scrollFrame
end

local function AddButton(parent, text, clickCallback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); btn.BackgroundTransparency = 0.7; btn.TextColor3 = Color3.fromRGB(220, 220, 235); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12; btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", btn); st.Color = Color3.fromRGB(200,200,220); st.Transparency = 0.88; st.Thickness = 1
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play(); TweenService:Create(st, TweenInfo.new(0.15), {Transparency = 0.6, Color = Color3.fromRGB(160, 120, 255)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play(); TweenService:Create(st, TweenInfo.new(0.2), {Transparency = 0.88, Color = Color3.fromRGB(200,200,220)}):Play() end)
    local function UpdateCol(state) TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundColor3 = state and Color3.fromRGB(130, 70, 220) or Color3.fromRGB(30, 30, 40)}):Play() end
    btn.MouseButton1Click:Connect(function() clickCallback(btn, UpdateCol) end)
end

local function AddSlider(parent, text, min, max, curr, callback)
    local frame = Instance.new("Frame", parent); frame.Size = UDim2.new(1, -10, 0, 45); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40); frame.BackgroundTransparency = 0.7; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    local st = Instance.new("UIStroke", frame); st.Color = Color3.fromRGB(200,200,220); st.Transparency = 0.88; st.Thickness = 1
    local lbl = Instance.new("TextLabel", frame); lbl.Size = UDim2.new(1, -10, 0, 20); lbl.Position = UDim2.new(0, 5, 0, 5); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.fromRGB(210,210,225); lbl.Text = text..": "..curr; lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local back = Instance.new("Frame", frame); back.Size = UDim2.new(1, -10, 0, 8); back.Position = UDim2.new(0, 5, 0, 30); back.BackgroundColor3 = Color3.fromRGB(25, 25, 35); back.BackgroundTransparency = 0.3; Instance.new("UICorner", back).CornerRadius = UDim.new(1, 0)
    local posNorm = math.clamp((curr-min)/(max-min), 0, 1)
    local posNorm = math.clamp((curr-min)/(max-min), 0, 1)
    if posNorm ~= posNorm then posNorm = 0 end
    local fill = Instance.new("Frame", back); fill.Size = UDim2.new(posNorm,0,1,0); fill.BackgroundColor3 = Color3.fromRGB(130, 70, 220); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", fill); fillGrad.Color = ColorSequence.new(Color3.fromRGB(100, 50, 200), Color3.fromRGB(180, 100, 255)); fillGrad.Rotation = 0
    table.insert(RGBObjects, fill)
    local isD = false
    local function update(i) local pos = math.clamp((i.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1); fill.Size = UDim2.new(pos, 0, 1, 0); local val = math.floor(min + (max - min) * pos); lbl.Text = text..": "..val; callback(val) end
    back.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isD = true; update(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then isD = false end end)
    UserInputService.InputChanged:Connect(function(i) if isD and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
end

-- // TARGET PLAYER WINDOW
local playerWindow = Instance.new("Frame", screenGui)
playerWindow.Size = UDim2.new(0, 260, 0, 380)
playerWindow.Position = UDim2.new(0.5, 270, 0.5, -190)
playerWindow.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
playerWindow.BackgroundTransparency = 0.25
playerWindow.Active = true
playerWindow.Draggable = true
playerWindow.Visible = false
Instance.new("UICorner", playerWindow).CornerRadius = UDim.new(0, 10)
local pwStroke = Instance.new("UIStroke", playerWindow); pwStroke.Color = Color3.fromRGB(130, 90, 220); pwStroke.Transparency = 0.6; pwStroke.Thickness = 1.2
table.insert(RGBObjects, pwStroke)
local pwGrad = Instance.new("UIGradient", playerWindow)
pwGrad.Color = ColorSequence.new(Color3.fromRGB(20,18,30), Color3.fromRGB(10,10,16))
pwGrad.Rotation = 135

local pwHeader = Instance.new("TextLabel", playerWindow)
pwHeader.Size = UDim2.new(1, 0, 0, 35); pwHeader.BackgroundColor3 = Color3.fromRGB(24, 24, 30); pwHeader.BackgroundTransparency = 0.15; pwHeader.Text = L("players_header"); pwHeader.TextColor3 = Color3.fromRGB(220, 220, 235); pwHeader.Font = Enum.Font.GothamBold; pwHeader.TextSize = 13; pwHeader.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", pwHeader).CornerRadius = UDim.new(0, 10)
local pwHdrGrad = Instance.new("UIGradient", pwHeader)
pwHdrGrad.Color = ColorSequence.new(Color3.fromRGB(30,25,45), Color3.fromRGB(18,18,22))
pwHdrGrad.Rotation = 90
local pwAccent = Instance.new("Frame", pwHeader)
pwAccent.Size = UDim2.new(1, 0, 0, 1); pwAccent.Position = UDim2.new(0, 0, 1, -1)
pwAccent.BackgroundColor3 = Color3.fromRGB(130, 90, 220); pwAccent.BackgroundTransparency = 0.3; pwAccent.BorderSizePixel = 0

local closePwBtn = Instance.new("TextButton", pwHeader)
closePwBtn.Size = UDim2.new(0, 28, 0, 28); closePwBtn.Position = UDim2.new(1, -33, 0, 3); closePwBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40); closePwBtn.BackgroundTransparency = 0.4; closePwBtn.Text = "X"; closePwBtn.TextColor3 = Color3.fromRGB(255, 220, 220); closePwBtn.Font = Enum.Font.GothamBold; closePwBtn.TextSize = 12
Instance.new("UICorner", closePwBtn).CornerRadius = UDim.new(0, 6)
closePwBtn.MouseEnter:Connect(function() TweenService:Create(closePwBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play() end)
closePwBtn.MouseLeave:Connect(function() TweenService:Create(closePwBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
closePwBtn.MouseButton1Click:Connect(function() playerWindow.Visible = false end)

local refBtn = Instance.new("TextButton", pwHeader)
refBtn.Size = UDim2.new(0, 28, 0, 28); refBtn.Position = UDim2.new(1, -66, 0, 3); refBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55); refBtn.BackgroundTransparency = 0.4; refBtn.Text = "↻"; refBtn.TextColor3 = Color3.fromRGB(210, 210, 225); refBtn.Font = Enum.Font.GothamBold; refBtn.TextSize = 14
Instance.new("UICorner", refBtn).CornerRadius = UDim.new(0, 6)
refBtn.MouseEnter:Connect(function() TweenService:Create(refBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play() end)
refBtn.MouseLeave:Connect(function() TweenService:Create(refBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)

local plScroll = Instance.new("ScrollingFrame", playerWindow)
plScroll.Size = UDim2.new(1, -10, 1, -200); plScroll.Position = UDim2.new(0, 5, 0, 65); plScroll.BackgroundTransparency = 1; plScroll.ScrollBarThickness = 4
local plLayout = Instance.new("UIListLayout", plScroll); plLayout.SortOrder = Enum.SortOrder.LayoutOrder; plLayout.Padding = UDim.new(0, 4)
plLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() plScroll.CanvasSize = UDim2.new(0, 0, 0, plLayout.AbsoluteContentSize.Y + 5) end)

local actionPanel = Instance.new("Frame", playerWindow)
actionPanel.Size = UDim2.new(1, -10, 0, 120); actionPanel.Position = UDim2.new(0, 5, 1, -125); actionPanel.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
actionPanel.BackgroundTransparency = 0.5
Instance.new("UICorner", actionPanel).CornerRadius = UDim.new(0, 8)
local apStroke = Instance.new("UIStroke", actionPanel); apStroke.Color = Color3.fromRGB(255,255,255); apStroke.Transparency = 0.92; apStroke.Thickness = 1

local selName = Instance.new("TextLabel", actionPanel)

local searchBox = Instance.new("TextBox", actionPanel)
searchBox.Size = UDim2.new(1, -10, 0, 20); searchBox.Position = UDim2.new(0, 5, 0, 25)
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35); searchBox.BackgroundTransparency = 0.4
searchBox.TextColor3 = Color3.fromRGB(210,210,225); searchBox.PlaceholderText = L("search"); searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
searchBox.Font = Enum.Font.GothamSemibold; searchBox.TextSize = 10
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 5)
local sts = Instance.new("UIStroke", searchBox); sts.Color = Color3.fromRGB(200,200,220); sts.Transparency = 0.88; sts.Thickness = 1

selName.Size = UDim2.new(1, 0, 0, 20); selName.BackgroundTransparency = 1; selName.Text = L("selected") .. ": " .. L("selected_none"); selName.TextColor3 = Color3.fromRGB(160, 140, 255); selName.Font = Enum.Font.GothamBold; selName.TextSize = 11

local tempTarget = nil
local loopTpUIBtn = Instance.new("TextButton", actionPanel)
loopTpUIBtn.Size = UDim2.new(0.5, -5, 0, 30); loopTpUIBtn.Position = UDim2.new(0, 3, 0, 50); loopTpUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); loopTpUIBtn.BackgroundTransparency = 0.6; loopTpUIBtn.TextColor3 = Color3.fromRGB(210,210,225); loopTpUIBtn.Text = L("loop_tp") .. ": " .. L("off"); loopTpUIBtn.Font = Enum.Font.GothamSemibold; loopTpUIBtn.TextSize = 10; Instance.new("UICorner", loopTpUIBtn).CornerRadius = UDim.new(0, 5)
local st = Instance.new("UIStroke", loopTpUIBtn); st.Color = Color3.fromRGB(200,200,220); st.Transparency = 0.88; st.Thickness = 1

local spectateUIBtn = Instance.new("TextButton", actionPanel)
spectateUIBtn.Size = UDim2.new(0.5, -5, 0, 30); spectateUIBtn.Position = UDim2.new(0.5, 2, 0, 50); spectateUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); spectateUIBtn.BackgroundTransparency = 0.6; spectateUIBtn.TextColor3 = Color3.fromRGB(210,210,225); spectateUIBtn.Text = L("spectate"); spectateUIBtn.Font = Enum.Font.GothamSemibold; spectateUIBtn.TextSize = 10; Instance.new("UICorner", spectateUIBtn).CornerRadius = UDim.new(0, 5)
local st2 = Instance.new("UIStroke", spectateUIBtn); st2.Color = Color3.fromRGB(200,200,220); st2.Transparency = 0.88; st2.Thickness = 1

local tpOnceBtn = Instance.new("TextButton", actionPanel)
tpOnceBtn.Size = UDim2.new(1, -6, 0, 30); tpOnceBtn.Position = UDim2.new(0, 3, 0, 85); tpOnceBtn.BackgroundColor3 = Color3.fromRGB(90, 50, 180); tpOnceBtn.BackgroundTransparency = 0.4; tpOnceBtn.TextColor3 = Color3.fromRGB(230, 220, 255); tpOnceBtn.Text = L("tp_to"); tpOnceBtn.Font = Enum.Font.GothamSemibold; tpOnceBtn.TextSize = 11; Instance.new("UICorner", tpOnceBtn).CornerRadius = UDim.new(0, 5)
local st3 = Instance.new("UIStroke", tpOnceBtn); st3.Color = Color3.fromRGB(160, 120, 255); st3.Transparency = 0.6; st3.Thickness = 1

local function RefreshPlayerList(filter)
    for _, v in ipairs(plScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    local list = Players:GetPlayers()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    table.sort(list, function(a,b)
        if a == LocalPlayer then return false end
        if b == LocalPlayer then return true end
        if currentSortMode == "name" then return a.Name:lower() < b.Name:lower() end
        if not a.Character or not b.Character then return false end
        if currentSortMode == "hp" then
            local hA = a.Character:FindFirstChildOfClass("Humanoid")
            local hB = b.Character:FindFirstChildOfClass("Humanoid")
            return (hA and hA.Health or 0) < (hB and hB.Health or 0)
        end
        if currentSortMode == "visible" then
            local vA = isVisibleCache[a] and 1 or 0
            local vB = isVisibleCache[b] and 1 or 0
            if vA ~= vB then return vA > vB end
        end
        if not myRoot then return false end
        local rA = a.Character:FindFirstChild("HumanoidRootPart")
        local rB = b.Character:FindFirstChild("HumanoidRootPart")
        if not rA or not rB then return false end
        return (rA.Position - myRoot.Position).Magnitude < (rB.Position - myRoot.Position).Magnitude
    end)
    for _, p in ipairs(list) do
        if p == LocalPlayer then continue end
        if filter and filter ~= "" and not string.find(string.lower(p.Name), string.lower(filter)) then continue end
        local pBtn = Instance.new("TextButton", plScroll)
        pBtn.Size = UDim2.new(1, -4, 0, 26); pBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42); pBtn.BackgroundTransparency = 0.5; pBtn.TextColor3 = Color3.fromRGB(210,210,225); pBtn.Text = "  " .. p.Name; pBtn.Font = Enum.Font.GothamSemibold; pBtn.TextSize = 11; pBtn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 5)
        pBtn.MouseEnter:Connect(function() TweenService:Create(pBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(50, 40, 70)}):Play() end)
        pBtn.MouseLeave:Connect(function() TweenService:Create(pBtn, TweenInfo.new(0.12), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(30, 30, 42)}):Play() end)
        pBtn.MouseButton1Click:Connect(function()
            tempTarget = p
            selName.Text = L("selected") .. ": " .. p.Name
            if Settings.TP.TargetPlayer ~= p then
                Settings.TP.LoopTP = false
                loopTpUIBtn.Text = L("loop_tp") .. ": " .. L("off")
                loopTpUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
                Settings.TP.TargetPlayer = nil
            end
        end)
    end
end
refBtn.MouseButton1Click:Connect(function() RefreshPlayerList(searchBox.Text) end)
searchBox.FocusLost:Connect(function() RefreshPlayerList(searchBox.Text) end)

-- Sort bar
local sortBar = Instance.new("Frame", playerWindow)
sortBar.Size = UDim2.new(1, -10, 0, 24); sortBar.Position = UDim2.new(0, 5, 0, 38)
sortBar.BackgroundTransparency = 1
local sortBarLayout = Instance.new("UIListLayout", sortBar)
sortBarLayout.FillDirection = Enum.FillDirection.Horizontal
sortBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sortBarLayout.Padding = UDim.new(0, 3)
local sortModes = {{"distance", L("sort_distance")}, {"name", L("sort_name")}, {"hp", L("sort_hp")}, {"visible", L("sort_visible")}}
local sortButtons = {}
for i, mode in ipairs(sortModes) do
    local sb = Instance.new("TextButton", sortBar)
    sb.Size = UDim2.new(0.25, -3, 1, 0)
    sb.BackgroundColor3 = (currentSortMode == mode[1]) and Color3.fromRGB(130, 70, 220) or Color3.fromRGB(25, 25, 35)
    sb.BackgroundTransparency = 0.4; sb.TextColor3 = Color3.fromRGB(200, 200, 220)
    sb.Font = Enum.Font.GothamSemibold; sb.TextSize = 9; sb.Text = mode[2]; sb.LayoutOrder = i
    Instance.new("UICorner", sb).CornerRadius = UDim.new(0, 4)
    sortButtons[mode[1]] = sb
    sb.MouseButton1Click:Connect(function()
        currentSortMode = mode[1]
        for k, v in pairs(sortButtons) do
            v.BackgroundColor3 = (k == mode[1]) and Color3.fromRGB(130, 70, 220) or Color3.fromRGB(25, 25, 35)
        end
        RefreshPlayerList(searchBox.Text)
    end)
end

tpOnceBtn.MouseButton1Click:Connect(function()
    if tempTarget and tempTarget.Character and tempTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = tempTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end
end)

spectateUIBtn.MouseButton1Click:Connect(function()
    if Settings.TP.Spectating then
        Settings.TP.Spectating = false
        Settings.TP.SpectateTarget = nil
        spectateUIBtn.Text = L("spectate")
        spectateUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        end
    else
        if tempTarget then
            Settings.TP.Spectating = true
            Settings.TP.SpectateTarget = tempTarget
            spectateUIBtn.Text = L("spectate") .. ": " .. L("on")
            spectateUIBtn.BackgroundColor3 = Color3.fromRGB(130, 70, 220)
            if tempTarget.Character and tempTarget.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = tempTarget.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end
end)

loopTpUIBtn.MouseButton1Click:Connect(function()
    if not tempTarget then return end
    Settings.TP.LoopTP = not Settings.TP.LoopTP
    loopTpUIBtn.Text = L("loop_tp") .. ": " .. (Settings.TP.LoopTP and L("on") or L("off"))
    loopTpUIBtn.BackgroundColor3 = Settings.TP.LoopTP and Color3.fromRGB(130, 70, 220) or Color3.fromRGB(30, 30, 40)
    if Settings.TP.LoopTP then Settings.TP.TargetPlayer = tempTarget else Settings.TP.TargetPlayer = nil end
end)


-- MENU
local tabVisuals = CreateTab(L("tab_visuals"))
local tabCombat = CreateTab(L("tab_combat"))
local tabMovement = CreateTab(L("tab_movement"))
local tabWorld = CreateTab(L("tab_world"))
local tabRage = CreateTab(L("tab_rage"))
local tabProtection = CreateTab(L("tab_protection"))
local tabMisc = CreateTab(L("tab_settings"))
local tabBinds = CreateTab(L("tab_binds"))
local tabTheme = CreateTab(L("tab_theme"))

-- Apply Theme function
local function ApplyTheme(name)
    local t = Themes[name]
    if not t then return end
    Settings.Theme.Current = name
    mainFrame.BackgroundColor3 = t.bg
    mainStroke.Color = t.accent
    mainGrad.Color = ColorSequence.new(t.grad1, t.grad2)
    header.BackgroundColor3 = t.header
    accentLine.BackgroundColor3 = t.accent
    leftMenu.BackgroundColor3 = t.leftMenu
    pwStroke.Color = t.accent
    pwHeader.BackgroundColor3 = t.header
    pwAccent.BackgroundColor3 = t.accent
    playerWindow.BackgroundColor3 = t.bg
    SendNotify(string.format(L("notify_theme"), name))
end

-- Bind button helper
local function AddBindButton(parent, label, bindKey)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 34); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); btn.BackgroundTransparency = 0.7
    btn.TextColor3 = Color3.fromRGB(220, 220, 235); btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 12
    btn.Text = label .. ": " .. UserBinds[bindKey].Name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local bst = Instance.new("UIStroke", btn); bst.Color = Color3.fromRGB(200,200,220); bst.Transparency = 0.88; bst.Thickness = 1
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    btn.MouseButton1Click:Connect(function()
        if listeningBind then return end
        listeningBind = {btn = btn, key = bindKey, label = label}
        btn.Text = L("bind_press_key")
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 100, 40)}):Play()
    end)
end

AddButton(tabMisc, L("rejoin"), function(b,c)
    SendNotify(L("notify_rejoin"))
    task.delay(2, function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)
AddButton(tabMisc, L("server_hop"), function(b,c)
    SendNotify(L("notify_search_server"))
    local success, servers = pcall(function()
        local Http = game:GetService("HttpService")
        local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        return Http:JSONDecode(game:HttpGet(url))
    end)
    if success and servers and servers.data then
        for _, s in ipairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                return
            end
        end
        SendNotify(L("notify_no_server"))
    else
        SendNotify(L("notify_server_error"))
    end
end)
AddButton(tabMisc, L("hide_menu"), function(b,c) 
    mainFrame.Visible = false
    playerWindow.Visible = false
    Settings.ESP.Enabled = false
    Settings.Aimbot.Enabled = false
    c(true)
end)
AddButton(tabMisc, L("anti_afk") .. ": " .. L("on"), function(b,c) Settings.Config.AntiAFK = not Settings.Config.AntiAFK; b.Text = L("anti_afk") .. ": " .. (Settings.Config.AntiAFK and L("on") or L("off")); c(Settings.Config.AntiAFK) end)
AddButton(tabMisc, L("team_check") .. ": " .. L("off"), function(b,c) Settings.Misc.TeamCheck = not Settings.Misc.TeamCheck; b.Text = L("team_check") .. ": " .. (Settings.Misc.TeamCheck and L("on") or L("off")); c(Settings.Misc.TeamCheck)
    if Settings.Misc.TeamCheck then SendNotify(L("notify_team_on")) else SendNotify(L("notify_team_off")) end
end)
AddButton(tabMisc, L("save_config"), function(b,c) 
    if writefile then 
        writefile("Rivals_Premium_Cfg.json", HttpService:JSONEncode(Settings))
        b.Text = L("saved")
        task.wait(1)
        b.Text = L("save_config")
    end
    c(true) 
end)

AddButton(tabMisc, L("load_config"), function(b,c) 
    if readfile and isfile and isfile("Rivals_Premium_Cfg.json") then 
        local s, r = pcall(function() return HttpService:JSONDecode(readfile("Rivals_Premium_Cfg.json")) end)
        if s and r then Settings = r; b.Text = L("loaded") end
        task.wait(1)
        b.Text = L("load_config")
    end
    c(true) 
end)

AddButton(tabVisuals, L("esp_main") .. ": " .. L("off"), function(b,c) Settings.ESP.Enabled = not Settings.ESP.Enabled; b.Text = L("esp_main") .. ": " .. (Settings.ESP.Enabled and L("on") or L("off")); c(Settings.ESP.Enabled)
    if Settings.ESP.Enabled then SendNotify(L("notify_esp_on")) else SendNotify(L("notify_esp_off")) end
    if not Settings.ESP.Enabled then Settings.ESP.Chams = false; Settings.ESP.Tracers = false end
end)
AddButton(tabVisuals, L("esp_names") .. ": " .. L("off"), function(b,c) Settings.ESP.ShowName = not Settings.ESP.ShowName; b.Text = L("esp_names") .. ": " .. (Settings.ESP.ShowName and L("on") or L("off")); c(Settings.ESP.ShowName) end)
AddButton(tabVisuals, L("esp_distance") .. ": " .. L("off"), function(b,c) Settings.ESP.ShowDistance = not Settings.ESP.ShowDistance; b.Text = L("esp_distance") .. ": " .. (Settings.ESP.ShowDistance and L("on") or L("off")); c(Settings.ESP.ShowDistance) end)
AddButton(tabVisuals, L("esp_hp") .. ": " .. L("off"), function(b,c) Settings.ESP.ShowHP = not Settings.ESP.ShowHP; b.Text = L("esp_hp") .. ": " .. (Settings.ESP.ShowHP and L("on") or L("off")); c(Settings.ESP.ShowHP) end)
AddButton(tabVisuals, L("esp_chams") .. ": " .. L("off"), function(b,c)
    if not Settings.ESP.Enabled then SendNotify(L("notify_esp_first")); return end
    Settings.ESP.Chams = not Settings.ESP.Chams; b.Text = L("esp_chams") .. ": " .. (Settings.ESP.Chams and L("on") or L("off")); c(Settings.ESP.Chams)
end)
AddButton(tabVisuals, L("esp_tracers") .. ": " .. L("off"), function(b,c)
    if not Settings.ESP.Enabled then SendNotify(L("notify_esp_first")); return end
    Settings.ESP.Tracers = not Settings.ESP.Tracers; b.Text = L("esp_tracers") .. ": " .. (Settings.ESP.Tracers and L("on") or L("off")); c(Settings.ESP.Tracers)
end)
AddButton(tabVisuals, L("show_fov") .. ": " .. L("on"), function(b,c) Settings.Aimbot.ShowFOV = not Settings.Aimbot.ShowFOV; b.Text = L("show_fov") .. ": " .. (Settings.Aimbot.ShowFOV and L("on") or L("off")); c(Settings.Aimbot.ShowFOV) end)
AddButton(tabVisuals, L("glow_effect") .. ": " .. L("off"), function(b,c)
    if not Settings.ESP.Enabled then SendNotify(L("notify_esp_first")); return end
    Settings.ESP.GlowEffect = not Settings.ESP.GlowEffect; b.Text = L("glow_effect") .. ": " .. (Settings.ESP.GlowEffect and L("on") or L("off")); c(Settings.ESP.GlowEffect)
end)
AddButton(tabVisuals, L("rainbow_chams") .. ": " .. L("off"), function(b,c) Settings.ESP.RainbowChams = not Settings.ESP.RainbowChams; b.Text = L("rainbow_chams") .. ": " .. (Settings.ESP.RainbowChams and L("on") or L("off")); c(Settings.ESP.RainbowChams) end)
AddButton(tabVisuals, L("dmg_indicator") .. ": " .. L("off"), function(b,c) Settings.ESP.DmgIndicator = not Settings.ESP.DmgIndicator; b.Text = L("dmg_indicator") .. ": " .. (Settings.ESP.DmgIndicator and L("on") or L("off")); c(Settings.ESP.DmgIndicator) end)

AddButton(tabCombat, L("aimbot") .. ": " .. L("off"), function(b,c) Settings.Aimbot.Enabled = not Settings.Aimbot.Enabled; b.Text = L("aimbot") .. ": " .. (Settings.Aimbot.Enabled and L("on") or L("off")); c(Settings.Aimbot.Enabled) end)
AddButton(tabCombat, L("silent_aim") .. ": " .. L("off"), function(b,c) Settings.Aimbot.SilentAim = not Settings.Aimbot.SilentAim; b.Text = L("silent_aim") .. ": " .. (Settings.Aimbot.SilentAim and L("on") or L("off")); c(Settings.Aimbot.SilentAim)
    if Settings.Aimbot.SilentAim then SendNotify(L("notify_silent")) end
end)
AddButton(tabCombat, L("no_recoil") .. ": " .. L("off"), function(b,c) Settings.Combat.NoRecoil = not Settings.Combat.NoRecoil; b.Text = L("no_recoil") .. ": " .. (Settings.Combat.NoRecoil and L("on") or L("off")); c(Settings.Combat.NoRecoil) end)
AddButton(tabCombat, L("wallcheck") .. ": " .. L("off"), function(b,c) Settings.Aimbot.WallCheck = not Settings.Aimbot.WallCheck; b.Text = L("wallcheck") .. ": " .. (Settings.Aimbot.WallCheck and L("on") or L("off")); c(Settings.Aimbot.WallCheck)
    if Settings.Aimbot.WallCheck then SendNotify(L("notify_wallcheck")) end
end)
AddButton(tabCombat, L("aim_target") .. ": " .. L("aim_target_head"), function(b,c) 
    if Settings.Aimbot.TargetPart == "Head" then Settings.Aimbot.TargetPart = "HumanoidRootPart"; b.Text = L("aim_target") .. ": " .. L("aim_target_body") else Settings.Aimbot.TargetPart = "Head"; b.Text = L("aim_target") .. ": " .. L("aim_target_head") end; c(true)
end)
AddSlider(tabCombat, L("aim_speed"), 1, 50, 5, function(v) Settings.Aimbot.Smoothing = v end)
AddSlider(tabCombat, L("aim_fov"), 10, 1000, 150, function(v) Settings.Aimbot.Radius = v end)

AddButton(tabCombat, L("prediction") .. ": " .. L("off"), function(b,c) Settings.Aimbot.Prediction = not Settings.Aimbot.Prediction; b.Text = L("prediction") .. ": " .. (Settings.Aimbot.Prediction and L("on") or L("off")); c(Settings.Aimbot.Prediction) end)
AddSlider(tabCombat, L("predict_power"), 1, 100, 15, function(v) Settings.Aimbot.PredictFactor = v / 100 end)
AddButton(tabCombat, L("smart_aim") .. ": " .. L("off"), function(b,c)
    Settings.Aimbot.SmartAim = not Settings.Aimbot.SmartAim
    b.Text = L("smart_aim") .. ": " .. (Settings.Aimbot.SmartAim and L("on") or L("off"))
    c(Settings.Aimbot.SmartAim)
    if Settings.Aimbot.SmartAim then SendNotify(L("notify_smart_aim")) end
end)

AddButton(tabCombat, L("hitbox") .. ": " .. L("off"), function(b,c) Settings.Hitbox.Enabled = not Settings.Hitbox.Enabled; b.Text = L("hitbox") .. ": " .. (Settings.Hitbox.Enabled and L("on") or L("off")); c(Settings.Hitbox.Enabled) end)
AddSlider(tabCombat, L("hitbox_size"), 1, 1000, 6, function(v) Settings.Hitbox.Size = v end)

AddButton(tabMovement, L("noclip") .. ": " .. L("off"), function(b,c) Settings.Movement.Noclip = not Settings.Movement.Noclip; b.Text = L("noclip") .. ": " .. (Settings.Movement.Noclip and L("on") or L("off")); c(Settings.Movement.Noclip) end)
AddButton(tabMovement, L("fly") .. ": " .. L("off"), function(b,c) Settings.Movement.Fly = not Settings.Movement.Fly; b.Text = L("fly") .. ": " .. (Settings.Movement.Fly and L("on") or L("off")); c(Settings.Movement.Fly) end)

do
    local function updateFlyUI() end

    local row = Instance.new("Frame", tabMovement)
    row.Size = UDim2.new(1, -10, 0, 34); row.BackgroundTransparency = 1

    local minusBtn = Instance.new("TextButton", row)
    minusBtn.Size = UDim2.new(0, 36, 1, 0); minusBtn.Position = UDim2.new(0, 0, 0, 0)
    minusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); minusBtn.BackgroundTransparency = 0.7
    minusBtn.TextColor3 = Color3.fromRGB(220, 220, 235); minusBtn.Font = Enum.Font.GothamBold; minusBtn.TextSize = 18; minusBtn.Text = "-"
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
    local st1 = Instance.new("UIStroke", minusBtn); st1.Color = Color3.fromRGB(200,200,220); st1.Transparency = 0.88; st1.Thickness = 1
    minusBtn.MouseEnter:Connect(function() TweenService:Create(minusBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    minusBtn.MouseLeave:Connect(function() TweenService:Create(minusBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local speedInput = Instance.new("TextBox", row)
    speedInput.Size = UDim2.new(1, -190, 1, 0); speedInput.Position = UDim2.new(0, 40, 0, 0)
    speedInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); speedInput.BackgroundTransparency = 0.4
    speedInput.TextColor3 = Color3.fromRGB(210, 210, 225); speedInput.PlaceholderText = L("fly_speed")
    speedInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    speedInput.Font = Enum.Font.GothamSemibold; speedInput.TextSize = 12
    speedInput.Text = L("fly_speed") .. ": " .. Settings.Movement.Speed
    speedInput.ClearTextOnFocus = true
    Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)
    local stInput = Instance.new("UIStroke", speedInput); stInput.Color = Color3.fromRGB(200,200,220); stInput.Transparency = 0.88; stInput.Thickness = 1

    function updateFlyUI()
        speedInput.Text = L("fly_speed") .. ": " .. Settings.Movement.Speed
    end

    speedInput.FocusLost:Connect(function(enterPressed)
        local num = tonumber(speedInput.Text)
        if num and num >= 1 then
            Settings.Movement.Speed = math.floor(num)
        end
        updateFlyUI()
    end)

    local plusBtn = Instance.new("TextButton", row)
    plusBtn.Size = UDim2.new(0, 36, 1, 0); plusBtn.Position = UDim2.new(1, -145, 0, 0)
    plusBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); plusBtn.BackgroundTransparency = 0.7
    plusBtn.TextColor3 = Color3.fromRGB(220, 220, 235); plusBtn.Font = Enum.Font.GothamBold; plusBtn.TextSize = 18; plusBtn.Text = "+"
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
    local st2 = Instance.new("UIStroke", plusBtn); st2.Color = Color3.fromRGB(200,200,220); st2.Transparency = 0.88; st2.Thickness = 1
    plusBtn.MouseEnter:Connect(function() TweenService:Create(plusBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    plusBtn.MouseLeave:Connect(function() TweenService:Create(plusBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local resetBtn = Instance.new("TextButton", row)
    resetBtn.Size = UDim2.new(0, 60, 1, 0); resetBtn.Position = UDim2.new(1, -105, 0, 0)
    resetBtn.BackgroundColor3 = Color3.fromRGB(130, 70, 220); resetBtn.BackgroundTransparency = 0.5
    resetBtn.TextColor3 = Color3.fromRGB(220, 220, 235); resetBtn.Font = Enum.Font.GothamSemibold; resetBtn.TextSize = 11; resetBtn.Text = L("fly_reset")
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
    local st3 = Instance.new("UIStroke", resetBtn); st3.Color = Color3.fromRGB(160, 120, 255); st3.Transparency = 0.6; st3.Thickness = 1
    resetBtn.MouseEnter:Connect(function() TweenService:Create(resetBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    resetBtn.MouseLeave:Connect(function() TweenService:Create(resetBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)

    minusBtn.MouseButton1Click:Connect(function()
        Settings.Movement.Speed = math.max(1, Settings.Movement.Speed - 10)
        updateFlyUI()
    end)
    plusBtn.MouseButton1Click:Connect(function()
        Settings.Movement.Speed = Settings.Movement.Speed + 10
        updateFlyUI()
    end)
    resetBtn.MouseButton1Click:Connect(function()
        Settings.Movement.Speed = 10
        updateFlyUI()
    end)
end
AddButton(tabMovement, L("inf_jump") .. ": " .. L("off"), function(b,c) Settings.Movement.InfJump = not Settings.Movement.InfJump; b.Text = L("inf_jump") .. ": " .. (Settings.Movement.InfJump and L("on") or L("off")); c(Settings.Movement.InfJump) end)
AddButton(tabMovement, L("bhop") .. ": " .. L("off"), function(b,c) Settings.Movement.BHop = not Settings.Movement.BHop; b.Text = L("bhop") .. ": " .. (Settings.Movement.BHop and L("on") or L("off")); c(Settings.Movement.BHop) end)
AddButton(tabMovement, L("jumppower_hack") .. ": " .. L("off"), function(b,c) Settings.Movement.JumpPowerOn = not Settings.Movement.JumpPowerOn; b.Text = L("jumppower_hack") .. ": " .. (Settings.Movement.JumpPowerOn and L("on") or L("off")); c(Settings.Movement.JumpPowerOn) end)
AddSlider(tabMovement, L("jumppower"), 50, 500, 50, function(v) Settings.Movement.JumpPowerVal = v end)
AddButton(tabMovement, L("cframe_speed") .. ": " .. L("off"), function(b,c) Settings.Movement.CFrameSpeed = not Settings.Movement.CFrameSpeed; b.Text = L("cframe_speed") .. ": " .. (Settings.Movement.CFrameSpeed and L("on") or L("off")); c(Settings.Movement.CFrameSpeed) end)
do
    local function updateCFUI() end

    local cfRow = Instance.new("Frame", tabMovement)
    cfRow.Size = UDim2.new(1, -10, 0, 34); cfRow.BackgroundTransparency = 1

    local cfMinus = Instance.new("TextButton", cfRow)
    cfMinus.Size = UDim2.new(0, 36, 1, 0); cfMinus.Position = UDim2.new(0, 0, 0, 0)
    cfMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); cfMinus.BackgroundTransparency = 0.7
    cfMinus.TextColor3 = Color3.fromRGB(220, 220, 235); cfMinus.Font = Enum.Font.GothamBold; cfMinus.TextSize = 18; cfMinus.Text = "-"
    Instance.new("UICorner", cfMinus).CornerRadius = UDim.new(0, 6)
    local cfSt1 = Instance.new("UIStroke", cfMinus); cfSt1.Color = Color3.fromRGB(200,200,220); cfSt1.Transparency = 0.88; cfSt1.Thickness = 1
    cfMinus.MouseEnter:Connect(function() TweenService:Create(cfMinus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    cfMinus.MouseLeave:Connect(function() TweenService:Create(cfMinus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local cfInput = Instance.new("TextBox", cfRow)
    cfInput.Size = UDim2.new(1, -190, 1, 0); cfInput.Position = UDim2.new(0, 40, 0, 0)
    cfInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); cfInput.BackgroundTransparency = 0.4
    cfInput.TextColor3 = Color3.fromRGB(210, 210, 225); cfInput.PlaceholderText = L("cframe_power")
    cfInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    cfInput.Font = Enum.Font.GothamSemibold; cfInput.TextSize = 12
    cfInput.Text = L("cframe_power") .. ": " .. Settings.Movement.CFrameSpeedVal
    cfInput.ClearTextOnFocus = true
    Instance.new("UICorner", cfInput).CornerRadius = UDim.new(0, 6)
    local cfStInput = Instance.new("UIStroke", cfInput); cfStInput.Color = Color3.fromRGB(200,200,220); cfStInput.Transparency = 0.88; cfStInput.Thickness = 1

    function updateCFUI()
        cfInput.Text = L("cframe_power") .. ": " .. Settings.Movement.CFrameSpeedVal
    end

    cfInput.FocusLost:Connect(function(enterPressed)
        local num = tonumber(cfInput.Text)
        if num and num >= 1 then
            Settings.Movement.CFrameSpeedVal = math.floor(num)
        end
        updateCFUI()
    end)

    local cfPlus = Instance.new("TextButton", cfRow)
    cfPlus.Size = UDim2.new(0, 36, 1, 0); cfPlus.Position = UDim2.new(1, -145, 0, 0)
    cfPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); cfPlus.BackgroundTransparency = 0.7
    cfPlus.TextColor3 = Color3.fromRGB(220, 220, 235); cfPlus.Font = Enum.Font.GothamBold; cfPlus.TextSize = 18; cfPlus.Text = "+"
    Instance.new("UICorner", cfPlus).CornerRadius = UDim.new(0, 6)
    local cfSt2 = Instance.new("UIStroke", cfPlus); cfSt2.Color = Color3.fromRGB(200,200,220); cfSt2.Transparency = 0.88; cfSt2.Thickness = 1
    cfPlus.MouseEnter:Connect(function() TweenService:Create(cfPlus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    cfPlus.MouseLeave:Connect(function() TweenService:Create(cfPlus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)

    local cfReset = Instance.new("TextButton", cfRow)
    cfReset.Size = UDim2.new(0, 60, 1, 0); cfReset.Position = UDim2.new(1, -105, 0, 0)
    cfReset.BackgroundColor3 = Color3.fromRGB(130, 70, 220); cfReset.BackgroundTransparency = 0.5
    cfReset.TextColor3 = Color3.fromRGB(220, 220, 235); cfReset.Font = Enum.Font.GothamSemibold; cfReset.TextSize = 11; cfReset.Text = "Reset 2"
    Instance.new("UICorner", cfReset).CornerRadius = UDim.new(0, 6)
    local cfSt3 = Instance.new("UIStroke", cfReset); cfSt3.Color = Color3.fromRGB(160, 120, 255); cfSt3.Transparency = 0.6; cfSt3.Thickness = 1
    cfReset.MouseEnter:Connect(function() TweenService:Create(cfReset, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    cfReset.MouseLeave:Connect(function() TweenService:Create(cfReset, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)

    cfMinus.MouseButton1Click:Connect(function()
        Settings.Movement.CFrameSpeedVal = math.max(1, Settings.Movement.CFrameSpeedVal - 1)
        updateCFUI()
    end)
    cfPlus.MouseButton1Click:Connect(function()
        Settings.Movement.CFrameSpeedVal = Settings.Movement.CFrameSpeedVal + 1
        updateCFUI()
    end)
    cfReset.MouseButton1Click:Connect(function()
        Settings.Movement.CFrameSpeedVal = 2
        updateCFUI()
    end)
end
AddButton(tabMovement, L("anti_void") .. ": " .. L("off"), function(b,c) Settings.Movement.AntiVoid = not Settings.Movement.AntiVoid; b.Text = L("anti_void") .. ": " .. (Settings.Movement.AntiVoid and L("on") or L("off")); c(Settings.Movement.AntiVoid) end)
AddButton(tabMovement, L("spider") .. ": " .. L("off"), function(b,c) Settings.Movement.Spider = not Settings.Movement.Spider; b.Text = L("spider") .. ": " .. (Settings.Movement.Spider and L("on") or L("off")); c(Settings.Movement.Spider) end)
AddButton(tabMovement, L("anti_kb") .. ": " .. L("off"), function(b,c) Settings.Movement.AntiKnockback = not Settings.Movement.AntiKnockback; b.Text = L("anti_kb") .. ": " .. (Settings.Movement.AntiKnockback and L("on") or L("off")); c(Settings.Movement.AntiKnockback) end)
AddButton(tabMovement, L("tp_mouse") .. ": " .. L("off"), function(b,c) Settings.Movement.TPtoMouse = not Settings.Movement.TPtoMouse; b.Text = L("tp_mouse") .. ": " .. (Settings.Movement.TPtoMouse and L("on") or L("off")); c(Settings.Movement.TPtoMouse) end)
AddButton(tabMovement, L("walk_speed") .. ": " .. L("off"), function(b,c) Settings.Movement.WalkSpeedOn = not Settings.Movement.WalkSpeedOn; b.Text = L("walk_speed") .. ": " .. (Settings.Movement.WalkSpeedOn and L("on") or L("off")); c(Settings.Movement.WalkSpeedOn) end)
do
    local function updateWSUI() end
    local wsRow = Instance.new("Frame", tabMovement)
    wsRow.Size = UDim2.new(1, -10, 0, 34); wsRow.BackgroundTransparency = 1
    local wsMinus = Instance.new("TextButton", wsRow)
    wsMinus.Size = UDim2.new(0, 36, 1, 0); wsMinus.Position = UDim2.new(0, 0, 0, 0)
    wsMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); wsMinus.BackgroundTransparency = 0.7
    wsMinus.TextColor3 = Color3.fromRGB(220, 220, 235); wsMinus.Font = Enum.Font.GothamBold; wsMinus.TextSize = 18; wsMinus.Text = "-"
    Instance.new("UICorner", wsMinus).CornerRadius = UDim.new(0, 6)
    local wsSt1 = Instance.new("UIStroke", wsMinus); wsSt1.Color = Color3.fromRGB(200,200,220); wsSt1.Transparency = 0.88; wsSt1.Thickness = 1
    wsMinus.MouseEnter:Connect(function() TweenService:Create(wsMinus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    wsMinus.MouseLeave:Connect(function() TweenService:Create(wsMinus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local wsInput = Instance.new("TextBox", wsRow)
    wsInput.Size = UDim2.new(1, -190, 1, 0); wsInput.Position = UDim2.new(0, 40, 0, 0)
    wsInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); wsInput.BackgroundTransparency = 0.4
    wsInput.TextColor3 = Color3.fromRGB(210, 210, 225); wsInput.PlaceholderText = L("walk_speed_val")
    wsInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    wsInput.Font = Enum.Font.GothamSemibold; wsInput.TextSize = 12
    wsInput.Text = L("walk_speed_val") .. ": " .. Settings.Movement.WalkSpeedVal
    wsInput.ClearTextOnFocus = true
    Instance.new("UICorner", wsInput).CornerRadius = UDim.new(0, 6)
    local wsStI = Instance.new("UIStroke", wsInput); wsStI.Color = Color3.fromRGB(200,200,220); wsStI.Transparency = 0.88; wsStI.Thickness = 1
    function updateWSUI() wsInput.Text = L("walk_speed_val") .. ": " .. Settings.Movement.WalkSpeedVal end
    wsInput.FocusLost:Connect(function() local n = tonumber(wsInput.Text); if n and n >= 1 then Settings.Movement.WalkSpeedVal = math.floor(n) end; updateWSUI() end)
    local wsPlus = Instance.new("TextButton", wsRow)
    wsPlus.Size = UDim2.new(0, 36, 1, 0); wsPlus.Position = UDim2.new(1, -145, 0, 0)
    wsPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); wsPlus.BackgroundTransparency = 0.7
    wsPlus.TextColor3 = Color3.fromRGB(220, 220, 235); wsPlus.Font = Enum.Font.GothamBold; wsPlus.TextSize = 18; wsPlus.Text = "+"
    Instance.new("UICorner", wsPlus).CornerRadius = UDim.new(0, 6)
    local wsSt2 = Instance.new("UIStroke", wsPlus); wsSt2.Color = Color3.fromRGB(200,200,220); wsSt2.Transparency = 0.88; wsSt2.Thickness = 1
    wsPlus.MouseEnter:Connect(function() TweenService:Create(wsPlus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    wsPlus.MouseLeave:Connect(function() TweenService:Create(wsPlus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local wsReset = Instance.new("TextButton", wsRow)
    wsReset.Size = UDim2.new(0, 60, 1, 0); wsReset.Position = UDim2.new(1, -105, 0, 0)
    wsReset.BackgroundColor3 = Color3.fromRGB(130, 70, 220); wsReset.BackgroundTransparency = 0.5
    wsReset.TextColor3 = Color3.fromRGB(220, 220, 235); wsReset.Font = Enum.Font.GothamSemibold; wsReset.TextSize = 11; wsReset.Text = "Reset 16"
    Instance.new("UICorner", wsReset).CornerRadius = UDim.new(0, 6)
    local wsSt3 = Instance.new("UIStroke", wsReset); wsSt3.Color = Color3.fromRGB(160, 120, 255); wsSt3.Transparency = 0.6; wsSt3.Thickness = 1
    wsReset.MouseEnter:Connect(function() TweenService:Create(wsReset, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    wsReset.MouseLeave:Connect(function() TweenService:Create(wsReset, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)
    wsMinus.MouseButton1Click:Connect(function() Settings.Movement.WalkSpeedVal = math.max(1, Settings.Movement.WalkSpeedVal - 10); updateWSUI() end)
    wsPlus.MouseButton1Click:Connect(function() Settings.Movement.WalkSpeedVal = Settings.Movement.WalkSpeedVal + 10; updateWSUI() end)
    wsReset.MouseButton1Click:Connect(function() Settings.Movement.WalkSpeedVal = 16; updateWSUI() end)
end
AddButton(tabMovement, L("lag_speed") .. ": " .. L("off"), function(b,c) Settings.Movement.LagSpeed = not Settings.Movement.LagSpeed; b.Text = L("lag_speed") .. ": " .. (Settings.Movement.LagSpeed and L("on") or L("off")); c(Settings.Movement.LagSpeed) end)
do
    local function updateLSUI() end
    local lsRow = Instance.new("Frame", tabMovement)
    lsRow.Size = UDim2.new(1, -10, 0, 34); lsRow.BackgroundTransparency = 1
    local lsMinus = Instance.new("TextButton", lsRow)
    lsMinus.Size = UDim2.new(0, 36, 1, 0); lsMinus.Position = UDim2.new(0, 0, 0, 0)
    lsMinus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); lsMinus.BackgroundTransparency = 0.7
    lsMinus.TextColor3 = Color3.fromRGB(220, 220, 235); lsMinus.Font = Enum.Font.GothamBold; lsMinus.TextSize = 18; lsMinus.Text = "-"
    Instance.new("UICorner", lsMinus).CornerRadius = UDim.new(0, 6)
    local lsSt1 = Instance.new("UIStroke", lsMinus); lsSt1.Color = Color3.fromRGB(200,200,220); lsSt1.Transparency = 0.88; lsSt1.Thickness = 1
    lsMinus.MouseEnter:Connect(function() TweenService:Create(lsMinus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    lsMinus.MouseLeave:Connect(function() TweenService:Create(lsMinus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local lsInput = Instance.new("TextBox", lsRow)
    lsInput.Size = UDim2.new(1, -190, 1, 0); lsInput.Position = UDim2.new(0, 40, 0, 0)
    lsInput.BackgroundColor3 = Color3.fromRGB(25, 25, 35); lsInput.BackgroundTransparency = 0.4
    lsInput.TextColor3 = Color3.fromRGB(210, 210, 225); lsInput.PlaceholderText = L("lag_speed_power")
    lsInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
    lsInput.Font = Enum.Font.GothamSemibold; lsInput.TextSize = 12
    lsInput.Text = L("lag_speed_power") .. ": " .. Settings.Movement.LagSpeedVal
    lsInput.ClearTextOnFocus = true
    Instance.new("UICorner", lsInput).CornerRadius = UDim.new(0, 6)
    local lsStI = Instance.new("UIStroke", lsInput); lsStI.Color = Color3.fromRGB(200,200,220); lsStI.Transparency = 0.88; lsStI.Thickness = 1
    function updateLSUI() lsInput.Text = L("lag_speed_power") .. ": " .. Settings.Movement.LagSpeedVal end
    lsInput.FocusLost:Connect(function() local n = tonumber(lsInput.Text); if n and n >= 1 then Settings.Movement.LagSpeedVal = math.floor(n) end; updateLSUI() end)
    local lsPlus = Instance.new("TextButton", lsRow)
    lsPlus.Size = UDim2.new(0, 36, 1, 0); lsPlus.Position = UDim2.new(1, -145, 0, 0)
    lsPlus.BackgroundColor3 = Color3.fromRGB(30, 30, 40); lsPlus.BackgroundTransparency = 0.7
    lsPlus.TextColor3 = Color3.fromRGB(220, 220, 235); lsPlus.Font = Enum.Font.GothamBold; lsPlus.TextSize = 18; lsPlus.Text = "+"
    Instance.new("UICorner", lsPlus).CornerRadius = UDim.new(0, 6)
    local lsSt2 = Instance.new("UIStroke", lsPlus); lsSt2.Color = Color3.fromRGB(200,200,220); lsSt2.Transparency = 0.88; lsSt2.Thickness = 1
    lsPlus.MouseEnter:Connect(function() TweenService:Create(lsPlus, TweenInfo.new(0.15), {BackgroundTransparency = 0.4}):Play() end)
    lsPlus.MouseLeave:Connect(function() TweenService:Create(lsPlus, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play() end)
    local lsReset = Instance.new("TextButton", lsRow)
    lsReset.Size = UDim2.new(0, 60, 1, 0); lsReset.Position = UDim2.new(1, -105, 0, 0)
    lsReset.BackgroundColor3 = Color3.fromRGB(130, 70, 220); lsReset.BackgroundTransparency = 0.5
    lsReset.TextColor3 = Color3.fromRGB(220, 220, 235); lsReset.Font = Enum.Font.GothamSemibold; lsReset.TextSize = 11; lsReset.Text = "Reset 5"
    Instance.new("UICorner", lsReset).CornerRadius = UDim.new(0, 6)
    local lsSt3 = Instance.new("UIStroke", lsReset); lsSt3.Color = Color3.fromRGB(160, 120, 255); lsSt3.Transparency = 0.6; lsSt3.Thickness = 1
    lsReset.MouseEnter:Connect(function() TweenService:Create(lsReset, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play() end)
    lsReset.MouseLeave:Connect(function() TweenService:Create(lsReset, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)
    lsMinus.MouseButton1Click:Connect(function() Settings.Movement.LagSpeedVal = math.max(1, Settings.Movement.LagSpeedVal - 1); updateLSUI() end)
    lsPlus.MouseButton1Click:Connect(function() Settings.Movement.LagSpeedVal = Settings.Movement.LagSpeedVal + 1; updateLSUI() end)
    lsReset.MouseButton1Click:Connect(function() Settings.Movement.LagSpeedVal = 5; updateLSUI() end)
end

AddButton(tabWorld, L("fullbright") .. ": " .. L("off"), function(b,c) Settings.World.Fullbright = not Settings.World.Fullbright; b.Text = L("fullbright") .. ": " .. (Settings.World.Fullbright and L("on") or L("off")); c(Settings.World.Fullbright); if Settings.World.Fullbright then Lighting.Ambient = Color3.new(1,1,1); Lighting.Brightness = 2 else Lighting.Ambient = Color3.fromRGB(128,128,128); Lighting.Brightness = 1 end end)
AddSlider(tabWorld, L("fov_camera"), 70, 120, 70, function(v) Camera.FieldOfView = v end)

AddButton(tabRage, L("open_target"), function(b,c)
    playerWindow.Visible = not playerWindow.Visible
    if playerWindow.Visible then RefreshPlayerList(searchBox.Text) end
    c(playerWindow.Visible)
end)
AddButton(tabRage, L("stop_spectate"), function(b,c) 
    Settings.TP.Spectating = false
    Settings.TP.SpectateTarget = nil
    spectateUIBtn.Text = L("spectate")
    spectateUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid") end; c(true)
end)
AddButton(tabRage, L("spinbot") .. ": " .. L("off"), function(b,c) Settings.Rage.Spinbot = not Settings.Rage.Spinbot; b.Text = L("spinbot") .. ": " .. (Settings.Rage.Spinbot and L("on") or L("off")); c(Settings.Rage.Spinbot) end)
AddButton(tabRage, L("anti_aim") .. ": " .. L("off"), function(b,c)
    Settings.Rage.AntiAim = not Settings.Rage.AntiAim
    b.Text = L("anti_aim") .. ": " .. (Settings.Rage.AntiAim and L("on") or L("off"))
    c(Settings.Rage.AntiAim)
    if Settings.Rage.AntiAim then SendNotify(L("notify_anti_aim")) end
end)

AddButton(tabRage, L("god_mode"), function(b,c)
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        local cam = Workspace.CurrentCamera
        local hum = char:FindFirstChildOfClass("Humanoid")
        hum.Name = "1"
        local newHum = hum:Clone()
        newHum.Name = "Humanoid"
        newHum.Parent = char
        hum:Destroy()
        cam.CameraSubject = newHum

        local animate = char:FindFirstChild("Animate")
        if animate then
            local animateClone = animate:Clone()
            animate:Destroy()
            animateClone.Parent = char
        end
        c(true)
    end
end)

-- // PROTECTION TAB
AddButton(tabProtection, L("anti_kick") .. ": " .. L("off"), function(b,c) Settings.Protection.AntiKick = not Settings.Protection.AntiKick; b.Text = L("anti_kick") .. ": " .. (Settings.Protection.AntiKick and L("on") or L("off")); c(Settings.Protection.AntiKick)
    if Settings.Protection.AntiKick then SendNotify(L("notify_anti_kick")) end
end)
AddButton(tabProtection, L("anti_ss") .. ": " .. L("off"), function(b,c)
    Settings.Protection.AntiScreenshot = not Settings.Protection.AntiScreenshot
    b.Text = L("anti_ss") .. ": " .. (Settings.Protection.AntiScreenshot and L("on") or L("off"))
    c(Settings.Protection.AntiScreenshot)
    if Settings.Protection.AntiScreenshot then
        ScreenGui.DisplayOrder = -999999
        SendNotify(L("notify_anti_ss"))
    else
        ScreenGui.DisplayOrder = 999999
    end
end)
AddButton(tabProtection, L("anti_lag") .. ": " .. L("off"), function(b,c)
    Settings.Protection.AntiLag = not Settings.Protection.AntiLag
    b.Text = L("anti_lag") .. ": " .. (Settings.Protection.AntiLag and L("on") or L("off"))
    c(Settings.Protection.AntiLag)
    if Settings.Protection.AntiLag then
        local removed = 0
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v:Destroy(); removed = removed + 1
            end
        end
        SendNotify(string.format(L("notify_anti_lag"), removed))
    end
end)

-- Performance Guard
AddButton(tabProtection, L("perf_guard") .. ": " .. L("off"), function(b,c)
    Settings.PerfGuard.Enabled = not Settings.PerfGuard.Enabled
    b.Text = L("perf_guard") .. ": " .. (Settings.PerfGuard.Enabled and L("on") or L("off"))
    c(Settings.PerfGuard.Enabled)
    if Settings.PerfGuard.Enabled then SendNotify(L("notify_perf_on")) end
end)
AddSlider(tabProtection, L("perf_guard_fps"), 15, 60, 30, function(v) Settings.PerfGuard.MinFPS = v end)

-- Bind Manager
AddBindButton(tabBinds, L("bind_menu"), "Menu")
AddBindButton(tabBinds, L("bind_fly"), "Fly")
AddBindButton(tabBinds, L("bind_panic"), "Panic")
AddBindButton(tabBinds, L("bind_tp_mouse"), "TPMouse")

-- Theme Editor
for _, themeName in ipairs({"Default", "Neon", "Terminal", "Toxic", "Clean"}) do
    AddButton(tabTheme, L("theme_" .. string.lower(themeName)), function(b, c)
        ApplyTheme(themeName)
        c(true)
    end)
end

SelectTab(L("tab_visuals"))

-- // INPUTS
UserInputService.InputBegan:Connect(function(input, gp)
    -- Bind listening mode
    if listeningBind and input.KeyCode ~= Enum.KeyCode.Unknown then
        UserBinds[listeningBind.key] = input.KeyCode
        listeningBind.btn.Text = listeningBind.label .. ": " .. input.KeyCode.Name
        TweenService:Create(listeningBind.btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
        SendNotify(string.format(L("notify_bind_set"), listeningBind.label, input.KeyCode.Name))
        listeningBind = nil
        return
    end
    if not gp then
        if input.KeyCode == Enum.KeyCode.W then FlyVars.ctrl.f = -1
        elseif input.KeyCode == Enum.KeyCode.S then FlyVars.ctrl.b = 1
        elseif input.KeyCode == Enum.KeyCode.A then FlyVars.ctrl.l = -1
        elseif input.KeyCode == Enum.KeyCode.D then FlyVars.ctrl.r = 1
        elseif input.KeyCode == Enum.KeyCode.Space then FlyVars.ctrl.u = 1
        elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyVars.ctrl.d = -1
        elseif input.KeyCode == UserBinds.Menu then 
            if mainFrame.Visible then
                TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 480, 0, 10), BackgroundTransparency = 1}):Play()
                task.delay(0.25, function() mainFrame.Visible = false; mainFrame.Size = UDim2.new(0, 500, 0, 380); mainFrame.BackgroundTransparency = 0.25 end)
            else
                mainFrame.Size = UDim2.new(0, 500, 0, 10); mainFrame.BackgroundTransparency = 1; mainFrame.Visible = true
                TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 380), BackgroundTransparency = 0.25}):Play()
            end
            playerWindow.Visible = false
        elseif input.KeyCode == UserBinds.Panic then 
            mainFrame.Visible = false
            playerWindow.Visible = false
            Settings.ESP.Enabled = false
            Settings.Aimbot.Enabled = false
        elseif input.KeyCode == UserBinds.Fly and UserBinds.Fly ~= Enum.KeyCode.None then
            Settings.Movement.Fly = not Settings.Movement.Fly
        elseif input.KeyCode == UserBinds.TPMouse and Settings.Movement.TPtoMouse then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local mouseHit = Mouse.Hit
                if mouseHit then
                    hrp.CFrame = mouseHit + Vector3.new(0, 3, 0)
                end
            end
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isRmbDown = true end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isLmbDown = true end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if not gp then
        if input.KeyCode == Enum.KeyCode.W then FlyVars.ctrl.f = 0
        elseif input.KeyCode == Enum.KeyCode.S then FlyVars.ctrl.b = 0
        elseif input.KeyCode == Enum.KeyCode.A then FlyVars.ctrl.l = 0
        elseif input.KeyCode == Enum.KeyCode.D then FlyVars.ctrl.r = 0
        elseif input.KeyCode == Enum.KeyCode.Space then FlyVars.ctrl.u = 0
        elseif input.KeyCode == Enum.KeyCode.LeftShift then FlyVars.ctrl.d = 0
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then isRmbDown = false end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isLmbDown = false end
end)

UserInputService.JumpRequest:Connect(function()
    if Settings.Movement.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local function UpdateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if head and humanoid and humanoid.Health > 0 then
            if not head:GetAttribute("OrigSize") then head:SetAttribute("OrigSize", head.Size) end
            if Settings.Hitbox.Enabled and IsEnemy(player) then
                head.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size); head.Transparency = Settings.Hitbox.Transparency; head.Massless = true; head.CanCollide = false; head.CanQuery = true
            else
                local origSize = head:GetAttribute("OrigSize")
                if origSize and head.Size ~= origSize then head.Size = origSize; head.Transparency = 0; head.Massless = false; head.CanQuery = true end
            end
        end
    end
end

local espTickCounter = 0
local fpsFrameCount = 0
local fpsLastTime = tick()
RunService.RenderStepped:Connect(function()
    -- FPS tracking for Performance Guard
    fpsFrameCount = fpsFrameCount + 1
    local now = tick()
    if now - fpsLastTime >= 1 then
        currentFPS = fpsFrameCount
        fpsFrameCount = 0
        fpsLastTime = now
        if Settings.PerfGuard.Enabled then
            if currentFPS < Settings.PerfGuard.MinFPS and not perfGuardTriggered then
                perfGuardTriggered = true
                Settings.ESP.GlowEffect = false
                Settings.ESP.RainbowChams = false
                Settings.ESP.DmgIndicator = false
                SendNotify(L("notify_perf_triggered"))
            elseif currentFPS >= Settings.PerfGuard.MinFPS + 10 then
                perfGuardTriggered = false
            end
        end
    end

    espTickCounter = espTickCounter + 1
    if espTickCounter >= 5 then
        espTickCounter = 0
        UpdateESP()
        UpdateHitboxes()
    end
    
    local mLoc = UserInputService:GetMouseLocation()
    if supportDrawing then
        fovCircle.Position = mLoc; fovCircle.Radius = Settings.Aimbot.Radius; fovCircle.Visible = Settings.Aimbot.ShowFOV
    else
        fovCircle.Size = UDim2.new(0, Settings.Aimbot.Radius * 2, 0, Settings.Aimbot.Radius * 2); fovCircle.Position = UDim2.new(0, mLoc.X - Settings.Aimbot.Radius, 0, mLoc.Y - Settings.Aimbot.Radius); fovCircle.Visible = Settings.Aimbot.ShowFOV
    end


    if Settings.Aimbot.Enabled and isRmbDown then
        local target, part = GetClosestTarget()
        if part then
            local aimPos = part.Position
            if Settings.Aimbot.Prediction and part.Parent:FindFirstChild("HumanoidRootPart") then
                aimPos = aimPos + (part.Parent.HumanoidRootPart.AssemblyLinearVelocity * Settings.Aimbot.PredictFactor)
            end
            if Settings.Aimbot.SilentAim then
                -- Silent Aim: snap camera instantly to target (invisible to player, hits register)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
            else
                local pos = Camera:WorldToViewportPoint(aimPos)
                local dx = (pos.X - mLoc.X)
                local dy = (pos.Y - mLoc.Y)
                if typeof(mousemoverel) == "function" then mousemoverel(dx / Settings.Aimbot.Smoothing, dy / Settings.Aimbot.Smoothing)
                else Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), 1 / Settings.Aimbot.Smoothing) end
            end
        end
    end

    -- No Recoil
    if Settings.Combat.NoRecoil then
        local char = LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BodyAngularVelocity") or v:IsA("BodyThrust") then v:Destroy() end
            end
        end
    end

    -- LOOP TP
    if Settings.TP.LoopTP and Settings.TP.TargetPlayer then
        local tChar = Settings.TP.TargetPlayer.Character
        local myChar = LocalPlayer.Character
        if tChar and myChar and tChar:FindFirstChild("HumanoidRootPart") and myChar:FindFirstChild("HumanoidRootPart") then
            -- TP behind target with slight offset
            myChar.HumanoidRootPart.CFrame = tChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            myChar.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end

    -- Persistent Spectate (survives target death/respawn)
    if Settings.TP.Spectating and Settings.TP.SpectateTarget then
        local specTarget = Settings.TP.SpectateTarget
        if specTarget.Parent then
            if specTarget.Character then
                local specHum = specTarget.Character:FindFirstChildOfClass("Humanoid")
                if specHum then
                    Camera.CameraSubject = specHum
                end
            end
        else
            Settings.TP.Spectating = false
            Settings.TP.SpectateTarget = nil
            spectateUIBtn.Text = L("spectate")
            spectateUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
        end
    end

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        if Settings.Movement.Noclip then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end end
        if Settings.Rage.Spinbot then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(50), 0) end
        -- Anti-Aim: desync head so enemy aimbots target wrong position
        if Settings.Rage.AntiAim then
            local head = char:FindFirstChild("Head")
            if head then
                local offset = CFrame.new(0, math.sin(tick() * 15) * 2.5, math.cos(tick() * 12) * 2)
                head.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0) * offset
            end
        end
        if Settings.Movement.Fly then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = true end
            if not FlyVars.bg then FlyVars.bg = Instance.new("BodyGyro", hrp); FlyVars.bg.P = 9e4; FlyVars.bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); FlyVars.bg.cframe = hrp.CFrame end
            if not FlyVars.bv then FlyVars.bv = Instance.new("BodyVelocity", hrp); FlyVars.bv.velocity = Vector3.zero; FlyVars.bv.maxForce = Vector3.new(9e9, 9e9, 9e9) end
            local ct = FlyVars.ctrl
            local moveDir = Vector3.new(ct.l + ct.r, ct.d + ct.u, ct.f + ct.b)
            if moveDir.Magnitude > 0 then FlyVars.bv.velocity = Camera.CFrame:VectorToWorldSpace(moveDir).Unit * Settings.Movement.Speed
            else FlyVars.bv.velocity = Vector3.zero end; FlyVars.bg.cframe = Camera.CFrame
        else
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
            if FlyVars.bg then FlyVars.bg:Destroy() FlyVars.bg = nil end
            if FlyVars.bv then FlyVars.bv:Destroy() FlyVars.bv = nil end
        end
        -- BHop
        if Settings.Movement.BHop then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.Running and hum.MoveDirection.Magnitude > 0 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        -- JumpPower Hack
        if Settings.Movement.JumpPowerOn then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = Settings.Movement.JumpPowerVal end
        end
        -- CFrame Speed (undetectable speed)
        if Settings.Movement.CFrameSpeed then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + hum.MoveDirection * Settings.Movement.CFrameSpeedVal
            end
        end
        -- WalkSpeed Hack
        if Settings.Movement.WalkSpeedOn then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Settings.Movement.WalkSpeedVal end
        end
        -- Lag Speed (ping lag effect - ultra laggy)
        if Settings.Movement.LagSpeed then
            lagSpeedCounter = lagSpeedCounter + 1
            if lagSpeedCounter >= lagSpeedNextTick then
                lagSpeedCounter = 0
                lagSpeedNextTick = math.random(1, 3)
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    local roll = math.random()
                    local lagDist
                    if roll < 0.2 then
                        lagDist = Settings.Movement.LagSpeedVal * (5 + math.random() * 8)
                    elseif roll < 0.5 then
                        lagDist = Settings.Movement.LagSpeedVal * (2 + math.random() * 5)
                    else
                        lagDist = Settings.Movement.LagSpeedVal * (1 + math.random() * 3)
                    end
                    local sideJitter = (math.random() - 0.5) * Settings.Movement.LagSpeedVal * 0.8
                    local yJitter = (math.random() - 0.3) * Settings.Movement.LagSpeedVal * 0.15
                    local moveDir = hum.MoveDirection
                    local sideDir = Vector3.new(-moveDir.Z, 0, moveDir.X)
                    hrp.CFrame = hrp.CFrame + moveDir * lagDist + sideDir * sideJitter + Vector3.new(0, yJitter, 0)
                    if roll < 0.15 then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
        -- Anti-Void
        if Settings.Movement.AntiVoid and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        -- Spider (wall climbing)
        if Settings.Movement.Spider then
            local rayDown = Workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 3, RaycastParams.new())
            if rayDown and rayDown.Instance then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 1.2, 0)
            end
        end
        -- Anti-Knockback
        if Settings.Movement.AntiKnockback then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, hrp.AssemblyLinearVelocity.Y, hrp.AssemblyLinearVelocity.Z)
            local vel = hrp.AssemblyLinearVelocity
            if vel.Magnitude > 60 then
                hrp.AssemblyLinearVelocity = vel.Unit * 20
            end
        end
    end

end)
