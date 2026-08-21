--[[
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                        NAMELESS WARE UI LIBRARY                       ║
    ║             Dutty / Passion Inspired Layout • Electric Purple         ║
    ║             100% Mobile Friendly • Touch Drag • Widgets Engine        ║
    ╚═══════════════════════════════════════════════════════════════════════╝
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Safe UI Parent (Executors: gethui, syn.protect_gui, or CoreGui/PlayerGui)
local function GetSafeParent()
    local success, result = pcall(function()
        if gethui then return gethui() end
        if syn and syn.protect_gui then
            local sg = Instance.new("ScreenGui")
            syn.protect_gui(sg)
            sg.Parent = CoreGui
            return sg
        end
        return CoreGui
    end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
end

-- Helper: Custom Asset Downloader
local function FetchCustomAsset(url, fileName)
    fileName = fileName or "NamelessWare_Logo.webp"
    if getcustomasset and (writefile and readfile and isfile) then
        local success, err = pcall(function()
            if not isfile(fileName) then
                local res
                if syn and syn.request then
                    res = syn.request({Url = url, Method = "GET"}).Body
                elseif http_request then
                    res = http_request({Url = url, Method = "GET"}).Body
                elseif request then
                    res = request({Url = url, Method = "GET"}).Body
                elseif game.HttpGet then
                    res = game:HttpGet(url)
                end
                if res then
                    writefile(fileName, res)
                end
            end
        end)
        if isfile(fileName) then
            local asset = getcustomasset(fileName)
            if asset then return asset end
        end
    end
    return nil
end

-- Helper: Tweening
local function Tween(obj, props, time, style, dir)
    time = time or 0.22
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(time, style, dir), props)
    tw:Play()
    return tw
end

-- Helper: Draggable (Touch & Mouse Support)
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

--------------------------------------------------------------------------------
-- 👑 NAMELESS WARE LIBRARY CORE
--------------------------------------------------------------------------------
local NamelessWare = {}
NamelessWare.__index = NamelessWare

-- Default Theme Colors (Nameless Ware Electric Purple Neon)
local THEME = {
    Accent = Color3.fromRGB(168, 85, 247),       -- Electric Neon Purple
    AccentLight = Color3.fromRGB(192, 132, 252),
    AccentDark = Color3.fromRGB(126, 34, 206),
    Background = Color3.fromRGB(16, 16, 22),     -- Obsidian
    DockBg = Color3.fromRGB(11, 11, 16),         -- Deep Dark Dock
    CardBg = Color3.fromRGB(22, 22, 29),         -- Surface
    CardBorder = Color3.fromRGB(36, 36, 48),     -- Sleek Outline
    TextMain = Color3.fromRGB(245, 245, 250),
    TextMuted = Color3.fromRGB(135, 135, 155),
    ToggleOff = Color3.fromRGB(30, 30, 40),
    GreenSuccess = Color3.fromRGB(34, 197, 94),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
}

local RAW_LOGO_URL = "https://raw.githubusercontent.com/ApparentlyZen/image-namelessWare/main/165abdd521328d77324b02ce8a77e090_1780162334922.webp"

function NamelessWare:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NAMELESS WARE"
    local SubTitle = config.SubTitle or "v2.0 • dutty layout"
    local AccentColor = config.Accent or THEME.Accent
    local LogoUrl = config.LogoUrl or RAW_LOGO_URL

    -- Clean any existing instance
    if _G.NamelessWareInstance then
        pcall(function() _G.NamelessWareInstance:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessWare_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetSafeParent()
    _G.NamelessWareInstance = ScreenGui

    -- Try resolving custom asset
    local customLogoAsset = FetchCustomAsset(LogoUrl, "NamelessWare_Logo.webp")

    ----------------------------------------------------------------------------
    -- 📱 MOBILE FLOATING TOGGLE BUTTON (Custom Logo Image)
    ----------------------------------------------------------------------------
    local MobileBtn = Instance.new("ImageButton")
    MobileBtn.Name = "NamelessMobileBtn"
    MobileBtn.Size = UDim2.new(0, 52, 0, 52)
    MobileBtn.Position = UDim2.new(0, 15, 0.5, -26)
    MobileBtn.BackgroundColor3 = THEME.DockBg
    MobileBtn.AutoButtonColor = false
    MobileBtn.Parent = ScreenGui

    local MobileBtnCorner = Instance.new("UICorner")
    MobileBtnCorner.CornerRadius = UDim.new(1, 0)
    MobileBtnCorner.Parent = MobileBtn

    local MobileBtnStroke = Instance.new("UIStroke")
    MobileBtnStroke.Color = AccentColor
    MobileBtnStroke.Thickness = 2
    MobileBtnStroke.Parent = MobileBtn

    if customLogoAsset then
        MobileBtn.Image = customLogoAsset
    else
        -- Fallback badge
        local FallbackText = Instance.new("TextLabel")
        FallbackText.Size = UDim2.new(1, 0, 1, 0)
        FallbackText.BackgroundTransparency = 1
        FallbackText.Text = "NW"
        FallbackText.Font = THEME.FontBold
        FallbackText.TextSize = 16
        FallbackText.TextColor3 = AccentColor
        FallbackText.Parent = MobileBtn
    end

    MakeDraggable(MobileBtn)

    ----------------------------------------------------------------------------
    -- 🖥️ MAIN WINDOW (Dutty / Passion Layout)
    ----------------------------------------------------------------------------
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 540, 0, 390)
    MainWindow.Position = UDim2.new(0.5, -270, 0.5, -195)
    MainWindow.BackgroundColor3 = THEME.Background
    MainWindow.BorderSizePixel = 0
    MainWindow.ClipsDescendants = false
    MainWindow.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainWindow

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.CardBorder
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainWindow

    -- Left Icon Dock
    local Dock = Instance.new("Frame")
    Dock.Name = "Dock"
    Dock.Size = UDim2.new(0, 54, 1, 0)
    Dock.BackgroundColor3 = THEME.DockBg
    Dock.BorderSizePixel = 0
    Dock.Parent = MainWindow

    local DockCorner = Instance.new("UICorner")
    DockCorner.CornerRadius = UDim.new(0, 12)
    DockCorner.Parent = Dock

    local DockStroke = Instance.new("UIStroke")
    DockStroke.Color = THEME.CardBorder
    DockStroke.Thickness = 1
    DockStroke.Parent = Dock

    -- Top Brand Logo in Dock
    local LogoBtn = Instance.new("ImageButton")
    LogoBtn.Size = UDim2.new(0, 38, 0, 38)
    LogoBtn.Position = UDim2.new(0.5, -19, 0, 8)
    LogoBtn.BackgroundColor3 = THEME.CardBg
    LogoBtn.AutoButtonColor = false
    LogoBtn.Parent = Dock

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 10)
    LogoCorner.Parent = LogoBtn

    local LogoGlow = Instance.new("UIStroke")
    LogoGlow.Color = AccentColor
    LogoGlow.Thickness = 1.5
    LogoGlow.Parent = LogoBtn

    if customLogoAsset then
        LogoBtn.Image = customLogoAsset
    else
        local LogoText = Instance.new("TextLabel")
        LogoText.Size = UDim2.new(1, 0, 1, 0)
        LogoText.BackgroundTransparency = 1
        LogoText.Text = "NW"
        LogoText.Font = THEME.FontBold
        LogoText.TextSize = 14
        LogoText.TextColor3 = AccentColor
        LogoText.Parent = LogoBtn
    end

    MakeDraggable(MainWindow, Dock)

    -- Dock Icons Scroll / List
    local DockScroll = Instance.new("ScrollingFrame")
    DockScroll.Size = UDim2.new(1, 0, 1, -55)
    DockScroll.Position = UDim2.new(0, 0, 0, 52)
    DockScroll.BackgroundTransparency = 1
    DockScroll.ScrollBarThickness = 0
    DockScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    DockScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    DockScroll.Parent = Dock

    local DockLayout = Instance.new("UIListLayout")
    DockLayout.Padding = UDim.new(0, 8)
    DockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DockLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DockLayout.Parent = DockScroll

    -- Top Sub-Navigation Bar
    local TopNavBar = Instance.new("Frame")
    TopNavBar.Name = "TopNavBar"
    TopNavBar.Size = UDim2.new(1, -70, 0, 42)
    TopNavBar.Position = UDim2.new(0, 62, 0, 6)
    TopNavBar.BackgroundTransparency = 1
    TopNavBar.Parent = MainWindow

    local SubTabsHolder = Instance.new("Frame")
    SubTabsHolder.Size = UDim2.new(1, -40, 1, 0)
    SubTabsHolder.BackgroundTransparency = 1
    SubTabsHolder.Parent = TopNavBar

    local SubTabsLayout = Instance.new("UIListLayout")
    SubTabsLayout.FillDirection = Enum.FillDirection.Horizontal
    SubTabsLayout.Padding = UDim.new(0, 18)
    SubTabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SubTabsLayout.Parent = SubTabsHolder

    -- Search / Info Icon on Top Right
    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 16, 0, 16)
    SearchIcon.Position = UDim2.new(1, -24, 0.5, -8)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://10734975692"
    SearchIcon.ImageColor3 = THEME.TextMuted
    SearchIcon.Parent = TopNavBar

    -- Neon Purple Active Tab Underline
    local TabUnderlineTrack = Instance.new("Frame")
    TabUnderlineTrack.Size = UDim2.new(1, -70, 0, 2)
    TabUnderlineTrack.Position = UDim2.new(0, 62, 0, 48)
    TabUnderlineTrack.BackgroundColor3 = THEME.CardBorder
    TabUnderlineTrack.BorderSizePixel = 0
    TabUnderlineTrack.Parent = MainWindow

    local ActiveUnderlineGlow = Instance.new("Frame")
    ActiveUnderlineGlow.Size = UDim2.new(0, 60, 1, 0)
    ActiveUnderlineGlow.Position = UDim2.new(0, 0, 0, 0)
    ActiveUnderlineGlow.BackgroundColor3 = AccentColor
    ActiveUnderlineGlow.BorderSizePixel = 0
    ActiveUnderlineGlow.Parent = TabUnderlineTrack

    MakeDraggable(MainWindow, TopNavBar)

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -70, 1, -58)
    ContentArea.Position = UDim2.new(0, 62, 0, 54)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow

    -- Mobile Toggle Action
    local isUIOpen = true
    local function ToggleUI()
        isUIOpen = not isUIOpen
        if isUIOpen then
            MainWindow.Visible = true
            Tween(MainWindow, {Position = UDim2.new(0.5, -270, 0.5, -195)}, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(MainWindow, {Position = UDim2.new(0.5, -270, 0.5, -160)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            wait(0.2)
            if not isUIOpen then
                MainWindow.Visible = false
            end
        end
    end

    MobileBtn.MouseButton1Click:Connect(ToggleUI)

    -- Window Object
    local Window = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        MobileBtn = MobileBtn,
        Dock = Dock,
        TopNavBar = TopNavBar,
        ContentArea = ContentArea,
        Tabs = {},
        Widgets = {}
    }

    local FirstTab = true

    ----------------------------------------------------------------------------
    -- 📁 CREATE DOCK TAB (Left Icon Dock)
    ----------------------------------------------------------------------------
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "rbxassetid://10734975692"

        local DockBtn = Instance.new("TextButton")
        DockBtn.Size = UDim2.new(0, 38, 0, 38)
        DockBtn.BackgroundColor3 = THEME.CardBg
        DockBtn.BackgroundTransparency = 1
        DockBtn.Text = ""
        DockBtn.AutoButtonColor = false
        DockBtn.Parent = DockScroll

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 10)
        BtnCorner.Parent = DockBtn

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0.5, -10, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = tabIcon
        Icon.ImageColor3 = THEME.TextMuted
        Icon.Parent = DockBtn

        local TabPage = Instance.new("Frame")
        TabPage.Name = tabName .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.Parent = ContentArea

        local SubTabs = {}
        local FirstSubTab = true

        local function ActivateTab()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Icon, {ImageColor3 = THEME.TextMuted}, 0.2)
            end
            TabPage.Visible = true
            Tween(DockBtn, {BackgroundTransparency = 0, BackgroundColor3 = THEME.CardBg}, 0.2)
            Tween(Icon, {ImageColor3 = AccentColor}, 0.2)

            -- Activate first subtab of this tab if available
            if SubTabs[1] then
                SubTabs[1].Activate()
            end
        end

        DockBtn.MouseButton1Click:Connect(ActivateTab)

        local TabObject = {
            Button = DockBtn,
            Icon = Icon,
            Page = TabPage,
            SubTabs = SubTabs
        }
        table.insert(Window.Tabs, TabObject)

        local TabMethods = {}

        ------------------------------------------------------------------------
        -- 📑 CREATE SUB-TAB (Top Navigation Bar)
        ------------------------------------------------------------------------
        function TabMethods:CreateSubTab(subName)
            local SubBtn = Instance.new("TextButton")
            SubBtn.Size = UDim2.new(0, 65, 1, 0)
            SubBtn.BackgroundTransparency = 1
            SubBtn.Text = subName
            SubBtn.Font = THEME.FontBold
            SubBtn.TextSize = 12
            SubBtn.TextColor3 = THEME.TextMuted
            SubBtn.AutoButtonColor = false
            SubBtn.Parent = SubTabsHolder

            local SubContent = Instance.new("ScrollingFrame")
            SubContent.Size = UDim2.new(1, 0, 1, 0)
            SubContent.BackgroundTransparency = 1
            SubContent.ScrollBarThickness = 3
            SubContent.ScrollBarImageColor3 = AccentColor
            SubContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            SubContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubContent.Visible = false
            SubContent.Parent = TabPage

            local SubLayout = Instance.new("UIListLayout")
            SubLayout.Padding = UDim.new(0, 8)
            SubLayout.FillDirection = Enum.FillDirection.Horizontal
            SubLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SubLayout.Parent = SubContent

            local function ActivateSub()
                for _, s in pairs(SubTabs) do
                    s.Content.Visible = false
                    Tween(s.Button, {TextColor3 = THEME.TextMuted}, 0.2)
                end
                SubContent.Visible = true
                Tween(SubBtn, {TextColor3 = AccentColor}, 0.2)
                Tween(ActiveUnderlineGlow, {
                    Position = UDim2.new(0, SubBtn.Position.X.Offset, 0, 0),
                    Size = UDim2.new(0, SubBtn.AbsoluteSize.X, 1, 0)
                }, 0.2)
            end

            SubBtn.MouseButton1Click:Connect(ActivateSub)

            local SubTabObject = {
                Button = SubBtn,
                Content = SubContent,
                Activate = ActivateSub
            }
            table.insert(SubTabs, SubTabObject)

            if FirstSubTab then
                FirstSubTab = false
                ActivateSub()
            end

            local SubMethods = {}

            --------------------------------------------------------------------
            -- 🗃️ CREATE CARD / COLUMN (Within Sub-Tab)
            --------------------------------------------------------------------
            function SubMethods:CreateCard(cardTitle)
                local Card = Instance.new("Frame")
                Card.Size = UDim2.new(0.5, -4, 0, 0)
                Card.AutomaticSize = Enum.AutomaticSize.Y
                Card.BackgroundColor3 = THEME.CardBg
                Card.BorderSizePixel = 0
                Card.Parent = SubContent

                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 10)
                CardCorner.Parent = Card

                local CardStroke = Instance.new("UIStroke")
                CardStroke.Color = THEME.CardBorder
                CardStroke.Thickness = 1
                CardStroke.Parent = Card

                local CardPadding = Instance.new("UIPadding")
                CardPadding.PaddingTop = UDim.new(0, 8)
                CardPadding.PaddingBottom = UDim.new(0, 8)
                CardPadding.PaddingLeft = UDim.new(0, 10)
                CardPadding.PaddingRight = UDim.new(0, 10)
                CardPadding.Parent = Card

                local CardLayout = Instance.new("UIListLayout")
                CardLayout.Padding = UDim.new(0, 6)
                CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
                CardLayout.Parent = Card

                if cardTitle then
                    local CardHeader = Instance.new("TextLabel")
                    CardHeader.Size = UDim2.new(1, 0, 0, 20)
                    CardHeader.BackgroundTransparency = 1
                    CardHeader.Text = cardTitle
                    CardHeader.Font = THEME.FontBold
                    CardHeader.TextSize = 11
                    CardHeader.TextColor3 = THEME.TextMain
                    CardHeader.TextXAlignment = Enum.TextXAlignment.Left
                    CardHeader.Parent = Card
                end

                local CardControls = {}

                -- 1. TOGGLE (Neon Capsule Switch)
                function CardControls:AddToggle(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Toggle"
                    local state = cfg.Default or false
                    local callback = cfg.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 30)
                    Row.BackgroundTransparency = 1
                    Row.Parent = Card

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, -45, 1, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = name
                    Label.Font = THEME.FontMain
                    Label.TextSize = 11
                    Label.TextColor3 = state and THEME.TextMain or THEME.TextMuted
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.Parent = Row

                    local Switch = Instance.new("TextButton")
                    Switch.Size = UDim2.new(0, 36, 0, 20)
                    Switch.Position = UDim2.new(1, -36, 0.5, -10)
                    Switch.BackgroundColor3 = state and AccentColor or THEME.ToggleOff
                    Switch.Text = ""
                    Switch.AutoButtonColor = false
                    Switch.Parent = Row

                    local SwitchCorner = Instance.new("UICorner")
                    SwitchCorner.CornerRadius = UDim.new(1, 0)
                    SwitchCorner.Parent = Switch

                    local Dot = Instance.new("Frame")
                    Dot.Size = UDim2.new(0, 14, 0, 14)
                    Dot.Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Dot.Parent = Switch

                    local DotCorner = Instance.new("UICorner")
                    DotCorner.CornerRadius = UDim.new(1, 0)
                    DotCorner.Parent = Dot

                    local function SetState(newVal)
                        state = newVal
                        if state then
                            Tween(Switch, {BackgroundColor3 = AccentColor}, 0.2)
                            Tween(Dot, {Position = UDim2.new(1, -17, 0.5, -7)}, 0.2)
                            Tween(Label, {TextColor3 = THEME.TextMain}, 0.2)
                        else
                            Tween(Switch, {BackgroundColor3 = THEME.ToggleOff}, 0.2)
                            Tween(Dot, {Position = UDim2.new(0, 3, 0.5, -7)}, 0.2)
                            Tween(Label, {TextColor3 = THEME.TextMuted}, 0.2)
                        end
                        callback(state)
                    end

                    Switch.MouseButton1Click:Connect(function()
                        SetState(not state)
                    end)

                    return {Set = SetState}
                end

                -- 2. SLIDER (Touch & Mouse Drag Supported)
                function CardControls:AddSlider(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Slider"
                    local min = cfg.Min or 0
                    local max = cfg.Max or 100
                    local default = cfg.Default or min
                    local suffix = cfg.Suffix or "%"
                    local callback = cfg.Callback or function() end
                    local value = default

                    local Frame = Instance.new("Frame")
                    Frame.Size = UDim2.new(1, 0, 0, 42)
                    Frame.BackgroundTransparency = 1
                    Frame.Parent = Card

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(0.65, 0, 0, 16)
                    Label.BackgroundTransparency = 1
                    Label.Text = name
                    Label.Font = THEME.FontMain
                    Label.TextSize = 11
                    Label.TextColor3 = THEME.TextMuted
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.Parent = Frame

                    local ValLabel = Instance.new("TextLabel")
                    ValLabel.Size = UDim2.new(0.35, 0, 0, 16)
                    ValLabel.Position = UDim2.new(0.65, 0, 0, 0)
                    ValLabel.BackgroundTransparency = 1
                    ValLabel.Text = tostring(value) .. suffix
                    ValLabel.Font = THEME.FontBold
                    ValLabel.TextSize = 11
                    ValLabel.TextColor3 = AccentColor
                    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                    ValLabel.Parent = Frame

                    local Track = Instance.new("Frame")
                    Track.Size = UDim2.new(1, 0, 0, 6)
                    Track.Position = UDim2.new(0, 0, 0, 24)
                    Track.BackgroundColor3 = THEME.ToggleOff
                    Track.Parent = Frame

                    local TrackCorner = Instance.new("UICorner")
                    TrackCorner.CornerRadius = UDim.new(1, 0)
                    TrackCorner.Parent = Track

                    local Fill = Instance.new("Frame")
                    local initPct = math.clamp((value - min) / (max - min), 0, 1)
                    Fill.Size = UDim2.new(initPct, 0, 1, 0)
                    Fill.BackgroundColor3 = AccentColor
                    Fill.BorderSizePixel = 0
                    Fill.Parent = Track

                    local FillCorner = Instance.new("UICorner")
                    FillCorner.CornerRadius = UDim.new(1, 0)
                    FillCorner.Parent = Fill

                    local Thumb = Instance.new("Frame")
                    Thumb.Size = UDim2.new(0, 12, 0, 12)
                    Thumb.Position = UDim2.new(1, -6, 0.5, -6)
                    Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Thumb.Parent = Fill

                    local ThumbCorner = Instance.new("UICorner")
                    ThumbCorner.CornerRadius = UDim.new(1, 0)
                    ThumbCorner.Parent = Thumb

                    local dragging = false
                    local function Update(input)
                        local absPos = Track.AbsolutePosition.X
                        local absSize = Track.AbsoluteSize.X
                        local pct = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                        value = math.floor(min + (max - min) * pct)
                        Fill.Size = UDim2.new(pct, 0, 1, 0)
                        ValLabel.Text = tostring(value) .. suffix
                        callback(value)
                    end

                    Track.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            Update(input)
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            Update(input)
                        end
                    end)
                end

                -- 3. BUTTON
                function CardControls:AddButton(cfg)
                    cfg = cfg or {}
                    local text = cfg.Name or "Button"
                    local callback = cfg.Callback or function() end

                    local Btn = Instance.new("TextButton")
                    Btn.Size = UDim2.new(1, 0, 0, 28)
                    Btn.BackgroundColor3 = THEME.DockBg
                    Btn.Text = text
                    Btn.Font = THEME.FontMain
                    Btn.TextSize = 11
                    Btn.TextColor3 = THEME.TextMain
                    Btn.AutoButtonColor = false
                    Btn.Parent = Card

                    local BtnCorner = Instance.new("UICorner")
                    BtnCorner.CornerRadius = UDim.new(0, 6)
                    BtnCorner.Parent = Btn

                    local BtnStroke = Instance.new("UIStroke")
                    BtnStroke.Color = THEME.CardBorder
                    BtnStroke.Thickness = 1
                    BtnStroke.Parent = Btn

                    Btn.MouseButton1Click:Connect(function()
                        Tween(Btn, {BackgroundColor3 = AccentColor}, 0.1)
                        wait(0.1)
                        Tween(Btn, {BackgroundColor3 = THEME.DockBg}, 0.2)
                        callback()
                    end)
                end

                -- 4. DROPDOWN
                function CardControls:AddDropdown(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Dropdown"
                    local options = cfg.Options or {}
                    local default = cfg.Default or options[1] or "Select"
                    local callback = cfg.Callback or function() end
                    local selected = default
                    local open = false

                    local DropFrame = Instance.new("Frame")
                    DropFrame.Size = UDim2.new(1, 0, 0, 48)
                    DropFrame.BackgroundTransparency = 1
                    DropFrame.Parent = Card

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, 0, 0, 16)
                    Label.BackgroundTransparency = 1
                    Label.Text = name
                    Label.Font = THEME.FontMain
                    Label.TextSize = 11
                    Label.TextColor3 = THEME.TextMuted
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.Parent = DropFrame

                    local DropBtn = Instance.new("TextButton")
                    DropBtn.Size = UDim2.new(1, 0, 0, 26)
                    DropBtn.Position = UDim2.new(0, 0, 0, 18)
                    DropBtn.BackgroundColor3 = THEME.DockBg
                    DropBtn.Text = "  " .. selected
                    DropBtn.Font = THEME.FontMain
                    DropBtn.TextSize = 11
                    DropBtn.TextColor3 = THEME.TextMain
                    DropBtn.TextXAlignment = Enum.TextXAlignment.Left
                    DropBtn.AutoButtonColor = false
                    DropBtn.Parent = DropFrame

                    local DropCorner = Instance.new("UICorner")
                    DropCorner.CornerRadius = UDim.new(0, 6)
                    DropCorner.Parent = DropBtn

                    local Arrow = Instance.new("TextLabel")
                    Arrow.Size = UDim2.new(0, 20, 1, 0)
                    Arrow.Position = UDim2.new(1, -22, 0, 0)
                    Arrow.BackgroundTransparency = 1
                    Arrow.Text = "▼"
                    Arrow.Font = THEME.FontBold
                    Arrow.TextSize = 9
                    Arrow.TextColor3 = THEME.TextMuted
                    Arrow.Parent = DropBtn

                    local MenuList = Instance.new("Frame")
                    MenuList.Size = UDim2.new(1, 0, 0, #options * 24)
                    MenuList.Position = UDim2.new(0, 0, 1, 3)
                    MenuList.BackgroundColor3 = THEME.Background
                    MenuList.BorderSizePixel = 0
                    MenuList.Visible = false
                    MenuList.ZIndex = 25
                    MenuList.Parent = DropBtn

                    local MenuCorner = Instance.new("UICorner")
                    MenuCorner.CornerRadius = UDim.new(0, 6)
                    MenuCorner.Parent = MenuList

                    local MenuStroke = Instance.new("UIStroke")
                    MenuStroke.Color = THEME.CardBorder
                    MenuStroke.Thickness = 1
                    MenuStroke.Parent = MenuList

                    local MenuLayout = Instance.new("UIListLayout")
                    MenuLayout.Parent = MenuList

                    for _, opt in ipairs(options) do
                        local OptItem = Instance.new("TextButton")
                        OptItem.Size = UDim2.new(1, 0, 0, 24)
                        OptItem.BackgroundTransparency = 1
                        OptItem.Text = "  " .. opt
                        OptItem.Font = THEME.FontMain
                        OptItem.TextSize = 10
                        OptItem.TextColor3 = (opt == selected) and AccentColor or THEME.TextMuted
                        OptItem.TextXAlignment = Enum.TextXAlignment.Left
                        OptItem.ZIndex = 26
                        OptItem.Parent = MenuList

                        OptItem.MouseButton1Click:Connect(function()
                            selected = opt
                            DropBtn.Text = "  " .. selected
                            MenuList.Visible = false
                            Arrow.Text = "▼"
                            callback(selected)
                        end)
                    end

                    DropBtn.MouseButton1Click:Connect(function()
                        open = not open
                        MenuList.Visible = open
                        Arrow.Text = open and "▲" or "▼"
                    end)
                end

                -- 5. DIVIDER
                function CardControls:AddDivider(label)
                    local DivFrame = Instance.new("Frame")
                    DivFrame.Size = UDim2.new(1, 0, 0, 18)
                    DivFrame.BackgroundTransparency = 1
                    DivFrame.Parent = Card

                    local Line = Instance.new("Frame")
                    Line.Size = UDim2.new(1, 0, 0, 1)
                    Line.Position = UDim2.new(0, 0, 0.5, 0)
                    Line.BackgroundColor3 = THEME.CardBorder
                    Line.BorderSizePixel = 0
                    Line.Parent = DivFrame

                    if label then
                        local Text = Instance.new("TextLabel")
                        Text.Size = UDim2.new(0, 80, 1, 0)
                        Text.Position = UDim2.new(0.5, -40, 0, 0)
                        Text.BackgroundColor3 = THEME.CardBg
                        Text.Text = label
                        Text.Font = THEME.FontMain
                        Text.TextSize = 9
                        Text.TextColor3 = THEME.TextMuted
                        Text.Parent = DivFrame
                    end
                end

                -- 6. KEYBIND
                function CardControls:AddKeybind(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Keybind"
                    local key = cfg.Default or Enum.KeyCode.E
                    local callback = cfg.Callback or function() end
                    local listening = false

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 28)
                    Row.BackgroundTransparency = 1
                    Row.Parent = Card

                    local Label = Instance.new("TextLabel")
                    Label.Size = UDim2.new(1, -65, 1, 0)
                    Label.BackgroundTransparency = 1
                    Label.Text = name
                    Label.Font = THEME.FontMain
                    Label.TextSize = 11
                    Label.TextColor3 = THEME.TextMain
                    Label.TextXAlignment = Enum.TextXAlignment.Left
                    Label.Parent = Row

                    local KeyBtn = Instance.new("TextButton")
                    KeyBtn.Size = UDim2.new(0, 60, 0, 20)
                    KeyBtn.Position = UDim2.new(1, -60, 0.5, -10)
                    KeyBtn.BackgroundColor3 = THEME.DockBg
                    KeyBtn.Text = key.Name
                    KeyBtn.Font = THEME.FontBold
                    KeyBtn.TextSize = 10
                    KeyBtn.TextColor3 = AccentColor
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.Parent = Row

                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 4)
                    KeyCorner.Parent = KeyBtn

                    KeyBtn.MouseButton1Click:Connect(function()
                        listening = true
                        KeyBtn.Text = "..."
                        local conn
                        conn = UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                key = inp.KeyCode
                                KeyBtn.Text = key.Name
                                listening = false
                                conn:Disconnect()
                                callback(key)
                            end
                        end)
                    end)
                end

                return CardControls
            end

            return SubMethods
        end

        if FirstTab then
            FirstTab = false
            ActivateTab()
        end

        return TabMethods
    end

    ----------------------------------------------------------------------------
    -- 🎵 CREATE MEDIA PLAYER WIDGET (Spotify Style from Passion/Dutty)
    ----------------------------------------------------------------------------
    function Window:CreateMediaPlayer(cfg)
        cfg = cfg or {}
        local trackTitle = cfg.Title or "JOHNNY CAGE"
        local artist = cfg.Artist or "HXG"
        local coverImage = cfg.Cover or "rbxassetid://10723346959"

        local MediaFrame = Instance.new("Frame")
        MediaFrame.Name = "NamelessMediaPlayer"
        MediaFrame.Size = UDim2.new(0, 160, 0, 180)
        MediaFrame.Position = UDim2.new(0.5, 280, 0.5, 10)
        MediaFrame.BackgroundColor3 = THEME.Background
        MediaFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 12)
        Corner.Parent = MediaFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = THEME.CardBorder
        Stroke.Thickness = 1.2
        Stroke.Parent = MediaFrame

        local Album = Instance.new("ImageLabel")
        Album.Size = UDim2.new(0, 136, 0, 105)
        Album.Position = UDim2.new(0.5, -68, 0, 10)
        Album.BackgroundColor3 = THEME.CardBg
        Album.Image = coverImage
        Album.ScaleType = Enum.ScaleType.Crop
        Album.Parent = MediaFrame

        local AlbumCorner = Instance.new("UICorner")
        AlbumCorner.CornerRadius = UDim.new(0, 8)
        AlbumCorner.Parent = Album

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -35, 0, 16)
        TitleLbl.Position = UDim2.new(0, 12, 0, 122)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = trackTitle
        TitleLbl.Font = THEME.FontBold
        TitleLbl.TextSize = 11
        TitleLbl.TextColor3 = THEME.TextMain
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Parent = MediaFrame

        local ArtistLbl = Instance.new("TextLabel")
        ArtistLbl.Size = UDim2.new(1, -35, 0, 14)
        ArtistLbl.Position = UDim2.new(0, 12, 0, 138)
        ArtistLbl.BackgroundTransparency = 1
        ArtistLbl.Text = artist
        ArtistLbl.Font = THEME.FontMain
        ArtistLbl.TextSize = 10
        ArtistLbl.TextColor3 = THEME.TextMuted
        ArtistLbl.TextXAlignment = Enum.TextXAlignment.Left
        ArtistLbl.Parent = MediaFrame

        -- Mini Progress Bar
        local Progress = Instance.new("Frame")
        Progress.Size = UDim2.new(1, -24, 0, 3)
        Progress.Position = UDim2.new(0, 12, 1, -12)
        Progress.BackgroundColor3 = THEME.ToggleOff
        Progress.Parent = MediaFrame

        local ProgressFill = Instance.new("Frame")
        ProgressFill.Size = UDim2.new(0.45, 0, 1, 0)
        ProgressFill.BackgroundColor3 = AccentColor
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Parent = Progress

        local ActionBtn = Instance.new("TextButton")
        ActionBtn.Size = UDim2.new(0, 22, 0, 22)
        ActionBtn.Position = UDim2.new(1, -30, 0, 125)
        ActionBtn.BackgroundTransparency = 1
        ActionBtn.Text = "⊕"
        ActionBtn.Font = THEME.FontBold
        ActionBtn.TextSize = 16
        ActionBtn.TextColor3 = AccentColor
        ActionBtn.Parent = MediaFrame

        MakeDraggable(MediaFrame)
        table.insert(Window.Widgets, MediaFrame)
        return MediaFrame
    end

    ----------------------------------------------------------------------------
    -- 📋 CREATE DATA LIST WIDGET (epstien list from Passion)
    ----------------------------------------------------------------------------
    function Window:CreateDataList(cfg)
        cfg = cfg or {}
        local listTitle = cfg.Title or "nameless list"
        local items = cfg.Items or {}

        local ListFrame = Instance.new("Frame")
        ListFrame.Name = "NamelessDataList"
        ListFrame.Size = UDim2.new(0, 175, 0, 205)
        ListFrame.Position = UDim2.new(0.5, -455, 0.5, -10)
        ListFrame.BackgroundColor3 = THEME.Background
        ListFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = ListFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = THEME.CardBorder
        Stroke.Thickness = 1
        Stroke.Parent = ListFrame

        local Header = Instance.new("TextLabel")
        Header.Size = UDim2.new(1, -16, 0, 24)
        Header.Position = UDim2.new(0, 8, 0, 2)
        Header.BackgroundTransparency = 1
        Header.Text = listTitle
        Header.Font = THEME.FontMain
        Header.TextSize = 10
        Header.TextColor3 = THEME.TextMuted
        Header.TextXAlignment = Enum.TextXAlignment.Left
        Header.Parent = ListFrame

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -12, 1, -48)
        Scroll.Position = UDim2.new(0, 6, 0, 26)
        Scroll.BackgroundTransparency = 1
        Scroll.ScrollBarThickness = 0
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Scroll.Parent = ListFrame

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 3)
        Layout.Parent = Scroll

        for i, item in ipairs(items) do
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 18)
            Row.BackgroundTransparency = 1
            Row.Parent = Scroll

            local Num = Instance.new("TextLabel")
            Num.Size = UDim2.new(0, 15, 1, 0)
            Num.BackgroundTransparency = 1
            Num.Text = tostring(i)
            Num.Font = THEME.FontMain
            Num.TextSize = 9
            Num.TextColor3 = THEME.TextMuted
            Num.Parent = Row

            local Name = Instance.new("TextLabel")
            Name.Size = UDim2.new(0, 45, 1, 0)
            Name.Position = UDim2.new(0, 18, 0, 0)
            Name.BackgroundTransparency = 1
            Name.Text = item.Name or ("item " .. i)
            Name.Font = THEME.FontMain
            Name.TextSize = 9
            Name.TextColor3 = THEME.TextMuted
            Name.TextXAlignment = Enum.TextXAlignment.Left
            Name.Parent = Row

            local Val = Instance.new("TextLabel")
            Val.Size = UDim2.new(1, -65, 1, 0)
            Val.Position = UDim2.new(0, 65, 0, 0)
            Val.BackgroundTransparency = 1
            Val.Text = item.Value or "50k dolar 50k lira"
            Val.Font = THEME.FontMain
            Val.TextSize = 9
            Val.TextColor3 = THEME.GreenSuccess
            Val.TextXAlignment = Enum.TextXAlignment.Right
            Val.Parent = Row
        end

        local BottomBar = Instance.new("Frame")
        BottomBar.Size = UDim2.new(1, -12, 0, 12)
        BottomBar.Position = UDim2.new(0, 6, 1, -16)
        BottomBar.BackgroundColor3 = AccentColor
        BottomBar.BorderSizePixel = 0
        BottomBar.Parent = ListFrame

        local BottomCorner = Instance.new("UICorner")
        BottomCorner.CornerRadius = UDim.new(0, 4)
        BottomCorner.Parent = BottomBar

        local BottomText = Instance.new("TextLabel")
        BottomText.Size = UDim2.new(1, 0, 1, 0)
        BottomText.BackgroundTransparency = 1
        BottomText.Text = "100%"
        BottomText.Font = THEME.FontBold
        BottomText.TextSize = 8
        BottomText.TextColor3 = Color3.fromRGB(255, 255, 255)
        BottomText.Parent = BottomBar

        MakeDraggable(ListFrame)
        table.insert(Window.Widgets, ListFrame)
        return ListFrame
    end

    ----------------------------------------------------------------------------
    -- 🏷️ CREATE WATERMARK CARD
    ----------------------------------------------------------------------------
    function Window:CreateWatermark(cfg)
        cfg = cfg or {}
        local wmTitle = cfg.Title or "namelessware - watermark"
        local items = cfg.Items or {"item 1", "item 2", "elita_53"}

        local WmFrame = Instance.new("Frame")
        WmFrame.Name = "NamelessWatermark"
        WmFrame.Size = UDim2.new(0, 130, 0, 20 + (#items * 16))
        WmFrame.Position = UDim2.new(1, -145, 0, 15)
        WmFrame.BackgroundColor3 = THEME.Background
        WmFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = WmFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = THEME.CardBorder
        Stroke.Thickness = 1
        Stroke.Parent = WmFrame

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 8)
        Padding.PaddingTop = UDim.new(0, 4)
        Padding.Parent = WmFrame

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 2)
        Layout.Parent = WmFrame

        local Header = Instance.new("TextLabel")
        Header.Size = UDim2.new(1, 0, 0, 16)
        Header.BackgroundTransparency = 1
        Header.Text = wmTitle
        Header.Font = THEME.FontBold
        Header.TextSize = 9
        Header.TextColor3 = THEME.TextMain
        Header.TextXAlignment = Enum.TextXAlignment.Left
        Header.Parent = WmFrame

        for _, it in ipairs(items) do
            local ItmLbl = Instance.new("TextLabel")
            ItmLbl.Size = UDim2.new(1, 0, 0, 14)
            ItmLbl.BackgroundTransparency = 1
            ItmLbl.Text = "• " .. it
            ItmLbl.Font = THEME.FontMain
            ItmLbl.TextSize = 9
            ItmLbl.TextColor3 = THEME.TextMuted
            ItmLbl.TextXAlignment = Enum.TextXAlignment.Left
            ItmLbl.Parent = WmFrame
        end

        MakeDraggable(WmFrame)
        table.insert(Window.Widgets, WmFrame)
        return WmFrame
    end

    return Window
end

return NamelessWare
