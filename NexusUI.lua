--[[
    NexusUI — Premium Custom GUI Library
    Dark Glassmorphism Theme | TweenService Animations | Optimized
    For Roblox Executors (XENO, etc.)
]]

local NexusUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════ DESIGN TOKENS ═══════════════════
local Theme = {
    Primary      = Color3.fromRGB(130, 90, 255),
    PrimaryDark  = Color3.fromRGB(95, 60, 200),
    PrimaryLight = Color3.fromRGB(170, 130, 255),
    Accent       = Color3.fromRGB(60, 180, 255),
    
    BgDeep       = Color3.fromRGB(12, 12, 18),
    BgDark       = Color3.fromRGB(18, 18, 28),
    BgMid        = Color3.fromRGB(25, 25, 38),
    BgLight      = Color3.fromRGB(32, 32, 48),
    BgHover      = Color3.fromRGB(40, 40, 58),
    
    TextPrimary  = Color3.fromRGB(240, 240, 255),
    TextSecondary= Color3.fromRGB(160, 160, 190),
    TextMuted    = Color3.fromRGB(100, 100, 130),
    
    Success      = Color3.fromRGB(80, 220, 120),
    Warning      = Color3.fromRGB(255, 180, 50),
    Error        = Color3.fromRGB(255, 70, 70),
    
    Border       = Color3.fromRGB(50, 50, 75),
    Shadow       = Color3.fromRGB(0, 0, 0),
    
    CornerRadius = UDim.new(0, 8),
    CornerSmall  = UDim.new(0, 6),
    CornerLarge  = UDim.new(0, 12),
    CornerPill   = UDim.new(0, 99),
    
    Font         = Enum.Font.GothamMedium,
    FontBold     = Enum.Font.GothamBold,
    FontLight    = Enum.Font.Gotham,
}

-- ═══════════════════ TWEEN PRESETS ═══════════════════
local Tween = {
    Fast     = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal   = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Smooth   = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    Bounce   = TweenInfo.new(0.4,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out),
    SlideIn  = TweenInfo.new(0.3,  Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    SlideOut = TweenInfo.new(0.2,  Enum.EasingStyle.Quart, Enum.EasingDirection.In),
}

-- ═══════════════════ UTILITY ═══════════════════
local function Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function Tw(inst, info, goal)
    local t = TweenService:Create(inst, info, goal)
    t:Play()
    return t
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = radius or Theme.CornerRadius, Parent = parent})
end

local function AddStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0.5,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function AddPadding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 8),
        PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 12),
        PaddingRight = UDim.new(0, r or 12),
        Parent = parent,
    })
end

local function AddGradient(parent, c1, c2, rotation)
    return Create("UIGradient", {
        Color = ColorSequence.new(c1 or Theme.Primary, c2 or Theme.PrimaryDark),
        Rotation = rotation or 45,
        Parent = parent,
    })
end

local function RippleEffect(button)
    local ripple = Create("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Parent = button,
    })
    AddCorner(ripple, UDim.new(1, 0))
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tw(ripple, Tween.Smooth, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1})
    task.delay(0.4, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

-- ═══════════════════ NOTIFICATION SYSTEM ═══════════════════
local NotifContainer

local function InitNotifications(screenGui)
    NotifContainer = Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -310, 0, 10),
        BackgroundTransparency = 1,
        Parent = screenGui,
    })
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = NotifContainer,
    })
end

function NexusUI:Notify(config)
    if not NotifContainer then return end
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    local colors = {
        ["warning"] = Theme.Warning,
        ["error"] = Theme.Error,
        ["success"] = Theme.Success,
    }
    local accentColor = colors[config.Image] or Theme.Primary
    
    local notif = Create("Frame", {
        Name = "Notif",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.BgDark,
        BackgroundTransparency = 0.05,
        ClipsDescendants = true,
        Parent = NotifContainer,
    })
    AddCorner(notif, Theme.CornerRadius)
    AddStroke(notif, accentColor, 1, 0.4)
    
    -- Accent bar
    Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = notif,
    })
    
    local inner = Create("Frame", {
        Size = UDim2.new(1, -15, 0, 0),
        Position = UDim2.new(0, 12, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = notif,
    })
    AddPadding(inner, 10, 10, 0, 0)
    Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = inner,
    })
    
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        Text = title,
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = inner,
    })
    
    if content ~= "" then
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = content,
            Font = Theme.Font,
            TextSize = 12,
            TextColor3 = Theme.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            Parent = inner,
        })
    end
    
    -- Animate in
    notif.Position = UDim2.new(1, 50, 0, 0)
    notif.BackgroundTransparency = 1
    Tw(notif, Tween.SlideIn, {Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.05})
    
    -- Animate out
    task.delay(duration, function()
        if notif and notif.Parent then
            local t = Tw(notif, Tween.SlideOut, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1})
            t.Completed:Wait()
            if notif and notif.Parent then notif:Destroy() end
        end
    end)
end

-- ═══════════════════ WINDOW ═══════════════════
function NexusUI:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "NexusUI"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
    -- ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "NexusUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = PlayerGui
    end
    
    InitNotifications(screenGui)
    
    -- Main container
    local mainFrame = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 580, 0, 420),
        Position = UDim2.new(0.5, -290, 0.5, -210),
        BackgroundColor3 = Theme.BgDeep,
        ClipsDescendants = true,
        Parent = screenGui,
    })
    AddCorner(mainFrame, Theme.CornerLarge)
    AddStroke(mainFrame, Theme.Border, 1, 0.3)
    
    -- Shadow
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.4,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = 0,
        Parent = mainFrame,
    })
    
    -- ═══ TITLE BAR ═══
    local titleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.BgDark,
        BorderSizePixel = 0,
        Parent = mainFrame,
    })
    
    -- Title gradient accent line
    local accentLine = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BorderSizePixel = 0,
        Parent = titleBar,
    })
    AddGradient(accentLine, Theme.Primary, Theme.Accent, 0)
    
    -- Title icon (diamond unicode)
    Create("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Text = "◆",
        Font = Theme.FontBold,
        TextSize = 16,
        TextColor3 = Theme.Primary,
        BackgroundTransparency = 1,
        Parent = titleBar,
    })
    
    Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 38, 0, 0),
        Text = windowName,
        Font = Theme.FontBold,
        TextSize = 15,
        TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Parent = titleBar,
    })
    
    -- Close / Minimize buttons
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -37, 0.5, -15),
        Text = "✕",
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.TextMuted,
        BackgroundTransparency = 1,
        Parent = titleBar,
    })
    closeBtn.MouseEnter:Connect(function() Tw(closeBtn, Tween.Fast, {TextColor3 = Theme.Error}) end)
    closeBtn.MouseLeave:Connect(function() Tw(closeBtn, Tween.Fast, {TextColor3 = Theme.TextMuted}) end)
    closeBtn.MouseButton1Click:Connect(function()
        Tw(mainFrame, Tween.SlideOut, {Size = UDim2.new(0, 580, 0, 0), BackgroundTransparency = 1})
        task.delay(0.25, function() screenGui:Destroy() end)
    end)
    
    local minBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -67, 0.5, -15),
        Text = "─",
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.TextMuted,
        BackgroundTransparency = 1,
        Parent = titleBar,
    })
    
    local isMinimized = false
    local function ToggleMinimize()
        isMinimized = not isMinimized
        if isMinimized then
            Tw(mainFrame, Tween.Smooth, {Size = UDim2.new(0, 580, 0, 40)})
        else
            Tw(mainFrame, Tween.Bounce, {Size = UDim2.new(0, 580, 0, 420)})
        end
    end
    
    minBtn.MouseEnter:Connect(function() Tw(minBtn, Tween.Fast, {TextColor3 = Theme.Warning}) end)
    minBtn.MouseLeave:Connect(function() Tw(minBtn, Tween.Fast, {TextColor3 = Theme.TextMuted}) end)
    minBtn.MouseButton1Click:Connect(ToggleMinimize)
    
    -- Dragging
    local dragging, dragStartPos, startFramePos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStartPos = input.Position
            startFramePos = mainFrame.Position
        end
    end)
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPos
            mainFrame.Position = UDim2.new(
                startFramePos.X.Scale, startFramePos.X.Offset + delta.X,
                startFramePos.Y.Scale, startFramePos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Toggle key
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)
    
    -- ═══ SIDEBAR ═══
    local sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 140, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundColor3 = Theme.BgDark,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = mainFrame,
    })
    
    local tabListLayout = Create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        Parent = sidebar,
    })
    AddPadding(sidebar, 6, 6, 6, 6)
    
    -- ═══ CONTENT AREA ═══
    local contentArea = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -142, 1, -42),
        Position = UDim2.new(0, 142, 0, 42),
        BackgroundColor3 = Theme.BgMid,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = mainFrame,
    })
    
    -- Open animation
    mainFrame.BackgroundTransparency = 1
    mainFrame.Size = UDim2.new(0, 540, 0, 380)
    task.defer(function()
        Tw(mainFrame, Tween.Bounce, {
            Size = UDim2.new(0, 580, 0, 420),
            BackgroundTransparency = 0,
        })
    end)
    
    -- Tab management
    local tabs = {}
    local activeTab = nil
    
    local Window = {}
    
    function Window:CreateTab(name, icon)
        local tabData = {Name = name, Elements = {}}
        
        -- Icons mapping
        local icons = {
            eye = "👁", sword = "⚔", target = "🎯", run = "🏃",
            settings = "⚙", shield = "🛡", star = "⭐", zap = "⚡",
        }
        local iconText = icons[icon] or "●"
        
        -- Tab button in sidebar
        local tabBtn = Create("TextButton", {
            Name = "Tab_" .. name,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.BgLight,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = sidebar,
        })
        AddCorner(tabBtn, Theme.CornerSmall)
        
        Create("TextLabel", {
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            Text = iconText,
            TextSize = 14,
            Font = Theme.Font,
            TextColor3 = Theme.TextMuted,
            BackgroundTransparency = 1,
            Name = "Icon",
            Parent = tabBtn,
        })
        
        Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 34, 0, 0),
            Text = name,
            Font = Theme.Font,
            TextSize = 13,
            TextColor3 = Theme.TextSecondary,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Name = "Label",
            Parent = tabBtn,
        })
        
        -- Active indicator
        local indicator = Create("Frame", {
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Name = "Indicator",
            Parent = tabBtn,
        })
        AddCorner(indicator, UDim.new(0, 2))
        
        -- Tab content page (scrollable)
        local tabPage = Create("ScrollingFrame", {
            Name = "Page_" .. name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Primary,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            BorderSizePixel = 0,
            Parent = contentArea,
        })
        AddPadding(tabPage, 10, 10, 14, 14)
        Create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 6),
            Parent = tabPage,
        })
        
        tabData.Button = tabBtn
        tabData.Page = tabPage
        tabData.Indicator = indicator
        table.insert(tabs, tabData)
        
        -- Hover effects
        tabBtn.MouseEnter:Connect(function()
            if activeTab ~= tabData then
                Tw(tabBtn, Tween.Fast, {BackgroundTransparency = 0.5})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if activeTab ~= tabData then
                Tw(tabBtn, Tween.Fast, {BackgroundTransparency = 1})
            end
        end)
        
        -- Tab switch
        local function ActivateTab()
            if activeTab == tabData then return end
            
            -- Deactivate old
            if activeTab then
                activeTab.Page.Visible = false
                Tw(activeTab.Button, Tween.Normal, {BackgroundTransparency = 1})
                Tw(activeTab.Indicator, Tween.Normal, {Size = UDim2.new(0, 3, 0, 0)})
                Tw(activeTab.Button:FindFirstChild("Label"), Tween.Normal, {TextColor3 = Theme.TextSecondary})
                Tw(activeTab.Button:FindFirstChild("Icon"), Tween.Normal, {TextColor3 = Theme.TextMuted})
            end
            
            -- Activate new
            activeTab = tabData
            tabPage.Visible = true
            tabPage.CanvasPosition = Vector2.new(0, 0)
            Tw(tabBtn, Tween.Normal, {BackgroundTransparency = 0.6})
            Tw(indicator, Tween.Bounce, {Size = UDim2.new(0, 3, 0, 20)})
            Tw(tabBtn:FindFirstChild("Label"), Tween.Normal, {TextColor3 = Theme.TextPrimary})
            Tw(tabBtn:FindFirstChild("Icon"), Tween.Normal, {TextColor3 = Theme.Primary})
        end
        
        tabBtn.MouseButton1Click:Connect(ActivateTab)
        
        -- Auto-activate first tab
        if #tabs == 1 then
            task.defer(ActivateTab)
        end
        
        -- ═══ ELEMENT BUILDERS ═══
        local Tab = {}
        local layoutOrder = 0
        local function nextOrder() layoutOrder = layoutOrder + 1 return layoutOrder end
        
        function Tab:CreateSection(title)
            local section = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = string.upper(title),
                Font = Theme.FontBold,
                TextSize = 11,
                TextColor3 = Theme.TextMuted,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = section,
            })
            local line = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.Border,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = section,
            })
        end
        
        function Tab:CreateDivider()
            Create("Frame", {
                Size = UDim2.new(1, 0, 0, 8),
                BackgroundTransparency = 1,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
        end
        
        function Tab:CreateLabel(text)
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                Text = text,
                Font = Theme.Font,
                TextSize = 12,
                TextColor3 = Theme.TextSecondary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
        end
        
        function Tab:CreateToggle(config)
            local toggled = config.CurrentValue or false
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.BgLight,
                BackgroundTransparency = 0.4,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            AddCorner(container, Theme.CornerSmall)
            
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                Text = config.Name or "Toggle",
                Font = Theme.Font,
                TextSize = 13,
                TextColor3 = Theme.TextPrimary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = container,
            })
            
            -- Toggle track
            local track = Create("Frame", {
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -52, 0.5, -10),
                BackgroundColor3 = toggled and Theme.Primary or Theme.BgHover,
                Parent = container,
            })
            AddCorner(track, Theme.CornerPill)
            AddStroke(track, Theme.Border, 1, 0.6)
            
            -- Toggle knob
            local knob = Create("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = track,
            })
            AddCorner(knob, UDim.new(1, 0))
            
            local function UpdateVisual()
                if toggled then
                    Tw(track, Tween.Normal, {BackgroundColor3 = Theme.Primary})
                    Tw(knob, Tween.Bounce, {Position = UDim2.new(1, -18, 0.5, -8)})
                else
                    Tw(track, Tween.Normal, {BackgroundColor3 = Theme.BgHover})
                    Tw(knob, Tween.Bounce, {Position = UDim2.new(0, 2, 0.5, -8)})
                end
            end
            
            -- Hover
            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    Tw(container, Tween.Fast, {BackgroundTransparency = 0.2})
                end
            end)
            container.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    Tw(container, Tween.Fast, {BackgroundTransparency = 0.4})
                end
            end)
            
            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = container,
            })
            btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateVisual()
                callback(toggled)
            end)
        end
        
        function Tab:CreateSlider(config)
            local min = config.Range[1] or 0
            local max = config.Range[2] or 100
            local increment = config.Increment or 1
            local value = config.CurrentValue or min
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.BgLight,
                BackgroundTransparency = 0.4,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            AddCorner(container, Theme.CornerSmall)
            
            Create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 12, 0, 4),
                Text = config.Name or "Slider",
                Font = Theme.Font,
                TextSize = 13,
                TextColor3 = Theme.TextPrimary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = container,
            })
            
            local valLabel = Create("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 4),
                Text = tostring(value),
                Font = Theme.FontBold,
                TextSize = 13,
                TextColor3 = Theme.Primary,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Parent = container,
            })
            
            -- Slider track
            local sliderTrack = Create("Frame", {
                Size = UDim2.new(1, -24, 0, 6),
                Position = UDim2.new(0, 12, 0, 34),
                BackgroundColor3 = Theme.BgHover,
                Parent = container,
            })
            AddCorner(sliderTrack, Theme.CornerPill)
            
            local pct = math.clamp((value - min) / (max - min), 0, 1)
            local fill = Create("Frame", {
                Size = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = Theme.Primary,
                BorderSizePixel = 0,
                Parent = sliderTrack,
            })
            AddCorner(fill, Theme.CornerPill)
            AddGradient(fill, Theme.Primary, Theme.Accent, 0)
            
            -- Slider thumb
            local thumb = Create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(pct, -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = 2,
                Parent = sliderTrack,
            })
            AddCorner(thumb, UDim.new(1, 0))
            AddStroke(thumb, Theme.Primary, 2, 0)
            
            local sliding = false
            
            local function Update(inputX)
                local trackAbsPos = sliderTrack.AbsolutePosition.X
                local trackAbsSize = sliderTrack.AbsoluteSize.X
                local rel = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
                local raw = min + (max - min) * rel
                value = math.floor(raw / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                pct = (value - min) / (max - min)
                
                Tw(fill, Tween.Fast, {Size = UDim2.new(pct, 0, 1, 0)})
                Tw(thumb, Tween.Fast, {Position = UDim2.new(pct, -7, 0.5, -7)})
                valLabel.Text = tostring(value)
                callback(value)
            end
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    Update(input.Position.X)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input.Position.X)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
            
            -- Hover
            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    Tw(container, Tween.Fast, {BackgroundTransparency = 0.2})
                end
            end)
            container.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    Tw(container, Tween.Fast, {BackgroundTransparency = 0.4})
                end
            end)
        end
        
        function Tab:CreateButton(config)
            local callback = config.Callback or function() end
            
            local btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = Theme.BgLight,
                BackgroundTransparency = 0.3,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = nextOrder(),
                ClipsDescendants = true,
                Parent = tabPage,
            })
            AddCorner(btn, Theme.CornerSmall)
            AddStroke(btn, Theme.Border, 1, 0.7)
            
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = config.Name or "Button",
                Font = Theme.Font,
                TextSize = 13,
                TextColor3 = Theme.TextPrimary,
                BackgroundTransparency = 1,
                Parent = btn,
            })
            
            btn.MouseEnter:Connect(function()
                Tw(btn, Tween.Fast, {BackgroundColor3 = Theme.Primary, BackgroundTransparency = 0.3})
            end)
            btn.MouseLeave:Connect(function()
                Tw(btn, Tween.Fast, {BackgroundColor3 = Theme.BgLight, BackgroundTransparency = 0.3})
            end)
            btn.MouseButton1Click:Connect(function()
                RippleEffect(btn)
                callback()
            end)
        end
        
        function Tab:CreateDropdown(config)
            local options = config.Options or {}
            local multi = config.MultipleOptions or false
            local callback = config.Callback or function() end
            local selected = config.CurrentOption
            
            local container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.BgLight,
                BackgroundTransparency = 0.4,
                ClipsDescendants = true,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            AddCorner(container, Theme.CornerSmall)
            
            Create("TextLabel", {
                Size = UDim2.new(1, -30, 0, 36),
                Position = UDim2.new(0, 12, 0, 0),
                Text = config.Name or "Dropdown",
                Font = Theme.Font,
                TextSize = 13,
                TextColor3 = Theme.TextPrimary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = container,
            })
            
            local arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 0, 36),
                Position = UDim2.new(1, -28, 0, 0),
                Text = "▼",
                Font = Theme.Font,
                TextSize = 10,
                TextColor3 = Theme.TextMuted,
                BackgroundTransparency = 1,
                Parent = container,
            })
            
            local optionsFrame = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 0),
                Position = UDim2.new(0, 4, 0, 38),
                BackgroundTransparency = 1,
                Parent = container,
            })
            Create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = optionsFrame,
            })
            
            local isOpen = false
            local optionButtons = {}
            
            local function BuildOptions()
                for _, child in pairs(optionsFrame:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                optionButtons = {}
                
                for i, opt in ipairs(options) do
                    local optBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundColor3 = Theme.BgMid,
                        BackgroundTransparency = 0.3,
                        Text = tostring(opt),
                        Font = Theme.Font,
                        TextSize = 12,
                        TextColor3 = Theme.TextSecondary,
                        AutoButtonColor = false,
                        LayoutOrder = i,
                        Parent = optionsFrame,
                    })
                    AddCorner(optBtn, UDim.new(0, 4))
                    
                    optBtn.MouseEnter:Connect(function()
                        Tw(optBtn, Tween.Fast, {BackgroundColor3 = Theme.Primary, TextColor3 = Theme.TextPrimary})
                    end)
                    optBtn.MouseLeave:Connect(function()
                        Tw(optBtn, Tween.Fast, {BackgroundColor3 = Theme.BgMid, TextColor3 = Theme.TextSecondary})
                    end)
                    optBtn.MouseButton1Click:Connect(function()
                        callback(opt)
                    end)
                    table.insert(optionButtons, optBtn)
                end
            end
            
            BuildOptions()
            
            local function ToggleDropdown()
                isOpen = not isOpen
                if isOpen then
                    local h = #options * 30 + 4
                    Tw(container, Tween.Smooth, {Size = UDim2.new(1, 0, 0, 36 + h)})
                    Tw(arrow, Tween.Normal, {Rotation = 180})
                else
                    Tw(container, Tween.Smooth, {Size = UDim2.new(1, 0, 0, 36)})
                    Tw(arrow, Tween.Normal, {Rotation = 0})
                end
            end
            
            local headerBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                Parent = container,
            })
            headerBtn.MouseButton1Click:Connect(ToggleDropdown)
            
            -- SetOptions method
            local dropdownObj = {}
            function dropdownObj:SetOptions(newOpts)
                options = newOpts
                BuildOptions()
                if isOpen then
                    local h = #options * 30 + 4
                    container.Size = UDim2.new(1, 0, 0, 36 + h)
                end
            end
            
            return dropdownObj
        end
        
        function Tab:CreateColorPicker(config)
            local currentColor = config.CurrentColor or Color3.fromRGB(255, 255, 255)
            local callback = config.Callback or function() end
            
            local container = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.BgLight,
                BackgroundTransparency = 0.4,
                ClipsDescendants = true,
                LayoutOrder = nextOrder(),
                Parent = tabPage,
            })
            AddCorner(container, Theme.CornerSmall)
            
            Create("TextLabel", {
                Size = UDim2.new(1, -50, 0, 36),
                Position = UDim2.new(0, 12, 0, 0),
                Text = config.Name or "Color",
                Font = Theme.Font,
                TextSize = 13,
                TextColor3 = Theme.TextPrimary,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Parent = container,
            })
            
            local preview = Create("Frame", {
                Size = UDim2.new(0, 24, 0, 24),
                Position = UDim2.new(1, -36, 0.5, -12),
                BackgroundColor3 = currentColor,
                Parent = container,
            })
            AddCorner(preview, UDim.new(0, 5))
            AddStroke(preview, Theme.Border, 1, 0.3)
            
            -- Color grid
            local colorGrid = Create("Frame", {
                Size = UDim2.new(1, -8, 0, 0),
                Position = UDim2.new(0, 4, 0, 38),
                BackgroundTransparency = 1,
                Parent = container,
            })
            local gridLayout = Create("UIGridLayout", {
                CellSize = UDim2.new(0, 28, 0, 28),
                CellPadding = UDim2.new(0, 4, 0, 4),
                Parent = colorGrid,
            })
            
            local presetColors = {
                Color3.fromRGB(255, 50, 50),   Color3.fromRGB(255, 100, 50),
                Color3.fromRGB(255, 200, 50),  Color3.fromRGB(100, 255, 100),
                Color3.fromRGB(50, 200, 50),   Color3.fromRGB(50, 200, 255),
                Color3.fromRGB(50, 100, 255),  Color3.fromRGB(130, 90, 255),
                Color3.fromRGB(200, 50, 255),  Color3.fromRGB(255, 50, 200),
                Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 150),
                Color3.fromRGB(80, 80, 80),    Color3.fromRGB(0, 255, 100),
            }
            
            for _, col in ipairs(presetColors) do
                local colorBtn = Create("TextButton", {
                    BackgroundColor3 = col,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = colorGrid,
                })
                AddCorner(colorBtn, UDim.new(0, 5))
                colorBtn.MouseButton1Click:Connect(function()
                    currentColor = col
                    Tw(preview, Tween.Normal, {BackgroundColor3 = col})
                    callback(col)
                end)
                colorBtn.MouseEnter:Connect(function()
                    Tw(colorBtn, Tween.Fast, {Size = UDim2.new(0, 26, 0, 26)})
                end)
                colorBtn.MouseLeave:Connect(function()
                    Tw(colorBtn, Tween.Fast, {Size = UDim2.new(0, 28, 0, 28)})
                end)
            end
            
            local isOpen = false
            local function ToggleColor()
                isOpen = not isOpen
                if isOpen then
                    Tw(container, Tween.Smooth, {Size = UDim2.new(1, 0, 0, 110)})
                else
                    Tw(container, Tween.Smooth, {Size = UDim2.new(1, 0, 0, 36)})
                end
            end
            
            local headerBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Text = "",
                Parent = container,
            })
            headerBtn.MouseButton1Click:Connect(ToggleColor)
        end
        
        return Tab
    end
    
    -- Loading notification
    if config.LoadingTitle then
        task.delay(0.5, function()
            NexusUI:Notify({
                Title = config.LoadingTitle,
                Content = config.LoadingSubtitle or "",
                Duration = 3,
                Image = "success",
            })
        end)
    end
    
    return Window
end

return NexusUI
