--[[
    ╔═══════════════════════════════════════════════════════════════════════╗
    ║                        NAMELESS WARE UI LIBRARY                       ║
    ║         Custom Round Toggles • Round Mobile Sliders & Dropdowns       ║
    ║         100% Touch Optimized • High Hitbox Comfort • Ultra Smooth     ║
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
-- 👑 NAMELESS WARE ENGINE
--------------------------------------------------------------------------------
local NamelessWare = {}
NamelessWare.__index = NamelessWare

-- Curated Neon Purple Theme
local THEME = {
    Accent = Color3.fromRGB(165, 95, 255),          -- Vibrant Purple Glow
    AccentGradient = Color3.fromRGB(195, 135, 255),  -- Light Purple Gradient
    AccentDark = Color3.fromRGB(120, 50, 220),      -- Deep Purple
    BgMain = Color3.fromRGB(16, 16, 23),            -- Obsidian Main Body
    BgMainGradient = Color3.fromRGB(20, 20, 29),
    BgSidebar = Color3.fromRGB(13, 13, 18),         -- Dark Sidebar
    CardBg = Color3.fromRGB(22, 22, 31),            -- Card Surface
    CardBgGradient = Color3.fromRGB(26, 26, 37),
    CardBorder = Color3.fromRGB(38, 38, 54),        -- Outline
    TextMain = Color3.fromRGB(245, 245, 252),
    TextMuted = Color3.fromRGB(135, 135, 160),
    CircleOff = Color3.fromRGB(28, 28, 38),
    CircleOffBorder = Color3.fromRGB(48, 48, 66),
    FontMain = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
}

local RAW_LOGO_URL = "https://raw.githubusercontent.com/ApparentlyZen/image-namelessWare/main/165abdd521328d77324b02ce8a77e090_1780162334922.webp"

function NamelessWare:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NAMELESS WARE"
    local SubTitle = config.SubTitle or "Combat - default hotkeys"
    local AccentColor = config.Accent or THEME.Accent
    local LogoUrl = config.LogoUrl or RAW_LOGO_URL

    -- Destroy old instance
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
    -- 📱 MOBILE FLOATING TOGGLE BUTTON
    ----------------------------------------------------------------------------
    local MobileBtn = Instance.new("ImageButton")
    MobileBtn.Name = "NamelessMobileBtn"
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
        FallbackText.Text = "NW"
        FallbackText.Font = THEME.FontBold
        FallbackText.TextSize = 16
        FallbackText.TextColor3 = AccentColor
        FallbackText.Parent = MobileBtn
    end

    MakeDraggable(MobileBtn)

    ----------------------------------------------------------------------------
    -- 🖥️ MAIN WINDOW
    ----------------------------------------------------------------------------
    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 590, 0, 420)
    MainWindow.Position = UDim2.new(0.5, -295, 0.5, -210)
    MainWindow.BackgroundColor3 = THEME.BgMain
    MainWindow.BorderSizePixel = 0
    MainWindow.ClipsDescendants = false
    MainWindow.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainWindow

    local MainGrad = Instance.new("UIGradient")
    MainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.BgMainGradient),
        ColorSequenceKeypoint.new(1, THEME.BgMain)
    })
    MainGrad.Rotation = 90
    MainGrad.Parent = MainWindow

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = THEME.CardBorder
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainWindow

    -- Left Navigation Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 145, 1, 0)
    Sidebar.BackgroundColor3 = THEME.BgSidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
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
    LogoBox.Size = UDim2.new(0, 26, 0, 26)
    LogoBox.Position = UDim2.new(0, 12, 0.5, -13)
    LogoBox.BackgroundColor3 = THEME.CardBg
    LogoBox.Parent = BrandFrame

    local LogoBoxCorner = Instance.new("UICorner")
    LogoBoxCorner.CornerRadius = UDim.new(0, 7)
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
        LogoTxt.Text = "NW"
        LogoTxt.Font = THEME.FontBold
        LogoTxt.TextSize = 12
        LogoTxt.TextColor3 = AccentColor
        LogoTxt.Parent = LogoBox
    end

    local BrandTitle = Instance.new("TextLabel")
    BrandTitle.Size = UDim2.new(1, -48, 1, 0)
    BrandTitle.Position = UDim2.new(0, 44, 0, 0)
    BrandTitle.BackgroundTransparency = 1
    BrandTitle.Text = Title
    BrandTitle.Font = THEME.FontBold
    BrandTitle.TextSize = 12
    BrandTitle.TextColor3 = THEME.TextMain
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
    BrandTitle.Parent = BrandFrame

    MakeDraggable(MainWindow, BrandFrame)

    -- Sidebar Category & Tab Scroll List
    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Size = UDim2.new(1, -12, 1, -55)
    NavScroll.Position = UDim2.new(0, 6, 0, 50)
    NavScroll.BackgroundTransparency = 1
    NavScroll.ScrollBarThickness = 0
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 4)
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Parent = NavScroll

    -- Top Header in Content Area
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, -155, 0, 45)
    HeaderFrame.Position = UDim2.new(0, 150, 0, 5)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = MainWindow

    local HeaderTabTitle = Instance.new("TextLabel")
    HeaderTabTitle.Size = UDim2.new(1, 0, 0, 20)
    HeaderTabTitle.Position = UDim2.new(0, 8, 0, 4)
    HeaderTabTitle.BackgroundTransparency = 1
    HeaderTabTitle.Text = "Combat"
    HeaderTabTitle.Font = THEME.FontBold
    HeaderTabTitle.TextSize = 14
    HeaderTabTitle.TextColor3 = THEME.TextMain
    HeaderTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabTitle.Parent = HeaderFrame

    local HeaderTabSub = Instance.new("TextLabel")
    HeaderTabSub.Size = UDim2.new(1, 0, 0, 14)
    HeaderTabSub.Position = UDim2.new(0, 8, 0, 24)
    HeaderTabSub.BackgroundTransparency = 1
    HeaderTabSub.Text = SubTitle
    HeaderTabSub.Font = THEME.FontMain
    HeaderTabSub.TextSize = 10
    HeaderTabSub.TextColor3 = THEME.TextMuted
    HeaderTabSub.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabSub.Parent = HeaderFrame

    MakeDraggable(MainWindow, HeaderFrame)

    -- Content Container (Holds Tab Pages)
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -155, 1, -55)
    ContentArea.Position = UDim2.new(0, 150, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow

    -- Mobile Toggle
    local isUIOpen = true
    local function ToggleUI()
        isUIOpen = not isUIOpen
        if isUIOpen then
            MainWindow.Visible = true
            MainWindow.Position = UDim2.new(0.5, -295, 0.5, -180)
            Tween(MainWindow, {Position = UDim2.new(0.5, -295, 0.5, -210)}, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            Tween(MainWindow, {Position = UDim2.new(0.5, -295, 0.5, -180)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.2)
            if not isUIOpen then
                MainWindow.Visible = false
            end
        end
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
        NavScroll = NavScroll,
        ContentArea = ContentArea,
        Tabs = {}
    }

    local FirstTab = true

    ----------------------------------------------------------------------------
    -- 📁 ADD CATEGORY
    ----------------------------------------------------------------------------
    function Window:AddCategory(catName)
        local Cat = Instance.new("TextLabel")
        Cat.Size = UDim2.new(1, 0, 0, 22)
        Cat.BackgroundTransparency = 1
        Cat.Text = "  " .. string.upper(catName)
        Cat.Font = THEME.FontBold
        Cat.TextSize = 9
        Cat.TextColor3 = Color3.fromRGB(110, 110, 135)
        Cat.TextXAlignment = Enum.TextXAlignment.Left
        Cat.Parent = NavScroll
    end

    ----------------------------------------------------------------------------
    -- 📑 CREATE TAB
    ----------------------------------------------------------------------------
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local name = tabConfig.Name or "Tab"
        local iconId = tabConfig.Icon or "rbxassetid://10734975692"
        local subText = tabConfig.Subtitle or (name .. " - default hotkeys")

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = AccentColor
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = NavScroll

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 7)
        TabBtnCorner.Parent = TabBtn

        local TabGrad = Instance.new("UIGradient")
        TabGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME.AccentGradient),
            ColorSequenceKeypoint.new(1, THEME.AccentDark)
        })
        TabGrad.Rotation = 90
        TabGrad.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Position = UDim2.new(0, 9, 0.5, -8)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId
        TabIcon.ImageColor3 = THEME.TextMuted
        TabIcon.Parent = TabBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -32, 1, 0)
        TabLabel.Position = UDim2.new(0, 30, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.Font = THEME.FontMain
        TabLabel.TextSize = 11
        TabLabel.TextColor3 = THEME.TextMuted
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        -- Content Page (2 Columns)
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
                Tween(t.Label, {TextColor3 = THEME.TextMuted}, 0.2)
                Tween(t.Icon, {ImageColor3 = THEME.TextMuted}, 0.2)
            end

            TabPage.Visible = true
            isCurrentTab = true
            HeaderTabTitle.Text = name
            HeaderTabSub.Text = subText

            TabPage.Position = UDim2.new(0, 8, 0, 0)
            Tween(TabPage, {Position = UDim2.new(0, 0, 0, 0)}, 0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

            Tween(TabBtn, {BackgroundTransparency = 0}, 0.2)
            Tween(TabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            Tween(TabIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        end

        TabBtn.MouseEnter:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 0.8}, 0.15)
                Tween(TabLabel, {TextColor3 = THEME.TextMain}, 0.15)
                Tween(TabIcon, {ImageColor3 = THEME.TextMain}, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
                Tween(TabLabel, {TextColor3 = THEME.TextMuted}, 0.15)
                Tween(TabIcon, {ImageColor3 = THEME.TextMuted}, 0.15)
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
        -- 🗃️ CREATE SECTION / CARD
        ------------------------------------------------------------------------
        function TabMethods:CreateSection(secTitle, secIcon)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(0.5, -4, 0, 0)
            Card.AutomaticSize = Enum.AutomaticSize.Y
            Card.BackgroundColor3 = THEME.CardBg
            Card.BorderSizePixel = 0
            Card.Parent = ColumnsHolder

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 10)
            CardCorner.Parent = Card

            local CardGrad = Instance.new("UIGradient")
            CardGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, THEME.CardBgGradient),
                ColorSequenceKeypoint.new(1, THEME.CardBg)
            })
            CardGrad.Rotation = 90
            CardGrad.Parent = Card

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = THEME.CardBorder
            CardStroke.Thickness = 1
            CardStroke.Parent = Card

            local CardPadding = Instance.new("UIPadding")
            CardPadding.PaddingTop = UDim.new(0, 9)
            CardPadding.PaddingBottom = UDim.new(0, 9)
            CardPadding.PaddingLeft = UDim.new(0, 11)
            CardPadding.PaddingRight = UDim.new(0, 11)
            CardPadding.Parent = Card

            local CardLayout = Instance.new("UIListLayout")
            CardLayout.Padding = UDim.new(0, 6)
            CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
            CardLayout.Parent = Card

            -- Card Header
            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 20)
            Header.BackgroundTransparency = 1
            Header.Parent = Card

            local HeaderIcon = Instance.new("ImageLabel")
            HeaderIcon.Size = UDim2.new(0, 14, 0, 14)
            HeaderIcon.Position = UDim2.new(0, 0, 0.5, -7)
            HeaderIcon.BackgroundTransparency = 1
            HeaderIcon.Image = secIcon or "rbxassetid://10734975692"
            HeaderIcon.ImageColor3 = AccentColor
            HeaderIcon.Parent = Header

            local HeaderLabel = Instance.new("TextLabel")
            HeaderLabel.Size = UDim2.new(1, -20, 1, 0)
            HeaderLabel.Position = UDim2.new(0, 20, 0, 0)
            HeaderLabel.BackgroundTransparency = 1
            HeaderLabel.Text = secTitle
            HeaderLabel.Font = THEME.FontBold
            HeaderLabel.TextSize = 12
            HeaderLabel.TextColor3 = THEME.TextMain
            HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
            HeaderLabel.Parent = Header

            local Controls = {}

            -- Sub-Header Divider inside Card
            function Controls:AddSubHeader(title, icon)
                local SubHeader = Instance.new("Frame")
                SubHeader.Size = UDim2.new(1, 0, 0, 22)
                SubHeader.BackgroundTransparency = 1
                SubHeader.Parent = Card

                local SubIcon = Instance.new("ImageLabel")
                SubIcon.Size = UDim2.new(0, 12, 0, 12)
                SubIcon.Position = UDim2.new(0, 0, 0.5, -6)
                SubIcon.BackgroundTransparency = 1
                SubIcon.Image = icon or "rbxassetid://10734975692"
                SubIcon.ImageColor3 = AccentColor
                SubIcon.Parent = SubHeader

                local SubText = Instance.new("TextLabel")
                SubText.Size = UDim2.new(1, -18, 1, 0)
                SubText.Position = UDim2.new(0, 18, 0, 0)
                SubText.BackgroundTransparency = 1
                SubText.Text = title
                SubText.Font = THEME.FontBold
                SubText.TextSize = 11
                SubText.TextColor3 = THEME.TextMain
                SubText.TextXAlignment = Enum.TextXAlignment.Left
                SubText.Parent = SubHeader
            end

            --------------------------------------------------------------------
            -- 🔘 1. CIRCULAR TOGGLE BUTTON (Custom Round Indicator with Color Morph)
            --------------------------------------------------------------------
            function Controls:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local state = cfg.Default or false
                local keybind = cfg.Keybind
                local callback = cfg.Callback or function() end

                -- Full row interactive button for easy mobile tapping
                local RowBtn = Instance.new("TextButton")
                RowBtn.Size = UDim2.new(1, 0, 0, 30)
                RowBtn.BackgroundTransparency = 1
                RowBtn.Text = ""
                RowBtn.AutoButtonColor = false
                RowBtn.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, keybind and -65 or -32, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = state and THEME.TextMain or THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = RowBtn

                if keybind then
                    local KeyBadge = Instance.new("TextLabel")
                    KeyBadge.Size = UDim2.new(0, 20, 0, 16)
                    KeyBadge.Position = UDim2.new(1, -56, 0.5, -8)
                    KeyBadge.BackgroundColor3 = THEME.BgSidebar
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

                -- Outer Circular Ring
                local CircleFrame = Instance.new("Frame")
                CircleFrame.Size = UDim2.new(0, 20, 0, 20)
                CircleFrame.Position = UDim2.new(1, -22, 0.5, -10)
                CircleFrame.BackgroundColor3 = state and AccentColor or THEME.CircleOff
                CircleFrame.Parent = RowBtn

                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = CircleFrame

                local CircleStroke = Instance.new("UIStroke")
                CircleStroke.Color = state and THEME.AccentGradient or THEME.CircleOffBorder
                CircleStroke.Thickness = 1.5
                CircleStroke.Parent = CircleFrame

                -- Inner Glowing Center Dot
                local InnerDot = Instance.new("Frame")
                InnerDot.Size = state and UDim2.new(0, 10, 0, 10) or UDim2.new(0, 0, 0, 0)
                InnerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
                InnerDot.AnchorPoint = Vector2.new(0.5, 0.5)
                InnerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                InnerDot.Parent = CircleFrame

                local InnerCorner = Instance.new("UICorner")
                InnerCorner.CornerRadius = UDim.new(1, 0)
                InnerCorner.Parent = InnerDot

                local function SetState(newVal)
                    state = newVal
                    if state then
                        -- Active: Circle turns Purple, Inner Dot blooms in white/purple
                        Tween(CircleFrame, {BackgroundColor3 = AccentColor}, 0.2)
                        Tween(CircleStroke, {Color = THEME.AccentGradient}, 0.2)
                        Tween(InnerDot, {Size = UDim2.new(0, 10, 0, 10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                        Tween(Label, {TextColor3 = THEME.TextMain}, 0.2)
                    else
                        -- Inactive: Circle turns Dark, Inner Dot shrinks
                        Tween(CircleFrame, {BackgroundColor3 = THEME.CircleOff}, 0.2)
                        Tween(CircleStroke, {Color = THEME.CircleOffBorder}, 0.2)
                        Tween(InnerDot, {Size = UDim2.new(0, 0, 0, 0)}, 0.18)
                        Tween(Label, {TextColor3 = THEME.TextMuted}, 0.2)
                    end
                    callback(state)
                end

                RowBtn.MouseButton1Click:Connect(function()
                    -- Pop bounce effect
                    Tween(CircleFrame, {Size = UDim2.new(0, 23, 0, 23), Position = UDim2.new(1, -23.5, 0.5, -11.5)}, 0.08)
                    task.wait(0.08)
                    Tween(CircleFrame, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -22, 0.5, -10)}, 0.12)
                    SetState(not state)
                end)

                return {Set = SetState}
            end

            --------------------------------------------------------------------
            -- 🎚️ 2. ROUND SLIDER (Extra Touch Comfort & Large Circular Knob)
            --------------------------------------------------------------------
            function Controls:AddSlider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local maxFormat = cfg.MaxFormat or false
                local suffix = cfg.Suffix or ""
                local callback = cfg.Callback or function() end
                local value = default

                -- Taller frame for easy mobile thumb dragging
                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 42)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.6, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(0.4, 0, 0, 16)
                ValLabel.Position = UDim2.new(0.6, 0, 0, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = maxFormat and (tostring(value) .. " / " .. tostring(max)) or (tostring(value) .. suffix)
                ValLabel.Font = THEME.FontBold
                ValLabel.TextSize = 10
                ValLabel.TextColor3 = THEME.TextMuted
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent = Frame

                -- Thick Rounded Track (7px)
                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 7)
                Track.Position = UDim2.new(0, 0, 0, 24)
                Track.BackgroundColor3 = THEME.CircleOff
                Track.Parent = Frame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local TrackStroke = Instance.new("UIStroke")
                TrackStroke.Color = THEME.CardBorder
                TrackStroke.Thickness = 1
                TrackStroke.Parent = Track

                -- Glowing Rounded Fill Bar
                local Fill = Instance.new("Frame")
                local initPct = math.clamp((value - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(initPct, 0, 1, 0)
                Fill.BackgroundColor3 = AccentColor
                Fill.BorderSizePixel = 0
                Fill.Parent = Track

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                local FillGrad = Instance.new("UIGradient")
                FillGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, THEME.AccentGradient),
                    ColorSequenceKeypoint.new(1, THEME.Accent)
                })
                FillGrad.Parent = Fill

                -- Prominent Circular Draggable Knob (16x16 pure circle)
                local Thumb = Instance.new("Frame")
                Thumb.Size = UDim2.new(0, 16, 0, 16)
                Thumb.Position = UDim2.new(1, -8, 0.5, -8)
                Thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
                    value = math.floor(min + (max - min) * pct)
                    Tween(Fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
                    ValLabel.Text = maxFormat and (tostring(value) .. " / " .. tostring(max)) or (tostring(value) .. suffix)
                    callback(value)
                end

                -- Touch & Click Detection on Entire Slider Frame Area
                Frame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Tween(Thumb, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -10, 0.5, -10)}, 0.15)
                        Tween(ValLabel, {TextColor3 = AccentColor}, 0.15)
                        Update(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        Tween(Thumb, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}, 0.15)
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
            -- 🔽 3. ROUNDED DROPDOWN (Comfortable Mobile Touch Target)
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
                DropFrame.Size = UDim2.new(1, 0, 0, 32)
                DropFrame.BackgroundTransparency = 1
                DropFrame.Parent = Card

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.48, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = DropFrame

                -- Taller, Rounded Dropdown Box (24px height, 7px radius)
                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(0.5, 0, 0, 24)
                DropBtn.Position = UDim2.new(0.5, 0, 0.5, -12)
                DropBtn.BackgroundColor3 = THEME.BgSidebar
                DropBtn.Text = "  " .. selected
                DropBtn.Font = THEME.FontMain
                DropBtn.TextSize = 10
                DropBtn.TextColor3 = THEME.TextMain
                DropBtn.TextXAlignment = Enum.TextXAlignment.Left
                DropBtn.AutoButtonColor = false
                DropBtn.Parent = DropFrame

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 7)
                DropCorner.Parent = DropBtn

                local DropStroke = Instance.new("UIStroke")
                DropStroke.Color = THEME.CardBorder
                DropStroke.Thickness = 1
                DropStroke.Parent = DropBtn

                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 20, 1, 0)
                Arrow.Position = UDim2.new(1, -20, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▾"
                Arrow.Font = THEME.FontBold
                Arrow.TextSize = 10
                Arrow.TextColor3 = THEME.TextMuted
                Arrow.Parent = DropBtn

                -- Floating Rounded Menu List
                local MenuList = Instance.new("Frame")
                MenuList.Size = UDim2.new(1, 0, 0, #options * 26)
                MenuList.Position = UDim2.new(0, 0, 1, 4)
                MenuList.BackgroundColor3 = THEME.BgMain
                MenuList.BorderSizePixel = 0
                MenuList.Visible = false
                MenuList.ClipsDescendants = true
                MenuList.ZIndex = 30
                MenuList.Parent = DropBtn

                local MenuCorner = Instance.new("UICorner")
                MenuCorner.CornerRadius = UDim.new(0, 8)
                MenuCorner.Parent = MenuList

                local MenuStroke = Instance.new("UIStroke")
                MenuStroke.Color = THEME.CardBorder
                MenuStroke.Thickness = 1
                MenuStroke.Parent = MenuList

                local MenuLayout = Instance.new("UIListLayout")
                MenuLayout.Parent = MenuList

                for _, opt in ipairs(options) do
                    local OptItem = Instance.new("TextButton")
                    OptItem.Size = UDim2.new(1, 0, 0, 26)
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
                        DropBtn.Text = "  " .. selected
                        MenuList.Visible = false
                        open = false
                        Arrow.Text = "▾"
                        callback(selected)
                    end)
                end

                DropBtn.MouseButton1Click:Connect(function()
                    open = not open
                    MenuList.Visible = open
                    Arrow.Text = open and "▲" or "▾"
                    if open then
                        MenuList.Size = UDim2.new(1, 0, 0, 0)
                        Tween(MenuList, {Size = UDim2.new(1, 0, 0, #options * 26)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    end
                end)
            end

            -- 4. BUTTON (Rounded with Click Bounce)
            function Controls:AddButton(cfg)
                cfg = cfg or {}
                local text = cfg.Name or "Button"
                local callback = cfg.Callback or function() end

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(1, 0, 0, 28)
                Btn.BackgroundColor3 = THEME.BgSidebar
                Btn.Text = text
                Btn.Font = THEME.FontMain
                Btn.TextSize = 11
                Btn.TextColor3 = THEME.TextMain
                Btn.AutoButtonColor = false
                Btn.Parent = Card

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 7)
                BtnCorner.Parent = Btn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = THEME.CardBorder
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = THEME.CardBg}, 0.2)
                    Tween(BtnStroke, {Color = AccentColor}, 0.2)
                end)

                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = THEME.BgSidebar}, 0.2)
                    Tween(BtnStroke, {Color = THEME.CardBorder}, 0.2)
                end)

                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn, {BackgroundColor3 = AccentColor}, 0.1)
                    task.wait(0.1)
                    Tween(Btn, {BackgroundColor3 = THEME.BgSidebar}, 0.2)
                    callback()
                end)
            end

            return Controls
        end

        return TabMethods
    end

    return Window
end

return NamelessWare
