--[[
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                 NAMELESS WARE UI LIBRARY - V2 ULTIMATE                ║
    ║        Exact Passion / Dutty Layout • Pixel Perfect • No Overflow     ║
    ║        Scoped Sub-Tabs • Dual Column Cards • Mobile Touch Friendly    ║
    ╚═══════════════════════════════════════════════════════════════════════╝
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
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
    time = time or 0.2
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

-- Visual Theme Matching Passion / Dutty Style + Nameless Ware Neon
local THEME = {
    Accent = Color3.fromRGB(175, 95, 255),       -- Electric Purple
    AccentGlow = Color3.fromRGB(200, 140, 255),
    BgMain = Color3.fromRGB(15, 15, 20),         -- Deep obsidian
    BgDock = Color3.fromRGB(10, 10, 14),         -- Dark Dock
    CardBg = Color3.fromRGB(20, 20, 27),         -- Card surface
    CardBorder = Color3.fromRGB(34, 34, 46),     -- Subtle 1px stroke
    TextMain = Color3.fromRGB(245, 245, 250),
    TextMuted = Color3.fromRGB(130, 130, 150),
    ToggleOff = Color3.fromRGB(30, 30, 42),
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

    -- Clean old instance
    if _G.NamelessWareInstance then
        pcall(function() _G.NamelessWareInstance:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessWare_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetSafeParent()
    _G.NamelessWareInstance = ScreenGui

    local customLogoAsset = FetchCustomAsset(LogoUrl, "NamelessWare_Logo.webp")

    ----------------------------------------------------------------------------
    -- 📱 MOBILE FLOATING BUTTON
    ----------------------------------------------------------------------------
    local MobileBtn = Instance.new("ImageButton")
    MobileBtn.Name = "NamelessMobileBtn"
    MobileBtn.Size = UDim2.new(0, 48, 0, 48)
    MobileBtn.Position = UDim2.new(0, 15, 0.5, -24)
    MobileBtn.BackgroundColor3 = THEME.BgDock
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
        local FallbackText = Instance.new("TextLabel")
        FallbackText.Size = UDim2.new(1, 0, 1, 0)
        FallbackText.BackgroundTransparency = 1
        FallbackText.Text = "NW"
        FallbackText.Font = THEME.FontBold
        FallbackText.TextSize = 15
        FallbackText.TextColor3 = AccentColor
        FallbackText.Parent = MobileBtn
    end

    MakeDraggable(MobileBtn)

    ----------------------------------------------------------------------------
    -- 🖥️ MAIN WINDOW (Exact Passion / Dutty Sizing & Proportions)
    ----------------------------------------------------------------------------
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 560, 0, 390)
    MainWindow.Position = UDim2.new(0.5, -280, 0.5, -195)
    MainWindow.BackgroundColor3 = THEME.BgMain
    MainWindow.BorderSizePixel = 0
    MainWindow.ClipsDescendants = false
    MainWindow.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainWindow

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.CardBorder
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainWindow

    -- Left Icon Dock
    local Dock = Instance.new("Frame")
    Dock.Name = "Dock"
    Dock.Size = UDim2.new(0, 52, 1, 0)
    Dock.BackgroundColor3 = THEME.BgDock
    Dock.BorderSizePixel = 0
    Dock.Parent = MainWindow

    local DockCorner = Instance.new("UICorner")
    DockCorner.CornerRadius = UDim.new(0, 10)
    DockCorner.Parent = Dock

    local DockStroke = Instance.new("UIStroke")
    DockStroke.Color = THEME.CardBorder
    DockStroke.Thickness = 1
    DockStroke.Parent = Dock

    -- Top Brand Logo in Dock
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Size = UDim2.new(0, 36, 0, 36)
    LogoContainer.Position = UDim2.new(0.5, -18, 0, 8)
    LogoContainer.BackgroundColor3 = THEME.CardBg
    LogoContainer.Parent = Dock

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = LogoContainer

    local LogoGlow = Instance.new("UIStroke")
    LogoGlow.Color = AccentColor
    LogoGlow.Thickness = 1.5
    LogoGlow.Parent = LogoContainer

    if customLogoAsset then
        local LogoImg = Instance.new("ImageLabel")
        LogoImg.Size = UDim2.new(1, -4, 1, -4)
        LogoImg.Position = UDim2.new(0, 2, 0, 2)
        LogoImg.BackgroundTransparency = 1
        LogoImg.Image = customLogoAsset
        LogoImg.ScaleType = Enum.ScaleType.Fit
        LogoImg.Parent = LogoContainer
    else
        local LogoText = Instance.new("TextLabel")
        LogoText.Size = UDim2.new(1, 0, 1, 0)
        LogoText.BackgroundTransparency = 1
        LogoText.Text = "NW"
        LogoText.Font = THEME.FontBold
        LogoText.TextSize = 14
        LogoText.TextColor3 = AccentColor
        LogoText.Parent = LogoContainer
    end

    MakeDraggable(MainWindow, Dock)

    -- Dock Scroll List for Main Icons
    local DockScroll = Instance.new("ScrollingFrame")
    DockScroll.Size = UDim2.new(1, 0, 1, -55)
    DockScroll.Position = UDim2.new(0, 0, 0, 50)
    DockScroll.BackgroundTransparency = 1
    DockScroll.ScrollBarThickness = 0
    DockScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    DockScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    DockScroll.Parent = Dock

    local DockLayout = Instance.new("UIListLayout")
    DockLayout.Padding = UDim.new(0, 6)
    DockLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DockLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DockLayout.Parent = DockScroll

    -- Top Header Container (Holds the Sub-Tabs bar per active tab)
    local TopHeader = Instance.new("Frame")
    TopHeader.Name = "TopHeader"
    TopHeader.Size = UDim2.new(1, -62, 0, 42)
    TopHeader.Position = UDim2.new(0, 58, 0, 4)
    TopHeader.BackgroundTransparency = 1
    TopHeader.Parent = MainWindow

    -- Search / Status Icon in Top Right
    local SearchBtn = Instance.new("ImageButton")
    SearchBtn.Size = UDim2.new(0, 18, 0, 18)
    SearchBtn.Position = UDim2.new(1, -26, 0.5, -9)
    SearchBtn.BackgroundTransparency = 1
    SearchBtn.Image = "rbxassetid://10734975692"
    SearchBtn.ImageColor3 = THEME.TextMuted
    SearchBtn.AutoButtonColor = false
    SearchBtn.Parent = TopHeader

    -- Pink/Purple Active Underline Track
    local UnderlineTrack = Instance.new("Frame")
    UnderlineTrack.Size = UDim2.new(1, -62, 0, 2)
    UnderlineTrack.Position = UDim2.new(0, 58, 0, 44)
    UnderlineTrack.BackgroundColor3 = THEME.CardBorder
    UnderlineTrack.BorderSizePixel = 0
    UnderlineTrack.Parent = MainWindow

    local ActiveUnderline = Instance.new("Frame")
    ActiveUnderline.Size = UDim2.new(0, 50, 1, 0)
    ActiveUnderline.Position = UDim2.new(0, 0, 0, 0)
    ActiveUnderline.BackgroundColor3 = AccentColor
    ActiveUnderline.BorderSizePixel = 0
    ActiveUnderline.Parent = UnderlineTrack

    MakeDraggable(MainWindow, TopHeader)

    -- Content Container (Cards area)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -68, 1, -56)
    ContentArea.Position = UDim2.new(0, 60, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow

    -- Mobile Toggle Action
    local isUIOpen = true
    local function ToggleUI()
        isUIOpen = not isUIOpen
        MainWindow.Visible = isUIOpen
    end
    MobileBtn.MouseButton1Click:Connect(ToggleUI)

    local Window = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        MobileBtn = MobileBtn,
        Dock = Dock,
        TopHeader = TopHeader,
        ContentArea = ContentArea,
        Tabs = {},
        Widgets = {}
    }

    local FirstTab = true

    ----------------------------------------------------------------------------
    -- 📁 CREATE TAB (Main Dock Icon)
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
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = DockBtn

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 18, 0, 18)
        Icon.Position = UDim2.new(0.5, -9, 0.5, -9)
        Icon.BackgroundTransparency = 1
        Icon.Image = tabIcon
        Icon.ImageColor3 = THEME.TextMuted
        Icon.Parent = DockBtn

        -- Sub-Tabs Bar Holder specifically for THIS tab (Solves the overflow bug!)
        local TabSubBar = Instance.new("Frame")
        TabSubBar.Name = tabName .. "_SubBar"
        TabSubBar.Size = UDim2.new(1, -35, 1, 0)
        TabSubBar.BackgroundTransparency = 1
        TabSubBar.Visible = false
        TabSubBar.Parent = TopHeader

        local SubBarLayout = Instance.new("UIListLayout")
        SubBarLayout.FillDirection = Enum.FillDirection.Horizontal
        SubBarLayout.Padding = UDim.new(0, 16)
        SubBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SubBarLayout.Parent = TabSubBar

        -- Main Content Page for THIS tab
        local TabPage = Instance.new("Frame")
        TabPage.Name = tabName .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.Parent = ContentArea

        local SubTabs = {}
        local FirstSubTab = true

        local function ActivateTab()
            -- Hide all other tabs
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.SubBar.Visible = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Icon, {ImageColor3 = THEME.TextMuted}, 0.2)
            end

            -- Show this tab
            TabPage.Visible = true
            TabSubBar.Visible = true
            Tween(DockBtn, {BackgroundTransparency = 0, BackgroundColor3 = THEME.CardBg}, 0.2)
            Tween(Icon, {ImageColor3 = AccentColor}, 0.2)

            -- Activate first subtab
            if SubTabs[1] then
                SubTabs[1].Activate()
            end
        end

        DockBtn.MouseButton1Click:Connect(ActivateTab)

        local TabObject = {
            Button = DockBtn,
            Icon = Icon,
            Page = TabPage,
            SubBar = TabSubBar,
            SubTabs = SubTabs
        }
        table.insert(Window.Tabs, TabObject)

        local TabMethods = {}

        ------------------------------------------------------------------------
        -- 📑 CREATE SUB-TAB (Inside This Specific Main Tab)
        ------------------------------------------------------------------------
        function TabMethods:CreateSubTab(subName)
            local SubBtn = Instance.new("TextButton")
            SubBtn.Size = UDim2.new(0, 60, 1, 0)
            SubBtn.BackgroundTransparency = 1
            SubBtn.Text = subName
            SubBtn.Font = THEME.FontBold
            SubBtn.TextSize = 12
            SubBtn.TextColor3 = THEME.TextMuted
            SubBtn.AutoButtonColor = false
            SubBtn.Parent = TabSubBar

            -- Sub-Tab Content: 2-Column Scrolling View
            local SubScroll = Instance.new("ScrollingFrame")
            SubScroll.Size = UDim2.new(1, 0, 1, 0)
            SubScroll.BackgroundTransparency = 1
            SubScroll.ScrollBarThickness = 3
            SubScroll.ScrollBarImageColor3 = AccentColor
            SubScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            SubScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            SubScroll.Visible = false
            SubScroll.Parent = TabPage

            local ColumnsHolder = Instance.new("Frame")
            ColumnsHolder.Size = UDim2.new(1, 0, 0, 0)
            ColumnsHolder.AutomaticSize = Enum.AutomaticSize.Y
            ColumnsHolder.BackgroundTransparency = 1
            ColumnsHolder.Parent = SubScroll

            local ColumnsLayout = Instance.new("UIListLayout")
            ColumnsLayout.FillDirection = Enum.FillDirection.Horizontal
            ColumnsLayout.Padding = UDim.new(0, 8)
            ColumnsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ColumnsLayout.Parent = ColumnsHolder

            local function ActivateSub()
                for _, s in pairs(SubTabs) do
                    s.Scroll.Visible = false
                    Tween(s.Button, {TextColor3 = THEME.TextMuted}, 0.2)
                end
                SubScroll.Visible = true
                Tween(SubBtn, {TextColor3 = AccentColor}, 0.2)

                -- Move underline smoothly
                task.spawn(function()
                    task.wait(0.02)
                    local xOffset = SubBtn.AbsolutePosition.X - TopHeader.AbsolutePosition.X
                    local width = SubBtn.AbsoluteSize.X
                    Tween(ActiveUnderline, {
                        Position = UDim2.new(0, math.max(0, xOffset), 0, 0),
                        Size = UDim2.new(0, width, 1, 0)
                    }, 0.2)
                end)
            end

            SubBtn.MouseButton1Click:Connect(ActivateSub)

            local SubTabObject = {
                Button = SubBtn,
                Scroll = SubScroll,
                Activate = ActivateSub
            }
            table.insert(SubTabs, SubTabObject)

            if FirstSubTab then
                FirstSubTab = false
                ActivateSub()
            end

            local SubMethods = {}

            --------------------------------------------------------------------
            -- 🗃️ CREATE CARD (Left or Right Column)
            --------------------------------------------------------------------
            function SubMethods:CreateCard(cardTitle)
                local Card = Instance.new("Frame")
                Card.Size = UDim2.new(0.5, -4, 0, 0)
                Card.AutomaticSize = Enum.AutomaticSize.Y
                Card.BackgroundColor3 = THEME.CardBg
                Card.BorderSizePixel = 0
                Card.Parent = ColumnsHolder

                local CardCorner = Instance.new("UICorner")
                CardCorner.CornerRadius = UDim.new(0, 8)
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
                    CardHeader.Size = UDim2.new(1, 0, 0, 18)
                    CardHeader.BackgroundTransparency = 1
                    CardHeader.Text = cardTitle
                    CardHeader.Font = THEME.FontBold
                    CardHeader.TextSize = 11
                    CardHeader.TextColor3 = THEME.TextMain
                    CardHeader.TextXAlignment = Enum.TextXAlignment.Left
                    CardHeader.Parent = Card
                end

                local Controls = {}

                -- 1. TOGGLE (Neon Capsule Switch)
                function Controls:AddToggle(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Toggle"
                    local state = cfg.Default or false
                    local callback = cfg.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 28)
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
                    Switch.Size = UDim2.new(0, 34, 0, 18)
                    Switch.Position = UDim2.new(1, -34, 0.5, -9)
                    Switch.BackgroundColor3 = state and AccentColor or THEME.ToggleOff
                    Switch.Text = ""
                    Switch.AutoButtonColor = false
                    Switch.Parent = Row

                    local SwitchCorner = Instance.new("UICorner")
                    SwitchCorner.CornerRadius = UDim.new(1, 0)
                    SwitchCorner.Parent = Switch

                    local Dot = Instance.new("Frame")
                    Dot.Size = UDim2.new(0, 12, 0, 12)
                    Dot.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
                    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Dot.Parent = Switch

                    local DotCorner = Instance.new("UICorner")
                    DotCorner.CornerRadius = UDim.new(1, 0)
                    DotCorner.Parent = Dot

                    local function SetState(newVal)
                        state = newVal
                        if state then
                            Tween(Switch, {BackgroundColor3 = AccentColor}, 0.2)
                            Tween(Dot, {Position = UDim2.new(1, -15, 0.5, -6)}, 0.2)
                            Tween(Label, {TextColor3 = THEME.TextMain}, 0.2)
                        else
                            Tween(Switch, {BackgroundColor3 = THEME.ToggleOff}, 0.2)
                            Tween(Dot, {Position = UDim2.new(0, 3, 0.5, -6)}, 0.2)
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
                function Controls:AddSlider(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Slider"
                    local min = cfg.Min or 0
                    local max = cfg.Max or 100
                    local default = cfg.Default or min
                    local suffix = cfg.Suffix or "%"
                    local callback = cfg.Callback or function() end
                    local value = default

                    local Frame = Instance.new("Frame")
                    Frame.Size = UDim2.new(1, 0, 0, 38)
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
                    Track.Size = UDim2.new(1, 0, 0, 5)
                    Track.Position = UDim2.new(0, 0, 0, 22)
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
                    Thumb.Size = UDim2.new(0, 11, 0, 11)
                    Thumb.Position = UDim2.new(1, -5, 0.5, -5.5)
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
                function Controls:AddButton(cfg)
                    cfg = cfg or {}
                    local text = cfg.Name or "Button"
                    local callback = cfg.Callback or function() end

                    local Btn = Instance.new("TextButton")
                    Btn.Size = UDim2.new(1, 0, 0, 26)
                    Btn.BackgroundColor3 = THEME.BgDock
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
                        task.wait(0.1)
                        Tween(Btn, {BackgroundColor3 = THEME.BgDock}, 0.2)
                        callback()
                    end)
                end

                -- 4. DROPDOWN
                function Controls:AddDropdown(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Dropdown"
                    local options = cfg.Options or {}
                    local default = cfg.Default or options[1] or "Select"
                    local callback = cfg.Callback or function() end
                    local selected = default
                    local open = false

                    local DropFrame = Instance.new("Frame")
                    DropFrame.Size = UDim2.new(1, 0, 0, 46)
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
                    DropBtn.Size = UDim2.new(1, 0, 0, 24)
                    DropBtn.Position = UDim2.new(0, 0, 0, 18)
                    DropBtn.BackgroundColor3 = THEME.BgDock
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
                    MenuList.Size = UDim2.new(1, 0, 0, #options * 22)
                    MenuList.Position = UDim2.new(0, 0, 1, 3)
                    MenuList.BackgroundColor3 = THEME.BgMain
                    MenuList.BorderSizePixel = 0
                    MenuList.Visible = false
                    MenuList.ZIndex = 30
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
                        OptItem.Size = UDim2.new(1, 0, 0, 22)
                        OptItem.BackgroundTransparency = 1
                        OptItem.Text = "  " .. opt
                        OptItem.Font = THEME.FontMain
                        OptItem.TextSize = 10
                        OptItem.TextColor3 = (opt == selected) and AccentColor or THEME.TextMuted
                        OptItem.TextXAlignment = Enum.TextXAlignment.Left
                        OptItem.ZIndex = 31
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
                function Controls:AddDivider(label)
                    local DivFrame = Instance.new("Frame")
                    DivFrame.Size = UDim2.new(1, 0, 0, 16)
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
                function Controls:AddKeybind(cfg)
                    cfg = cfg or {}
                    local name = cfg.Name or "Keybind"
                    local key = cfg.Default or Enum.KeyCode.E
                    local callback = cfg.Callback or function() end

                    local Row = Instance.new("Frame")
                    Row.Size = UDim2.new(1, 0, 0, 26)
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
                    KeyBtn.Size = UDim2.new(0, 55, 0, 18)
                    KeyBtn.Position = UDim2.new(1, -55, 0.5, -9)
                    KeyBtn.BackgroundColor3 = THEME.BgDock
                    KeyBtn.Text = key.Name
                    KeyBtn.Font = THEME.FontBold
                    KeyBtn.TextSize = 9
                    KeyBtn.TextColor3 = AccentColor
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.Parent = Row

                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 4)
                    KeyCorner.Parent = KeyBtn

                    KeyBtn.MouseButton1Click:Connect(function()
                        KeyBtn.Text = "..."
                        local conn
                        conn = UserInputService.InputBegan:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.Keyboard then
                                key = inp.KeyCode
                                KeyBtn.Text = key.Name
                                conn:Disconnect()
                                callback(key)
                            end
                        end)
                    end)
                end

                return Controls
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
    -- 🎵 CREATE MEDIA PLAYER WIDGET (Spotify / Passion Style)
    ----------------------------------------------------------------------------
    function Window:CreateMediaPlayer(cfg)
        cfg = cfg or {}
        local trackTitle = cfg.Title or "JOHNNY CAGE"
        local artist = cfg.Artist or "HXG"

        local MediaFrame = Instance.new("Frame")
        MediaFrame.Name = "NamelessMediaPlayer"
        MediaFrame.Size = UDim2.new(0, 150, 0, 165)
        MediaFrame.Position = UDim2.new(0.5, 290, 0.5, 20)
        MediaFrame.BackgroundColor3 = THEME.BgMain
        MediaFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 10)
        Corner.Parent = MediaFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = THEME.CardBorder
        Stroke.Thickness = 1.2
        Stroke.Parent = MediaFrame

        -- Sleek Vinyl / Album Visual
        local Album = Instance.new("Frame")
        Album.Size = UDim2.new(0, 126, 0, 95)
        Album.Position = UDim2.new(0.5, -63, 0, 10)
        Album.BackgroundColor3 = THEME.CardBg
        Album.Parent = MediaFrame

        local AlbumCorner = Instance.new("UICorner")
        AlbumCorner.CornerRadius = UDim.new(0, 8)
        AlbumCorner.Parent = Album

        local AlbumIcon = Instance.new("ImageLabel")
        AlbumIcon.Size = UDim2.new(0, 48, 0, 48)
        AlbumIcon.Position = UDim2.new(0.5, -24, 0.5, -24)
        AlbumIcon.BackgroundTransparency = 1
        AlbumIcon.Image = "rbxassetid://10734975692" -- Music / Vinyl icon
        AlbumIcon.ImageColor3 = AccentColor
        AlbumIcon.Parent = Album

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, -35, 0, 15)
        TitleLbl.Position = UDim2.new(0, 12, 0, 112)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = trackTitle
        TitleLbl.Font = THEME.FontBold
        TitleLbl.TextSize = 11
        TitleLbl.TextColor3 = THEME.TextMain
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.Parent = MediaFrame

        local ArtistLbl = Instance.new("TextLabel")
        ArtistLbl.Size = UDim2.new(1, -35, 0, 13)
        ArtistLbl.Position = UDim2.new(0, 12, 0, 127)
        ArtistLbl.BackgroundTransparency = 1
        ArtistLbl.Text = artist
        ArtistLbl.Font = THEME.FontMain
        ArtistLbl.TextSize = 9
        ArtistLbl.TextColor3 = THEME.TextMuted
        ArtistLbl.TextXAlignment = Enum.TextXAlignment.Left
        ArtistLbl.Parent = MediaFrame

        local Progress = Instance.new("Frame")
        Progress.Size = UDim2.new(1, -24, 0, 3)
        Progress.Position = UDim2.new(0, 12, 1, -12)
        Progress.BackgroundColor3 = THEME.ToggleOff
        Progress.Parent = MediaFrame

        local ProgressFill = Instance.new("Frame")
        ProgressFill.Size = UDim2.new(0.65, 0, 1, 0)
        ProgressFill.BackgroundColor3 = AccentColor
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Parent = Progress

        local ActionBtn = Instance.new("TextButton")
        ActionBtn.Size = UDim2.new(0, 20, 0, 20)
        ActionBtn.Position = UDim2.new(1, -28, 0, 116)
        ActionBtn.BackgroundTransparency = 1
        ActionBtn.Text = "⊕"
        ActionBtn.Font = THEME.FontBold
        ActionBtn.TextSize = 15
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
        local listTitle = cfg.Title or "epstien list"
        local items = cfg.Items or {}

        local ListFrame = Instance.new("Frame")
        ListFrame.Name = "NamelessDataList"
        ListFrame.Size = UDim2.new(0, 160, 0, 185)
        ListFrame.Position = UDim2.new(0.5, -450, 0.5, 0)
        ListFrame.BackgroundColor3 = THEME.BgMain
        ListFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = ListFrame

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = THEME.CardBorder
        Stroke.Thickness = 1
        Stroke.Parent = ListFrame

        local Header = Instance.new("TextLabel")
        Header.Size = UDim2.new(1, -16, 0, 20)
        Header.Position = UDim2.new(0, 8, 0, 3)
        Header.BackgroundTransparency = 1
        Header.Text = listTitle
        Header.Font = THEME.FontMain
        Header.TextSize = 10
        Header.TextColor3 = THEME.TextMuted
        Header.TextXAlignment = Enum.TextXAlignment.Left
        Header.Parent = ListFrame

        local Scroll = Instance.new("ScrollingFrame")
        Scroll.Size = UDim2.new(1, -12, 1, -40)
        Scroll.Position = UDim2.new(0, 6, 0, 22)
        Scroll.BackgroundTransparency = 1
        Scroll.ScrollBarThickness = 0
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Scroll.Parent = ListFrame

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0, 2)
        Layout.Parent = Scroll

        for i, item in ipairs(items) do
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 16)
            Row.BackgroundTransparency = 1
            Row.Parent = Scroll

            local Num = Instance.new("TextLabel")
            Num.Size = UDim2.new(0, 14, 1, 0)
            Num.BackgroundTransparency = 1
            Num.Text = tostring(i)
            Num.Font = THEME.FontMain
            Num.TextSize = 9
            Num.TextColor3 = THEME.TextMuted
            Num.Parent = Row

            local Name = Instance.new("TextLabel")
            Name.Size = UDim2.new(0, 42, 1, 0)
            Name.Position = UDim2.new(0, 16, 0, 0)
            Name.BackgroundTransparency = 1
            Name.Text = item.Name or ("item " .. i)
            Name.Font = THEME.FontMain
            Name.TextSize = 9
            Name.TextColor3 = THEME.TextMuted
            Name.TextXAlignment = Enum.TextXAlignment.Left
            Name.Parent = Row

            local Val = Instance.new("TextLabel")
            Val.Size = UDim2.new(1, -60, 1, 0)
            Val.Position = UDim2.new(0, 60, 0, 0)
            Val.BackgroundTransparency = 1
            Val.Text = item.Value or "50k dolar 50k lira"
            Val.Font = THEME.FontMain
            Val.TextSize = 8
            Val.TextColor3 = THEME.GreenSuccess
            Val.TextXAlignment = Enum.TextXAlignment.Right
            Val.Parent = Row
        end

        local BottomBar = Instance.new("Frame")
        BottomBar.Size = UDim2.new(1, -12, 0, 11)
        BottomBar.Position = UDim2.new(0, 6, 1, -14)
        BottomBar.BackgroundColor3 = AccentColor
        BottomBar.BorderSizePixel = 0
        BottomBar.Parent = ListFrame

        local BottomCorner = Instance.new("UICorner")
        BottomCorner.CornerRadius = UDim.new(0, 3)
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
        local wmTitle = cfg.Title or "passion - watermark"
        local items = cfg.Items or {"item 1", "item 2", "notsamet_53"}

        local WmFrame = Instance.new("Frame")
        WmFrame.Name = "NamelessWatermark"
        WmFrame.Size = UDim2.new(0, 120, 0, 20 + (#items * 15))
        WmFrame.Position = UDim2.new(1, -135, 0, 15)
        WmFrame.BackgroundColor3 = THEME.BgMain
        WmFrame.Parent = ScreenGui

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
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
        Header.Size = UDim2.new(1, 0, 0, 14)
        Header.BackgroundTransparency = 1
        Header.Text = wmTitle
        Header.Font = THEME.FontBold
        Header.TextSize = 9
        Header.TextColor3 = THEME.TextMain
        Header.TextXAlignment = Enum.TextXAlignment.Left
        Header.Parent = WmFrame

        for _, it in ipairs(items) do
            local ItmLbl = Instance.new("TextLabel")
            ItmLbl.Size = UDim2.new(1, 0, 0, 13)
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
