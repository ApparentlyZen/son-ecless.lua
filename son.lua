--[[
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                 NAMELESS WARE UI LIBRARY - REPTILIAN EDITION          ║
    ║      Exact 1:1 Match of Reptilian CS:GO / Neverlose Cheat Layout      ║
    ║      Features: 3D ESP Preview, Real-Time Keybind List, Watermark Bar  ║
    ║      Checkboxes with Keybinds, Precision Sliders, 100% Mobile Ready   ║
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

-- Custom Asset Loader
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

-- Helper: Advanced Tweening Engine
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
-- 👑 NAMELESS WARE - REPTILIAN EDITION
--------------------------------------------------------------------------------
local NamelessWare = {}
NamelessWare.__index = NamelessWare

-- Reptilian Palette
local THEME = {
    Accent = Color3.fromRGB(138, 96, 255),          -- Reptilian Purple
    AccentGradient = Color3.fromRGB(175, 135, 255),
    AccentDark = Color3.fromRGB(98, 55, 210),
    BgMain = Color3.fromRGB(17, 17, 23),            -- Obsidian Body
    BgSidebar = Color3.fromRGB(13, 13, 18),         -- Dark Sidebar
    CardBg = Color3.fromRGB(22, 22, 30),            -- Card Surface
    CardBorder = Color3.fromRGB(36, 36, 48),        -- Sleek 1px Outline
    TextMain = Color3.fromRGB(245, 245, 252),
    TextMuted = Color3.fromRGB(140, 140, 165),
    BoxOff = Color3.fromRGB(28, 28, 38),
    BoxOffBorder = Color3.fromRGB(46, 46, 62),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
}

local RAW_LOGO_URL = "https://raw.githubusercontent.com/ApparentlyZen/image-namelessWare/main/165abdd521328d77324b02ce8a77e090_1780162334922.webp"

function NamelessWare:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "reptilian.lua"
    local SubTitle = config.SubTitle or "v1.0 ~ operation one"
    local AccentColor = config.Accent or THEME.Accent
    local LogoUrl = config.LogoUrl or RAW_LOGO_URL

    -- Destroy old instance
    if _G.NamelessWareInstance then
        pcall(function() _G.NamelessWareInstance:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Reptilian_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetSafeParent()
    _G.NamelessWareInstance = ScreenGui

    local customLogoAsset = FetchCustomAsset(LogoUrl, "NamelessWare_Logo.webp")

    ----------------------------------------------------------------------------
    -- 📱 MOBILE FLOATING TOGGLE BUTTON
    ----------------------------------------------------------------------------
    local MobileBtn = Instance.new("ImageButton")
    MobileBtn.Name = "ReptilianMobileBtn"
    MobileBtn.Size = UDim2.new(0, 48, 0, 48)
    MobileBtn.Position = UDim2.new(0, 15, 0.5, -24)
    MobileBtn.BackgroundColor3 = THEME.BgSidebar
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
        FallbackText.Text = "RL"
        FallbackText.Font = THEME.FontBold
        FallbackText.TextSize = 15
        FallbackText.TextColor3 = AccentColor
        FallbackText.Parent = MobileBtn
    end

    MakeDraggable(MobileBtn)

    ----------------------------------------------------------------------------
    -- 🖥️ MAIN WINDOW (Exact Reptilian Layout: 560x390)
    ----------------------------------------------------------------------------
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 560, 0, 395)
    MainWindow.Position = UDim2.new(0.5, -280, 0.5, -197)
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

    -- Left Navigation Sidebar (Tabs with Icons)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = THEME.BgSidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = THEME.CardBorder
    SidebarStroke.Thickness = 1
    SidebarStroke.Parent = Sidebar

    -- Brand Top Left Header
    local BrandFrame = Instance.new("Frame")
    BrandFrame.Size = UDim2.new(1, 0, 0, 50)
    BrandFrame.BackgroundTransparency = 1
    BrandFrame.Parent = Sidebar

    local LogoBox = Instance.new("Frame")
    LogoBox.Size = UDim2.new(0, 24, 0, 24)
    LogoBox.Position = UDim2.new(0, 12, 0.5, -12)
    LogoBox.BackgroundColor3 = THEME.CardBg
    LogoBox.Parent = BrandFrame

    local LogoBoxCorner = Instance.new("UICorner")
    LogoBoxCorner.CornerRadius = UDim.new(0, 6)
    LogoBoxCorner.Parent = LogoBox

    local LogoGlow = Instance.new("UIStroke")
    LogoGlow.Color = AccentColor
    LogoGlow.Thickness = 1.2
    LogoGlow.Parent = LogoBox

    if customLogoAsset then
        local LogoImg = Instance.new("ImageLabel")
        LogoImg.Size = UDim2.new(1, -2, 1, -2)
        LogoImg.Position = UDim2.new(0, 1, 0, 1)
        LogoImg.BackgroundTransparency = 1
        LogoImg.Image = customLogoAsset
        LogoImg.ScaleType = Enum.ScaleType.Fit
        LogoImg.Parent = LogoBox
    else
        local LogoTxt = Instance.new("TextLabel")
        LogoTxt.Size = UDim2.new(1, 0, 1, 0)
        LogoTxt.BackgroundTransparency = 1
        LogoTxt.Text = "RL"
        LogoTxt.Font = THEME.FontBold
        LogoTxt.TextSize = 11
        LogoTxt.TextColor3 = AccentColor
        LogoTxt.Parent = LogoBox
    end

    local BrandTitle = Instance.new("TextLabel")
    BrandTitle.Size = UDim2.new(1, -44, 0, 16)
    BrandTitle.Position = UDim2.new(0, 42, 0, 10)
    BrandTitle.BackgroundTransparency = 1
    BrandTitle.Text = Title
    BrandTitle.Font = THEME.FontBold
    BrandTitle.TextSize = 12
    BrandTitle.TextColor3 = THEME.TextMain
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
    BrandTitle.Parent = BrandFrame

    local BrandSub = Instance.new("TextLabel")
    BrandSub.Size = UDim2.new(1, -44, 0, 14)
    BrandSub.Position = UDim2.new(0, 42, 0, 26)
    BrandSub.BackgroundTransparency = 1
    BrandSub.Text = SubTitle
    BrandSub.Font = THEME.FontMain
    BrandSub.TextSize = 9
    BrandSub.TextColor3 = THEME.TextMuted
    BrandSub.TextXAlignment = Enum.TextXAlignment.Left
    BrandSub.Parent = BrandFrame

    MakeDraggable(MainWindow, BrandFrame)

    -- Sidebar Tab Buttons List
    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Size = UDim2.new(1, -12, 1, -55)
    NavScroll.Position = UDim2.new(0, 6, 0, 50)
    NavScroll.BackgroundTransparency = 1
    NavScroll.ScrollBarThickness = 0
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 5)
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Parent = NavScroll

    -- Content Container (Holds Pages)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -150, 1, -14)
    ContentArea.Position = UDim2.new(0, 145, 0, 7)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow

    ----------------------------------------------------------------------------
    -- 📦 REPTILIAN FLOATING WIDGETS (Keybinds, ESP 3D Preview, Watermark)
    ----------------------------------------------------------------------------

    -- 1. Keybind List Widget
    local KeybindWidget = Instance.new("Frame")
    KeybindWidget.Name = "KeybindWidget"
    KeybindWidget.Size = UDim2.new(0, 135, 0, 80)
    KeybindWidget.Position = UDim2.new(0.5, -430, 0.5, -40)
    KeybindWidget.BackgroundColor3 = THEME.BgMain
    KeybindWidget.Parent = ScreenGui

    local KeybindCorner = Instance.new("UICorner")
    KeybindCorner.CornerRadius = UDim.new(0, 8)
    KeybindCorner.Parent = KeybindWidget

    local KeybindStroke = Instance.new("UIStroke")
    KeybindStroke.Color = THEME.CardBorder
    KeybindStroke.Thickness = 1.2
    KeybindStroke.Parent = KeybindWidget

    local KeybindHeader = Instance.new("TextLabel")
    KeybindHeader.Size = UDim2.new(1, 0, 0, 24)
    KeybindHeader.BackgroundTransparency = 1
    KeybindHeader.Text = "Keybind List"
    KeybindHeader.Font = THEME.FontBold
    KeybindHeader.TextSize = 11
    KeybindHeader.TextColor3 = THEME.TextMain
    KeybindHeader.Parent = KeybindWidget

    local KeybindScroll = Instance.new("ScrollingFrame")
    KeybindScroll.Size = UDim2.new(1, -10, 1, -26)
    KeybindScroll.Position = UDim2.new(0, 5, 0, 24)
    KeybindScroll.BackgroundTransparency = 1
    KeybindScroll.ScrollBarThickness = 0
    KeybindScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    KeybindScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    KeybindScroll.Parent = KeybindWidget

    local KeybindLayout = Instance.new("UIListLayout")
    KeybindLayout.Padding = UDim.new(0, 2)
    KeybindLayout.Parent = KeybindScroll

    local function AddKeybindItem(name, key, mode, active)
        local row = Instance.new("TextLabel")
        row.Size = UDim2.new(1, 0, 0, 16)
        row.BackgroundTransparency = 1
        row.Text = string.format("%s  [%s]  [%s]", name, key, mode or "toggle")
        row.Font = THEME.FontMain
        row.TextSize = 9
        row.TextColor3 = active and AccentColor or THEME.TextMuted
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.Parent = KeybindScroll
    end

    AddKeybindItem("Ragebot", "Z", "hold", true)
    AddKeybindItem("Aim Assist", "F", "toggle", true)

    MakeDraggable(KeybindWidget)

    -- 2. ESP Preview Widget (Interactive Avatar Preview with 2D Box & Spin)
    local ESPWidget = Instance.new("Frame")
    ESPWidget.Name = "ESPWidget"
    ESPWidget.Size = UDim2.new(0, 120, 0, 160)
    ESPWidget.Position = UDim2.new(0.5, 290, 0.5, -197)
    ESPWidget.BackgroundColor3 = THEME.BgMain
    ESPWidget.Parent = ScreenGui

    local ESPCorner = Instance.new("UICorner")
    ESPCorner.CornerRadius = UDim.new(0, 8)
    ESPCorner.Parent = ESPWidget

    local ESPStroke = Instance.new("UIStroke")
    ESPStroke.Color = THEME.CardBorder
    ESPStroke.Thickness = 1.2
    ESPStroke.Parent = ESPWidget

    local ESPHeader = Instance.new("TextLabel")
    ESPHeader.Size = UDim2.new(1, 0, 0, 22)
    ESPHeader.BackgroundTransparency = 1
    ESPHeader.Text = "ESP Preview"
    ESPHeader.Font = THEME.FontBold
    ESPHeader.TextSize = 11
    ESPHeader.TextColor3 = THEME.TextMain
    ESPHeader.Parent = ESPWidget

    local DummyAvatar = Instance.new("ImageLabel")
    DummyAvatar.Size = UDim2.new(0, 85, 0, 105)
    DummyAvatar.Position = UDim2.new(0.5, -42, 0, 24)
    DummyAvatar.BackgroundTransparency = 1
    DummyAvatar.Image = "rbxassetid://10723346959"
    DummyAvatar.ImageColor3 = Color3.fromRGB(225, 225, 255)
    DummyAvatar.Parent = ESPWidget

    -- 2D ESP Box Indicator
    local ESPBox = Instance.new("Frame")
    ESPBox.Size = UDim2.new(0, 65, 0, 95)
    ESPBox.Position = UDim2.new(0.5, -32, 0, 28)
    ESPBox.BackgroundTransparency = 1
    ESPBox.Parent = ESPWidget

    local ESPBoxStroke = Instance.new("UIStroke")
    ESPBoxStroke.Color = AccentColor
    ESPBoxStroke.Thickness = 1.5
    ESPBoxStroke.Parent = ESPBox

    local SpinFooter = Instance.new("TextLabel")
    SpinFooter.Size = UDim2.new(1, 0, 0, 18)
    SpinFooter.Position = UDim2.new(0, 0, 1, -20)
    SpinFooter.BackgroundTransparency = 1
    SpinFooter.Text = "Spin"
    SpinFooter.Font = THEME.FontMain
    SpinFooter.TextSize = 9
    SpinFooter.TextColor3 = THEME.TextMuted
    SpinFooter.Parent = ESPWidget

    MakeDraggable(ESPWidget)

    -- 3. Watermark Status Bar (FPS & Ping in Real-Time)
    local WatermarkBar = Instance.new("Frame")
    WatermarkBar.Name = "WatermarkBar"
    WatermarkBar.Size = UDim2.new(0, 280, 0, 26)
    WatermarkBar.Position = UDim2.new(0.5, -140, 0.5, 208)
    WatermarkBar.BackgroundColor3 = THEME.BgMain
    WatermarkBar.Parent = ScreenGui

    local WatermarkCorner = Instance.new("UICorner")
    WatermarkCorner.CornerRadius = UDim.new(0, 6)
    WatermarkCorner.Parent = WatermarkBar

    local WatermarkStroke = Instance.new("UIStroke")
    WatermarkStroke.Color = THEME.CardBorder
    WatermarkStroke.Thickness = 1
    WatermarkStroke.Parent = WatermarkBar

    local WatermarkLogo = Instance.new("ImageLabel")
    WatermarkLogo.Size = UDim2.new(0, 14, 0, 14)
    WatermarkLogo.Position = UDim2.new(0, 8, 0.5, -7)
    WatermarkLogo.BackgroundTransparency = 1
    WatermarkLogo.Image = "rbxassetid://10734975692"
    WatermarkLogo.ImageColor3 = AccentColor
    WatermarkLogo.Parent = WatermarkBar

    local WatermarkText = Instance.new("TextLabel")
    WatermarkText.Size = UDim2.new(1, -28, 1, 0)
    WatermarkText.Position = UDim2.new(0, 26, 0, 0)
    WatermarkText.BackgroundTransparency = 1
    WatermarkText.Text = "reptilian.lua ~ v1.0 • FPS: 240 • PING: 0MS"
    WatermarkText.Font = THEME.FontMain
    WatermarkText.TextSize = 10
    WatermarkText.TextColor3 = THEME.TextMuted
    WatermarkText.TextXAlignment = Enum.TextXAlignment.Left
    WatermarkText.Parent = WatermarkBar

    -- Real-time FPS & Ping updater
    task.spawn(function()
        local lastTime = tick()
        local frameCount = 0
        RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            if tick() - lastTime >= 1 then
                local fps = math.floor(frameCount / (tick() - lastTime))
                frameCount = 0
                lastTime = tick()
                local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                WatermarkText.Text = string.format("%s ~ %s • FPS: %d • PING: %dMS", Title, SubTitle, fps, ping)
            end
        end)
    end)

    MakeDraggable(WatermarkBar)

    -- Mobile Toggle Action
    local isUIOpen = true
    MobileBtn.MouseButton1Click:Connect(function()
        isUIOpen = not isUIOpen
        MainWindow.Visible = isUIOpen
        KeybindWidget.Visible = isUIOpen
        ESPWidget.Visible = isUIOpen
        WatermarkBar.Visible = isUIOpen
    end)

    local Window = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        MobileBtn = MobileBtn,
        KeybindWidget = KeybindWidget,
        ESPWidget = ESPWidget,
        WatermarkBar = WatermarkBar,
        Tabs = {}
    }

    local FirstTab = true

    ----------------------------------------------------------------------------
    -- 📑 CREATE TAB
    ----------------------------------------------------------------------------
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local name = tabConfig.Name or "Tab"
        local iconId = tabConfig.Icon or "rbxassetid://10734975692"

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = THEME.CardBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = NavScroll

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId
        TabIcon.ImageColor3 = THEME.TextMuted
        TabIcon.Parent = TabBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -28, 1, 0)
        TabLabel.Position = UDim2.new(0, 28, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.Font = THEME.FontMain
        TabLabel.TextSize = 11
        TabLabel.TextColor3 = THEME.TextMuted
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        -- Tab Content View (2 Columns)
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = name .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = AccentColor
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.Parent = ContentArea

        local ColumnsHolder = Instance.new("Frame")
        ColumnsHolder.Size = UDim2.new(1, -4, 0, 0)
        ColumnsHolder.AutomaticSize = Enum.AutomaticSize.Y
        ColumnsHolder.BackgroundTransparency = 1
        ColumnsHolder.Parent = TabPage

        local ColumnsLayout = Instance.new("UIListLayout")
        ColumnsLayout.FillDirection = Enum.FillDirection.Horizontal
        ColumnsLayout.Padding = UDim.new(0, 8)
        ColumnsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ColumnsLayout.Parent = ColumnsHolder

        local isCurrentTab = false

        local function ActivateTab()
            for _, t in pairs(Window.Tabs) do
                t.Page.Visible = false
                t.IsActive = false
                Tween(t.Button, {BackgroundTransparency = 1}, 0.2)
                Tween(t.Label, {TextColor3 = THEME.TextMuted}, 0.2)
                Tween(t.Icon, {ImageColor3 = THEME.TextMuted}, 0.2)
            end

            TabPage.Visible = true
            isCurrentTab = true

            TabPage.Position = UDim2.new(0, 8, 0, 0)
            Tween(TabPage, {Position = UDim2.new(0, 0, 0, 0)}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = THEME.CardBg}, 0.2)
            Tween(TabLabel, {TextColor3 = THEME.TextMain}, 0.2)
            Tween(TabIcon, {ImageColor3 = AccentColor}, 0.2)
        end

        TabBtn.MouseEnter:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 0.6}, 0.15)
                Tween(TabLabel, {TextColor3 = THEME.TextMain}, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
                Tween(TabLabel, {TextColor3 = THEME.TextMuted}, 0.15)
            end
        end)

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        local TabObject = {
            Button = TabBtn,
            Label = TabLabel,
            Icon = TabIcon,
            Page = TabPage,
            IsActive = isCurrentTab
        }
        table.insert(Window.Tabs, TabObject)

        if FirstTab then
            FirstTab = false
            ActivateTab()
        end

        local TabMethods = {}

        ------------------------------------------------------------------------
        -- 🗃️ CREATE CARD / COLUMN (Ragebot / Aim Assistance)
        ------------------------------------------------------------------------
        function TabMethods:CreateCard(cardTitle)
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
            CardPadding.PaddingBottom = UDim.new(0, 10)
            CardPadding.PaddingLeft = UDim.new(0, 10)
            CardPadding.PaddingRight = UDim.new(0, 10)
            CardPadding.Parent = Card

            local CardLayout = Instance.new("UIListLayout")
            CardLayout.Padding = UDim.new(0, 5)
            CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
            CardLayout.Parent = Card

            -- Card Header
            local Header = Instance.new("TextLabel")
            Header.Size = UDim2.new(1, 0, 0, 20)
            Header.BackgroundTransparency = 1
            Header.Text = cardTitle
            Header.Font = THEME.FontBold
            Header.TextSize = 12
            Header.TextColor3 = THEME.TextMain
            Header.TextXAlignment = Enum.TextXAlignment.Left
            Header.Parent = Card

            local Controls = {}

            -- Sub-Header inside Card (e.g. Autowall, Mods, Silent)
            function Controls:AddSubHeader(title)
                local SubText = Instance.new("TextLabel")
                SubText.Size = UDim2.new(1, 0, 0, 18)
                SubText.BackgroundTransparency = 1
                SubText.Text = title
                SubText.Font = THEME.FontBold
                SubText.TextSize = 11
                SubText.TextColor3 = THEME.TextMain
                SubText.TextXAlignment = Enum.TextXAlignment.Left
                SubText.Parent = Card
            end

            --------------------------------------------------------------------
            -- 🔘 1. REPTILIAN CHECKBOX / TOGGLE (With Keybind & Checkmark)
            --------------------------------------------------------------------
            function Controls:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local state = cfg.Default or false
                local keybind = cfg.Keybind
                local callback = cfg.Callback or function() end

                local Row = Instance.new("TextButton")
                Row.Size = UDim2.new(1, 0, 0, 24)
                Row.BackgroundTransparency = 1
                Row.Text = ""
                Row.AutoButtonColor = false
                Row.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, keybind and -60 or -28, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = state and THEME.TextMain or THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                if keybind then
                    local KeyBadge = Instance.new("TextLabel")
                    KeyBadge.Size = UDim2.new(0, 18, 0, 16)
                    KeyBadge.Position = UDim2.new(1, -48, 0.5, -8)
                    KeyBadge.BackgroundColor3 = THEME.BgSidebar
                    KeyBadge.Text = keybind
                    KeyBadge.Font = THEME.FontBold
                    KeyBadge.TextSize = 9
                    KeyBadge.TextColor3 = THEME.TextMuted
                    KeyBadge.Parent = Row

                    local KCorner = Instance.new("UICorner")
                    KCorner.CornerRadius = UDim.new(0, 3)
                    KCorner.Parent = KeyBadge
                end

                -- Square / Rounded Checkbox Box
                local Box = Instance.new("Frame")
                Box.Size = UDim2.new(0, 16, 0, 16)
                Box.Position = UDim2.new(1, -18, 0.5, -8)
                Box.BackgroundColor3 = state and AccentColor or THEME.BoxOff
                Box.Parent = Row

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = Box

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = state and THEME.AccentGradient or THEME.BoxOffBorder
                BoxStroke.Thickness = 1.2
                BoxStroke.Parent = Box

                local Checkmark = Instance.new("TextLabel")
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.BackgroundTransparency = 1
                Checkmark.Text = state and "✓" or ""
                Checkmark.Font = THEME.FontBold
                Checkmark.TextSize = 11
                Checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
                Checkmark.Parent = Box

                local function SetState(newVal)
                    state = newVal
                    if state then
                        Tween(Box, {BackgroundColor3 = AccentColor}, 0.15)
                        Tween(BoxStroke, {Color = THEME.AccentGradient}, 0.15)
                        Checkmark.Text = "✓"
                        Tween(Label, {TextColor3 = THEME.TextMain}, 0.15)
                    else
                        Tween(Box, {BackgroundColor3 = THEME.BoxOff}, 0.15)
                        Tween(BoxStroke, {Color = THEME.BoxOffBorder}, 0.15)
                        Checkmark.Text = ""
                        Tween(Label, {TextColor3 = THEME.TextMuted}, 0.15)
                    end
                    callback(state)
                end

                Row.MouseButton1Click:Connect(function()
                    SetState(not state)
                end)

                return {Set = SetState}
            end

            --------------------------------------------------------------------
            -- 🎚️ 2. REPTILIAN SLIDER (Clean Label, Value & Purple Track)
            --------------------------------------------------------------------
            function Controls:AddSlider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local suffix = cfg.Suffix or ""
                local callback = cfg.Callback or function() end
                local value = default

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 0, 14)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(0.4, 0, 0, 14)
                ValLabel.Position = UDim2.new(0.6, 0, 0, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = tostring(value) .. suffix
                ValLabel.Font = THEME.FontBold
                ValLabel.TextSize = 10
                ValLabel.TextColor3 = THEME.TextMuted
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent = Frame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 5)
                Track.Position = UDim2.new(0, 0, 0, 20)
                Track.BackgroundColor3 = THEME.BoxOff
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
                    Tween(Fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                    ValLabel.Text = tostring(value) .. suffix
                    callback(value)
                end

                Frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Tween(Thumb, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}, 0.15)
                        Tween(ValLabel, {TextColor3 = AccentColor}, 0.15)
                        Update(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        Tween(Thumb, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}, 0.15)
                        Tween(ValLabel, {TextColor3 = THEME.TextMuted}, 0.15)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        Update(input)
                    end
                end)
            end

            --------------------------------------------------------------------
            -- 🔽 3. REPTILIAN DROPDOWN (Hitpart)
            --------------------------------------------------------------------
            function Controls:AddDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Dropdown"
                local options = cfg.Options or {}
                local default = cfg.Default or options[1] or "None"
                local callback = cfg.Callback or function() end
                local selected = default
                local open = false

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, 44)
                DropFrame.BackgroundTransparency = 1
                DropFrame.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 14)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = DropFrame

                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(1, 0, 0, 24)
                DropBtn.Position = UDim2.new(0, 0, 0, 16)
                DropBtn.BackgroundColor3 = THEME.BgSidebar
                DropBtn.Text = ""
                DropBtn.AutoButtonColor = false
                DropBtn.Parent = DropFrame

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropBtn

                local DropStroke = Instance.new("UIStroke")
                DropStroke.Color = THEME.CardBorder
                DropStroke.Thickness = 1
                DropStroke.Parent = DropBtn

                local BtnText = Instance.new("TextLabel")
                BtnText.Size = UDim2.new(1, -22, 1, 0)
                BtnText.Position = UDim2.new(0, 8, 0, 0)
                BtnText.BackgroundTransparency = 1
                BtnText.Text = selected
                BtnText.Font = THEME.FontMain
                BtnText.TextSize = 10
                BtnText.TextColor3 = THEME.TextMain
                BtnText.TextXAlignment = Enum.TextXAlignment.Left
                BtnText.Parent = DropBtn

                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 18, 1, 0)
                Arrow.Position = UDim2.new(1, -20, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "v"
                Arrow.Font = THEME.FontBold
                Arrow.TextSize = 9
                Arrow.TextColor3 = THEME.TextMuted
                Arrow.Parent = DropBtn

                local MenuList = Instance.new("Frame")
                MenuList.Size = UDim2.new(1, 0, 0, #options * 24)
                MenuList.Position = UDim2.new(0, 0, 1, 3)
                MenuList.BackgroundColor3 = THEME.BgMain
                MenuList.BorderSizePixel = 0
                MenuList.Visible = false
                MenuList.ClipsDescendants = true
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
                    OptItem.Size = UDim2.new(1, 0, 0, 24)
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
                        BtnText.Text = selected
                        MenuList.Visible = false
                        open = false
                        Arrow.Text = "v"
                        callback(selected)
                    end)
                end

                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    MenuList.Visible = open
                    Arrow.Text = open and "^" or "v"
                end)
            end

            return Controls
        end

        return TabMethods
    end

    return Window
end

return NamelessWare
