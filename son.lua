--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                         NAMELESS UI LIBRARY v3.1                         ║
    ║   Sidebar Tabs | Theme Manager | UI Manager | Mobile & GIF Support       ║
    ║   Rounded Corners | Untinted Logo | Mobile Friendly                      ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local Library = {
    Version = "3.1.0",
    Flags = {},
    Signals = {},
    Themes = {
        Nameless = {
            Background = Color3.fromRGB(13, 13, 17),
            Sidebar = Color3.fromRGB(10, 10, 14),
            CardBackground = Color3.fromRGB(18, 18, 24),
            CardBorder = Color3.fromRGB(28, 28, 38),
            CardBorderHover = Color3.fromRGB(48, 48, 62),
            Accent = Color3.fromRGB(137, 132, 245),
            AccentSecondary = Color3.fromRGB(93, 197, 216),
            AccentDark = Color3.fromRGB(75, 70, 170),
            Text = Color3.fromRGB(240, 240, 245),
            TextDim = Color3.fromRGB(145, 145, 160),
            TextDark = Color3.fromRGB(85, 85, 100),
            ItemBg = Color3.fromRGB(23, 23, 31),
            ItemBgHover = Color3.fromRGB(30, 30, 42),
            ItemBorder = Color3.fromRGB(35, 35, 48),
            SliderTrack = Color3.fromRGB(24, 24, 33),
            SliderFill = Color3.fromRGB(137, 132, 245),
            ToggleOff = Color3.fromRGB(26, 26, 35),
            ToggleOn = Color3.fromRGB(137, 132, 245)
        },
        Midnight = {
            Background = Color3.fromRGB(8, 10, 15),
            Sidebar = Color3.fromRGB(6, 8, 12),
            CardBackground = Color3.fromRGB(12, 16, 24),
            CardBorder = Color3.fromRGB(20, 28, 42),
            CardBorderHover = Color3.fromRGB(35, 50, 75),
            Accent = Color3.fromRGB(70, 130, 245),
            AccentSecondary = Color3.fromRGB(50, 200, 225),
            AccentDark = Color3.fromRGB(40, 80, 180),
            Text = Color3.fromRGB(235, 240, 250),
            TextDim = Color3.fromRGB(130, 145, 170),
            TextDark = Color3.fromRGB(75, 90, 115),
            ItemBg = Color3.fromRGB(16, 22, 34),
            ItemBgHover = Color3.fromRGB(22, 30, 46),
            ItemBorder = Color3.fromRGB(25, 36, 56),
            SliderTrack = Color3.fromRGB(15, 20, 32),
            SliderFill = Color3.fromRGB(70, 130, 245),
            ToggleOff = Color3.fromRGB(16, 22, 34),
            ToggleOn = Color3.fromRGB(70, 130, 245)
        },
        Emerald = {
            Background = Color3.fromRGB(10, 15, 12),
            Sidebar = Color3.fromRGB(8, 12, 10),
            CardBackground = Color3.fromRGB(14, 22, 18),
            CardBorder = Color3.fromRGB(22, 36, 28),
            CardBorderHover = Color3.fromRGB(38, 62, 48),
            Accent = Color3.fromRGB(60, 205, 130),
            AccentSecondary = Color3.fromRGB(70, 230, 190),
            AccentDark = Color3.fromRGB(35, 140, 80),
            Text = Color3.fromRGB(235, 248, 240),
            TextDim = Color3.fromRGB(130, 165, 145),
            TextDark = Color3.fromRGB(75, 105, 90),
            ItemBg = Color3.fromRGB(18, 28, 22),
            ItemBgHover = Color3.fromRGB(24, 38, 30),
            ItemBorder = Color3.fromRGB(28, 46, 36),
            SliderTrack = Color3.fromRGB(16, 25, 20),
            SliderFill = Color3.fromRGB(60, 205, 130),
            ToggleOff = Color3.fromRGB(18, 28, 22),
            ToggleOn = Color3.fromRGB(60, 205, 130)
        },
        Crimson = {
            Background = Color3.fromRGB(15, 10, 12),
            Sidebar = Color3.fromRGB(12, 8, 10),
            CardBackground = Color3.fromRGB(24, 14, 18),
            CardBorder = Color3.fromRGB(42, 22, 28),
            CardBorderHover = Color3.fromRGB(70, 35, 45),
            Accent = Color3.fromRGB(235, 65, 85),
            AccentSecondary = Color3.fromRGB(255, 110, 125),
            AccentDark = Color3.fromRGB(160, 35, 50),
            Text = Color3.fromRGB(250, 235, 240),
            TextDim = Color3.fromRGB(170, 130, 140),
            TextDark = Color3.fromRGB(115, 75, 85),
            ItemBg = Color3.fromRGB(32, 18, 24),
            ItemBgHover = Color3.fromRGB(44, 24, 32),
            ItemBorder = Color3.fromRGB(52, 28, 38),
            SliderTrack = Color3.fromRGB(28, 16, 22),
            SliderFill = Color3.fromRGB(235, 65, 85),
            ToggleOff = Color3.fromRGB(32, 18, 24),
            ToggleOn = Color3.fromRGB(235, 65, 85)
        },
        Sakura = {
            Background = Color3.fromRGB(16, 12, 17),
            Sidebar = Color3.fromRGB(13, 9, 14),
            CardBackground = Color3.fromRGB(25, 18, 26),
            CardBorder = Color3.fromRGB(45, 30, 48),
            CardBorderHover = Color3.fromRGB(75, 50, 80),
            Accent = Color3.fromRGB(245, 115, 180),
            AccentSecondary = Color3.fromRGB(255, 170, 210),
            AccentDark = Color3.fromRGB(170, 60, 120),
            Text = Color3.fromRGB(250, 240, 248),
            TextDim = Color3.fromRGB(175, 145, 170),
            TextDark = Color3.fromRGB(115, 90, 110),
            ItemBg = Color3.fromRGB(34, 24, 36),
            ItemBgHover = Color3.fromRGB(46, 32, 48),
            ItemBorder = Color3.fromRGB(55, 38, 58),
            SliderTrack = Color3.fromRGB(30, 20, 32),
            SliderFill = Color3.fromRGB(245, 115, 180),
            ToggleOff = Color3.fromRGB(34, 24, 36),
            ToggleOn = Color3.fromRGB(245, 115, 180)
        }
    },
    CurrentTheme = "Nameless",
    ThemeObjects = {},
    CurrentWindow = nil
}

Library.Theme = Library.Themes.Nameless

-- Utility Functions
local function getGuiParent()
    local success, parent = pcall(function()
        if gethui then return gethui() end
        local core = game:GetService("CoreGui")
        local t = Instance.new("Folder", core)
        t:Destroy()
        return core
    end)
    if success and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function createTween(instance, properties, duration, style, direction)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    local tween = TweenService:Create(instance, TweenInfo.new(duration, style, direction), properties)
    tween:Play()
    return tween
end

local function makeDraggable(dragTrigger, targetFrame)
    local dragging, dragInput, dragStart, startPos
    
    dragTrigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragTrigger.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Theme Registration & Management
function Library:RegisterThemeObject(instance, property, themeKey)
    if not self.ThemeObjects[themeKey] then
        self.ThemeObjects[themeKey] = {}
    end
    table.insert(self.ThemeObjects[themeKey], { Instance = instance, Property = property })
    if self.Theme[themeKey] and instance and instance.Parent then
        instance[property] = self.Theme[themeKey]
    end
end

function Library:SetTheme(themeName)
    local targetTheme = self.Themes[themeName]
    if not targetTheme then return end
    self.CurrentTheme = themeName
    self.Theme = targetTheme

    for themeKey, objects in pairs(self.ThemeObjects) do
        local targetColor = targetTheme[themeKey]
        if targetColor then
            for _, obj in ipairs(objects) do
                if obj.Instance and obj.Instance.Parent then
                    createTween(obj.Instance, { [obj.Property] = targetColor }, 0.25)
                end
            end
        end
    end
end

function Library:SetAccent(color)
    self.Theme.Accent = color
    self.Theme.SliderFill = color
    self.Theme.ToggleOn = color
    
    local accentObjects = self.ThemeObjects["Accent"] or {}
    for _, obj in ipairs(accentObjects) do
        if obj.Instance and obj.Instance.Parent then
            createTween(obj.Instance, { [obj.Property] = color }, 0.2)
        end
    end
end

-- ==================== CREATE WINDOW ====================
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Nameless"
    local windowSubtitle = config.SubTitle or "Ware"
    local logoIcon = config.Logo or "rbxassetid://105243902490842"
    local footerUser = config.Footer or (LocalPlayer and LocalPlayer.Name or "Username")
    local footerRank = config.FooterRight or "Lifetime"
    local windowSize = config.Size or UDim2.new(0, 720, 0, 500)
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local mobileLogo = config.MobileLogo or logoIcon
    local showMobile = config.ShowMobileButton ~= false

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = getGuiParent()

    -- Main Container Window (Rounded 12px)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Library:RegisterThemeObject(MainFrame, "BackgroundColor3", "Background")

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.CardBorder
    MainStroke.Thickness = 1.2
    MainStroke.Parent = MainFrame
    Library:RegisterThemeObject(MainStroke, "Color", "CardBorder")

    -- ==================== BACKGROUND IMAGE & GIF SUPPORT ====================
    local BackgroundContainer = Instance.new("Frame")
    BackgroundContainer.Name = "BackgroundContainer"
    BackgroundContainer.Size = UDim2.new(1, 0, 1, 0)
    BackgroundContainer.BackgroundTransparency = 1
    BackgroundContainer.ZIndex = 1
    BackgroundContainer.Parent = MainFrame

    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "BackgroundImage"
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.ImageTransparency = 0.85
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ZIndex = 1
    BackgroundImage.Parent = BackgroundContainer

    local BackgroundOverlay = Instance.new("Frame")
    BackgroundOverlay.Name = "DarkOverlay"
    BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
    BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    BackgroundOverlay.BackgroundTransparency = 0.25
    BackgroundOverlay.ZIndex = 2
    BackgroundOverlay.Parent = BackgroundContainer

    local GifPlayer = {
        Frames = {},
        FPS = 30,
        CurrentIndex = 1,
        Connection = nil
    }

    local function setBackgroundImg(assetId, transparency)
        BackgroundImage.Image = assetId or ""
        BackgroundImage.ImageTransparency = transparency or 0.85
        BackgroundImage.Visible = (assetId ~= nil and assetId ~= "")
    end

    local function setBackgroundGif(frames, fps, transparency)
        if GifPlayer.Connection then
            GifPlayer.Connection:Disconnect()
            GifPlayer.Connection = nil
        end

        GifPlayer.Frames = frames or {}
        GifPlayer.FPS = fps or 30
        GifPlayer.CurrentIndex = 1

        if #GifPlayer.Frames == 0 then
            BackgroundImage.Visible = false
            return
        end

        BackgroundImage.Visible = true
        BackgroundImage.ImageTransparency = transparency or 0.85
        
        local frameDuration = 1 / GifPlayer.FPS
        local lastUpdate = tick()

        GifPlayer.Connection = RunService.RenderStepped:Connect(function()
            local now = tick()
            if now - lastUpdate >= frameDuration then
                lastUpdate = now
                GifPlayer.CurrentIndex = GifPlayer.CurrentIndex + 1
                if GifPlayer.CurrentIndex > #GifPlayer.Frames then
                    GifPlayer.CurrentIndex = 1
                end
                BackgroundImage.Image = GifPlayer.Frames[GifPlayer.CurrentIndex]
            end
        end)
    end

    if config.BackgroundImage then
        setBackgroundImg(config.BackgroundImage, config.BackgroundTransparency or 0.85)
    end

    -- ==================== LEFT SIDEBAR ====================
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 5
    Sidebar.Parent = MainFrame
    Library:RegisterThemeObject(Sidebar, "BackgroundColor3", "Sidebar")

    local SidebarRightBorder = Instance.new("Frame")
    SidebarRightBorder.Size = UDim2.new(0, 1, 1, 0)
    SidebarRightBorder.Position = UDim2.new(1, -1, 0, 0)
    SidebarRightBorder.BackgroundColor3 = Library.Theme.CardBorder
    SidebarRightBorder.BorderSizePixel = 0
    SidebarRightBorder.ZIndex = 6
    SidebarRightBorder.Parent = Sidebar
    Library:RegisterThemeObject(SidebarRightBorder, "BackgroundColor3", "CardBorder")

    -- Sidebar Top Branding
    local BrandHeader = Instance.new("Frame")
    BrandHeader.Name = "BrandHeader"
    BrandHeader.Size = UDim2.new(1, 0, 0, 56)
    BrandHeader.BackgroundTransparency = 1
    BrandHeader.ZIndex = 6
    BrandHeader.Parent = Sidebar

    makeDraggable(BrandHeader, MainFrame)

    -- Brand Logo (Untinted: does NOT change color with theme)
    local BrandLogo = Instance.new("ImageLabel")
    BrandLogo.Name = "BrandLogo"
    BrandLogo.Size = UDim2.new(0, 26, 0, 26)
    BrandLogo.Position = UDim2.new(0, 14, 0.5, -13)
    BrandLogo.BackgroundTransparency = 1
    BrandLogo.Image = logoIcon
    BrandLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
    BrandLogo.ZIndex = 7
    BrandLogo.Parent = BrandHeader

    local BrandTitle = Instance.new("TextLabel")
    BrandTitle.Name = "BrandTitle"
    BrandTitle.Size = UDim2.new(1, -50, 1, 0)
    BrandTitle.Position = UDim2.new(0, 46, 0, 0)
    BrandTitle.BackgroundTransparency = 1
    BrandTitle.RichText = true
    BrandTitle.Text = '<b>' .. windowTitle .. '</b><font color="#8984f5">' .. windowSubtitle .. '</font>'
    BrandTitle.TextColor3 = Library.Theme.Text
    BrandTitle.Font = Enum.Font.GothamBold
    BrandTitle.TextSize = 14
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
    BrandTitle.ZIndex = 7
    BrandTitle.Parent = BrandHeader

    -- Sidebar Tabs List
    local TabsContainer = Instance.new("ScrollingFrame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, 0, 1, -110)
    TabsContainer.Position = UDim2.new(0, 0, 0, 56)
    TabsContainer.BackgroundTransparency = 1
    TabsContainer.BorderSizePixel = 0
    TabsContainer.ScrollBarThickness = 0
    TabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabsContainer.ZIndex = 6
    TabsContainer.Parent = Sidebar

    local TabsListLayout = Instance.new("UIListLayout")
    TabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsListLayout.Padding = UDim.new(0, 5)
    TabsListLayout.Parent = TabsContainer

    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)
    TabsPadding.PaddingTop = UDim.new(0, 8)
    TabsPadding.Parent = TabsContainer

    -- Sidebar Footer / Profile Info
    local SidebarFooter = Instance.new("Frame")
    SidebarFooter.Name = "SidebarFooter"
    SidebarFooter.Size = UDim2.new(1, 0, 0, 50)
    SidebarFooter.Position = UDim2.new(0, 0, 1, -50)
    SidebarFooter.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    SidebarFooter.BorderSizePixel = 0
    SidebarFooter.ZIndex = 6
    SidebarFooter.Parent = Sidebar

    local FooterDivider = Instance.new("Frame")
    FooterDivider.Size = UDim2.new(1, 0, 0, 1)
    FooterDivider.BackgroundColor3 = Library.Theme.CardBorder
    FooterDivider.BorderSizePixel = 0
    FooterDivider.ZIndex = 7
    FooterDivider.Parent = SidebarFooter
    Library:RegisterThemeObject(FooterDivider, "BackgroundColor3", "CardBorder")

    local FooterUser = Instance.new("TextLabel")
    FooterUser.Size = UDim2.new(1, -20, 0, 16)
    FooterUser.Position = UDim2.new(0, 12, 0, 8)
    FooterUser.BackgroundTransparency = 1
    FooterUser.Text = footerUser
    FooterUser.TextColor3 = Library.Theme.Text
    FooterUser.Font = Enum.Font.GothamBold
    FooterUser.TextSize = 11
    FooterUser.TextXAlignment = Enum.TextXAlignment.Left
    FooterUser.ZIndex = 7
    FooterUser.Parent = SidebarFooter

    local FooterRank = Instance.new("TextLabel")
    FooterRank.Size = UDim2.new(1, -20, 0, 14)
    FooterRank.Position = UDim2.new(0, 12, 0, 24)
    FooterRank.BackgroundTransparency = 1
    FooterRank.Text = footerRank
    FooterRank.TextColor3 = Library.Theme.Accent
    FooterRank.Font = Enum.Font.GothamMedium
    FooterRank.TextSize = 10
    FooterRank.TextXAlignment = Enum.TextXAlignment.Left
    FooterRank.ZIndex = 7
    FooterRank.Parent = SidebarFooter
    Library:RegisterThemeObject(FooterRank, "TextColor3", "Accent")

    -- ==================== RIGHT MAIN CONTENT AREA ====================
    local MainContent = Instance.new("Frame")
    MainContent.Name = "MainContent"
    MainContent.Size = UDim2.new(1, -160, 1, 0)
    MainContent.Position = UDim2.new(0, 160, 0, 0)
    MainContent.BackgroundTransparency = 1
    MainContent.ZIndex = 5
    MainContent.Parent = MainFrame

    local TopDrag = Instance.new("Frame")
    TopDrag.Name = "TopDrag"
    TopDrag.Size = UDim2.new(1, 0, 0, 42)
    TopDrag.BackgroundTransparency = 1
    TopDrag.ZIndex = 6
    TopDrag.Parent = MainContent

    makeDraggable(TopDrag, MainFrame)

    local CurrentTabTitle = Instance.new("TextLabel")
    CurrentTabTitle.Name = "CurrentTabTitle"
    CurrentTabTitle.Size = UDim2.new(1, -60, 1, 0)
    CurrentTabTitle.Position = UDim2.new(0, 18, 0, 0)
    CurrentTabTitle.BackgroundTransparency = 1
    CurrentTabTitle.Text = "Visuals"
    CurrentTabTitle.TextColor3 = Library.Theme.Text
    CurrentTabTitle.Font = Enum.Font.GothamBold
    CurrentTabTitle.TextSize = 14
    CurrentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    CurrentTabTitle.ZIndex = 7
    CurrentTabTitle.Parent = TopDrag

    -- Content Holder for Tab Pages
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -24, 1, -54)
    ContentHolder.Position = UDim2.new(0, 12, 0, 44)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true
    ContentHolder.ZIndex = 6
    ContentHolder.Parent = MainContent

    -- Floating Popover Overlay
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.ZIndex = 50
    Overlay.Parent = MainFrame

    -- ==================== MOBILE DRAGGABLE ROUND BUTTON WITH UNTINTED LOGO ====================
    local MobileButton = Instance.new("ImageButton")
    MobileButton.Name = "NamelessMobileBtn"
    MobileButton.Size = UDim2.new(0, 48, 0, 48)
    MobileButton.Position = UDim2.new(0, 24, 0.25, 0)
    MobileButton.BackgroundColor3 = Library.Theme.Sidebar
    MobileButton.AutoButtonColor = false
    MobileButton.ZIndex = 100
    MobileButton.Visible = showMobile and (UserInputService.TouchEnabled or config.ForceMobileButton)
    MobileButton.Parent = ScreenGui
    Library:RegisterThemeObject(MobileButton, "BackgroundColor3", "Sidebar")

    local MobileCorner = Instance.new("UICorner")
    MobileCorner.CornerRadius = UDim.new(1, 0)
    MobileCorner.Parent = MobileButton

    local MobileStroke = Instance.new("UIStroke")
    MobileStroke.Color = Library.Theme.Accent
    MobileStroke.Thickness = 1.8
    MobileStroke.Parent = MobileButton
    Library:RegisterThemeObject(MobileStroke, "Color", "Accent")

    -- Mobile Logo (Untinted: does NOT change color with theme)
    local MobileLogoImg = Instance.new("ImageLabel")
    MobileLogoImg.Name = "Logo"
    MobileLogoImg.Size = UDim2.new(0, 26, 0, 26)
    MobileLogoImg.Position = UDim2.new(0.5, -13, 0.5, -13)
    MobileLogoImg.BackgroundTransparency = 1
    MobileLogoImg.Image = mobileLogo
    MobileLogoImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MobileLogoImg.ZIndex = 101
    MobileLogoImg.Parent = MobileButton

    makeDraggable(MobileButton, MobileButton)

    local WindowObj = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentHolder = ContentHolder,
        Overlay = Overlay,
        MobileButton = MobileButton,
        Tabs = {},
        CurrentTab = nil,
        IsOpen = true
    }

    Library.CurrentWindow = WindowObj

    -- Toggle Window Visibility
    function WindowObj:Toggle(state)
        if state == nil then state = not self.IsOpen end
        self.IsOpen = state
        
        if self.IsOpen then
            MainFrame.Visible = true
            createTween(MainFrame, {
                Size = windowSize,
                BackgroundTransparency = 0
            }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            local tw = createTween(MainFrame, {
                Size = windowSize - UDim2.new(0, 20, 0, 20),
                BackgroundTransparency = 1
            }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw.Completed:Connect(function()
                if not self.IsOpen then MainFrame.Visible = false end
            end)
        end
    end

    MobileButton.MouseButton1Click:Connect(function()
        WindowObj:Toggle()
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            WindowObj:Toggle()
        end
    end)

    function WindowObj:SetBackground(assetId, transparency)
        setBackgroundImg(assetId, transparency)
    end

    function WindowObj:SetBackgroundGif(frames, fps, transparency)
        setBackgroundGif(frames, fps, transparency)
    end

    -- Close popovers when clicking outside
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            for _, child in ipairs(Overlay:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then
                    local mousePos = UserInputService:GetMouseLocation()
                    local absPos = child.AbsolutePosition
                    local absSize = child.AbsoluteSize
                    if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                       mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                        local tag = child:GetAttribute("ActivatorPos")
                        if not tag or (mousePos - Vector2.new(tag.X, tag.Y)).Magnitude > 40 then
                            child.Visible = false
                        end
                    end
                end
            end
        end
    end)

    -- ==================== CREATE TAB (SIDEBAR) ====================
    function WindowObj:CreateTab(tabConfig)
        local name
        if type(tabConfig) == "table" then
            name = tabConfig.Name or "Tab"
        else
            name = tostring(tabConfig)
        end

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "_Tab"
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Library.Theme.ItemBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 7
        TabBtn.Parent = TabsContainer

        -- Rounded 8px Tab
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabBtn

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 3, 0, 18)
        TabIndicator.Position = UDim2.new(0, 5, 0.5, -9)
        TabIndicator.BackgroundColor3 = Library.Theme.Accent
        TabIndicator.BackgroundTransparency = 1
        TabIndicator.BorderSizePixel = 0
        TabIndicator.ZIndex = 8
        TabIndicator.Parent = TabBtn
        Library:RegisterThemeObject(TabIndicator, "BackgroundColor3", "Accent")

        local TabIndicatorCorner = Instance.new("UICorner")
        TabIndicatorCorner.CornerRadius = UDim.new(1, 0)
        TabIndicatorCorner.Parent = TabIndicator

        local TabText = Instance.new("TextLabel")
        TabText.Name = "TabText"
        TabText.Size = UDim2.new(1, -24, 1, 0)
        TabText.Position = UDim2.new(0, 16, 0, 0)
        TabText.BackgroundTransparency = 1
        TabText.Text = name
        TabText.TextColor3 = Library.Theme.TextDark
        TabText.Font = Enum.Font.GothamMedium
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 8
        TabText.Parent = TabBtn

        -- Tab Page
        local TabPage = Instance.new("Frame")
        TabPage.Name = name .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ZIndex = 7
        TabPage.Parent = ContentHolder

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.FillDirection = Enum.FillDirection.Horizontal
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 12)
        PageLayout.Parent = TabPage

        -- Left Column
        local LeftCol = Instance.new("ScrollingFrame")
        LeftCol.Name = "LeftColumn"
        LeftCol.Size = UDim2.new(0.5, -6, 1, 0)
        LeftCol.BackgroundTransparency = 1
        LeftCol.BorderSizePixel = 0
        LeftCol.ScrollBarThickness = 2
        LeftCol.ScrollBarImageColor3 = Library.Theme.CardBorder
        LeftCol.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftCol.ZIndex = 7
        LeftCol.Parent = TabPage
        Library:RegisterThemeObject(LeftCol, "ScrollBarImageColor3", "CardBorder")

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Padding = UDim.new(0, 12)
        LeftLayout.Parent = LeftCol

        -- Right Column
        local RightCol = Instance.new("ScrollingFrame")
        RightCol.Name = "RightColumn"
        RightCol.Size = UDim2.new(0.5, -6, 1, 0)
        RightCol.BackgroundTransparency = 1
        RightCol.BorderSizePixel = 0
        RightCol.ScrollBarThickness = 2
        RightCol.ScrollBarImageColor3 = Library.Theme.CardBorder
        RightCol.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightCol.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightCol.ZIndex = 7
        RightCol.Parent = TabPage
        Library:RegisterThemeObject(RightCol, "ScrollBarImageColor3", "CardBorder")

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 12)
        RightLayout.Parent = RightCol

        local TabObj = {
            Name = name,
            Button = TabBtn,
            Page = TabPage,
            LeftColumn = LeftCol,
            RightColumn = RightCol
        }

        local function activateTab()
            for _, tab in pairs(WindowObj.Tabs) do
                tab.Page.Visible = false
                createTween(tab.Button, { BackgroundTransparency = 1 }, 0.15)
                createTween(tab.Button.TabText, { TextColor3 = Library.Theme.TextDark }, 0.15)
                createTween(tab.Button.Indicator, { BackgroundTransparency = 1 }, 0.15)
            end
            TabPage.Visible = true
            CurrentTabTitle.Text = name
            createTween(TabBtn, { BackgroundTransparency = 0.5, BackgroundColor3 = Library.Theme.ItemBgHover }, 0.15)
            createTween(TabText, { TextColor3 = Library.Theme.Text }, 0.15)
            createTween(TabIndicator, { BackgroundTransparency = 0 }, 0.15)
            WindowObj.CurrentTab = TabObj
        end

        TabBtn.MouseButton1Click:Connect(activateTab)

        TabBtn.MouseEnter:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                createTween(TabBtn, { BackgroundTransparency = 0.8, BackgroundColor3 = Library.Theme.ItemBgHover }, 0.15)
                createTween(TabText, { TextColor3 = Library.Theme.TextDim }, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                createTween(TabBtn, { BackgroundTransparency = 1 }, 0.15)
                createTween(TabText, { TextColor3 = Library.Theme.TextDark }, 0.15)
            end
        end)

        if #WindowObj.Tabs == 0 then
            activateTab()
        end

        table.insert(WindowObj.Tabs, TabObj)

        -- ==================== SECTION / GROUPBOX ====================
        function TabObj:CreateSection(sectionTitle, side)
            side = side or "Left"
            local parentCol = (side:lower() == "right") and RightCol or LeftCol

            -- Rounded 10px Card
            local Card = Instance.new("Frame")
            Card.Name = sectionTitle .. "_Card"
            Card.Size = UDim2.new(1, 0, 0, 0)
            Card.AutomaticSize = Enum.AutomaticSize.Y
            Card.BackgroundColor3 = Library.Theme.CardBackground
            Card.BorderSizePixel = 0
            Card.ZIndex = 8
            Card.Parent = parentCol
            Library:RegisterThemeObject(Card, "BackgroundColor3", "CardBackground")

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 10)
            CardCorner.Parent = Card

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Library.Theme.CardBorder
            CardStroke.Thickness = 1
            CardStroke.Parent = Card
            Library:RegisterThemeObject(CardStroke, "Color", "CardBorder")

            local CardHeader = Instance.new("Frame")
            CardHeader.Name = "Header"
            CardHeader.Size = UDim2.new(1, 0, 0, 28)
            CardHeader.BackgroundTransparency = 1
            CardHeader.ZIndex = 9
            CardHeader.Parent = Card

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -24, 1, 0)
            TitleLabel.Position = UDim2.new(0, 12, 0, 2)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text = sectionTitle
            TitleLabel.TextColor3 = Library.Theme.Text
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.ZIndex = 9
            TitleLabel.Parent = CardHeader

            local CardContainer = Instance.new("Frame")
            CardContainer.Name = "Container"
            CardContainer.Size = UDim2.new(1, -24, 0, 0)
            CardContainer.Position = UDim2.new(0, 12, 0, 28)
            CardContainer.AutomaticSize = Enum.AutomaticSize.Y
            CardContainer.BackgroundTransparency = 1
            CardContainer.ZIndex = 9
            CardContainer.Parent = Card

            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Padding = UDim.new(0, 10)
            ContainerLayout.Parent = CardContainer

            local CardPadding = Instance.new("UIPadding")
            CardPadding.PaddingBottom = UDim.new(0, 12)
            CardPadding.Parent = CardContainer

            local SectionObj = {
                Card = Card,
                Container = CardContainer
            }

            -- ==================== TOGGLE ====================
            function SectionObj:AddToggle(toggleConfig)
                toggleConfig = toggleConfig or {}
                local name = toggleConfig.Name or "Toggle"
                local default = toggleConfig.Default or false
                local callback = toggleConfig.Callback or function() end
                local flag = toggleConfig.Flag

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name .. "_Toggle"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 22)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.ZIndex = 10
                ToggleFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = default and Library.Theme.Text or Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = ToggleFrame

                local RightElements = Instance.new("Frame")
                RightElements.Name = "RightElements"
                RightElements.Size = UDim2.new(0, 130, 1, 0)
                RightElements.Position = UDim2.new(1, -130, 0, 0)
                RightElements.BackgroundTransparency = 1
                RightElements.ZIndex = 10
                RightElements.Parent = ToggleFrame

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 6)
                RightLayout.Parent = RightElements

                local CheckBox = Instance.new("TextButton")
                CheckBox.Name = "CheckBox"
                CheckBox.Size = UDim2.new(0, 15, 0, 15)
                CheckBox.LayoutOrder = 100
                CheckBox.BackgroundColor3 = default and Library.Theme.ToggleOn or Library.Theme.ToggleOff
                CheckBox.BorderSizePixel = 0
                CheckBox.Text = ""
                CheckBox.AutoButtonColor = false
                CheckBox.ZIndex = 11
                CheckBox.Parent = RightElements

                -- Rounded 5px Checkbox
                local CheckCorner = Instance.new("UICorner")
                CheckCorner.CornerRadius = UDim.new(0, 5)
                CheckCorner.Parent = CheckBox

                local CheckStroke = Instance.new("UIStroke")
                CheckStroke.Color = default and Library.Theme.Accent or Library.Theme.CardBorder
                CheckStroke.Thickness = 1
                CheckStroke.Parent = CheckBox

                local state = default
                if flag then Library.Flags[flag] = state end

                local function setToggle(val, ignoreCallback)
                    state = val
                    if flag then Library.Flags[flag] = state end
                    
                    if state then
                        createTween(CheckBox, { BackgroundColor3 = Library.Theme.ToggleOn }, 0.15)
                        createTween(CheckStroke, { Color = Library.Theme.Accent }, 0.15)
                        createTween(Label, { TextColor3 = Library.Theme.Text }, 0.15)
                    else
                        createTween(CheckBox, { BackgroundColor3 = Library.Theme.ToggleOff }, 0.15)
                        createTween(CheckStroke, { Color = Library.Theme.CardBorder }, 0.15)
                        createTween(Label, { TextColor3 = Library.Theme.TextDim }, 0.15)
                    end
                    
                    if not ignoreCallback then
                        task.spawn(callback, state)
                    end
                end

                CheckBox.MouseButton1Click:Connect(function()
                    setToggle(not state)
                end)

                local ToggleObj = {
                    Value = state,
                    Set = setToggle,
                    RightElements = RightElements
                }

                -- Multi ColorPicker
                function ToggleObj:AddColorPicker(cpConfig)
                    cpConfig = cpConfig or {}
                    local cpDefault = cpConfig.Default or Library.Theme.Accent
                    local cpCallback = cpConfig.Callback or function() end
                    local cpFlag = cpConfig.Flag

                    local ColorBox = Instance.new("TextButton")
                    ColorBox.Name = "ColorBox"
                    ColorBox.Size = UDim2.new(0, 18, 0, 13)
                    ColorBox.BackgroundColor3 = cpDefault
                    ColorBox.BorderSizePixel = 0
                    ColorBox.Text = ""
                    ColorBox.AutoButtonColor = false
                    ColorBox.LayoutOrder = 10
                    ColorBox.ZIndex = 11
                    ColorBox.Parent = RightElements

                    -- Rounded 5px ColorBox
                    local BoxCorner = Instance.new("UICorner")
                    BoxCorner.CornerRadius = UDim.new(0, 5)
                    BoxCorner.Parent = ColorBox

                    local BoxStroke = Instance.new("UIStroke")
                    BoxStroke.Color = Library.Theme.CardBorder
                    BoxStroke.Thickness = 1
                    BoxStroke.Parent = ColorBox

                    local currentColor = cpDefault
                    if cpFlag then Library.Flags[cpFlag] = currentColor end

                    -- Color Picker Overlay (Rounded 10px)
                    local PickerFrame = Instance.new("Frame")
                    PickerFrame.Name = "ColorPickerPopup"
                    PickerFrame.Size = UDim2.new(0, 160, 0, 140)
                    PickerFrame.BackgroundColor3 = Library.Theme.CardBackground
                    PickerFrame.BorderSizePixel = 0
                    PickerFrame.Visible = false
                    PickerFrame.ZIndex = 60
                    PickerFrame.Parent = Overlay
                    Library:RegisterThemeObject(PickerFrame, "BackgroundColor3", "CardBackground")

                    local PickerCorner = Instance.new("UICorner")
                    PickerCorner.CornerRadius = UDim.new(0, 10)
                    PickerCorner.Parent = PickerFrame

                    local PickerStroke = Instance.new("UIStroke")
                    PickerStroke.Color = Library.Theme.CardBorder
                    PickerStroke.Thickness = 1
                    PickerStroke.Parent = PickerFrame

                    local SatVal = Instance.new("TextButton")
                    SatVal.Name = "SatVal"
                    SatVal.Size = UDim2.new(1, -16, 0, 90)
                    SatVal.Position = UDim2.new(0, 8, 0, 8)
                    SatVal.BackgroundColor3 = cpDefault
                    SatVal.BorderSizePixel = 0
                    SatVal.Text = ""
                    SatVal.AutoButtonColor = false
                    SatVal.ZIndex = 61
                    SatVal.Parent = PickerFrame

                    local SatValCorner = Instance.new("UICorner")
                    SatValCorner.CornerRadius = UDim.new(0, 8)
                    SatValCorner.Parent = SatVal

                    local HueBar = Instance.new("TextButton")
                    HueBar.Name = "HueBar"
                    HueBar.Size = UDim2.new(1, -16, 0, 14)
                    HueBar.Position = UDim2.new(0, 8, 0, 106)
                    HueBar.BorderSizePixel = 0
                    HueBar.Text = ""
                    HueBar.AutoButtonColor = false
                    HueBar.ZIndex = 61
                    HueBar.Parent = PickerFrame

                    local HueCorner = Instance.new("UICorner")
                    HueCorner.CornerRadius = UDim.new(0, 6)
                    HueCorner.Parent = HueBar

                    local HueGradient = Instance.new("UIGradient")
                    HueGradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    })
                    HueGradient.Parent = HueBar

                    local h, s, v = cpDefault:ToHSV()

                    local function updateColor()
                        currentColor = Color3.fromHSV(h, s, v)
                        ColorBox.BackgroundColor3 = currentColor
                        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        if cpFlag then Library.Flags[cpFlag] = currentColor end
                        task.spawn(cpCallback, currentColor)
                    end

                    ColorBox.MouseButton1Click:Connect(function()
                        PickerFrame.Visible = not PickerFrame.Visible
                        if PickerFrame.Visible then
                            local absPos = ColorBox.AbsolutePosition
                            local mainPos = MainFrame.AbsolutePosition
                            PickerFrame.Position = UDim2.new(0, absPos.X - mainPos.X - 140, 0, absPos.Y - mainPos.Y + 20)
                            PickerFrame:SetAttribute("ActivatorPos", Vector2.new(absPos.X, absPos.Y))
                        end
                    end)

                    local draggingHue = false
                    HueBar.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            draggingHue = true
                            local percent = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                            h = 1 - percent
                            updateColor()
                        end
                    end)

                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            draggingHue = false
                        end
                    end)

                    UserInputService.InputChanged:Connect(function(input)
                        if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            local percent = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                            h = 1 - percent
                            updateColor()
                        end
                    end)

                    return ToggleObj
                end

                -- Keybind
                function ToggleObj:AddKeybind(kbConfig)
                    kbConfig = kbConfig or {}
                    local defaultKey = kbConfig.Default or Enum.KeyCode.Unknown
                    local kbCallback = kbConfig.Callback or function() end
                    local currentKey = defaultKey
                    local binding = false

                    local KeyBtn = Instance.new("TextButton")
                    KeyBtn.Name = "KeybindBtn"
                    KeyBtn.Size = UDim2.new(0, 24, 0, 15)
                    KeyBtn.BackgroundColor3 = Library.Theme.ItemBg
                    KeyBtn.BorderSizePixel = 0
                    KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                    KeyBtn.TextColor3 = Library.Theme.TextDark
                    KeyBtn.Font = Enum.Font.GothamBold
                    KeyBtn.TextSize = 10
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.LayoutOrder = 5
                    KeyBtn.ZIndex = 11
                    KeyBtn.Parent = RightElements

                    -- Rounded 5px KeyBtn
                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 5)
                    KeyCorner.Parent = KeyBtn

                    local KeyStroke = Instance.new("UIStroke")
                    KeyStroke.Color = Library.Theme.CardBorder
                    KeyStroke.Thickness = 1
                    KeyStroke.Parent = KeyBtn

                    KeyBtn.MouseButton1Click:Connect(function()
                        binding = true
                        KeyBtn.Text = "..."
                        KeyBtn.TextColor3 = Library.Theme.Accent
                    end)

                    UserInputService.InputBegan:Connect(function(input, gpe)
                        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                currentKey = Enum.KeyCode.Unknown
                                KeyBtn.Text = "..."
                            else
                                currentKey = input.KeyCode
                                KeyBtn.Text = input.KeyCode.Name
                            end
                            binding = false
                            KeyBtn.TextColor3 = Library.Theme.TextDark
                            task.spawn(kbCallback, currentKey)
                        elseif not gpe and not binding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                            setToggle(not state)
                        end
                    end)

                    return ToggleObj
                end

                return ToggleObj
            end

            -- ==================== SLIDER ====================
            function SectionObj:AddSlider(sliderConfig)
                sliderConfig = sliderConfig or {}
                local name = sliderConfig.Name or "Slider"
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Default or min
                local precise = sliderConfig.Precise or 0
                local suffix = sliderConfig.Suffix or ""
                local callback = sliderConfig.Callback or function() end
                local flag = sliderConfig.Flag

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = name .. "_Slider"
                SliderFrame.Size = UDim2.new(1, 0, 0, 36)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.ZIndex = 10
                SliderFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.7, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0.3, 0, 0, 16)
                ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default) .. suffix
                ValueLabel.TextColor3 = Library.Theme.Text
                ValueLabel.Font = Enum.Font.GothamMedium
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.ZIndex = 10
                ValueLabel.Parent = SliderFrame

                local Track = Instance.new("TextButton")
                Track.Name = "Track"
                Track.Size = UDim2.new(1, 0, 0, 6)
                Track.Position = UDim2.new(0, 0, 0, 22)
                Track.BackgroundColor3 = Library.Theme.SliderTrack
                Track.BorderSizePixel = 0
                Track.Text = ""
                Track.AutoButtonColor = false
                Track.ZIndex = 11
                Track.Parent = SliderFrame
                Library:RegisterThemeObject(Track, "BackgroundColor3", "SliderTrack")

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local Fill = Instance.new("Frame")
                Fill.Name = "Fill"
                local initPercent = math.clamp((default - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(initPercent, 0, 1, 0)
                Fill.BackgroundColor3 = Library.Theme.SliderFill
                Fill.BorderSizePixel = 0
                Fill.ZIndex = 12
                Fill.Parent = Track
                Library:RegisterThemeObject(Fill, "BackgroundColor3", "Accent")

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                local currentValue = default
                if flag then Library.Flags[flag] = currentValue end

                local function setSlider(val, ignoreCallback)
                    val = math.clamp(val, min, max)
                    if precise == 0 then
                        val = math.floor(val + 0.5)
                    else
                        val = math.floor(val * (10 ^ precise) + 0.5) / (10 ^ precise)
                    end
                    currentValue = val
                    if flag then Library.Flags[flag] = currentValue end

                    ValueLabel.Text = tostring(currentValue) .. suffix
                    local percent = math.clamp((currentValue - min) / (max - min), 0, 1)
                    createTween(Fill, { Size = UDim2.new(percent, 0, 1, 0) }, 0.08)

                    if not ignoreCallback then
                        task.spawn(callback, currentValue)
                    end
                end

                local dragging = false
                Track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        setSlider(min + (max - min) * percent)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percent = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                        setSlider(min + (max - min) * percent)
                    end
                end)

                return {
                    Value = currentValue,
                    Set = setSlider
                }
            end

            -- ==================== DROPDOWN ====================
            function SectionObj:AddDropdown(dropdownConfig)
                dropdownConfig = dropdownConfig or {}
                local name = dropdownConfig.Name or "Dropdown"
                local options = dropdownConfig.Options or {}
                local default = dropdownConfig.Default or options[1] or ""
                local callback = dropdownConfig.Callback or function() end
                local flag = dropdownConfig.Flag

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = name .. "_Dropdown"
                DropdownFrame.Size = UDim2.new(1, 0, 0, 46)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.ZIndex = 10
                DropdownFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = DropdownFrame

                local Selector = Instance.new("TextButton")
                Selector.Name = "Selector"
                Selector.Size = UDim2.new(1, 0, 0, 26)
                Selector.Position = UDim2.new(0, 0, 0, 18)
                Selector.BackgroundColor3 = Library.Theme.ItemBg
                Selector.BorderSizePixel = 0
                Selector.Text = ""
                Selector.AutoButtonColor = false
                Selector.ZIndex = 11
                Selector.Parent = DropdownFrame
                Library:RegisterThemeObject(Selector, "BackgroundColor3", "ItemBg")

                -- Rounded 8px Selector
                local SelCorner = Instance.new("UICorner")
                SelCorner.CornerRadius = UDim.new(0, 8)
                SelCorner.Parent = Selector

                local SelStroke = Instance.new("UIStroke")
                SelStroke.Color = Library.Theme.ItemBorder
                SelStroke.Thickness = 1
                SelStroke.Parent = Selector
                Library:RegisterThemeObject(SelStroke, "Color", "ItemBorder")

                local SelText = Instance.new("TextLabel")
                SelText.Size = UDim2.new(1, -30, 1, 0)
                SelText.Position = UDim2.new(0, 10, 0, 0)
                SelText.BackgroundTransparency = 1
                SelText.Text = tostring(default)
                SelText.TextColor3 = Library.Theme.Text
                SelText.Font = Enum.Font.GothamMedium
                SelText.TextSize = 12
                SelText.TextXAlignment = Enum.TextXAlignment.Left
                SelText.ZIndex = 12
                SelText.Parent = Selector

                local MenuIcon = Instance.new("TextLabel")
                MenuIcon.Size = UDim2.new(0, 20, 1, 0)
                MenuIcon.Position = UDim2.new(1, -24, 0, 0)
                MenuIcon.BackgroundTransparency = 1
                MenuIcon.Text = "≡"
                MenuIcon.TextColor3 = Library.Theme.TextDark
                MenuIcon.Font = Enum.Font.GothamBold
                MenuIcon.TextSize = 14
                MenuIcon.ZIndex = 12
                MenuIcon.Parent = Selector

                -- Rounded 8px DropList
                local DropList = Instance.new("Frame")
                DropList.Name = "DropList"
                DropList.Size = UDim2.new(1, 0, 0, 0)
                DropList.AutomaticSize = Enum.AutomaticSize.Y
                DropList.BackgroundColor3 = Library.Theme.CardBackground
                DropList.BorderSizePixel = 0
                DropList.Visible = false
                DropList.ZIndex = 70
                DropList.Parent = Overlay
                Library:RegisterThemeObject(DropList, "BackgroundColor3", "CardBackground")

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 8)
                DropCorner.Parent = DropList

                local DropStroke = Instance.new("UIStroke")
                DropStroke.Color = Library.Theme.CardBorder
                DropStroke.Thickness = 1
                DropStroke.Parent = DropList

                local DropLayout = Instance.new("UIListLayout")
                DropLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropLayout.Padding = UDim.new(0, 2)
                DropLayout.Parent = DropList

                local DropPadding = Instance.new("UIPadding")
                DropPadding.PaddingTop = UDim.new(0, 4)
                DropPadding.PaddingBottom = UDim.new(0, 4)
                DropPadding.PaddingLeft = UDim.new(0, 4)
                DropPadding.PaddingRight = UDim.new(0, 4)
                DropPadding.Parent = DropList

                local currentSelected = default
                if flag then Library.Flags[flag] = currentSelected end

                local function refreshOptions()
                    for _, child in ipairs(DropList:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    for _, opt in ipairs(options) do
                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Name = tostring(opt)
                        OptBtn.Size = UDim2.new(1, 0, 0, 24)
                        OptBtn.BackgroundColor3 = (opt == currentSelected) and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                        OptBtn.BackgroundTransparency = (opt == currentSelected) and 0 or 1
                        OptBtn.Text = "  " .. tostring(opt)
                        OptBtn.TextColor3 = (opt == currentSelected) and Library.Theme.Accent or Library.Theme.TextDim
                        OptBtn.Font = Enum.Font.GothamMedium
                        OptBtn.TextSize = 11
                        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OptBtn.AutoButtonColor = false
                        OptBtn.ZIndex = 71
                        OptBtn.Parent = DropList

                        -- Rounded 6px Option Button
                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 6)
                        OptCorner.Parent = OptBtn

                        OptBtn.MouseButton1Click:Connect(function()
                            currentSelected = opt
                            SelText.Text = tostring(opt)
                            if flag then Library.Flags[flag] = currentSelected end
                            DropList.Visible = false
                            task.spawn(callback, opt)
                            refreshOptions()
                        end)
                    end
                end

                refreshOptions()

                Selector.MouseButton1Click:Connect(function()
                    DropList.Visible = not DropList.Visible
                    if DropList.Visible then
                        local absPos = Selector.AbsolutePosition
                        local mainPos = MainFrame.AbsolutePosition
                        DropList.Size = UDim2.new(0, Selector.AbsoluteSize.X, 0, 0)
                        DropList.Position = UDim2.new(0, absPos.X - mainPos.X, 0, absPos.Y - mainPos.Y + 30)
                        DropList:SetAttribute("ActivatorPos", Vector2.new(absPos.X, absPos.Y))
                    end
                end)

                return {
                    Value = currentSelected,
                    Set = function(val)
                        currentSelected = val
                        SelText.Text = tostring(val)
                        if flag then Library.Flags[flag] = currentSelected end
                        refreshOptions()
                    end,
                    Refresh = function(newOpts)
                        options = newOpts
                        refreshOptions()
                    end
                }
            end

            -- ==================== LISTBOX ====================
            function SectionObj:AddListbox(listConfig)
                listConfig = listConfig or {}
                local name = listConfig.Name or "Listbox"
                local items = listConfig.Items or {}
                local default = listConfig.Default or items[1]
                local callback = listConfig.Callback or function() end
                local flag = listConfig.Flag
                local height = listConfig.Height or 120

                local ListboxFrame = Instance.new("Frame")
                ListboxFrame.Name = name .. "_Listbox"
                ListboxFrame.Size = UDim2.new(1, 0, 0, height + 24)
                ListboxFrame.BackgroundTransparency = 1
                ListboxFrame.ZIndex = 10
                ListboxFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = ListboxFrame

                local Container = Instance.new("ScrollingFrame")
                Container.Name = "Container"
                Container.Size = UDim2.new(1, 0, 0, height)
                Container.Position = UDim2.new(0, 0, 0, 20)
                Container.BackgroundColor3 = Library.Theme.ItemBg
                Container.BorderSizePixel = 0
                Container.ScrollBarThickness = 2
                Container.ScrollBarImageColor3 = Library.Theme.CardBorder
                Container.CanvasSize = UDim2.new(0, 0, 0, 0)
                Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
                Container.ZIndex = 11
                Container.Parent = ListboxFrame
                Library:RegisterThemeObject(Container, "BackgroundColor3", "ItemBg")

                -- Rounded 8px Listbox Container
                local ContCorner = Instance.new("UICorner")
                ContCorner.CornerRadius = UDim.new(0, 8)
                ContCorner.Parent = Container

                local ContStroke = Instance.new("UIStroke")
                ContStroke.Color = Library.Theme.ItemBorder
                ContStroke.Thickness = 1
                ContStroke.Parent = Container

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 2)
                ListLayout.Parent = Container

                local ListPadding = Instance.new("UIPadding")
                ListPadding.PaddingTop = UDim.new(0, 4)
                ListPadding.PaddingBottom = UDim.new(0, 4)
                ListPadding.PaddingLeft = UDim.new(0, 4)
                ListPadding.PaddingRight = UDim.new(0, 4)
                ListPadding.Parent = Container

                local currentSelected = default
                if flag then Library.Flags[flag] = currentSelected end

                local function refreshItems()
                    for _, child in ipairs(Container:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    for _, item in ipairs(items) do
                        local isSelected = (item == currentSelected)
                        local ItemBtn = Instance.new("TextButton")
                        ItemBtn.Name = tostring(item)
                        ItemBtn.Size = UDim2.new(1, 0, 0, 22)
                        ItemBtn.BackgroundColor3 = isSelected and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                        ItemBtn.BackgroundTransparency = isSelected and 0.4 or 1
                        ItemBtn.Text = "  " .. tostring(item)
                        ItemBtn.TextColor3 = isSelected and Library.Theme.Accent or Library.Theme.TextDim
                        ItemBtn.Font = Enum.Font.GothamMedium
                        ItemBtn.TextSize = 11
                        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        ItemBtn.AutoButtonColor = false
                        ItemBtn.ZIndex = 12
                        ItemBtn.Parent = Container

                        -- Rounded 6px Listbox Item
                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 6)
                        ItemCorner.Parent = ItemBtn

                        ItemBtn.MouseButton1Click:Connect(function()
                            currentSelected = item
                            if flag then Library.Flags[flag] = currentSelected end
                            refreshItems()
                            task.spawn(callback, item)
                        end)
                    end
                end

                refreshItems()

                return {
                    Value = currentSelected,
                    Set = function(val)
                        currentSelected = val
                        if flag then Library.Flags[flag] = currentSelected end
                        refreshItems()
                    end,
                    Refresh = function(newItems)
                        items = newItems
                        refreshItems()
                    end
                }
            end

            -- ==================== BUTTON ====================
            function SectionObj:AddButton(btnConfig)
                btnConfig = btnConfig or {}
                local name = btnConfig.Name or "Button"
                local callback = btnConfig.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.Name = name .. "_Button"
                Button.Size = UDim2.new(1, 0, 0, 28)
                Button.BackgroundColor3 = Library.Theme.ItemBg
                Button.BorderSizePixel = 0
                Button.Text = name
                Button.TextColor3 = Library.Theme.Text
                Button.Font = Enum.Font.GothamMedium
                Button.TextSize = 12
                Button.AutoButtonColor = false
                Button.ZIndex = 10
                Button.Parent = CardContainer
                Library:RegisterThemeObject(Button, "BackgroundColor3", "ItemBg")

                -- Rounded 8px Button
                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 8)
                BtnCorner.Parent = Button

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Library.Theme.ItemBorder
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Button

                Button.MouseEnter:Connect(function()
                    createTween(Button, { BackgroundColor3 = Library.Theme.ItemBgHover }, 0.15)
                    createTween(BtnStroke, { Color = Library.Theme.Accent }, 0.15)
                end)

                Button.MouseLeave:Connect(function()
                    createTween(Button, { BackgroundColor3 = Library.Theme.ItemBg }, 0.15)
                    createTween(BtnStroke, { Color = Library.Theme.ItemBorder }, 0.15)
                end)

                Button.MouseButton1Click:Connect(function()
                    createTween(Button, { BackgroundColor3 = Library.Theme.AccentDark }, 0.08)
                    task.delay(0.1, function()
                        createTween(Button, { BackgroundColor3 = Library.Theme.ItemBgHover }, 0.1)
                    end)
                    task.spawn(callback)
                end)

                return Button
            end

            -- ==================== TEXT INPUT ====================
            function SectionObj:AddInput(inputConfig)
                inputConfig = inputConfig or {}
                local name = inputConfig.Name or "Input"
                local placeholder = inputConfig.Placeholder or "Type here..."
                local callback = inputConfig.Callback or function() end
                local flag = inputConfig.Flag

                local InputFrame = Instance.new("Frame")
                InputFrame.Name = name .. "_InputFrame"
                InputFrame.Size = UDim2.new(1, 0, 0, 48)
                InputFrame.BackgroundTransparency = 1
                InputFrame.ZIndex = 10
                InputFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = InputFrame

                local BoxContainer = Instance.new("Frame")
                BoxContainer.Size = UDim2.new(1, 0, 0, 26)
                BoxContainer.Position = UDim2.new(0, 0, 0, 20)
                BoxContainer.BackgroundColor3 = Library.Theme.ItemBg
                BoxContainer.BorderSizePixel = 0
                BoxContainer.ZIndex = 11
                BoxContainer.Parent = InputFrame
                Library:RegisterThemeObject(BoxContainer, "BackgroundColor3", "ItemBg")

                -- Rounded 8px Input Box
                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 8)
                BoxCorner.Parent = BoxContainer

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = Library.Theme.ItemBorder
                BoxStroke.Thickness = 1
                BoxStroke.Parent = BoxContainer

                local TextBox = Instance.new("TextBox")
                TextBox.Size = UDim2.new(1, -16, 1, 0)
                TextBox.Position = UDim2.new(0, 8, 0, 0)
                TextBox.BackgroundTransparency = 1
                TextBox.Text = ""
                TextBox.PlaceholderText = placeholder
                TextBox.PlaceholderColor3 = Library.Theme.TextDark
                TextBox.TextColor3 = Library.Theme.Text
                TextBox.Font = Enum.Font.GothamMedium
                TextBox.TextSize = 12
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.ClearTextOnFocus = false
                TextBox.ZIndex = 12
                TextBox.Parent = BoxContainer

                TextBox.Focused:Connect(function()
                    createTween(BoxStroke, { Color = Library.Theme.Accent }, 0.15)
                end)

                TextBox.FocusLost:Connect(function(enterPressed)
                    createTween(BoxStroke, { Color = Library.Theme.ItemBorder }, 0.15)
                    if flag then Library.Flags[flag] = TextBox.Text end
                    task.spawn(callback, TextBox.Text, enterPressed)
                end)

                return {
                    Value = TextBox.Text,
                    Set = function(text)
                        TextBox.Text = text
                        if flag then Library.Flags[flag] = text end
                    end
                }
            end

            return SectionObj
        end

        return TabObj
    end

    -- ==================== NOTIFICATION ====================
    function Library:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "Nameless"
        local content = notifConfig.Content or ""
        local duration = notifConfig.Duration or 3

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Name = "Notification"
        NotifFrame.Size = UDim2.new(0, 240, 0, 58)
        NotifFrame.Position = UDim2.new(1, 260, 1, -75)
        NotifFrame.BackgroundColor3 = Library.Theme.Background
        NotifFrame.BorderSizePixel = 0
        NotifFrame.ZIndex = 100
        NotifFrame.Parent = ScreenGui

        -- Rounded 10px Notification
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 10)
        NotifCorner.Parent = NotifFrame

        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Library.Theme.Accent
        NotifStroke.Thickness = 1.2
        NotifStroke.Parent = NotifFrame

        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 18)
        NotifTitle.Position = UDim2.new(0, 12, 0, 8)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Library.Theme.Accent
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = 13
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.ZIndex = 101
        NotifTitle.Parent = NotifFrame

        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -20, 0, 18)
        NotifContent.Position = UDim2.new(0, 12, 0, 28)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = content
        NotifContent.TextColor3 = Library.Theme.TextDim
        NotifContent.Font = Enum.Font.GothamMedium
        NotifContent.TextSize = 11
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.ZIndex = 101
        NotifContent.Parent = NotifFrame

        createTween(NotifFrame, { Position = UDim2.new(1, -260, 1, -75) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.delay(duration, function()
            local tw = createTween(NotifFrame, { Position = UDim2.new(1, 260, 1, -75) }, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end)
    end

    -- ==================== THEME MANAGER HELPER ====================
    function WindowObj:CreateThemeManager(targetSection)
        targetSection:AddDropdown({
            Name = "Select Theme",
            Options = { "Nameless", "Midnight", "Emerald", "Crimson", "Sakura" },
            Default = Library.CurrentTheme,
            Callback = function(theme)
                Library:SetTheme(theme)
            end
        })

        local AccentToggle = targetSection:AddToggle({
            Name = "Custom Accent Color",
            Default = false,
            Callback = function() end
        })
        AccentToggle:AddColorPicker({
            Default = Library.Theme.Accent,
            Callback = function(col)
                Library:SetAccent(col)
            end
        })
    end

    -- ==================== UI / CONFIG MANAGER HELPER ====================
    function WindowObj:CreateConfigManager(targetSection, folderName)
        folderName = folderName or "NamelessConfigs"
        
        local function ensureFolder()
            if makefolder and isfolder and not isfolder(folderName) then
                makefolder(folderName)
            end
        end

        local function getConfigs()
            ensureFolder()
            local list = {}
            if listfiles then
                for _, file in ipairs(listfiles(folderName)) do
                    local name = file:match("([^/\\]+)%.json$")
                    if name then table.insert(list, name) end
                end
            end
            if #list == 0 then table.insert(list, "default") end
            return list
        end

        local configName = "default"
        local configDropdown

        targetSection:AddInput({
            Name = "Config Name",
            Placeholder = "Enter config name...",
            Callback = function(text)
                if text and #text > 0 then
                    configName = text
                end
            end
        })

        configDropdown = targetSection:AddDropdown({
            Name = "Saved Configs",
            Options = getConfigs(),
            Default = "default",
            Callback = function(selected)
                configName = selected
            end
        })

        targetSection:AddButton({
            Name = "Save Config",
            Callback = function()
                ensureFolder()
                if writefile then
                    local data = HttpService:JSONEncode(Library.Flags)
                    writefile(folderName .. "/" .. configName .. ".json", data)
                    configDropdown.Refresh(getConfigs())
                    Library:Notify({
                        Title = "Config Manager",
                        Content = "Saved config: " .. configName,
                        Duration = 3
                    })
                end
            end
        })

        targetSection:AddButton({
            Name = "Load Config",
            Callback = function()
                ensureFolder()
                local path = folderName .. "/" .. configName .. ".json"
                if readfile and isfile and isfile(path) then
                    local data = HttpService:JSONDecode(readfile(path))
                    for flag, val in pairs(data) do
                        Library.Flags[flag] = val
                    end
                    Library:Notify({
                        Title = "Config Manager",
                        Content = "Loaded config: " .. configName,
                        Duration = 3
                    })
                end
            end
        })

        targetSection:AddButton({
            Name = "Refresh List",
            Callback = function()
                configDropdown.Refresh(getConfigs())
            end
        })
    end

    return WindowObj
end

return Library
