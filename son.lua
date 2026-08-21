--[[
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                   NAMELESS.LUA — REPTILIAN EDITION                    ║
    ║         Exact 1:1 CS:GO / Neverlose Layout & Design System            ║
    ║     3D ESP Avatar Preview (Spin), Keybind List, Watermark Bar,        ║
    ║     Round Color-Morph Toggles, Smooth Sliders & Full Touch Support    ║
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
-- 👑 REPTILIAN / NAMELESS.LUA CORE
--------------------------------------------------------------------------------
local Reptilian = {}
Reptilian.__index = Reptilian

-- Palette Identique à Reptilian / Neverlose
local THEME = {
    Accent = Color3.fromRGB(135, 95, 255),          -- Reptilian Electric Purple
    AccentGradient = Color3.fromRGB(165, 125, 255),
    AccentDark = Color3.fromRGB(95, 55, 205),
    BgMain = Color3.fromRGB(15, 15, 20),            -- Obsidian Main Body
    BgMainGradient = Color3.fromRGB(19, 19, 27),
    BgSidebar = Color3.fromRGB(11, 11, 15),         -- Dark Left Sidebar
    CardBg = Color3.fromRGB(19, 19, 26),            -- Card Surface
    CardBgGradient = Color3.fromRGB(23, 23, 32),
    CardBorder = Color3.fromRGB(32, 32, 44),        -- Sleek 1px Stroke
    TextMain = Color3.fromRGB(245, 245, 252),
    TextMuted = Color3.fromRGB(120, 120, 145),
    CircleOff = Color3.fromRGB(24, 24, 32),
    CircleOffBorder = Color3.fromRGB(42, 42, 56),
    KeybindTagBg = Color3.fromRGB(16, 16, 22),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
}

local RAW_LOGO_URL = "https://raw.githubusercontent.com/ApparentlyZen/image-namelessWare/main/165abdd521328d77324b02ce8a77e090_1780162334922.webp"

function Reptilian:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "nameless.lua"
    local SubTitle = config.SubTitle or "this is a window subname"
    local AccentColor = config.Accent or THEME.Accent
    local LogoUrl = config.LogoUrl or RAW_LOGO_URL

    -- Destroy old instance
    if _G.ReptilianInstance then
        pcall(function() _G.ReptilianInstance:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Reptilian_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GetSafeParent()
    _G.ReptilianInstance = ScreenGui

    local customLogoAsset = FetchCustomAsset(LogoUrl, "NamelessWare_Logo.webp")

    ----------------------------------------------------------------------------
    -- 📱 MOBILE FLOATING TOGGLE BUTTON (Custom Logo Image)
    ----------------------------------------------------------------------------
    local MobileBtn = Instance.new("ImageButton")
    MobileBtn.Name = "ReptilianMobileBtn"
    MobileBtn.Size = UDim2.new(0, 50, 0, 50)
    MobileBtn.Position = UDim2.new(0, 16, 0.5, -25)
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
        FallbackText.Text = "NL"
        FallbackText.Font = THEME.FontBold
        FallbackText.TextSize = 16
        FallbackText.TextColor3 = AccentColor
        FallbackText.Parent = MobileBtn
    end

    MakeDraggable(MobileBtn)

    ----------------------------------------------------------------------------
    -- 🖥️ MAIN WINDOW (Exact Reptilian Layout: 540x380px)
    ----------------------------------------------------------------------------
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 540, 0, 385)
    MainWindow.Position = UDim2.new(0.5, -270, 0.5, -192)
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

    -- Left Navigation Sidebar (Tabs on Side with Icons)
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

    -- Top Brand Header in Sidebar (Reptilian Logo + Subname)
    local BrandFrame = Instance.new("Frame")
    BrandFrame.Size = UDim2.new(1, 0, 0, 52)
    BrandFrame.BackgroundTransparency = 1
    BrandFrame.Parent = Sidebar

    local LogoBox = Instance.new("Frame")
    LogoBox.Size = UDim2.new(0, 24, 0, 24)
    LogoBox.Position = UDim2.new(0, 10, 0.5, -12)
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
        LogoTxt.Text = "NL"
        LogoTxt.Font = THEME.FontBold
        LogoTxt.TextSize = 11
        LogoTxt.TextColor3 = AccentColor
        LogoTxt.Parent = LogoBox
    end

    local BrandTitle = Instance.new("TextLabel")
    BrandTitle.Size = UDim2.new(1, -40, 0, 16)
    BrandTitle.Position = UDim2.new(0, 38, 0, 10)
    BrandTitle.BackgroundTransparency = 1
    BrandTitle.Text = Title
    BrandTitle.Font = THEME.FontBold
    BrandTitle.TextSize = 12
    BrandTitle.TextColor3 = THEME.TextMain
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
    BrandTitle.Parent = BrandFrame

    local BrandSub = Instance.new("TextLabel")
    BrandSub.Size = UDim2.new(1, -40, 0, 14)
    BrandSub.Position = UDim2.new(0, 38, 0, 26)
    BrandSub.BackgroundTransparency = 1
    BrandSub.Text = SubTitle
    BrandSub.Font = THEME.FontMain
    BrandSub.TextSize = 9
    BrandSub.TextColor3 = THEME.TextMuted
    BrandSub.TextXAlignment = Enum.TextXAlignment.Left
    BrandSub.Parent = BrandFrame

    MakeDraggable(MainWindow, BrandFrame)

    -- Sidebar Tabs Scroll List
    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Size = UDim2.new(1, -12, 1, -60)
    NavScroll.Position = UDim2.new(0, 6, 0, 54)
    NavScroll.BackgroundTransparency = 1
    NavScroll.ScrollBarThickness = 0
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 4)
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Parent = NavScroll

    -- Top Header in Content Area (Aimbot Tab Indicator & Mini Icons)
    local ContentHeader = Instance.new("Frame")
    ContentHeader.Name = "ContentHeader"
    ContentHeader.Size = UDim2.new(1, -145, 0, 40)
    ContentHeader.Position = UDim2.new(0, 142, 0, 4)
    ContentHeader.BackgroundTransparency = 1
    ContentHeader.Parent = MainWindow

    local HeaderTabName = Instance.new("TextLabel")
    HeaderTabName.Size = UDim2.new(0, 120, 1, 0)
    HeaderTabName.Position = UDim2.new(0, 10, 0, 0)
    HeaderTabName.BackgroundTransparency = 1
    HeaderTabName.Text = "Aimbot"
    HeaderTabName.Font = THEME.FontBold
    HeaderTabName.TextSize = 13
    HeaderTabName.TextColor3 = THEME.TextMain
    HeaderTabName.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabName.Parent = ContentHeader

    -- Right Mini Icons (Crosshair, Eye, Gear)
    local TopIcon1 = Instance.new("ImageLabel")
    TopIcon1.Size = UDim2.new(0, 15, 0, 15)
    TopIcon1.Position = UDim2.new(1, -65, 0.5, -7.5)
    TopIcon1.BackgroundTransparency = 1
    TopIcon1.Image = "rbxassetid://10734975692"
    TopIcon1.ImageColor3 = AccentColor
    TopIcon1.Parent = ContentHeader

    local TopIcon2 = Instance.new("ImageLabel")
    TopIcon2.Size = UDim2.new(0, 15, 0, 15)
    TopIcon2.Position = UDim2.new(1, -42, 0.5, -7.5)
    TopIcon2.BackgroundTransparency = 1
    TopIcon2.Image = "rbxassetid://10723415903"
    TopIcon2.ImageColor3 = THEME.TextMuted
    TopIcon2.Parent = ContentHeader

    local TopIcon3 = Instance.new("ImageLabel")
    TopIcon3.Size = UDim2.new(0, 15, 0, 15)
    TopIcon3.Position = UDim2.new(1, -20, 0.5, -7.5)
    TopIcon3.BackgroundTransparency = 1
    TopIcon3.Image = "rbxassetid://10709791437"
    TopIcon3.ImageColor3 = THEME.TextMuted
    TopIcon3.Parent = ContentHeader

    MakeDraggable(MainWindow, ContentHeader)

    -- Content Area (Dual Columns)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -148, 1, -48)
    ContentArea.Position = UDim2.new(0, 144, 0, 44)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow

    ----------------------------------------------------------------------------
    -- 📦 REPTILIAN FLOATING WIDGETS (Keybinds, 3D ESP Preview, Watermark)
    ----------------------------------------------------------------------------

    -- 1. Keybind List Widget (Left of Main Window)
    local KeybindWidget = Instance.new("Frame")
    KeybindWidget.Name = "KeybindWidget"
    KeybindWidget.Size = UDim2.new(0, 140, 0, 75)
    KeybindWidget.Position = UDim2.new(0.5, -425, 0.5, -35)
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
    KeybindHeader.Size = UDim2.new(1, 0, 0, 22)
    KeybindHeader.BackgroundTransparency = 1
    KeybindHeader.Text = "Keybind List"
    KeybindHeader.Font = THEME.FontBold
    KeybindHeader.TextSize = 10
    KeybindHeader.TextColor3 = THEME.TextMain
    KeybindHeader.Parent = KeybindWidget

    local KeybindList = Instance.new("Frame")
    KeybindList.Size = UDim2.new(1, -12, 1, -26)
    KeybindList.Position = UDim2.new(0, 6, 0, 24)
    KeybindList.BackgroundTransparency = 1
    KeybindList.Parent = KeybindWidget

    local KeybindItem1 = Instance.new("TextLabel")
    KeybindItem1.Size = UDim2.new(1, 0, 0, 16)
    KeybindItem1.BackgroundTransparency = 1
    KeybindItem1.Text = "Ragebot  [Z]  [hold]"
    KeybindItem1.Font = THEME.FontMain
    KeybindItem1.TextSize = 9
    KeybindItem1.TextColor3 = THEME.TextMuted
    KeybindItem1.Parent = KeybindList

    local KeybindItem2 = Instance.new("TextLabel")
    KeybindItem2.Size = UDim2.new(1, 0, 0, 16)
    KeybindItem2.Position = UDim2.new(0, 0, 0, 18)
    KeybindItem2.BackgroundTransparency = 1
    KeybindItem2.Text = "Aim Assist  [F]  [toggle]"
    KeybindItem2.Font = THEME.FontMain
    KeybindItem2.TextSize = 9
    KeybindItem2.TextColor3 = AccentColor
    KeybindItem2.Parent = KeybindList

    MakeDraggable(KeybindWidget)

    -- 2. ESP Preview Widget (Right of Main Window with Interactive 3D Avatar & Spin)
    local ESPWidget = Instance.new("Frame")
    ESPWidget.Name = "ESPWidget"
    ESPWidget.Size = UDim2.new(0, 125, 0, 160)
    ESPWidget.Position = UDim2.new(0.5, 280, 0.5, -192)
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
    ESPHeader.TextSize = 10
    ESPHeader.TextColor3 = THEME.TextMain
    ESPHeader.Parent = ESPWidget

    -- 3D Avatar Preview Container / Viewport
    local ESPDummyImg = Instance.new("ImageLabel")
    ESPDummyImg.Size = UDim2.new(0, 80, 0, 100)
    ESPDummyImg.Position = UDim2.new(0.5, -40, 0, 24)
    ESPDummyImg.BackgroundTransparency = 1
    ESPDummyImg.Image = "rbxassetid://10723346959"
    ESPDummyImg.ImageColor3 = Color3.fromRGB(215, 215, 255)
    ESPDummyImg.Parent = ESPWidget

    -- 2D ESP Box Frame Overlay
    local ESPBox = Instance.new("Frame")
    ESPBox.Size = UDim2.new(0, 60, 0, 88)
    ESPBox.Position = UDim2.new(0.5, -30, 0, 28)
    ESPBox.BackgroundTransparency = 1
    ESPBox.Parent = ESPWidget

    local ESPBoxStroke = Instance.new("UIStroke")
    ESPBoxStroke.Color = AccentColor
    ESPBoxStroke.Thickness = 1.5
    ESPBoxStroke.Parent = ESPBox

    local ESPFooter = Instance.new("TextLabel")
    ESPFooter.Size = UDim2.new(1, 0, 0, 20)
    ESPFooter.Position = UDim2.new(0, 0, 1, -22)
    ESPFooter.BackgroundTransparency = 1
    ESPFooter.Text = "Spin • 2D Box"
    ESPFooter.Font = THEME.FontMain
    ESPFooter.TextSize = 9
    ESPFooter.TextColor3 = THEME.TextMuted
    ESPFooter.Parent = ESPWidget

    MakeDraggable(ESPWidget)

    -- 3. Bottom Watermark Pill Status Bar
    local WatermarkBar = Instance.new("Frame")
    WatermarkBar.Name = "WatermarkBar"
    WatermarkBar.Size = UDim2.new(0, 280, 0, 26)
    WatermarkBar.Position = UDim2.new(0.5, -140, 0.5, 200)
    WatermarkBar.BackgroundColor3 = THEME.BgMain
    WatermarkBar.Parent = ScreenGui

    local WatermarkCorner = Instance.new("UICorner")
    WatermarkCorner.CornerRadius = UDim.new(0, 6)
    WatermarkCorner.Parent = WatermarkBar

    local WatermarkStroke = Instance.new("UIStroke")
    WatermarkStroke.Color = THEME.CardBorder
    WatermarkStroke.Thickness = 1
    WatermarkStroke.Parent = WatermarkBar

    local WmIcon = Instance.new("ImageLabel")
    WmIcon.Size = UDim2.new(0, 14, 0, 14)
    WmIcon.Position = UDim2.new(0, 8, 0.5, -7)
    WmIcon.BackgroundTransparency = 1
    WmIcon.Image = "rbxassetid://10734975692"
    WmIcon.ImageColor3 = AccentColor
    WmIcon.Parent = WatermarkBar

    local WatermarkText = Instance.new("TextLabel")
    WatermarkText.Size = UDim2.new(1, -28, 1, 0)
    WatermarkText.Position = UDim2.new(0, 26, 0, 0)
    WatermarkText.BackgroundTransparency = 1
    WatermarkText.Text = "nameless.lua ~ v1.0 • FPS: 60 • PING: 32MS"
    WatermarkText.Font = THEME.FontMain
    WatermarkText.TextSize = 9
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
                WatermarkText.Text = string.format("%s ~ v1.0 • FPS: %d • PING: %dMS", Title, fps, ping)
            end
        end)
    end)

    -- Mobile Toggle Action
    local isUIOpen = true
    local function ToggleUI()
        isUIOpen = not isUIOpen
        MainWindow.Visible = isUIOpen
        KeybindWidget.Visible = isUIOpen
        ESPWidget.Visible = isUIOpen
        WatermarkBar.Visible = isUIOpen
    end

    MobileBtn.MouseButton1Click:Connect(function()
        Tween(MobileBtn, {Size = UDim2.new(0, 44, 0, 44)}, 0.08)
        task.wait(0.08)
        Tween(MobileBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.12)
        ToggleUI()
    end)

    local Window = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        MobileBtn = MobileBtn,
        KeybindWidget = KeybindWidget,
        ESPWidget = ESPWidget,
        WatermarkBar = WatermarkBar,
        NavScroll = NavScroll,
        ContentArea = ContentArea,
        Tabs = {}
    }

    local FirstTab = true

    ----------------------------------------------------------------------------
    -- 📑 CREATE TAB (Sidebar Item)
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
        TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId
        TabIcon.ImageColor3 = THEME.TextMuted
        TabIcon.Parent = TabBtn

        local TabTitle = Instance.new("TextLabel")
        TabTitle.Size = UDim2.new(1, -34, 1, 0)
        TabTitle.Position = UDim2.new(0, 32, 0, 0)
        TabTitle.BackgroundTransparency = 1
        TabTitle.Text = name
        TabTitle.Font = THEME.FontMain
        TabTitle.TextSize = 11
        TabTitle.TextColor3 = THEME.TextMuted
        TabTitle.TextXAlignment = Enum.TextXAlignment.Left
        TabTitle.Parent = TabBtn

        -- Content Page (Dual Column Layout)
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
        ColumnsHolder.Size = UDim2.new(1, -6, 0, 0)
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
                Tween(t.Title, {TextColor3 = THEME.TextMuted}, 0.2)
                Tween(t.Icon, {ImageColor3 = THEME.TextMuted}, 0.2)
            end

            TabPage.Visible = true
            isCurrentTab = true
            HeaderTabName.Text = name

            TabPage.Position = UDim2.new(0, 8, 0, 0)
            Tween(TabPage, {Position = UDim2.new(0, 0, 0, 0)}, 0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            Tween(TabBtn, {BackgroundTransparency = 0, BackgroundColor3 = THEME.CardBg}, 0.2)
            Tween(TabTitle, {TextColor3 = THEME.TextMain}, 0.2)
            Tween(TabIcon, {ImageColor3 = AccentColor}, 0.2)
        end

        TabBtn.MouseEnter:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 0.8}, 0.15)
                Tween(TabTitle, {TextColor3 = THEME.TextMain}, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
                Tween(TabTitle, {TextColor3 = THEME.TextMuted}, 0.15)
            end
        end)

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        local TabObj = {
            Button = TabBtn,
            Title = TabTitle,
            Icon = TabIcon,
            Page = TabPage,
            IsActive = isCurrentTab
        }
        table.insert(Window.Tabs, TabObj)

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
            CardPadding.PaddingBottom = UDim.new(0, 12)
            CardPadding.PaddingLeft = UDim.new(0, 10)
            CardPadding.PaddingRight = UDim.new(0, 10)
            CardPadding.Parent = Card

            local CardLayout = Instance.new("UIListLayout")
            CardLayout.Padding = UDim.new(0, 6)
            CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
            CardLayout.Parent = Card

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

            -- Sub-Header (e.g. Mods, Silent, Effects)
            function Controls:AddSubHeader(title)
                local SubText = Instance.new("TextLabel")
                SubText.Size = UDim2.new(1, 0, 0, 20)
                SubText.BackgroundTransparency = 1
                SubText.Text = title
                SubText.Font = THEME.FontBold
                SubText.TextSize = 11
                SubText.TextColor3 = THEME.TextMain
                SubText.TextXAlignment = Enum.TextXAlignment.Left
                SubText.Parent = Card
            end

            --------------------------------------------------------------------
            -- 🔘 1. REPTILIAN ROUND TOGGLE (With Color Morph & Keybind Badge)
            --------------------------------------------------------------------
            function Controls:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local state = cfg.Default or false
                local keybind = cfg.Keybind
                local callback = cfg.Callback or function() end

                local RowBtn = Instance.new("TextButton")
                RowBtn.Size = UDim2.new(1, 0, 0, 26)
                RowBtn.BackgroundTransparency = 1
                RowBtn.Text = ""
                RowBtn.AutoButtonColor = false
                RowBtn.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, keybind and -60 or -30, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = state and THEME.TextMain or THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = RowBtn

                if keybind then
                    local KeyBadge = Instance.new("TextLabel")
                    KeyBadge.Size = UDim2.new(0, 18, 0, 16)
                    KeyBadge.Position = UDim2.new(1, -52, 0.5, -8)
                    KeyBadge.BackgroundColor3 = THEME.KeybindTagBg
                    KeyBadge.Text = keybind
                    KeyBadge.Font = THEME.FontBold
                    KeyBadge.TextSize = 9
                    KeyBadge.TextColor3 = THEME.TextMuted
                    KeyBadge.Parent = RowBtn

                    local KCorner = Instance.new("UICorner")
                    KCorner.CornerRadius = UDim.new(0, 4)
                    KCorner.Parent = KeyBadge

                    local KStroke = Instance.new("UIStroke")
                    KStroke.Color = THEME.CardBorder
                    KStroke.Thickness = 1
                    KStroke.Parent = KeyBadge
                end

                -- Round Toggle Indicator
                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 18, 0, 18)
                Circle.Position = UDim2.new(1, -20, 0.5, -9)
                Circle.BackgroundColor3 = state and AccentColor or THEME.CircleOff
                Circle.Parent = RowBtn

                local CCorn = Instance.new("UICorner")
                CCorn.CornerRadius = UDim.new(1, 0)
                CCorn.Parent = Circle

                local CStroke = Instance.new("UIStroke")
                CStroke.Color = state and THEME.AccentGradient or THEME.CircleOffBorder
                CStroke.Thickness = 1.2
                CStroke.Parent = Circle

                local Dot = Instance.new("Frame")
                Dot.Size = state and UDim2.new(0, 8, 0, 8) or UDim2.new(0, 0, 0, 0)
                Dot.Position = UDim2.new(0.5, 0, 0.5, 0)
                Dot.AnchorPoint = Vector2.new(0.5, 0.5)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dot.Parent = Circle

                local DCorn = Instance.new("UICorner")
                DCorn.CornerRadius = UDim.new(1, 0)
                DCorn.Parent = Dot

                local function SetState(newVal)
                    state = newVal
                    if state then
                        Tween(Circle, {BackgroundColor3 = AccentColor}, 0.2)
                        Tween(CStroke, {Color = THEME.AccentGradient}, 0.2)
                        Tween(Dot, {Size = UDim2.new(0, 8, 0, 8)}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Tween(Label, {TextColor3 = THEME.TextMain}, 0.2)
                    else
                        Tween(Circle, {BackgroundColor3 = THEME.CircleOff}, 0.2)
                        Tween(CStroke, {Color = THEME.CircleOffBorder}, 0.2)
                        Tween(Dot, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
                        Tween(Label, {TextColor3 = THEME.TextMuted}, 0.2)
                    end
                    callback(state)
                end

                RowBtn.MouseButton1Click:Connect(function()
                    Tween(Circle, {Size = UDim2.new(0, 21, 0, 21), Position = UDim2.new(1, -21.5, 0.5, -10.5)}, 0.08)
                    task.wait(0.08)
                    Tween(Circle, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -20, 0.5, -9)}, 0.12)
                    SetState(not state)
                end)

                return {Set = SetState}
            end

            --------------------------------------------------------------------
            -- 🎚️ 2. REPTILIAN SLIDER (With Suffix e.g. 10st, 1s, 0.1s, 0%, 1x)
            --------------------------------------------------------------------
            function Controls:AddSlider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local suffix = cfg.Suffix or ""
                local decimals = cfg.Decimals or 0
                local callback = cfg.Callback or function() end
                local value = default

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 42)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.65, 0, 0, 16)
                Label.Position = UDim2.new(0, 0, 0, 2)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(0.35, 0, 0, 16)
                ValLabel.Position = UDim2.new(0.65, 0, 0, 2)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = string.format("%." .. decimals .. "f%s", value, suffix)
                ValLabel.Font = THEME.FontBold
                ValLabel.TextSize = 10
                ValLabel.TextColor3 = THEME.TextMuted
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent = Frame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 5)
                Track.Position = UDim2.new(0, 0, 0, 24)
                Track.BackgroundColor3 = THEME.CircleOff
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
                Thumb.Size = UDim2.new(0, 13, 0, 13)
                Thumb.Position = UDim2.new(1, -6.5, 0.5, -6.5)
                Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Thumb.ZIndex = 5
                Thumb.Parent = Fill

                local ThumbCorner = Instance.new("UICorner")
                ThumbCorner.CornerRadius = UDim.new(1, 0)
                ThumbCorner.Parent = Thumb

                local ThumbStroke = Instance.new("UIStroke")
                ThumbStroke.Color = AccentColor
                ThumbStroke.Thickness = 2
                ThumbStroke.Parent = Thumb

                local dragging = false
                local function Update(input)
                    local absPos = Track.AbsolutePosition.X
                    local absSize = Track.AbsoluteSize.X
                    local pct = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                    value = min + (max - min) * pct
                    if decimals == 0 then
                        value = math.floor(value)
                    end
                    Tween(Fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                    ValLabel.Text = string.format("%." .. decimals .. "f%s", value, suffix)
                    callback(value)
                end

                Frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Tween(Thumb, {Size = UDim2.new(0, 17, 0, 17), Position = UDim2.new(1, -8.5, 0.5, -8.5)}, 0.15)
                        Tween(ValLabel, {TextColor3 = AccentColor}, 0.15)
                        Update(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        Tween(Thumb, {Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(1, -6.5, 0.5, -6.5)}, 0.15)
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
            -- 🔽 3. REPTILIAN DROPDOWN (Hitpart: Head)
            --------------------------------------------------------------------
            function Controls:AddDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Hitpart"
                local options = cfg.Options or {"Head", "Torso", "Random"}
                local default = cfg.Default or options[1]
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
                BtnText.Size = UDim2.new(1, -24, 1, 0)
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
                    OptItem.AutoButtonColor = false
                    OptItem.Parent = MenuList

                    OptItem.MouseEnter:Connect(function()
                        Tween(OptItem, {BackgroundTransparency = 0.8, TextColor3 = THEME.TextMain}, 0.15)
                    end)

                    OptItem.MouseLeave:Connect(function()
                        Tween(OptItem, {BackgroundTransparency = 1, TextColor3 = (opt == selected) and AccentColor or THEME.TextMuted}, 0.15)
                    end)

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
                    if open then
                        MenuList.Size = UDim2.new(1, 0, 0, 0)
                        Tween(MenuList, {Size = UDim2.new(1, 0, 0, #options * 24)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    end
                end)
            end

            --------------------------------------------------------------------
            -- 🎨 4. TRACERS / COLOR PREVIEW BOXES
            --------------------------------------------------------------------
            function Controls:AddColorPicker(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Tracers"
                local defaultColor = cfg.Default or Color3.fromRGB(255, 255, 255)
                local callback = cfg.Callback or function() end

                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 26)
                Row.BackgroundTransparency = 1
                Row.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -40, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMain
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                local ColorBox = Instance.new("TextButton")
                ColorBox.Size = UDim2.new(0, 16, 0, 16)
                ColorBox.Position = UDim2.new(1, -18, 0.5, -8)
                ColorBox.BackgroundColor3 = defaultColor
                ColorBox.Text = ""
                ColorBox.AutoButtonColor = false
                ColorBox.Parent = Row

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = ColorBox

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = THEME.CardBorder
                BoxStroke.Thickness = 1
                BoxStroke.Parent = ColorBox
            end

            return Controls
        end

        return TabMethods
    end

    return Window
end

return Reptilian
