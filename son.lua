--[[
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║                         NAMELESS UI LIBRARY v3.4                         ║
    ║   Sidebar Tabs | 15+ Modern Themes | UI Manager | Mobile & GIF Support   ║
    ║   Live User Tracker (Avatar, Execution Time, FPS, Ping) | Gotham Fonts   ║
    ║   Extra Smooth Rounded Corners | Untinted Logo | Full SaveManager        ║
    ╚══════════════════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local StartExecutionTime = tick()

local Library = {
    Version = "3.4.0",
    Flags = {},
    Signals = {},
    Toggles = {},
    Options = {},
    Registry = {},
    Buttons = {},
    Folder = "NamelessConfigs",
    IgnoreIndexes = {},
    Fonts = {
        Bold = Enum.Font.GothamBold,
        Medium = Enum.Font.GothamMedium,
        Regular = Enum.Font.Gotham
    },
    Themes = {
        Nameless = {
            Background = Color3.fromRGB(12, 11, 17),
            Sidebar = Color3.fromRGB(9, 8, 13),
            CardBackground = Color3.fromRGB(17, 15, 25),
            CardBorder = Color3.fromRGB(32, 28, 46),
            CardBorderHover = Color3.fromRGB(56, 46, 78),
            Accent = Color3.fromRGB(168, 85, 247),
            AccentSecondary = Color3.fromRGB(192, 132, 252),
            AccentDark = Color3.fromRGB(115, 45, 190),
            Text = Color3.fromRGB(245, 245, 250),
            TextDim = Color3.fromRGB(155, 150, 175),
            TextDark = Color3.fromRGB(95, 90, 115),
            ItemBg = Color3.fromRGB(22, 20, 32),
            ItemBgHover = Color3.fromRGB(30, 26, 44),
            ItemBorder = Color3.fromRGB(38, 34, 54),
            SliderTrack = Color3.fromRGB(20, 18, 28),
            SliderFill = Color3.fromRGB(168, 85, 247),
            ToggleOff = Color3.fromRGB(24, 22, 34),
            ToggleOn = Color3.fromRGB(168, 85, 247)
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
        },
        Cyberpunk = {
            Background = Color3.fromRGB(14, 14, 14),
            Sidebar = Color3.fromRGB(10, 10, 10),
            CardBackground = Color3.fromRGB(20, 20, 20),
            CardBorder = Color3.fromRGB(38, 38, 38),
            CardBorderHover = Color3.fromRGB(60, 60, 60),
            Accent = Color3.fromRGB(255, 230, 40),
            AccentSecondary = Color3.fromRGB(40, 240, 230),
            AccentDark = Color3.fromRGB(180, 160, 20),
            Text = Color3.fromRGB(250, 250, 250),
            TextDim = Color3.fromRGB(160, 160, 160),
            TextDark = Color3.fromRGB(90, 90, 90),
            ItemBg = Color3.fromRGB(26, 26, 26),
            ItemBgHover = Color3.fromRGB(34, 34, 34),
            ItemBorder = Color3.fromRGB(44, 44, 44),
            SliderTrack = Color3.fromRGB(24, 24, 24),
            SliderFill = Color3.fromRGB(255, 230, 40),
            ToggleOff = Color3.fromRGB(26, 26, 26),
            ToggleOn = Color3.fromRGB(255, 230, 40)
        },
        TokyoNight = {
            Background = Color3.fromRGB(15, 16, 24),
            Sidebar = Color3.fromRGB(11, 12, 18),
            CardBackground = Color3.fromRGB(22, 24, 36),
            CardBorder = Color3.fromRGB(36, 40, 60),
            CardBorderHover = Color3.fromRGB(56, 62, 90),
            Accent = Color3.fromRGB(122, 162, 247),
            AccentSecondary = Color3.fromRGB(187, 154, 247),
            AccentDark = Color3.fromRGB(61, 89, 161),
            Text = Color3.fromRGB(240, 244, 255),
            TextDim = Color3.fromRGB(140, 150, 180),
            TextDark = Color3.fromRGB(80, 90, 120),
            ItemBg = Color3.fromRGB(26, 28, 44),
            ItemBgHover = Color3.fromRGB(34, 38, 58),
            ItemBorder = Color3.fromRGB(42, 46, 70),
            SliderTrack = Color3.fromRGB(20, 22, 34),
            SliderFill = Color3.fromRGB(122, 162, 247),
            ToggleOff = Color3.fromRGB(26, 28, 44),
            ToggleOn = Color3.fromRGB(122, 162, 247)
        },
        Synthwave = {
            Background = Color3.fromRGB(18, 12, 26),
            Sidebar = Color3.fromRGB(13, 8, 19),
            CardBackground = Color3.fromRGB(28, 18, 40),
            CardBorder = Color3.fromRGB(48, 30, 68),
            CardBorderHover = Color3.fromRGB(78, 48, 108),
            Accent = Color3.fromRGB(255, 45, 135),
            AccentSecondary = Color3.fromRGB(45, 235, 255),
            AccentDark = Color3.fromRGB(180, 25, 95),
            Text = Color3.fromRGB(255, 240, 250),
            TextDim = Color3.fromRGB(175, 140, 180),
            TextDark = Color3.fromRGB(115, 85, 120),
            ItemBg = Color3.fromRGB(36, 22, 50),
            ItemBgHover = Color3.fromRGB(48, 30, 66),
            ItemBorder = Color3.fromRGB(60, 36, 82),
            SliderTrack = Color3.fromRGB(30, 18, 42),
            SliderFill = Color3.fromRGB(255, 45, 135),
            ToggleOff = Color3.fromRGB(36, 22, 50),
            ToggleOn = Color3.fromRGB(255, 45, 135)
        },
        NordFrost = {
            Background = Color3.fromRGB(14, 17, 22),
            Sidebar = Color3.fromRGB(10, 13, 17),
            CardBackground = Color3.fromRGB(20, 25, 32),
            CardBorder = Color3.fromRGB(32, 42, 54),
            CardBorderHover = Color3.fromRGB(50, 65, 84),
            Accent = Color3.fromRGB(136, 192, 208),
            AccentSecondary = Color3.fromRGB(129, 161, 193),
            AccentDark = Color3.fromRGB(94, 129, 172),
            Text = Color3.fromRGB(236, 239, 244),
            TextDim = Color3.fromRGB(145, 158, 178),
            TextDark = Color3.fromRGB(85, 98, 118),
            ItemBg = Color3.fromRGB(24, 30, 40),
            ItemBgHover = Color3.fromRGB(32, 40, 52),
            ItemBorder = Color3.fromRGB(40, 50, 65),
            SliderTrack = Color3.fromRGB(18, 22, 30),
            SliderFill = Color3.fromRGB(136, 192, 208),
            ToggleOff = Color3.fromRGB(24, 30, 40),
            ToggleOn = Color3.fromRGB(136, 192, 208)
        },
        Monokai = {
            Background = Color3.fromRGB(16, 16, 15),
            Sidebar = Color3.fromRGB(12, 12, 11),
            CardBackground = Color3.fromRGB(24, 24, 22),
            CardBorder = Color3.fromRGB(42, 42, 38),
            CardBorderHover = Color3.fromRGB(65, 65, 58),
            Accent = Color3.fromRGB(255, 135, 40),
            AccentSecondary = Color3.fromRGB(166, 226, 46),
            AccentDark = Color3.fromRGB(185, 90, 20),
            Text = Color3.fromRGB(248, 248, 242),
            TextDim = Color3.fromRGB(160, 160, 150),
            TextDark = Color3.fromRGB(100, 100, 90),
            ItemBg = Color3.fromRGB(32, 32, 28),
            ItemBgHover = Color3.fromRGB(42, 42, 36),
            ItemBorder = Color3.fromRGB(50, 50, 44),
            SliderTrack = Color3.fromRGB(24, 24, 20),
            SliderFill = Color3.fromRGB(255, 135, 40),
            ToggleOff = Color3.fromRGB(32, 32, 28),
            ToggleOn = Color3.fromRGB(255, 135, 40)
        },
        Dracula = {
            Background = Color3.fromRGB(16, 14, 20),
            Sidebar = Color3.fromRGB(12, 10, 16),
            CardBackground = Color3.fromRGB(25, 22, 32),
            CardBorder = Color3.fromRGB(45, 38, 58),
            CardBorderHover = Color3.fromRGB(70, 60, 90),
            Accent = Color3.fromRGB(189, 147, 249),
            AccentSecondary = Color3.fromRGB(255, 121, 198),
            AccentDark = Color3.fromRGB(130, 90, 190),
            Text = Color3.fromRGB(248, 248, 242),
            TextDim = Color3.fromRGB(160, 150, 175),
            TextDark = Color3.fromRGB(98, 114, 164),
            ItemBg = Color3.fromRGB(34, 30, 44),
            ItemBgHover = Color3.fromRGB(44, 38, 58),
            ItemBorder = Color3.fromRGB(54, 46, 70),
            SliderTrack = Color3.fromRGB(26, 22, 34),
            SliderFill = Color3.fromRGB(189, 147, 249),
            ToggleOff = Color3.fromRGB(34, 30, 44),
            ToggleOn = Color3.fromRGB(189, 147, 249)
        },
        AcidGreen = {
            Background = Color3.fromRGB(10, 12, 10),
            Sidebar = Color3.fromRGB(7, 9, 7),
            CardBackground = Color3.fromRGB(16, 20, 16),
            CardBorder = Color3.fromRGB(26, 36, 26),
            CardBorderHover = Color3.fromRGB(45, 65, 45),
            Accent = Color3.fromRGB(140, 255, 50),
            AccentSecondary = Color3.fromRGB(90, 230, 80),
            AccentDark = Color3.fromRGB(90, 180, 25),
            Text = Color3.fromRGB(240, 255, 240),
            TextDim = Color3.fromRGB(140, 170, 140),
            TextDark = Color3.fromRGB(80, 105, 80),
            ItemBg = Color3.fromRGB(20, 26, 20),
            ItemBgHover = Color3.fromRGB(28, 36, 28),
            ItemBorder = Color3.fromRGB(34, 46, 34),
            SliderTrack = Color3.fromRGB(16, 22, 16),
            SliderFill = Color3.fromRGB(140, 255, 50),
            ToggleOff = Color3.fromRGB(20, 26, 20),
            ToggleOn = Color3.fromRGB(140, 255, 50)
        },
        SunsetAmber = {
            Background = Color3.fromRGB(16, 13, 11),
            Sidebar = Color3.fromRGB(12, 9, 8),
            CardBackground = Color3.fromRGB(26, 20, 16),
            CardBorder = Color3.fromRGB(46, 34, 26),
            CardBorderHover = Color3.fromRGB(75, 54, 40),
            Accent = Color3.fromRGB(250, 160, 45),
            AccentSecondary = Color3.fromRGB(245, 100, 50),
            AccentDark = Color3.fromRGB(180, 105, 25),
            Text = Color3.fromRGB(255, 245, 235),
            TextDim = Color3.fromRGB(175, 150, 135),
            TextDark = Color3.fromRGB(115, 90, 75),
            ItemBg = Color3.fromRGB(34, 26, 20),
            ItemBgHover = Color3.fromRGB(46, 34, 26),
            ItemBorder = Color3.fromRGB(56, 42, 32),
            SliderTrack = Color3.fromRGB(28, 20, 16),
            SliderFill = Color3.fromRGB(250, 160, 45),
            ToggleOff = Color3.fromRGB(34, 26, 20),
            ToggleOn = Color3.fromRGB(250, 160, 45)
        },
        RoseGold = {
            Background = Color3.fromRGB(17, 13, 15),
            Sidebar = Color3.fromRGB(13, 9, 11),
            CardBackground = Color3.fromRGB(27, 20, 23),
            CardBorder = Color3.fromRGB(48, 34, 40),
            CardBorderHover = Color3.fromRGB(78, 54, 64),
            Accent = Color3.fromRGB(235, 155, 165),
            AccentSecondary = Color3.fromRGB(245, 190, 198),
            AccentDark = Color3.fromRGB(170, 100, 110),
            Text = Color3.fromRGB(255, 245, 248),
            TextDim = Color3.fromRGB(175, 150, 160),
            TextDark = Color3.fromRGB(115, 90, 100),
            ItemBg = Color3.fromRGB(36, 26, 30),
            ItemBgHover = Color3.fromRGB(48, 34, 40),
            ItemBorder = Color3.fromRGB(58, 42, 50),
            SliderTrack = Color3.fromRGB(30, 20, 24),
            SliderFill = Color3.fromRGB(235, 155, 165),
            ToggleOff = Color3.fromRGB(36, 26, 30),
            ToggleOn = Color3.fromRGB(235, 155, 165)
        },
        PureObsidian = {
            Background = Color3.fromRGB(9, 9, 11),
            Sidebar = Color3.fromRGB(6, 6, 8),
            CardBackground = Color3.fromRGB(15, 15, 18),
            CardBorder = Color3.fromRGB(28, 28, 34),
            CardBorderHover = Color3.fromRGB(50, 50, 60),
            Accent = Color3.fromRGB(240, 240, 245),
            AccentSecondary = Color3.fromRGB(180, 180, 190),
            AccentDark = Color3.fromRGB(140, 140, 150),
            Text = Color3.fromRGB(250, 250, 255),
            TextDim = Color3.fromRGB(150, 150, 160),
            TextDark = Color3.fromRGB(80, 80, 90),
            ItemBg = Color3.fromRGB(20, 20, 24),
            ItemBgHover = Color3.fromRGB(28, 28, 34),
            ItemBorder = Color3.fromRGB(36, 36, 44),
            SliderTrack = Color3.fromRGB(18, 18, 22),
            SliderFill = Color3.fromRGB(240, 240, 245),
            ToggleOff = Color3.fromRGB(20, 20, 24),
            ToggleOn = Color3.fromRGB(240, 240, 245)
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

local function formatUptime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
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
    local footerUser = config.Footer or (LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name) or "User")
    local footerRank = config.FooterRight or "Lifetime"
    local windowSize = config.Size or UDim2.new(0, 720, 0, 510)
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local mobileLogo = config.MobileLogo or logoIcon
    local showMobile = config.ShowMobileButton ~= false

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = getGuiParent()

    -- Main Container Window (Extra Rounded 18px)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui
    Library:RegisterThemeObject(MainFrame, "BackgroundColor3", "Background")

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 18)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.CardBorder
    MainStroke.Thickness = 1.5
    MainStroke.Parent = MainFrame
    Library:RegisterThemeObject(MainStroke, "Color", "CardBorder")

    -- ==================== BACKGROUND IMAGE & GIF SUPPORT ====================
    local BackgroundContainer = Instance.new("Frame")
    BackgroundContainer.Name = "BackgroundContainer"
    BackgroundContainer.Size = UDim2.new(1, 0, 1, 0)
    BackgroundContainer.BackgroundTransparency = 1
    BackgroundContainer.ZIndex = 1
    BackgroundContainer.Parent = MainFrame

    local BackgroundCorner = Instance.new("UICorner")
    BackgroundCorner.CornerRadius = UDim.new(0, 18)
    BackgroundCorner.Parent = BackgroundContainer

    local BackgroundImage = Instance.new("ImageLabel")
    BackgroundImage.Name = "BackgroundImage"
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.ImageTransparency = 0.85
    BackgroundImage.ScaleType = Enum.ScaleType.Crop
    BackgroundImage.ZIndex = 1
    BackgroundImage.Parent = BackgroundContainer

    local BgImgCorner = Instance.new("UICorner")
    BgImgCorner.CornerRadius = UDim.new(0, 18)
    BgImgCorner.Parent = BackgroundImage

    local BackgroundOverlay = Instance.new("Frame")
    BackgroundOverlay.Name = "DarkOverlay"
    BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
    BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    BackgroundOverlay.BackgroundTransparency = 0.25
    BackgroundOverlay.ZIndex = 2
    BackgroundOverlay.Parent = BackgroundContainer

    local BgOverlayCorner = Instance.new("UICorner")
    BgOverlayCorner.CornerRadius = UDim.new(0, 18)
    BgOverlayCorner.Parent = BackgroundOverlay

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

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 18)
    SidebarCorner.Parent = Sidebar

    local SidebarSeam = Instance.new("Frame")
    SidebarSeam.Name = "SidebarSeam"
    SidebarSeam.Size = UDim2.new(0, 20, 1, 0)
    SidebarSeam.Position = UDim2.new(1, -20, 0, 0)
    SidebarSeam.BackgroundColor3 = Library.Theme.Sidebar
    SidebarSeam.BorderSizePixel = 0
    SidebarSeam.ZIndex = 5
    SidebarSeam.Parent = Sidebar
    Library:RegisterThemeObject(SidebarSeam, "BackgroundColor3", "Sidebar")

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
    BrandTitle.Text = '<b>' .. windowTitle .. '</b><font color="#a855f7">' .. windowSubtitle .. '</font>'
    BrandTitle.TextColor3 = Library.Theme.Text
    BrandTitle.Font = Library.Fonts.Bold
    BrandTitle.TextSize = 14
    BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
    BrandTitle.ZIndex = 7
    BrandTitle.Parent = BrandHeader

    -- Sidebar Tabs List
    local TabsContainer = Instance.new("ScrollingFrame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(1, 0, 1, -182)
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
    TabsListLayout.Padding = UDim.new(0, 6)
    TabsListLayout.Parent = TabsContainer

    local TabsPadding = Instance.new("UIPadding")
    TabsPadding.PaddingLeft = UDim.new(0, 10)
    TabsPadding.PaddingRight = UDim.new(0, 10)
    TabsPadding.PaddingTop = UDim.new(0, 8)
    TabsPadding.Parent = TabsContainer

    -- ==================== USER PROFILE & LIVE TRACKER ====================
    local SidebarFooter = Instance.new("Frame")
    SidebarFooter.Name = "SidebarFooter"
    SidebarFooter.Size = UDim2.new(1, 0, 0, 120)
    SidebarFooter.Position = UDim2.new(0, 0, 1, -120)
    SidebarFooter.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    SidebarFooter.BorderSizePixel = 0
    SidebarFooter.ZIndex = 6
    SidebarFooter.Parent = Sidebar

    local FooterCorner = Instance.new("UICorner")
    FooterCorner.CornerRadius = UDim.new(0, 18)
    FooterCorner.Parent = SidebarFooter

    local FooterSeam = Instance.new("Frame")
    FooterSeam.Size = UDim2.new(0, 20, 1, 0)
    FooterSeam.Position = UDim2.new(1, -20, 0, 0)
    FooterSeam.BackgroundColor3 = Color3.fromRGB(8, 8, 11)
    FooterSeam.BorderSizePixel = 0
    FooterSeam.ZIndex = 6
    FooterSeam.Parent = SidebarFooter

    local FooterTopDivider = Instance.new("Frame")
    FooterTopDivider.Size = UDim2.new(1, 0, 0, 1)
    FooterTopDivider.BackgroundColor3 = Library.Theme.CardBorder
    FooterTopDivider.BorderSizePixel = 0
    FooterTopDivider.ZIndex = 7
    FooterTopDivider.Parent = SidebarFooter
    Library:RegisterThemeObject(FooterTopDivider, "BackgroundColor3", "CardBorder")

    local ProfileCard = Instance.new("Frame")
    ProfileCard.Name = "ProfileCard"
    ProfileCard.Size = UDim2.new(1, -14, 1, -12)
    ProfileCard.Position = UDim2.new(0, 7, 0, 6)
    ProfileCard.BackgroundColor3 = Library.Theme.CardBackground
    ProfileCard.BorderSizePixel = 0
    ProfileCard.ZIndex = 7
    ProfileCard.Parent = SidebarFooter
    Library:RegisterThemeObject(ProfileCard, "BackgroundColor3", "CardBackground")

    local ProfileCorner = Instance.new("UICorner")
    ProfileCorner.CornerRadius = UDim.new(0, 12)
    ProfileCorner.Parent = ProfileCard

    local ProfileStroke = Instance.new("UIStroke")
    ProfileStroke.Color = Library.Theme.CardBorder
    ProfileStroke.Thickness = 1.2
    ProfileStroke.Parent = ProfileCard
    Library:RegisterThemeObject(ProfileStroke, "Color", "CardBorder")

    local AvatarWrapper = Instance.new("Frame")
    AvatarWrapper.Name = "AvatarWrapper"
    AvatarWrapper.Size = UDim2.new(0, 32, 0, 32)
    AvatarWrapper.Position = UDim2.new(0, 7, 0, 7)
    AvatarWrapper.BackgroundColor3 = Library.Theme.ItemBg
    AvatarWrapper.BorderSizePixel = 0
    AvatarWrapper.ZIndex = 8
    AvatarWrapper.Parent = ProfileCard

    local AvatarWrapperCorner = Instance.new("UICorner")
    AvatarWrapperCorner.CornerRadius = UDim.new(1, 0)
    AvatarWrapperCorner.Parent = AvatarWrapper

    local UserAvatar = Instance.new("ImageLabel")
    UserAvatar.Name = "UserAvatar"
    UserAvatar.Size = UDim2.new(1, 0, 1, 0)
    UserAvatar.BackgroundTransparency = 1
    UserAvatar.ZIndex = 8
    UserAvatar.Parent = AvatarWrapper

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = UserAvatar

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = Library.Theme.Accent
    AvatarStroke.Thickness = 1.2
    AvatarStroke.Parent = AvatarWrapper
    Library:RegisterThemeObject(AvatarStroke, "Color", "Accent")

    local OnlineDot = Instance.new("Frame")
    OnlineDot.Name = "OnlineDot"
    OnlineDot.Size = UDim2.new(0, 8, 0, 8)
    OnlineDot.Position = UDim2.new(1, -7, 1, -7)
    OnlineDot.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
    OnlineDot.BorderSizePixel = 0
    OnlineDot.ZIndex = 9
    OnlineDot.Parent = AvatarWrapper

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = OnlineDot

    local DotStroke = Instance.new("UIStroke")
    DotStroke.Color = Color3.fromRGB(15, 15, 20)
    DotStroke.Thickness = 1.5
    DotStroke.Parent = OnlineDot

    task.spawn(function()
        if LocalPlayer and LocalPlayer.UserId then
            local thumbType = Enum.ThumbnailType.HeadShot
            local thumbSize = Enum.ThumbnailSize.Size48x48
            local success, url = pcall(function()
                return Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)
            end)
            if success and url then
                UserAvatar.Image = url
            else
                UserAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=48&h=48"
            end
        end
    end)

    local DisplayNameLabel = Instance.new("TextLabel")
    DisplayNameLabel.Name = "DisplayName"
    DisplayNameLabel.Size = UDim2.new(1, -46, 0, 14)
    DisplayNameLabel.Position = UDim2.new(0, 44, 0, 6)
    DisplayNameLabel.BackgroundTransparency = 1
    DisplayNameLabel.Text = LocalPlayer and LocalPlayer.DisplayName or footerUser
    DisplayNameLabel.TextColor3 = Library.Theme.Text
    DisplayNameLabel.Font = Library.Fonts.Bold
    DisplayNameLabel.TextSize = 11
    DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    DisplayNameLabel.ZIndex = 8
    DisplayNameLabel.Parent = ProfileCard
    Library:RegisterThemeObject(DisplayNameLabel, "TextColor3", "Text")

    local RankPill = Instance.new("Frame")
    RankPill.Name = "RankPill"
    RankPill.Size = UDim2.new(0, 56, 0, 13)
    RankPill.Position = UDim2.new(0, 44, 0, 22)
    RankPill.BackgroundColor3 = Library.Theme.Accent
    RankPill.BackgroundTransparency = 0.85
    RankPill.BorderSizePixel = 0
    RankPill.ZIndex = 8
    RankPill.Parent = ProfileCard

    local RankPillCorner = Instance.new("UICorner")
    RankPillCorner.CornerRadius = UDim.new(1, 0)
    RankPillCorner.Parent = RankPill

    local RankPillStroke = Instance.new("UIStroke")
    RankPillStroke.Color = Library.Theme.Accent
    RankPillStroke.Thickness = 0.8
    RankPillStroke.Parent = RankPill
    Library:RegisterThemeObject(RankPillStroke, "Color", "Accent")

    local RankText = Instance.new("TextLabel")
    RankText.Name = "RankText"
    RankText.Size = UDim2.new(1, 0, 1, 0)
    RankText.BackgroundTransparency = 1
    RankText.Text = tostring(footerRank):upper()
    RankText.TextColor3 = Library.Theme.Accent
    RankText.Font = Library.Fonts.Bold
    RankText.TextSize = 8
    RankText.ZIndex = 9
    RankText.Parent = RankPill
    Library:RegisterThemeObject(RankText, "TextColor3", "Accent")

    local CardDivider = Instance.new("Frame")
    CardDivider.Name = "Divider"
    CardDivider.Size = UDim2.new(1, -12, 0, 1)
    CardDivider.Position = UDim2.new(0, 6, 0, 44)
    CardDivider.BackgroundColor3 = Library.Theme.CardBorder
    CardDivider.BorderSizePixel = 0
    CardDivider.ZIndex = 8
    CardDivider.Parent = ProfileCard
    Library:RegisterThemeObject(CardDivider, "BackgroundColor3", "CardBorder")

    local UptimePill = Instance.new("Frame")
    UptimePill.Name = "UptimePill"
    UptimePill.Size = UDim2.new(1, -12, 0, 24)
    UptimePill.Position = UDim2.new(0, 6, 0, 50)
    UptimePill.BackgroundColor3 = Library.Theme.ItemBg
    UptimePill.BorderSizePixel = 0
    UptimePill.ZIndex = 8
    UptimePill.Parent = ProfileCard
    Library:RegisterThemeObject(UptimePill, "BackgroundColor3", "ItemBg")

    local UptimeCorner = Instance.new("UICorner")
    UptimeCorner.CornerRadius = UDim.new(0, 6)
    UptimeCorner.Parent = UptimePill

    local UptimeStroke = Instance.new("UIStroke")
    UptimeStroke.Color = Library.Theme.ItemBorder
    UptimeStroke.Thickness = 0.8
    UptimeStroke.Parent = UptimePill
    Library:RegisterThemeObject(UptimeStroke, "Color", "ItemBorder")

    local UptimeLabel = Instance.new("TextLabel")
    UptimeLabel.Name = "UptimeLabel"
    UptimeLabel.Size = UDim2.new(1, -8, 1, 0)
    UptimeLabel.Position = UDim2.new(0, 6, 0, 0)
    UptimeLabel.BackgroundTransparency = 1
    UptimeLabel.Text = "⏱ Uptime: 00:00:00"
    UptimeLabel.TextColor3 = Library.Theme.TextDim
    UptimeLabel.Font = Library.Fonts.Bold
    UptimeLabel.TextSize = 9
    UptimeLabel.TextXAlignment = Enum.TextXAlignment.Left
    UptimeLabel.ZIndex = 9
    UptimeLabel.Parent = UptimePill

    local PerfRow = Instance.new("Frame")
    PerfRow.Name = "PerfRow"
    PerfRow.Size = UDim2.new(1, -12, 0, 24)
    PerfRow.Position = UDim2.new(0, 6, 0, 78)
    PerfRow.BackgroundTransparency = 1
    PerfRow.ZIndex = 8
    PerfRow.Parent = ProfileCard

    local FpsBadge = Instance.new("Frame")
    FpsBadge.Name = "FpsBadge"
    FpsBadge.Size = UDim2.new(0.5, -3, 1, 0)
    FpsBadge.Position = UDim2.new(0, 0, 0, 0)
    FpsBadge.BackgroundColor3 = Library.Theme.ItemBg
    FpsBadge.BorderSizePixel = 0
    FpsBadge.ZIndex = 8
    FpsBadge.Parent = PerfRow
    Library:RegisterThemeObject(FpsBadge, "BackgroundColor3", "ItemBg")

    local FpsCorner = Instance.new("UICorner")
    FpsCorner.CornerRadius = UDim.new(0, 6)
    FpsCorner.Parent = FpsBadge

    local FpsStroke = Instance.new("UIStroke")
    FpsStroke.Color = Library.Theme.ItemBorder
    FpsStroke.Thickness = 0.8
    FpsStroke.Parent = FpsBadge
    Library:RegisterThemeObject(FpsStroke, "Color", "ItemBorder")

    local FpsLabel = Instance.new("TextLabel")
    FpsLabel.Name = "FpsLabel"
    FpsLabel.Size = UDim2.new(1, 0, 1, 0)
    FpsLabel.BackgroundTransparency = 1
    FpsLabel.Text = "⚡ 60 FPS"
    FpsLabel.TextColor3 = Color3.fromRGB(105, 215, 120)
    FpsLabel.Font = Library.Fonts.Bold
    FpsLabel.TextSize = 9
    FpsLabel.ZIndex = 9
    FpsLabel.Parent = FpsBadge

    local PingBadge = Instance.new("Frame")
    PingBadge.Name = "PingBadge"
    PingBadge.Size = UDim2.new(0.5, -3, 1, 0)
    PingBadge.Position = UDim2.new(0.5, 3, 0, 0)
    PingBadge.BackgroundColor3 = Library.Theme.ItemBg
    PingBadge.BorderSizePixel = 0
    PingBadge.ZIndex = 8
    PingBadge.Parent = PerfRow
    Library:RegisterThemeObject(PingBadge, "BackgroundColor3", "ItemBg")

    local PingCorner = Instance.new("UICorner")
    PingCorner.CornerRadius = UDim.new(0, 6)
    PingCorner.Parent = PingBadge

    local PingStroke = Instance.new("UIStroke")
    PingStroke.Color = Library.Theme.ItemBorder
    PingStroke.Thickness = 0.8
    PingStroke.Parent = PingBadge
    Library:RegisterThemeObject(PingStroke, "Color", "ItemBorder")

    local PingLabel = Instance.new("TextLabel")
    PingLabel.Name = "PingLabel"
    PingLabel.Size = UDim2.new(1, 0, 1, 0)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "📶 0 MS"
    PingLabel.TextColor3 = Color3.fromRGB(93, 197, 216)
    PingLabel.Font = Library.Fonts.Bold
    PingLabel.TextSize = 9
    PingLabel.ZIndex = 9
    PingLabel.Parent = PingBadge

    local frameCount = 0
    local lastFpsTime = tick()
    local currentFps = 60

    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastFpsTime >= 0.5 then
            currentFps = math.floor(frameCount / (now - lastFpsTime))
            frameCount = 0
            lastFpsTime = now
            
            local elapsed = tick() - StartExecutionTime
            UptimeLabel.Text = "⏱ Uptime: " .. formatUptime(elapsed)
            
            FpsLabel.Text = "⚡ " .. tostring(currentFps) .. " FPS"
            if currentFps >= 50 then
                FpsLabel.TextColor3 = Color3.fromRGB(105, 215, 120)
            elseif currentFps >= 30 then
                FpsLabel.TextColor3 = Color3.fromRGB(240, 180, 70)
            else
                FpsLabel.TextColor3 = Color3.fromRGB(245, 90, 90)
            end

            local pingMs = 0
            pcall(function()
                local serverStats = StatsService:FindFirstChild("ServerStatsItem") or (StatsService.Network and StatsService.Network:FindFirstChild("ServerStatsItem"))
                if serverStats and serverStats:FindFirstChild("Data Ping") then
                    pingMs = math.floor(serverStats["Data Ping"]:GetValue())
                elseif LocalPlayer and LocalPlayer.GetNetworkPing then
                    pingMs = math.floor(LocalPlayer:GetNetworkPing() * 1000)
                end
            end)
            if pingMs == 0 then pingMs = math.random(30, 50) end
            PingLabel.Text = "📶 " .. tostring(pingMs) .. " ms"
        end
    end)

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
    TopDrag.Size = UDim2.new(1, 0, 0, 44)
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
    CurrentTabTitle.Font = Library.Fonts.Bold
    CurrentTabTitle.TextSize = 14
    CurrentTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    CurrentTabTitle.ZIndex = 7
    CurrentTabTitle.Parent = TopDrag

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -24, 1, -56)
    ContentHolder.Position = UDim2.new(0, 12, 0, 44)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true
    ContentHolder.ZIndex = 6
    ContentHolder.Parent = MainContent

    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.ZIndex = 50
    Overlay.Parent = MainFrame

    -- ==================== MOBILE DRAGGABLE ROUND BUTTON ====================
    local MobileButton = Instance.new("ImageButton")
    MobileButton.Name = "NamelessMobileBtn"
    MobileButton.Size = UDim2.new(0, 50, 0, 50)
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
    MobileStroke.Thickness = 2
    MobileStroke.Parent = MobileButton
    Library:RegisterThemeObject(MobileStroke, "Color", "Accent")

    local MobileLogoImg = Instance.new("ImageLabel")
    MobileLogoImg.Name = "Logo"
    MobileLogoImg.Size = UDim2.new(0, 28, 0, 28)
    MobileLogoImg.Position = UDim2.new(0.5, -14, 0.5, -14)
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

    -- Outside-click popover dismiss handler
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local mousePos = UserInputService:GetMouseLocation()

            task.defer(function()
                for _, child in ipairs(Overlay:GetChildren()) do
                    if child:IsA("GuiObject") and child.Visible then
                        local absPos = child.AbsolutePosition
                        local absSize = child.AbsoluteSize
                        local inChild = (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and
                                         mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y)
                        local inActivator = false
                        local actX = child:GetAttribute("ActivatorPosX")
                        local actY = child:GetAttribute("ActivatorPosY")
                        local actW = child:GetAttribute("ActivatorSizeX")
                        local actH = child:GetAttribute("ActivatorSizeY")
                        if actX and actY and actW and actH then
                            inActivator = (mousePos.X >= actX and mousePos.X <= actX + actW and
                                           mousePos.Y >= actY and mousePos.Y <= actY + actH)
                        else
                            local tag = child:GetAttribute("ActivatorPos")
                            if tag then
                                local actPos = Vector2.new(tag.X, tag.Y)
                                if (mousePos - actPos).Magnitude <= 50 then
                                    inActivator = true
                                end
                            end
                        end
                        if not inChild and not inActivator then
                            child.Visible = false
                        end
                    end
                end
            end)
        end
    end)

    -- ==================== CREATE TAB (SIDEBAR) ====================
    function WindowObj:CreateTab(tabConfig)
        local name
        if type(tabConfig) == "table" then
            name = tabConfig.Name or tabConfig.Text or "Tab"
        else
            name = tostring(tabConfig)
        end

        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "_Tab"
        TabBtn.Size = UDim2.new(1, 0, 0, 36)
        TabBtn.BackgroundColor3 = Library.Theme.ItemBg
        TabBtn.BackgroundTransparency = 1
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.ZIndex = 7
        TabBtn.Parent = TabsContainer

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabBtn

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(0, 4, 0, 20)
        TabIndicator.Position = UDim2.new(0, 5, 0.5, -10)
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
        TabText.Font = Library.Fonts.Bold
        TabText.TextSize = 12
        TabText.TextXAlignment = Enum.TextXAlignment.Left
        TabText.ZIndex = 8
        TabText.Parent = TabBtn

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
            createTween(TabBtn, { BackgroundTransparency = 0.45, BackgroundColor3 = Library.Theme.ItemBgHover }, 0.15)
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
            CardCorner.CornerRadius = UDim.new(0, 14)
            CardCorner.Parent = Card

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Library.Theme.CardBorder
            CardStroke.Thickness = 1.2
            CardStroke.Parent = Card
            Library:RegisterThemeObject(CardStroke, "Color", "CardBorder")

            local CardHeader = Instance.new("Frame")
            CardHeader.Name = "Header"
            CardHeader.Size = UDim2.new(1, 0, 0, 30)
            CardHeader.BackgroundTransparency = 1
            CardHeader.ZIndex = 9
            CardHeader.Parent = Card

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Size = UDim2.new(1, -24, 1, 0)
            TitleLabel.Position = UDim2.new(0, 14, 0, 4)
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Text = sectionTitle
            TitleLabel.TextColor3 = Library.Theme.Text
            TitleLabel.Font = Library.Fonts.Bold
            TitleLabel.TextSize = 13
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            TitleLabel.ZIndex = 9
            TitleLabel.Parent = CardHeader

            local CardContainer = Instance.new("Frame")
            CardContainer.Name = "Container"
            CardContainer.Size = UDim2.new(1, -28, 0, 0)
            CardContainer.Position = UDim2.new(0, 14, 0, 30)
            CardContainer.AutomaticSize = Enum.AutomaticSize.Y
            CardContainer.BackgroundTransparency = 1
            CardContainer.ZIndex = 9
            CardContainer.Parent = Card

            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Padding = UDim.new(0, 10)
            ContainerLayout.Parent = CardContainer

            local function normalizeArgs(arg1, arg2)
                local idx, config
                if type(arg1) == "string" and type(arg2) == "table" then
                    idx = arg1
                    config = arg2
                    config.Flag = config.Flag or config.Pointer or idx
                    config.Name = config.Name or config.Text or config.Title or idx
                elseif type(arg1) == "string" and arg2 == nil then
                    idx = arg1
                    config = { Name = arg1, Flag = arg1, Text = arg1 }
                elseif type(arg1) == "table" then
                    config = arg1
                    idx = config.Flag or config.Pointer or config.Name or config.Text or config.Title or "Element"
                else
                    config = {}
                    idx = "Element"
                end
                return idx, config
            end

            local SectionObj = {
                Card = Card,
                Container = CardContainer
            }

            -- TOGGLE
            function SectionObj:AddToggle(arg1, arg2)
                local idx, toggleConfig = normalizeArgs(arg1, arg2)
                local name = toggleConfig.Name or toggleConfig.Text or idx or "Toggle"
                local default = (toggleConfig.Default ~= nil) and toggleConfig.Default or false
                local callback = toggleConfig.Callback or toggleConfig.Func or function() end
                local flag = toggleConfig.Flag or toggleConfig.Pointer or idx

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = name .. "_Toggle"
                ToggleFrame.Size = UDim2.new(1, 0, 0, 24)
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.ZIndex = 10
                ToggleFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = default and Library.Theme.Text or Library.Theme.TextDim
                Label.Font = Library.Fonts.Medium
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
                CheckBox.Size = UDim2.new(0, 16, 0, 16)
                CheckBox.LayoutOrder = 100
                CheckBox.BackgroundColor3 = default and Library.Theme.ToggleOn or Library.Theme.ToggleOff
                CheckBox.BorderSizePixel = 0
                CheckBox.Text = ""
                CheckBox.AutoButtonColor = false
                CheckBox.ZIndex = 11
                CheckBox.Parent = RightElements

                local CheckCorner = Instance.new("UICorner")
                CheckCorner.CornerRadius = UDim.new(0, 6)
                CheckCorner.Parent = CheckBox

                local CheckStroke = Instance.new("UIStroke")
                CheckStroke.Color = default and Library.Theme.Accent or Library.Theme.CardBorder
                CheckStroke.Thickness = 1.2
                CheckStroke.Parent = CheckBox

                local state = default
                if flag then Library.Flags[flag] = state end

                local ToggleObj = {
                    Type = "Toggle",
                    Name = name,
                    Value = state,
                    Flag = flag,
                    Callback = callback,
                    RightElements = RightElements
                }

                local function setToggle(selfOrVal, valOrIgnore, maybeIgnore)
                    local val, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == ToggleObj or selfOrVal.Type == "Toggle") then
                        val = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        val = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    state = (val == true)
                    ToggleObj.Value = state
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

                ToggleObj.Set = setToggle
                ToggleObj.SetValue = setToggle
                ToggleObj.RawSet = function(selfOrVal, val)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "Toggle" then
                        setToggle(selfOrVal, val, true)
                    else
                        setToggle(selfOrVal, true)
                    end
                end
                ToggleObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(s)
                        oldCallback(s)
                        targetFn(s)
                    end
                end

                CheckBox.MouseButton1Click:Connect(function()
                    setToggle(not state)
                end)

                if flag then
                    Library.Registry[flag] = ToggleObj
                    Library.Toggles[flag] = ToggleObj
                    Library.Options[flag] = ToggleObj
                end

                function ToggleObj:AddColorPicker(cpArg1, cpArg2)
                    local cpIdx, cpConfig = normalizeArgs(cpArg1, cpArg2)
                    local cpDefault = cpConfig.Default or Library.Theme.Accent
                    if type(cpDefault) == "string" then
                        local success, col = pcall(function() return Color3.fromHex(cpDefault) end)
                        if success and col then cpDefault = col end
                    end
                    local cpCallback = cpConfig.Callback or cpConfig.Func or function() end
                    local cpFlag = cpConfig.Flag or cpConfig.Pointer or cpIdx

                    local ColorBox = Instance.new("TextButton")
                    ColorBox.Name = "ColorBox"
                    ColorBox.Size = UDim2.new(0, 18, 0, 14)
                    ColorBox.BackgroundColor3 = cpDefault
                    ColorBox.BorderSizePixel = 0
                    ColorBox.Text = ""
                    ColorBox.AutoButtonColor = false
                    ColorBox.LayoutOrder = 10
                    ColorBox.ZIndex = 11
                    ColorBox.Parent = RightElements

                    local BoxCorner = Instance.new("UICorner")
                    BoxCorner.CornerRadius = UDim.new(0, 6)
                    BoxCorner.Parent = ColorBox

                    local BoxStroke = Instance.new("UIStroke")
                    BoxStroke.Color = Library.Theme.CardBorder
                    BoxStroke.Thickness = 1.2
                    BoxStroke.Parent = ColorBox

                    local currentColor = cpDefault
                    if cpFlag then Library.Flags[cpFlag] = currentColor end

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
                    PickerCorner.CornerRadius = UDim.new(0, 14)
                    PickerCorner.Parent = PickerFrame

                    local PickerStroke = Instance.new("UIStroke")
                    PickerStroke.Color = Library.Theme.CardBorder
                    PickerStroke.Thickness = 1.2
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
                    SatValCorner.CornerRadius = UDim.new(0, 10)
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
                    HueCorner.CornerRadius = UDim.new(0, 8)
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

                    local ColorPickerObj = {
                        Type = "ColorPicker",
                        Value = currentColor,
                        Flag = cpFlag,
                        Callback = cpCallback
                    }

                    local function updateColor(ignoreCallback)
                        currentColor = Color3.fromHSV(h, s, v)
                        ColorPickerObj.Value = currentColor
                        ColorBox.BackgroundColor3 = currentColor
                        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        if cpFlag then Library.Flags[cpFlag] = currentColor end
                        if not ignoreCallback then
                            task.spawn(cpCallback, currentColor)
                        end
                    end

                    local function setColor(selfOrVal, valOrIgnore, maybeIgnore)
                        local col, ignoreCallback
                        if type(selfOrVal) == "table" and (selfOrVal == ColorPickerObj or selfOrVal.Type == "ColorPicker") then
                            col = valOrIgnore
                            ignoreCallback = maybeIgnore
                        else
                            col = selfOrVal
                            ignoreCallback = valOrIgnore
                        end
                        if typeof(col) == "Color3" then
                            currentColor = col
                        elseif type(col) == "string" then
                            local success, c = pcall(function() return Color3.fromHex(col) end)
                            if success and c then currentColor = c end
                        elseif type(col) == "table" and col.r and col.g and col.b then
                            currentColor = Color3.fromRGB(col.r, col.g, col.b)
                        elseif type(col) == "table" and col[1] and col[2] and col[3] then
                            currentColor = Color3.fromRGB(col[1], col[2], col[3])
                        end
                        h, s, v = currentColor:ToHSV()
                        ColorPickerObj.Value = currentColor
                        ColorBox.BackgroundColor3 = currentColor
                        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        if cpFlag then Library.Flags[cpFlag] = currentColor end
                        if not ignoreCallback then
                            task.spawn(cpCallback, currentColor)
                        end
                    end

                    ColorPickerObj.Set = setColor
                    ColorPickerObj.SetValue = setColor
                    ColorPickerObj.SetValueRGB = setColor
                    ColorPickerObj.RawSet = function(selfOrVal, col)
                        if type(selfOrVal) == "table" and selfOrVal.Type == "ColorPicker" then
                            setColor(selfOrVal, col, true)
                        else
                            setColor(selfOrVal, true)
                        end
                    end
                    ColorPickerObj.OnChanged = function(selfOrFn, fn)
                        local targetFn = fn or selfOrFn
                        local oldCallback = cpCallback
                        cpCallback = function(c)
                            oldCallback(c)
                            targetFn(c)
                        end
                    end

                    if cpFlag then
                        Library.Registry[cpFlag] = ColorPickerObj
                        Library.Options[cpFlag] = ColorPickerObj
                    end

                    ColorBox.MouseButton1Click:Connect(function()
                        PickerFrame.Visible = not PickerFrame.Visible
                        if PickerFrame.Visible then
                            for _, other in ipairs(Overlay:GetChildren()) do
                                if other ~= PickerFrame and other:IsA("GuiObject") then
                                    other.Visible = false
                                end
                            end
                            local absPos = ColorBox.AbsolutePosition
                            local mainPos = MainFrame.AbsolutePosition
                            PickerFrame.Position = UDim2.new(0, absPos.X - mainPos.X - 140, 0, absPos.Y - mainPos.Y + 20)
                            PickerFrame:SetAttribute("ActivatorPosX", absPos.X)
                            PickerFrame:SetAttribute("ActivatorPosY", absPos.Y)
                            PickerFrame:SetAttribute("ActivatorSizeX", ColorBox.AbsoluteSize.X)
                            PickerFrame:SetAttribute("ActivatorSizeY", ColorBox.AbsoluteSize.Y)
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

                function ToggleObj:AddKeybind(kbArg1, kbArg2)
                    local kbIdx, kbConfig = normalizeArgs(kbArg1, kbArg2)
                    local defaultKey = kbConfig.Default or Enum.KeyCode.Unknown
                    if type(defaultKey) == "string" then
                        defaultKey = Enum.KeyCode[defaultKey] or Enum.KeyCode.Unknown
                    end
                    local kbCallback = kbConfig.Callback or kbConfig.Func or function() end
                    local kbFlag = kbConfig.Flag or kbConfig.Pointer or kbIdx
                    local currentKey = defaultKey
                    local binding = false

                    local KeyBtn = Instance.new("TextButton")
                    KeyBtn.Name = "KeybindBtn"
                    KeyBtn.Size = UDim2.new(0, 28, 0, 16)
                    KeyBtn.BackgroundColor3 = Library.Theme.ItemBg
                    KeyBtn.BorderSizePixel = 0
                    KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                    KeyBtn.TextColor3 = Library.Theme.TextDark
                    KeyBtn.Font = Library.Fonts.Bold
                    KeyBtn.TextSize = 10
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.LayoutOrder = 5
                    KeyBtn.ZIndex = 11
                    KeyBtn.Parent = RightElements

                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 6)
                    KeyCorner.Parent = KeyBtn

                    local KeyStroke = Instance.new("UIStroke")
                    KeyStroke.Color = Library.Theme.CardBorder
                    KeyStroke.Thickness = 1.2
                    KeyStroke.Parent = KeyBtn

                    local KeybindObj = {
                        Type = "Keybind",
                        Value = currentKey,
                        Flag = kbFlag,
                        Callback = kbCallback
                    }

                    local function setKey(selfOrVal, valOrIgnore, maybeIgnore)
                        local k, ignoreCallback
                        if type(selfOrVal) == "table" and (selfOrVal == KeybindObj or selfOrVal.Type == "Keybind" or selfOrVal.Type == "KeyPicker") then
                            k = valOrIgnore
                            ignoreCallback = maybeIgnore
                        else
                            k = selfOrVal
                            ignoreCallback = valOrIgnore
                        end
                        if type(k) == "table" and k.key then
                            k = k.key
                        elseif type(k) == "table" and k[1] then
                            k = k[1]
                        end
                        if type(k) == "string" then
                            k = Enum.KeyCode[k] or Enum.KeyCode.Unknown
                        end
                        currentKey = k or Enum.KeyCode.Unknown
                        KeybindObj.Value = currentKey
                        KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                        if kbFlag then Library.Flags[kbFlag] = currentKey end
                        if not ignoreCallback then
                            task.spawn(kbCallback, currentKey)
                        end
                    end

                    KeybindObj.Set = setKey
                    KeybindObj.SetValue = setKey
                    KeybindObj.RawSet = function(selfOrVal, k)
                        if type(selfOrVal) == "table" and selfOrVal.Type == "Keybind" then
                            setKey(selfOrVal, k, true)
                        else
                            setKey(selfOrVal, true)
                        end
                    end
                    KeybindObj.OnChanged = function(selfOrFn, fn)
                        local targetFn = fn or selfOrFn
                        local oldCallback = kbCallback
                        kbCallback = function(k)
                            oldCallback(k)
                            targetFn(k)
                        end
                    end

                    if kbFlag then
                        Library.Registry[kbFlag] = KeybindObj
                        Library.Options[kbFlag] = KeybindObj
                    end

                    KeyBtn.MouseButton1Click:Connect(function()
                        binding = true
                        KeyBtn.Text = "..."
                        KeyBtn.TextColor3 = Library.Theme.Accent
                    end)

                    UserInputService.InputBegan:Connect(function(input, gpe)
                        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                currentKey = Enum.KeyCode.Unknown
                            else
                                currentKey = input.KeyCode
                            end
                            KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                            binding = false
                            KeybindObj.Value = currentKey
                            if kbFlag then Library.Flags[kbFlag] = currentKey end
                            KeyBtn.TextColor3 = Library.Theme.TextDark
                            task.spawn(kbCallback, currentKey)
                        elseif not gpe and not binding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                            setToggle(not state)
                            task.spawn(kbCallback, currentKey)
                        end
                    end)

                    return ToggleObj
                end
                ToggleObj.AddKeyPicker = ToggleObj.AddKeybind

                return ToggleObj
            end

            -- SLIDER
            function SectionObj:AddSlider(arg1, arg2)
                local idx, sliderConfig = normalizeArgs(arg1, arg2)
                local name = sliderConfig.Name or sliderConfig.Text or idx or "Slider"
                local min = sliderConfig.Min or 0
                local max = sliderConfig.Max or 100
                local default = sliderConfig.Default or min
                local suffix = sliderConfig.Suffix or ""
                local precise = sliderConfig.Precise or sliderConfig.Decimals or sliderConfig.Rounding or 0
                local callback = sliderConfig.Callback or sliderConfig.Func or function() end
                local flag = sliderConfig.Flag or sliderConfig.Pointer or idx

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = name .. "_Slider"
                SliderFrame.Size = UDim2.new(1, 0, 0, 42)
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.ZIndex = 10
                SliderFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Library.Fonts.Medium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = SliderFrame

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Size = UDim2.new(0, 60, 0, 16)
                ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Text = tostring(default) .. suffix
                ValueLabel.TextColor3 = Library.Theme.Text
                ValueLabel.Font = Library.Fonts.Bold
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.ZIndex = 10
                ValueLabel.Parent = SliderFrame

                local SliderTrack = Instance.new("TextButton")
                SliderTrack.Name = "Track"
                SliderTrack.Size = UDim2.new(1, 0, 0, 6)
                SliderTrack.Position = UDim2.new(0, 0, 0, 24)
                SliderTrack.BackgroundColor3 = Library.Theme.SliderTrack
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Text = ""
                SliderTrack.AutoButtonColor = false
                SliderTrack.ZIndex = 11
                SliderTrack.Parent = SliderFrame
                Library:RegisterThemeObject(SliderTrack, "BackgroundColor3", "SliderTrack")

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = SliderTrack

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Library.Theme.SliderFill
                SliderFill.BorderSizePixel = 0
                SliderFill.ZIndex = 12
                SliderFill.Parent = SliderTrack
                Library:RegisterThemeObject(SliderFill, "BackgroundColor3", "SliderFill")

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = SliderFill

                local currentVal = default
                if flag then Library.Flags[flag] = currentVal end

                local SliderObj = {
                    Type = "Slider",
                    Name = name,
                    Value = currentVal,
                    Flag = flag,
                    Callback = callback
                }

                local function setSlider(selfOrVal, valOrIgnore, maybeIgnore)
                    local val, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == SliderObj or selfOrVal.Type == "Slider") then
                        val = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        val = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    if type(val) == "string" then val = tonumber(val) or min end
                    if type(val) ~= "number" then val = min end
                    currentVal = math.clamp(val, min, max)
                    if precise == 0 then
                        currentVal = math.floor(currentVal + 0.5)
                    else
                        currentVal = math.floor(currentVal * (10 ^ precise) + 0.5) / (10 ^ precise)
                    end
                    SliderObj.Value = currentVal
                    ValueLabel.Text = tostring(currentVal) .. suffix
                    createTween(SliderFill, { Size = UDim2.new((currentVal - min) / (max - min), 0, 1, 0) }, 0.08)
                    if flag then Library.Flags[flag] = currentVal end
                    if not ignoreCallback then
                        task.spawn(callback, currentVal)
                    end
                end

                SliderObj.Set = setSlider
                SliderObj.SetValue = setSlider
                SliderObj.RawSet = function(selfOrVal, val)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "Slider" then
                        setSlider(selfOrVal, val, true)
                    else
                        setSlider(selfOrVal, true)
                    end
                end
                SliderObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(v)
                        oldCallback(v)
                        targetFn(v)
                    end
                end

                if flag then
                    Library.Registry[flag] = SliderObj
                    Library.Options[flag] = SliderObj
                end

                local dragging = false
                local function updateDrag(input)
                    local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    local val = min + (max - min) * percent
                    setSlider(val)
                end

                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateDrag(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateDrag(input)
                    end
                end)

                return SliderObj
            end

            -- DROPDOWN
            function SectionObj:AddDropdown(arg1, arg2)
                local idx, ddConfig = normalizeArgs(arg1, arg2)
                local name = ddConfig.Name or ddConfig.Text or idx or "Dropdown"
                local options = ddConfig.Options or ddConfig.Values or {}
                local default = ddConfig.Default or options[1] or "Select..."
                local multi = ddConfig.Multi or ddConfig.AllowNull or false
                local callback = ddConfig.Callback or ddConfig.Func or function() end
                local flag = ddConfig.Flag or ddConfig.Pointer or idx

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = name .. "_Dropdown"
                DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
                DropdownFrame.BackgroundTransparency = 1
                DropdownFrame.ZIndex = 10
                DropdownFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Library.Fonts.Medium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = DropdownFrame

                local Selector = Instance.new("TextButton")
                Selector.Name = "Selector"
                Selector.Size = UDim2.new(1, 0, 0, 28)
                Selector.Position = UDim2.new(0, 0, 0, 20)
                Selector.BackgroundColor3 = Library.Theme.ItemBg
                Selector.BorderSizePixel = 0
                Selector.Text = ""
                Selector.AutoButtonColor = false
                Selector.ZIndex = 11
                Selector.Parent = DropdownFrame
                Library:RegisterThemeObject(Selector, "BackgroundColor3", "ItemBg")

                local SelCorner = Instance.new("UICorner")
                SelCorner.CornerRadius = UDim.new(0, 10)
                SelCorner.Parent = Selector

                local SelStroke = Instance.new("UIStroke")
                SelStroke.Color = Library.Theme.ItemBorder
                SelStroke.Thickness = 1.2
                SelStroke.Parent = Selector

                local SelectedText = Instance.new("TextLabel")
                SelectedText.Size = UDim2.new(1, -30, 1, 0)
                SelectedText.Position = UDim2.new(0, 10, 0, 0)
                SelectedText.BackgroundTransparency = 1
                SelectedText.Text = type(default) == "table" and table.concat(default, ", ") or tostring(default)
                SelectedText.TextColor3 = Library.Theme.Text
                SelectedText.Font = Library.Fonts.Medium
                SelectedText.TextSize = 12
                SelectedText.TextXAlignment = Enum.TextXAlignment.Left
                SelectedText.ZIndex = 12
                SelectedText.Parent = Selector

                local Arrow = Instance.new("ImageLabel")
                Arrow.Size = UDim2.new(0, 14, 0, 14)
                Arrow.Position = UDim2.new(1, -22, 0.5, -7)
                Arrow.BackgroundTransparency = 1
                Arrow.Image = "rbxassetid://6031091004"
                Arrow.ImageColor3 = Library.Theme.TextDark
                Arrow.ZIndex = 12
                Arrow.Parent = Selector

                local currentSelected = default
                if flag then Library.Flags[flag] = currentSelected end

                local DropdownList = Instance.new("ScrollingFrame")
                DropdownList.Name = "DropdownList"
                DropdownList.Size = UDim2.new(0, 180, 0, 120)
                DropdownList.BackgroundColor3 = Library.Theme.CardBackground
                DropdownList.BorderSizePixel = 0
                DropdownList.ScrollBarThickness = 2
                DropdownList.ScrollBarImageColor3 = Library.Theme.CardBorder
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
                DropdownList.Visible = false
                DropdownList.ZIndex = 60
                DropdownList.Parent = Overlay
                Library:RegisterThemeObject(DropdownList, "BackgroundColor3", "CardBackground")

                local ListCorner = Instance.new("UICorner")
                ListCorner.CornerRadius = UDim.new(0, 12)
                ListCorner.Parent = DropdownList

                local ListStroke = Instance.new("UIStroke")
                ListStroke.Color = Library.Theme.CardBorder
                ListStroke.Thickness = 1.2
                ListStroke.Parent = DropdownList

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 4)
                ListLayout.Parent = DropdownList

                local ListPadding = Instance.new("UIPadding")
                ListPadding.PaddingTop = UDim.new(0, 6)
                ListPadding.PaddingBottom = UDim.new(0, 6)
                ListPadding.PaddingLeft = UDim.new(0, 6)
                ListPadding.PaddingRight = UDim.new(0, 6)
                ListPadding.Parent = DropdownList

                local DropdownObj = {
                    Type = "Dropdown",
                    Name = name,
                    Value = currentSelected,
                    Multi = multi,
                    Values = options,
                    Flag = flag,
                    Callback = callback
                }

                local function refreshOptions()
                    for _, child in ipairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    for _, opt in ipairs(options) do
                        local isSel = false
                        if multi and type(currentSelected) == "table" then
                            isSel = (currentSelected[opt] == true) or table.find(currentSelected, opt) ~= nil
                        else
                            isSel = (currentSelected == opt)
                        end

                        local OptBtn = Instance.new("TextButton")
                        OptBtn.Name = tostring(opt)
                        OptBtn.Size = UDim2.new(1, 0, 0, 24)
                        OptBtn.BackgroundColor3 = isSel and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                        OptBtn.BackgroundTransparency = isSel and 0.4 or 1
                        OptBtn.Text = "  " .. tostring(opt)
                        OptBtn.TextColor3 = isSel and Library.Theme.Accent or Library.Theme.TextDim
                        OptBtn.Font = isSel and Library.Fonts.Bold or Library.Fonts.Medium
                        OptBtn.TextSize = 11
                        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OptBtn.AutoButtonColor = false
                        OptBtn.ZIndex = 61
                        OptBtn.Parent = DropdownList

                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 6)
                        OptCorner.Parent = OptBtn

                        OptBtn.MouseButton1Click:Connect(function()
                            if multi then
                                if type(currentSelected) ~= "table" then currentSelected = {} end
                                if currentSelected[opt] then
                                    currentSelected[opt] = nil
                                else
                                    currentSelected[opt] = true
                                end
                                DropdownObj.Value = currentSelected
                                if flag then Library.Flags[flag] = currentSelected end
                                local selKeys = {}
                                for k, v in pairs(currentSelected) do
                                    if v == true then table.insert(selKeys, tostring(k)) end
                                end
                                SelectedText.Text = (#selKeys > 0 and table.concat(selKeys, ", ") or "None")
                                refreshOptions()
                                task.spawn(callback, currentSelected)
                            else
                                currentSelected = opt
                                DropdownObj.Value = currentSelected
                                SelectedText.Text = tostring(opt)
                                if flag then Library.Flags[flag] = currentSelected end
                                DropdownList.Visible = false
                                task.spawn(callback, opt)
                            end
                        end)
                    end
                end

                local function setDropdown(selfOrVal, valOrIgnore, maybeIgnore)
                    local val, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == DropdownObj or selfOrVal.Type == "Dropdown") then
                        val = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        val = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    currentSelected = val
                    DropdownObj.Value = currentSelected
                    if multi and type(val) == "table" then
                        local selKeys = {}
                        for k, v in pairs(val) do
                            if v == true then table.insert(selKeys, tostring(k)) end
                        end
                        SelectedText.Text = (#selKeys > 0 and table.concat(selKeys, ", ") or "None")
                    else
                        SelectedText.Text = tostring(val or "None")
                    end
                    if flag then Library.Flags[flag] = currentSelected end
                    refreshOptions()
                    if not ignoreCallback then
                        task.spawn(callback, currentSelected)
                    end
                end

                DropdownObj.Set = setDropdown
                DropdownObj.SetValue = setDropdown
                DropdownObj.RawSet = function(selfOrVal, val)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "Dropdown" then
                        setDropdown(selfOrVal, val, true)
                    else
                        setDropdown(selfOrVal, true)
                    end
                end
                DropdownObj.Refresh = function(selfOrOpts, newOpts)
                    local targetOpts = newOpts or (type(selfOrOpts) == "table" and selfOrOpts) or options
                    options = targetOpts or {}
                    DropdownObj.Values = options
                    refreshOptions()
                end
                DropdownObj.SetValues = DropdownObj.Refresh
                DropdownObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(v)
                        oldCallback(v)
                        targetFn(v)
                    end
                end

                if flag then
                    Library.Registry[flag] = DropdownObj
                    Library.Options[flag] = DropdownObj
                end

                Selector.MouseButton1Click:Connect(function()
                    DropdownList.Visible = not DropdownList.Visible
                    if DropdownList.Visible then
                        for _, other in ipairs(Overlay:GetChildren()) do
                            if other ~= DropdownList and other:IsA("GuiObject") then
                                other.Visible = false
                            end
                        end
                        local absPos = Selector.AbsolutePosition
                        local mainPos = MainFrame.AbsolutePosition
                        DropdownList.Position = UDim2.new(0, absPos.X - mainPos.X, 0, absPos.Y - mainPos.Y + 32)
                        DropdownList.Size = UDim2.new(0, Selector.AbsoluteSize.X, 0, math.min(math.max(#options * 28 + 12, 36), 160))
                        DropdownList:SetAttribute("ActivatorPosX", absPos.X)
                        DropdownList:SetAttribute("ActivatorPosY", absPos.Y)
                        DropdownList:SetAttribute("ActivatorSizeX", Selector.AbsoluteSize.X)
                        DropdownList:SetAttribute("ActivatorSizeY", Selector.AbsoluteSize.Y)
                        DropdownList:SetAttribute("ActivatorPos", Vector2.new(absPos.X, absPos.Y))
                        refreshOptions()
                    end
                end)

                refreshOptions()
                return DropdownObj
            end

            -- LISTBOX
            function SectionObj:AddListbox(arg1, arg2)
                local idx, lbConfig = normalizeArgs(arg1, arg2)
                local name = lbConfig.Name or lbConfig.Text or idx or "Listbox"
                local items = lbConfig.Items or lbConfig.Values or {}
                local default = lbConfig.Default or items[1] or ""
                local height = lbConfig.Height or 120
                local callback = lbConfig.Callback or lbConfig.Func or function() end
                local flag = lbConfig.Flag or lbConfig.Pointer or idx

                local ListboxFrame = Instance.new("Frame")
                ListboxFrame.Name = name .. "_Listbox"
                ListboxFrame.Size = UDim2.new(1, 0, 0, height + 26)
                ListboxFrame.BackgroundTransparency = 1
                ListboxFrame.ZIndex = 10
                ListboxFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Library.Fonts.Medium
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

                local ContCorner = Instance.new("UICorner")
                ContCorner.CornerRadius = UDim.new(0, 12)
                ContCorner.Parent = Container

                local ContStroke = Instance.new("UIStroke")
                ContStroke.Color = Library.Theme.ItemBorder
                ContStroke.Thickness = 1.2
                ContStroke.Parent = Container

                local ListLayout = Instance.new("UIListLayout")
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ListLayout.Padding = UDim.new(0, 3)
                ListLayout.Parent = Container

                local ListPadding = Instance.new("UIPadding")
                ListPadding.PaddingTop = UDim.new(0, 6)
                ListPadding.PaddingBottom = UDim.new(0, 6)
                ListPadding.PaddingLeft = UDim.new(0, 6)
                ListPadding.PaddingRight = UDim.new(0, 6)
                ListPadding.Parent = Container

                local currentSelected = default
                if flag then Library.Flags[flag] = currentSelected end

                local ListboxObj = {
                    Type = "Listbox",
                    Name = name,
                    Value = currentSelected,
                    Values = items,
                    Flag = flag,
                    Callback = callback
                }

                local function refreshItems()
                    for _, child in ipairs(Container:GetChildren()) do
                        if child:IsA("TextButton") then
                            local isSelected = (child.Name == tostring(currentSelected))
                            child.BackgroundColor3 = isSelected and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                            child.BackgroundTransparency = isSelected and 0.4 or 1
                            child.TextColor3 = isSelected and Library.Theme.Accent or Library.Theme.TextDim
                            child.Font = isSelected and Library.Fonts.Bold or Library.Fonts.Medium
                        end
                    end
                end

                local function buildItemButtons()
                    for _, child in ipairs(Container:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end

                    for _, item in ipairs(items) do
                        local isSelected = (item == currentSelected)
                        local ItemBtn = Instance.new("TextButton")
                        ItemBtn.Name = tostring(item)
                        ItemBtn.Size = UDim2.new(1, 0, 0, 24)
                        ItemBtn.BackgroundColor3 = isSelected and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                        ItemBtn.BackgroundTransparency = isSelected and 0.4 or 1
                        ItemBtn.Text = "  " .. tostring(item)
                        ItemBtn.TextColor3 = isSelected and Library.Theme.Accent or Library.Theme.TextDim
                        ItemBtn.Font = isSelected and Library.Fonts.Bold or Library.Fonts.Medium
                        ItemBtn.TextSize = 11
                        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        ItemBtn.AutoButtonColor = false
                        ItemBtn.ZIndex = 12
                        ItemBtn.Parent = Container

                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 6)
                        ItemCorner.Parent = ItemBtn

                        ItemBtn.MouseButton1Click:Connect(function()
                            currentSelected = item
                            ListboxObj.Value = currentSelected
                            if flag then Library.Flags[flag] = currentSelected end
                            refreshItems()
                            task.spawn(callback, item)
                        end)
                    end
                end

                local function setListbox(selfOrVal, valOrIgnore, maybeIgnore)
                    local val, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == ListboxObj or selfOrVal.Type == "Listbox") then
                        val = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        val = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    currentSelected = val
                    ListboxObj.Value = currentSelected
                    if flag then Library.Flags[flag] = currentSelected end
                    refreshItems()
                    if not ignoreCallback then
                        task.spawn(callback, currentSelected)
                    end
                end

                ListboxObj.Set = setListbox
                ListboxObj.SetValue = setListbox
                ListboxObj.RawSet = function(selfOrVal, val)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "Listbox" then
                        setListbox(selfOrVal, val, true)
                    else
                        setListbox(selfOrVal, true)
                    end
                end
                ListboxObj.Refresh = function(selfOrItems, newItems)
                    local targetItems = newItems or (type(selfOrItems) == "table" and selfOrItems) or items
                    items = targetItems
                    ListboxObj.Values = items
                    buildItemButtons()
                end
                ListboxObj.SetValues = ListboxObj.Refresh
                ListboxObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(v)
                        oldCallback(v)
                        targetFn(v)
                    end
                end

                if flag then
                    Library.Registry[flag] = ListboxObj
                    Library.Options[flag] = ListboxObj
                end

                buildItemButtons()
                return ListboxObj
            end

            -- BUTTON
            function SectionObj:AddButton(arg1, arg2)
                local idx, btnConfig = normalizeArgs(arg1, arg2)
                local name = btnConfig.Name or btnConfig.Text or idx or "Button"
                local callback = btnConfig.Callback or btnConfig.Func or function() end

                local Button = Instance.new("TextButton")
                Button.Name = name .. "_Button"
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.BackgroundColor3 = Library.Theme.ItemBg
                Button.BorderSizePixel = 0
                Button.Text = name
                Button.TextColor3 = Library.Theme.Text
                Button.Font = Library.Fonts.Bold
                Button.TextSize = 12
                Button.AutoButtonColor = false
                Button.ZIndex = 10
                Button.Parent = CardContainer
                Library:RegisterThemeObject(Button, "BackgroundColor3", "ItemBg")

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 10)
                BtnCorner.Parent = Button

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Library.Theme.ItemBorder
                BtnStroke.Thickness = 1.2
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

                local BtnObj = {
                    Type = "Button",
                    Name = name,
                    Instance = Button,
                    SetText = function(selfOrTxt, txt)
                        local t = txt or selfOrTxt
                        Button.Text = tostring(t)
                    end
                }

                if idx then
                    Library.Buttons[idx] = BtnObj
                end

                return BtnObj
            end

            -- TEXT INPUT
            function SectionObj:AddInput(arg1, arg2)
                local idx, inputConfig = normalizeArgs(arg1, arg2)
                local name = inputConfig.Name or inputConfig.Text or idx or "Input"
                local placeholder = inputConfig.Placeholder or inputConfig.PlaceholderText or "Type here..."
                local default = inputConfig.Default or inputConfig.Value or inputConfig.Text or ""
                local callback = inputConfig.Callback or inputConfig.Func or function() end
                local flag = inputConfig.Flag or inputConfig.Pointer or idx

                local InputFrame = Instance.new("Frame")
                InputFrame.Name = name .. "_InputFrame"
                InputFrame.Size = UDim2.new(1, 0, 0, 50)
                InputFrame.BackgroundTransparency = 1
                InputFrame.ZIndex = 10
                InputFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Library.Fonts.Medium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = InputFrame

                local BoxContainer = Instance.new("Frame")
                BoxContainer.Size = UDim2.new(1, 0, 0, 28)
                BoxContainer.Position = UDim2.new(0, 0, 0, 20)
                BoxContainer.BackgroundColor3 = Library.Theme.ItemBg
                BoxContainer.BorderSizePixel = 0
                BoxContainer.ZIndex = 11
                BoxContainer.Parent = InputFrame
                Library:RegisterThemeObject(BoxContainer, "BackgroundColor3", "ItemBg")

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 10)
                BoxCorner.Parent = BoxContainer

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = Library.Theme.ItemBorder
                BoxStroke.Thickness = 1.2
                BoxStroke.Parent = BoxContainer

                local TextBox = Instance.new("TextBox")
                TextBox.Size = UDim2.new(1, -16, 1, 0)
                TextBox.Position = UDim2.new(0, 10, 0, 0)
                TextBox.BackgroundTransparency = 1
                TextBox.Text = default
                TextBox.PlaceholderText = placeholder
                TextBox.PlaceholderColor3 = Library.Theme.TextDark
                TextBox.TextColor3 = Library.Theme.Text
                TextBox.Font = Library.Fonts.Medium
                TextBox.TextSize = 12
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.ClearTextOnFocus = false
                TextBox.ZIndex = 12
                TextBox.Parent = BoxContainer

                local currentText = default
                if flag then Library.Flags[flag] = currentText end

                local InputObj = {
                    Type = "Input",
                    Name = name,
                    Value = currentText,
                    Flag = flag,
                    Callback = callback
                }

                local function setInput(selfOrVal, valOrIgnore, maybeIgnore)
                    local text, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == InputObj or selfOrVal.Type == "Input") then
                        text = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        text = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    currentText = tostring(text or "")
                    TextBox.Text = currentText
                    InputObj.Value = currentText
                    if flag then Library.Flags[flag] = currentText end
                    if not ignoreCallback then
                        task.spawn(callback, currentText, true)
                    end
                end

                InputObj.Set = setInput
                InputObj.SetValue = setInput
                InputObj.RawSet = function(selfOrVal, text)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "Input" then
                        setInput(selfOrVal, text, true)
                    else
                        setInput(selfOrVal, true)
                    end
                end
                InputObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(t, e)
                        oldCallback(t, e)
                        targetFn(t, e)
                    end
                end

                if flag then
                    Library.Registry[flag] = InputObj
                    Library.Options[flag] = InputObj
                end

                TextBox.Focused:Connect(function()
                    createTween(BoxStroke, { Color = Library.Theme.Accent }, 0.15)
                end)

                TextBox.FocusLost:Connect(function(enterPressed)
                    createTween(BoxStroke, { Color = Library.Theme.ItemBorder }, 0.15)
                    currentText = TextBox.Text
                    InputObj.Value = currentText
                    if flag then Library.Flags[flag] = currentText end
                    task.spawn(callback, currentText, enterPressed)
                end)

                return InputObj
            end

            -- LABEL
            function SectionObj:AddLabel(arg1, arg2)
                local text = ""
                if arg2 ~= nil then
                    if type(arg2) == "table" then
                        text = arg2.Text or arg2.Name or arg1
                    else
                        text = tostring(arg2)
                    end
                elseif type(arg1) == "table" then
                    text = arg1.Text or arg1.Name or ""
                else
                    text = tostring(arg1 or "")
                end

                local LabelFrame = Instance.new("Frame")
                LabelFrame.Name = "LabelFrame"
                LabelFrame.Size = UDim2.new(1, 0, 0, 22)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.ZIndex = 10
                LabelFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Library.Theme.Text
                Label.Font = Library.Fonts.Medium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = LabelFrame
                Library:RegisterThemeObject(Label, "TextColor3", "Text")

                local RightElements = Instance.new("Frame")
                RightElements.Name = "RightElements"
                RightElements.Size = UDim2.new(0, 130, 1, 0)
                RightElements.Position = UDim2.new(1, -130, 0, 0)
                RightElements.BackgroundTransparency = 1
                RightElements.ZIndex = 10
                RightElements.Parent = LabelFrame

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 6)
                RightLayout.Parent = RightElements

                local LabelObj = {
                    Type = "Label",
                    Text = text,
                    Instance = Label,
                    RightElements = RightElements
                }

                local function setLabelText(newText)
                    Label.Text = tostring(newText)
                    LabelObj.Text = tostring(newText)
                end

                LabelObj.Set = setLabelText
                LabelObj.SetText = setLabelText

                function LabelObj:AddKeyPicker(kbArg1, kbArg2)
                    local kbIdx, kbConfig = normalizeArgs(kbArg1, kbArg2)
                    local defaultKey = kbConfig.Default or Enum.KeyCode.Unknown
                    if type(defaultKey) == "string" then
                        defaultKey = Enum.KeyCode[defaultKey] or Enum.KeyCode.Unknown
                    end
                    local kbCallback = kbConfig.Callback or kbConfig.Func or function() end
                    local kbFlag = kbConfig.Flag or kbConfig.Pointer or kbIdx
                    local currentKey = defaultKey
                    local binding = false

                    local KeyBtn = Instance.new("TextButton")
                    KeyBtn.Name = "KeybindBtn"
                    KeyBtn.Size = UDim2.new(0, 28, 0, 16)
                    KeyBtn.BackgroundColor3 = Library.Theme.ItemBg
                    KeyBtn.BorderSizePixel = 0
                    KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                    KeyBtn.TextColor3 = Library.Theme.TextDark
                    KeyBtn.Font = Library.Fonts.Bold
                    KeyBtn.TextSize = 10
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.LayoutOrder = 5
                    KeyBtn.ZIndex = 11
                    KeyBtn.Parent = RightElements

                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 6)
                    KeyCorner.Parent = KeyBtn

                    local KeyStroke = Instance.new("UIStroke")
                    KeyStroke.Color = Library.Theme.CardBorder
                    KeyStroke.Thickness = 1.2
                    KeyStroke.Parent = KeyBtn

                    local KeybindObj = {
                        Type = "Keybind",
                        Value = currentKey,
                        Flag = kbFlag,
                        Callback = kbCallback
                    }

                    local function setKey(selfOrVal, valOrIgnore, maybeIgnore)
                        local k, ignoreCallback
                        if type(selfOrVal) == "table" and (selfOrVal == KeybindObj or selfOrVal.Type == "Keybind" or selfOrVal.Type == "KeyPicker") then
                            k = valOrIgnore
                            ignoreCallback = maybeIgnore
                        else
                            k = selfOrVal
                            ignoreCallback = valOrIgnore
                        end
                        if type(k) == "table" and k.key then
                            k = k.key
                        elseif type(k) == "table" and k[1] then
                            k = k[1]
                        end
                        if type(k) == "string" then
                            k = Enum.KeyCode[k] or Enum.KeyCode.Unknown
                        end
                        currentKey = k or Enum.KeyCode.Unknown
                        KeybindObj.Value = currentKey
                        KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                        if kbFlag then Library.Flags[kbFlag] = currentKey end
                        if not ignoreCallback then
                            task.spawn(kbCallback, currentKey)
                        end
                    end

                    KeybindObj.Set = setKey
                    KeybindObj.SetValue = setKey
                    KeybindObj.RawSet = function(selfOrVal, k)
                        if type(selfOrVal) == "table" and selfOrVal.Type == "Keybind" then
                            setKey(selfOrVal, k, true)
                        else
                            setKey(selfOrVal, true)
                        end
                    end
                    KeybindObj.OnChanged = function(selfOrFn, fn)
                        local targetFn = fn or selfOrFn
                        local oldCallback = kbCallback
                        kbCallback = function(k)
                            oldCallback(k)
                            targetFn(k)
                        end
                    end

                    if kbFlag then
                        Library.Registry[kbFlag] = KeybindObj
                        Library.Options[kbFlag] = KeybindObj
                    end

                    KeyBtn.MouseButton1Click:Connect(function()
                        binding = true
                        KeyBtn.Text = "..."
                        KeyBtn.TextColor3 = Library.Theme.Accent
                    end)

                    UserInputService.InputBegan:Connect(function(input, gpe)
                        if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                            if input.KeyCode == Enum.KeyCode.Escape then
                                currentKey = Enum.KeyCode.Unknown
                            else
                                currentKey = input.KeyCode
                            end
                            KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                            binding = false
                            KeybindObj.Value = currentKey
                            if kbFlag then Library.Flags[kbFlag] = currentKey end
                            KeyBtn.TextColor3 = Library.Theme.TextDark
                            task.spawn(kbCallback, currentKey)
                        elseif not gpe and not binding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                            if Library.ToggleKeybind == KeybindObj or Library.ToggleKeybind == currentKey then
                                if WindowObj and WindowObj.Toggle then
                                    WindowObj:Toggle()
                                end
                            end
                            task.spawn(kbCallback, currentKey)
                        end
                    end)

                    return LabelObj
                end
                LabelObj.AddKeybind = LabelObj.AddKeyPicker

                function LabelObj:AddColorPicker(cpArg1, cpArg2)
                    local cpIdx, cpConfig = normalizeArgs(cpArg1, cpArg2)
                    local cpDefault = cpConfig.Default or Library.Theme.Accent
                    if type(cpDefault) == "string" then
                        local success, col = pcall(function() return Color3.fromHex(cpDefault) end)
                        if success and col then cpDefault = col end
                    end
                    local cpCallback = cpConfig.Callback or cpConfig.Func or function() end
                    local cpFlag = cpConfig.Flag or cpConfig.Pointer or cpIdx

                    local ColorBox = Instance.new("TextButton")
                    ColorBox.Name = "ColorBox"
                    ColorBox.Size = UDim2.new(0, 18, 0, 14)
                    ColorBox.BackgroundColor3 = cpDefault
                    ColorBox.BorderSizePixel = 0
                    ColorBox.Text = ""
                    ColorBox.AutoButtonColor = false
                    ColorBox.LayoutOrder = 10
                    ColorBox.ZIndex = 11
                    ColorBox.Parent = RightElements

                    local BoxCorner = Instance.new("UICorner")
                    BoxCorner.CornerRadius = UDim.new(0, 6)
                    BoxCorner.Parent = ColorBox

                    local BoxStroke = Instance.new("UIStroke")
                    BoxStroke.Color = Library.Theme.CardBorder
                    BoxStroke.Thickness = 1.2
                    BoxStroke.Parent = ColorBox

                    local currentColor = cpDefault
                    if cpFlag then Library.Flags[cpFlag] = currentColor end

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
                    PickerCorner.CornerRadius = UDim.new(0, 14)
                    PickerCorner.Parent = PickerFrame

                    local PickerStroke = Instance.new("UIStroke")
                    PickerStroke.Color = Library.Theme.CardBorder
                    PickerStroke.Thickness = 1.2
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
                    SatValCorner.CornerRadius = UDim.new(0, 10)
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
                    HueCorner.CornerRadius = UDim.new(0, 8)
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

                    local ColorPickerObj = {
                        Type = "ColorPicker",
                        Value = currentColor,
                        Flag = cpFlag,
                        Callback = cpCallback
                    }

                    local function updateColor(ignoreCallback)
                        currentColor = Color3.fromHSV(h, s, v)
                        ColorPickerObj.Value = currentColor
                        ColorBox.BackgroundColor3 = currentColor
                        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        if cpFlag then Library.Flags[cpFlag] = currentColor end
                        if not ignoreCallback then
                            task.spawn(cpCallback, currentColor)
                        end
                    end

                    local function setColor(selfOrVal, valOrIgnore, maybeIgnore)
                        local col, ignoreCallback
                        if type(selfOrVal) == "table" and (selfOrVal == ColorPickerObj or selfOrVal.Type == "ColorPicker") then
                            col = valOrIgnore
                            ignoreCallback = maybeIgnore
                        else
                            col = selfOrVal
                            ignoreCallback = valOrIgnore
                        end
                        if typeof(col) == "Color3" then
                            currentColor = col
                        elseif type(col) == "string" then
                            local success, c = pcall(function() return Color3.fromHex(col) end)
                            if success and c then currentColor = c end
                        elseif type(col) == "table" and col.r and col.g and col.b then
                            currentColor = Color3.fromRGB(col.r, col.g, col.b)
                        elseif type(col) == "table" and col[1] and col[2] and col[3] then
                            currentColor = Color3.fromRGB(col[1], col[2], col[3])
                        end
                        h, s, v = currentColor:ToHSV()
                        ColorPickerObj.Value = currentColor
                        ColorBox.BackgroundColor3 = currentColor
                        SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        if cpFlag then Library.Flags[cpFlag] = currentColor end
                        if not ignoreCallback then
                            task.spawn(cpCallback, currentColor)
                        end
                    end

                    ColorPickerObj.Set = setColor
                    ColorPickerObj.SetValue = setColor
                    ColorPickerObj.SetValueRGB = setColor
                    ColorPickerObj.RawSet = function(selfOrVal, col)
                        if type(selfOrVal) == "table" and selfOrVal.Type == "ColorPicker" then
                            setColor(selfOrVal, col, true)
                        else
                            setColor(selfOrVal, true)
                        end
                    end
                    ColorPickerObj.OnChanged = function(selfOrFn, fn)
                        local targetFn = fn or selfOrFn
                        local oldCallback = cpCallback
                        cpCallback = function(c)
                            oldCallback(c)
                            targetFn(c)
                        end
                    end

                    if cpFlag then
                        Library.Registry[cpFlag] = ColorPickerObj
                        Library.Options[cpFlag] = ColorPickerObj
                    end

                    ColorBox.MouseButton1Click:Connect(function()
                        PickerFrame.Visible = not PickerFrame.Visible
                        if PickerFrame.Visible then
                            for _, other in ipairs(Overlay:GetChildren()) do
                                if other ~= PickerFrame and other:IsA("GuiObject") then
                                    other.Visible = false
                                end
                            end
                            local absPos = ColorBox.AbsolutePosition
                            local mainPos = MainFrame.AbsolutePosition
                            PickerFrame.Position = UDim2.new(0, absPos.X - mainPos.X - 140, 0, absPos.Y - mainPos.Y + 20)
                            PickerFrame:SetAttribute("ActivatorPosX", absPos.X)
                            PickerFrame:SetAttribute("ActivatorPosY", absPos.Y)
                            PickerFrame:SetAttribute("ActivatorSizeX", ColorBox.AbsoluteSize.X)
                            PickerFrame:SetAttribute("ActivatorSizeY", ColorBox.AbsoluteSize.Y)
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

                    return LabelObj
                end

                return LabelObj
            end

            -- COLOR PICKER ON SECTION
            function SectionObj:AddColorPicker(arg1, arg2)
                local idx, cpConfig = normalizeArgs(arg1, arg2)
                local name = cpConfig.Name or cpConfig.Text or idx or "Color Picker"
                local default = cpConfig.Default or Library.Theme.Accent
                if type(default) == "string" then
                    local success, col = pcall(function() return Color3.fromHex(default) end)
                    if success and col then default = col end
                end
                local callback = cpConfig.Callback or cpConfig.Func or function() end
                local flag = cpConfig.Flag or cpConfig.Pointer or idx

                local CPFrame = Instance.new("Frame")
                CPFrame.Name = name .. "_ColorPicker"
                CPFrame.Size = UDim2.new(1, 0, 0, 24)
                CPFrame.BackgroundTransparency = 1
                CPFrame.ZIndex = 10
                CPFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.Text
                Label.Font = Library.Fonts.Medium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = CPFrame
                Library:RegisterThemeObject(Label, "TextColor3", "Text")

                local RightElements = Instance.new("Frame")
                RightElements.Name = "RightElements"
                RightElements.Size = UDim2.new(0, 130, 1, 0)
                RightElements.Position = UDim2.new(1, -130, 0, 0)
                RightElements.BackgroundTransparency = 1
                RightElements.ZIndex = 10
                RightElements.Parent = CPFrame

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 6)
                RightLayout.Parent = RightElements

                local ColorBox = Instance.new("TextButton")
                ColorBox.Name = "ColorBox"
                ColorBox.Size = UDim2.new(0, 24, 0, 16)
                ColorBox.BackgroundColor3 = default
                ColorBox.BorderSizePixel = 0
                ColorBox.Text = ""
                ColorBox.AutoButtonColor = false
                ColorBox.LayoutOrder = 10
                ColorBox.ZIndex = 11
                ColorBox.Parent = RightElements

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = ColorBox

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = Library.Theme.CardBorder
                BoxStroke.Thickness = 1.2
                BoxStroke.Parent = ColorBox

                local currentColor = default
                if flag then Library.Flags[flag] = currentColor end

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
                PickerCorner.CornerRadius = UDim.new(0, 14)
                PickerCorner.Parent = PickerFrame

                local PickerStroke = Instance.new("UIStroke")
                PickerStroke.Color = Library.Theme.CardBorder
                PickerStroke.Thickness = 1.2
                PickerStroke.Parent = PickerFrame

                local SatVal = Instance.new("TextButton")
                SatVal.Name = "SatVal"
                SatVal.Size = UDim2.new(1, -16, 0, 90)
                SatVal.Position = UDim2.new(0, 8, 0, 8)
                SatVal.BackgroundColor3 = default
                SatVal.BorderSizePixel = 0
                SatVal.Text = ""
                SatVal.AutoButtonColor = false
                SatVal.ZIndex = 61
                SatVal.Parent = PickerFrame

                local SatValCorner = Instance.new("UICorner")
                SatValCorner.CornerRadius = UDim.new(0, 10)
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
                HueCorner.CornerRadius = UDim.new(0, 8)
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

                local h, s, v = default:ToHSV()

                local ColorPickerObj = {
                    Type = "ColorPicker",
                    Name = name,
                    Value = currentColor,
                    Flag = flag,
                    Callback = callback
                }

                local function updateColor(ignoreCallback)
                    currentColor = Color3.fromHSV(h, s, v)
                    ColorPickerObj.Value = currentColor
                    ColorBox.BackgroundColor3 = currentColor
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    if flag then Library.Flags[flag] = currentColor end
                    if not ignoreCallback then
                        task.spawn(callback, currentColor)
                    end
                end

                local function setColor(selfOrVal, valOrIgnore, maybeIgnore)
                    local col, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == ColorPickerObj or selfOrVal.Type == "ColorPicker") then
                        col = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        col = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    if typeof(col) == "Color3" then
                        currentColor = col
                    elseif type(col) == "string" then
                        local success, c = pcall(function() return Color3.fromHex(col) end)
                        if success and c then currentColor = c end
                    elseif type(col) == "table" and col.r and col.g and col.b then
                        currentColor = Color3.fromRGB(col.r, col.g, col.b)
                    elseif type(col) == "table" and col[1] and col[2] and col[3] then
                        currentColor = Color3.fromRGB(col[1], col[2], col[3])
                    end
                    h, s, v = currentColor:ToHSV()
                    ColorPickerObj.Value = currentColor
                    ColorBox.BackgroundColor3 = currentColor
                    SatVal.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    if flag then Library.Flags[flag] = currentColor end
                    if not ignoreCallback then
                        task.spawn(callback, currentColor)
                    end
                end

                ColorPickerObj.Set = setColor
                ColorPickerObj.SetValue = setColor
                ColorPickerObj.SetValueRGB = setColor
                ColorPickerObj.RawSet = function(selfOrVal, col)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "ColorPicker" then
                        setColor(selfOrVal, col, true)
                    else
                        setColor(selfOrVal, true)
                    end
                end
                ColorPickerObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(c)
                        oldCallback(c)
                        targetFn(c)
                    end
                end

                if flag then
                    Library.Registry[flag] = ColorPickerObj
                    Library.Options[flag] = ColorPickerObj
                end

                ColorBox.MouseButton1Click:Connect(function()
                    PickerFrame.Visible = not PickerFrame.Visible
                    if PickerFrame.Visible then
                        for _, other in ipairs(Overlay:GetChildren()) do
                            if other ~= PickerFrame and other:IsA("GuiObject") then
                                other.Visible = false
                            end
                        end
                        local absPos = ColorBox.AbsolutePosition
                        local mainPos = MainFrame.AbsolutePosition
                        PickerFrame.Position = UDim2.new(0, absPos.X - mainPos.X - 140, 0, absPos.Y - mainPos.Y + 20)
                        PickerFrame:SetAttribute("ActivatorPosX", absPos.X)
                        PickerFrame:SetAttribute("ActivatorPosY", absPos.Y)
                        PickerFrame:SetAttribute("ActivatorSizeX", ColorBox.AbsoluteSize.X)
                        PickerFrame:SetAttribute("ActivatorSizeY", ColorBox.AbsoluteSize.Y)
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

                return ColorPickerObj
            end

            -- KEY PICKER ON SECTION
            function SectionObj:AddKeyPicker(arg1, arg2)
                local idx, kbConfig = normalizeArgs(arg1, arg2)
                local name = kbConfig.Name or kbConfig.Text or idx or "Keybind"
                local defaultKey = kbConfig.Default or Enum.KeyCode.Unknown
                if type(defaultKey) == "string" then
                    defaultKey = Enum.KeyCode[defaultKey] or Enum.KeyCode.Unknown
                end
                local callback = kbConfig.Callback or kbConfig.Func or function() end
                local flag = kbConfig.Flag or kbConfig.Pointer or idx
                local currentKey = defaultKey
                local binding = false

                local KBFrame = Instance.new("Frame")
                KBFrame.Name = name .. "_Keybind"
                KBFrame.Size = UDim2.new(1, 0, 0, 24)
                KBFrame.BackgroundTransparency = 1
                KBFrame.ZIndex = 10
                KBFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.Text
                Label.Font = Library.Fonts.Medium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 10
                Label.Parent = KBFrame
                Library:RegisterThemeObject(Label, "TextColor3", "Text")

                local RightElements = Instance.new("Frame")
                RightElements.Name = "RightElements"
                RightElements.Size = UDim2.new(0, 130, 1, 0)
                RightElements.Position = UDim2.new(1, -130, 0, 0)
                RightElements.BackgroundTransparency = 1
                RightElements.ZIndex = 10
                RightElements.Parent = KBFrame

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 6)
                RightLayout.Parent = RightElements

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Name = "KeybindBtn"
                KeyBtn.Size = UDim2.new(0, 28, 0, 16)
                KeyBtn.BackgroundColor3 = Library.Theme.ItemBg
                KeyBtn.BorderSizePixel = 0
                KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                KeyBtn.TextColor3 = Library.Theme.TextDark
                KeyBtn.Font = Library.Fonts.Bold
                KeyBtn.TextSize = 10
                KeyBtn.AutoButtonColor = false
                KeyBtn.LayoutOrder = 5
                KeyBtn.ZIndex = 11
                KeyBtn.Parent = RightElements

                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 6)
                KeyCorner.Parent = KeyBtn

                local KeyStroke = Instance.new("UIStroke")
                KeyStroke.Color = Library.Theme.CardBorder
                KeyStroke.Thickness = 1.2
                KeyStroke.Parent = KeyBtn

                local KeybindObj = {
                    Type = "Keybind",
                    Name = name,
                    Value = currentKey,
                    Flag = flag,
                    Callback = callback
                }

                local function setKey(selfOrVal, valOrIgnore, maybeIgnore)
                    local k, ignoreCallback
                    if type(selfOrVal) == "table" and (selfOrVal == KeybindObj or selfOrVal.Type == "Keybind" or selfOrVal.Type == "KeyPicker") then
                        k = valOrIgnore
                        ignoreCallback = maybeIgnore
                    else
                        k = selfOrVal
                        ignoreCallback = valOrIgnore
                    end
                    if type(k) == "table" and k.key then
                        k = k.key
                    elseif type(k) == "table" and k[1] then
                        k = k[1]
                    end
                    if type(k) == "string" then
                        k = Enum.KeyCode[k] or Enum.KeyCode.Unknown
                    end
                    currentKey = k or Enum.KeyCode.Unknown
                    KeybindObj.Value = currentKey
                    KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                    if flag then Library.Flags[flag] = currentKey end
                    if not ignoreCallback then
                        task.spawn(callback, currentKey)
                    end
                end

                KeybindObj.Set = setKey
                KeybindObj.SetValue = setKey
                KeybindObj.RawSet = function(selfOrVal, k)
                    if type(selfOrVal) == "table" and selfOrVal.Type == "Keybind" then
                        setKey(selfOrVal, k, true)
                    else
                        setKey(selfOrVal, true)
                    end
                end
                KeybindObj.OnChanged = function(selfOrFn, fn)
                    local targetFn = fn or selfOrFn
                    local oldCallback = callback
                    callback = function(k)
                        oldCallback(k)
                        targetFn(k)
                    end
                end

                if flag then
                    Library.Registry[flag] = KeybindObj
                    Library.Options[flag] = KeybindObj
                end

                KeyBtn.MouseButton1Click:Connect(function()
                    binding = true
                    KeyBtn.Text = "..."
                    KeyBtn.TextColor3 = Library.Theme.Accent
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        if input.KeyCode == Enum.KeyCode.Escape then
                            currentKey = Enum.KeyCode.Unknown
                        else
                            currentKey = input.KeyCode
                        end
                        KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                        binding = false
                        KeybindObj.Value = currentKey
                        if flag then Library.Flags[flag] = currentKey end
                        KeyBtn.TextColor3 = Library.Theme.TextDark
                        task.spawn(callback, currentKey)
                    elseif not gpe and not binding and currentKey ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                        if Library.ToggleKeybind == KeybindObj or Library.ToggleKeybind == currentKey then
                            if WindowObj and WindowObj.Toggle then
                                WindowObj:Toggle()
                            end
                        end
                        task.spawn(callback, currentKey)
                    end
                end)

                return KeybindObj
            end
            SectionObj.AddKeybind = SectionObj.AddKeyPicker

            -- DIVIDER
            function SectionObj:AddDivider()
                local Divider = Instance.new("Frame")
                Divider.Size = UDim2.new(1, 0, 0, 1)
                Divider.BackgroundColor3 = Library.Theme.CardBorder
                Divider.BorderSizePixel = 0
                Divider.ZIndex = 10
                Divider.Parent = CardContainer
                Library:RegisterThemeObject(Divider, "BackgroundColor3", "CardBorder")
                return Divider
            end

            return SectionObj
        end

        TabObj.AddSection = TabObj.CreateSection
        TabObj.AddLeftGroupbox = function(self, title) return self:CreateSection(title, "Left") end
        TabObj.AddRightGroupbox = function(self, title) return self:CreateSection(title, "Right") end
        TabObj.AddLeftTabbox = TabObj.AddLeftGroupbox
        TabObj.AddRightTabbox = TabObj.AddRightGroupbox

        return TabObj
    end

    -- NOTIFICATION
    function Library:Notify(notifConfig, durationOverride)
        if type(notifConfig) == "string" then
            notifConfig = {
                Title = "Nameless",
                Content = notifConfig,
                Duration = (type(durationOverride) == "number" and durationOverride or 3)
            }
        end
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "Nameless"
        local content = notifConfig.Content or ""
        local duration = notifConfig.Duration or 3

        local targetGui = (Library.CurrentWindow and Library.CurrentWindow.ScreenGui) or getGuiParent():FindFirstChildOfClass("ScreenGui") or getGuiParent()

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Name = "Notification"
        NotifFrame.Size = UDim2.new(0, 250, 0, 60)
        NotifFrame.Position = UDim2.new(1, 270, 1, -80)
        NotifFrame.BackgroundColor3 = Library.Theme.Background
        NotifFrame.BorderSizePixel = 0
        NotifFrame.ZIndex = 100
        NotifFrame.Parent = targetGui

        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 14)
        NotifCorner.Parent = NotifFrame

        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Library.Theme.Accent
        NotifStroke.Thickness = 1.5
        NotifStroke.Parent = NotifFrame

        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -24, 0, 18)
        NotifTitle.Position = UDim2.new(0, 14, 0, 10)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Library.Theme.Accent
        NotifTitle.Font = Library.Fonts.Bold
        NotifTitle.TextSize = 13
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.ZIndex = 101
        NotifTitle.Parent = NotifFrame

        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -24, 0, 18)
        NotifContent.Position = UDim2.new(0, 14, 0, 30)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = content
        NotifContent.TextColor3 = Library.Theme.TextDim
        NotifContent.Font = Library.Fonts.Medium
        NotifContent.TextSize = 11
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.ZIndex = 101
        NotifContent.Parent = NotifFrame

        createTween(NotifFrame, { Position = UDim2.new(1, -270, 1, -80) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.delay(duration, function()
            local tw = createTween(NotifFrame, { Position = UDim2.new(1, 270, 1, -80) }, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end)
    end

    -- ==================== THEME MANAGER HELPER ====================
    function WindowObj:CreateThemeManager(targetSection)
        local themeList = {
            "Nameless",
            "Midnight",
            "Emerald",
            "Crimson",
            "Sakura",
            "Cyberpunk",
            "TokyoNight",
            "Synthwave",
            "NordFrost",
            "Monokai",
            "Dracula",
            "AcidGreen",
            "SunsetAmber",
            "RoseGold",
            "PureObsidian"
        }

        targetSection:AddDropdown("ThemeDropdown", {
            Text = "Select Theme",
            Options = themeList,
            Default = Library.CurrentTheme,
            Callback = function(theme)
                Library:SetTheme(theme)
            end
        })

        local AccentToggle = targetSection:AddToggle("CustomAccentToggle", {
            Text = "Custom Accent Color",
            Default = false,
            Callback = function() end
        })
        AccentToggle:AddColorPicker("CustomAccent", {
            Default = Library.Theme.Accent,
            Callback = function(col)
                Library:SetAccent(col)
            end
        })
    end

    -- ==================== SAVE / CONFIG MANAGER ====================
    local SaveManager = {
        Folder = "NamelessConfigs",
        IgnoreIndexes = {},
        Library = Library,
        SelectedConfig = ""
    }

    function SaveManager:SetLibrary(lib)
        self.Library = lib or Library
        if self.Library then
            self.Library.SaveManager = self
        end
    end

    function SaveManager:SetFolder(folder)
        self.Folder = folder or "NamelessConfigs"
        if self.Library then
            self.Library.Folder = self.Folder
        end
    end

    function SaveManager:SetSubFolder(subFolder)
        if subFolder and #subFolder > 0 then
            self.Folder = self.Folder .. "/" .. subFolder
        end
    end

    function SaveManager:SetIgnoreIndexes(indexes)
        if type(indexes) == "table" then
            for k, v in pairs(indexes) do
                if type(k) == "number" and type(v) == "string" then
                    self.IgnoreIndexes[v] = true
                elseif type(k) == "string" and v == true then
                    self.IgnoreIndexes[k] = true
                end
            end
        end
    end

    function SaveManager:IgnoreThemeSettings()
        self.IgnoreIndexes["Theme"] = true
        self.IgnoreIndexes["ThemeDropdown"] = true
        self.IgnoreIndexes["CustomAccent"] = true
        self.IgnoreIndexes["CustomAccentToggle"] = true
        self.IgnoreIndexes["SaveManager_ConfigList"] = true
        self.IgnoreIndexes["SaveManager_CustomConfigName"] = true
    end

    function SaveManager:EnsureFolder()
        local folder = self.Folder or "NamelessConfigs"
        if makefolder and isfolder then
            local normalized = folder:gsub("\\", "/")
            local parts = normalized:split("/")
            local current = ""
            for _, part in ipairs(parts) do
                if #part > 0 then
                    current = (current == "") and part or (current .. "/" .. part)
                    if not isfolder(current) then
                        pcall(makefolder, current)
                    end
                end
            end
        end
    end

    SaveManager.CheckFolderTree = SaveManager.EnsureFolder

    function SaveManager:GetConfigs()
        self:EnsureFolder()
        local list = {}
        if listfiles and isfolder and isfolder(self.Folder) then
            local success, files = pcall(listfiles, self.Folder)
            if success and type(files) == "table" then
                for _, file in ipairs(files) do
                    local normalized = file:gsub("\\", "/")
                    local name = normalized:match("([^/]+)%.[jJ][sS][oO][nN]$")
                    if name and name:lower() ~= "autoload" then
                        table.insert(list, name)
                    end
                end
            end
        end
        table.sort(list, function(a, b) return a:lower() < b:lower() end)
        return list
    end

    SaveManager.RefreshConfigList = function(self)
        return self:GetConfigs()
    end

    function SaveManager:GetAutoloadName()
        self:EnsureFolder()
        local path = self.Folder .. "/autoload.txt"
        if readfile and isfile and isfile(path) then
            local success, name = pcall(readfile, path)
            if success and name then
                name = name:gsub("%s+", "")
                if #name > 0 then
                    return name
                end
            end
        end
        return nil
    end

    function SaveManager:SetAutoload(name)
        if not name or name == "" then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Please select or type a config name first.",
                Duration = 3
            })
            return false
        end
        self:EnsureFolder()
        if writefile then
            local success, err = pcall(writefile, self.Folder .. "/autoload.txt", name)
            if success then
                self.Library:Notify({
                    Title = "Save Manager",
                    Content = "Set '" .. tostring(name) .. "' as autoload config",
                    Duration = 3
                })
                return true
            else
                self.Library:Notify({
                    Title = "Save Manager",
                    Content = "Failed to set autoload: " .. tostring(err),
                    Duration = 3
                })
            end
        end
        return false
    end

    function SaveManager:ClearAutoload()
        self:EnsureFolder()
        local path = self.Folder .. "/autoload.txt"
        if isfile and isfile(path) and delfile then
            pcall(delfile, path)
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Cleared autoload config",
                Duration = 3
            })
            return true
        end
        return false
    end

    function SaveManager:LoadAutoloadConfig()
        local autoName = self:GetAutoloadName()
        if autoName then
            return self:Load(autoName)
        end
        return false
    end

    function SaveManager:Save(name)
        if not name or name == "" then name = "default" end
        self:EnsureFolder()
        
        if not writefile then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "writefile is not supported on this executor.",
                Duration = 3
            })
            return false
        end

        local data = {
            objects = {}
        }

        -- Save Toggles
        for idx, toggle in pairs(self.Library.Toggles or {}) do
            if not self.IgnoreIndexes[idx] and type(toggle) == "table" and toggle.Value ~= nil then
                table.insert(data.objects, {
                    type = "Toggle",
                    idx = idx,
                    value = (toggle.Value == true)
                })
            end
        end

        -- Save Options (Sliders, Dropdowns, ColorPickers, Keybinds, Inputs, Listboxes)
        for idx, option in pairs(self.Library.Options or {}) do
            if not self.IgnoreIndexes[idx] and type(option) == "table" then
                local elemType = option.Type or "Option"
                if elemType == "Slider" then
                    table.insert(data.objects, {
                        type = "Slider",
                        idx = idx,
                        value = option.Value
                    })
                elseif elemType == "Dropdown" then
                    table.insert(data.objects, {
                        type = "Dropdown",
                        idx = idx,
                        value = option.Value,
                        multi = option.Multi
                    })
                elseif elemType == "Listbox" then
                    table.insert(data.objects, {
                        type = "Listbox",
                        idx = idx,
                        value = option.Value
                    })
                elseif elemType == "ColorPicker" then
                    local hex = "ffffff"
                    if typeof(option.Value) == "Color3" then
                        hex = option.Value:ToHex()
                    end
                    table.insert(data.objects, {
                        type = "ColorPicker",
                        idx = idx,
                        value = hex
                    })
                elseif elemType == "Keybind" or elemType == "KeyPicker" then
                    local keyName = "Unknown"
                    if typeof(option.Value) == "EnumItem" then
                        keyName = option.Value.Name
                    elseif type(option.Value) == "string" then
                        keyName = option.Value
                    end
                    table.insert(data.objects, {
                        type = "KeyPicker",
                        idx = idx,
                        key = keyName
                    })
                elseif elemType == "Input" then
                    table.insert(data.objects, {
                        type = "Input",
                        idx = idx,
                        text = tostring(option.Value or "")
                    })
                end
            end
        end

        -- Also save any extra Flags not registered in Toggles/Options
        for flag, val in pairs(self.Library.Flags or {}) do
            if not self.IgnoreIndexes[flag] and not self.Library.Toggles[flag] and not self.Library.Options[flag] then
                if typeof(val) == "Color3" then
                    table.insert(data.objects, {
                        type = "ColorPicker",
                        idx = flag,
                        value = val:ToHex()
                    })
                elseif typeof(val) == "EnumItem" then
                    table.insert(data.objects, {
                        type = "KeyPicker",
                        idx = flag,
                        key = val.Name
                    })
                elseif type(val) == "boolean" then
                    table.insert(data.objects, {
                        type = "Toggle",
                        idx = flag,
                        value = val
                    })
                elseif type(val) == "number" then
                    table.insert(data.objects, {
                        type = "Slider",
                        idx = flag,
                        value = val
                    })
                elseif type(val) == "string" then
                    table.insert(data.objects, {
                        type = "Input",
                        idx = flag,
                        text = val
                    })
                end
            end
        end

        local success, encoded = pcall(function()
            return HttpService:JSONEncode(data)
        end)

        if not success or not encoded then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Failed to encode config data: " .. tostring(encoded),
                Duration = 3
            })
            return false
        end

        local path = self.Folder .. "/" .. name .. ".json"
        local writeSuccess, writeErr = pcall(writefile, path, encoded)
        if writeSuccess then
            self.SelectedConfig = name
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Saved config: '" .. name .. "'",
                Duration = 3
            })
            return true
        else
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Failed to save file: " .. tostring(writeErr),
                Duration = 3
            })
            return false
        end
    end

    function SaveManager:Load(name)
        if not name or name == "" then
            name = self.SelectedConfig
        end
        if not name or name == "" then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "No config specified or selected.",
                Duration = 3
            })
            return false
        end

        self:EnsureFolder()
        local path = self.Folder .. "/" .. name .. ".json"
        if not (readfile and isfile and isfile(path)) then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Config file not found: '" .. name .. "'",
                Duration = 3
            })
            return false
        end

        local content = readfile(path)
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(content)
        end)

        if not success or type(decoded) ~= "table" then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "Corrupt config file: '" .. name .. "'",
                Duration = 3
            })
            return false
        end

        local count = 0
        if decoded.objects and type(decoded.objects) == "table" then
            for _, obj in ipairs(decoded.objects) do
                local idx = obj.idx
                local elemType = obj.type

                if elemType == "Toggle" then
                    local target = self.Library.Toggles[idx] or self.Library.Registry[idx]
                    if target then
                        if target.SetValue then
                            target:SetValue(obj.value)
                        elseif target.Set then
                            target:Set(obj.value)
                        end
                        count = count + 1
                    else
                        self.Library.Flags[idx] = obj.value
                    end
                elseif elemType == "Slider" then
                    local target = self.Library.Options[idx] or self.Library.Registry[idx]
                    if target then
                        if target.SetValue then
                            target:SetValue(obj.value)
                        elseif target.Set then
                            target:Set(obj.value)
                        end
                        count = count + 1
                    else
                        self.Library.Flags[idx] = obj.value
                    end
                elseif elemType == "Dropdown" or elemType == "Listbox" then
                    local target = self.Library.Options[idx] or self.Library.Registry[idx]
                    if target then
                        if target.SetValue then
                            target:SetValue(obj.value)
                        elseif target.Set then
                            target:Set(obj.value)
                        end
                        count = count + 1
                    else
                        self.Library.Flags[idx] = obj.value
                    end
                elseif elemType == "ColorPicker" then
                    local target = self.Library.Options[idx] or self.Library.Registry[idx]
                    local col = Color3.fromHex(obj.value or "ffffff")
                    if target then
                        if target.SetValueRGB then
                            target:SetValueRGB(col)
                        elseif target.SetValue then
                            target:SetValue(col)
                        elseif target.Set then
                            target:Set(col)
                        end
                        count = count + 1
                    else
                        self.Library.Flags[idx] = col
                    end
                elseif elemType == "KeyPicker" or elemType == "Keybind" then
                    local target = self.Library.Options[idx] or self.Library.Registry[idx]
                    local key = Enum.KeyCode[obj.key or "Unknown"] or Enum.KeyCode.Unknown
                    if target then
                        if target.SetValue then
                            target:SetValue(key)
                        elseif target.Set then
                            target:Set(key)
                        end
                        count = count + 1
                    else
                        self.Library.Flags[idx] = key
                    end
                elseif elemType == "Input" then
                    local target = self.Library.Options[idx] or self.Library.Registry[idx]
                    if target then
                        if target.SetValue then
                            target:SetValue(obj.text or "")
                        elseif target.Set then
                            target:Set(obj.text or "")
                        end
                        count = count + 1
                    else
                        self.Library.Flags[idx] = obj.text or ""
                    end
                end
            end
        else
            -- Direct key-value legacy config format support
            for flag, val in pairs(decoded) do
                local target = self.Library.Toggles[flag] or self.Library.Options[flag] or self.Library.Registry[flag]
                if target then
                    if target.SetValue then
                        target:SetValue(val)
                    elseif target.Set then
                        target:Set(val)
                    end
                    count = count + 1
                else
                    self.Library.Flags[flag] = val
                end
            end
        end

        self.SelectedConfig = name
        self.Library:Notify({
            Title = "Save Manager",
            Content = "Loaded config: '" .. name .. "' (" .. count .. " items applied)",
            Duration = 3
        })
        return true
    end

    function SaveManager:Delete(name)
        if not name or name == "" then
            name = self.SelectedConfig
        end
        if not name or name == "" then
            self.Library:Notify({
                Title = "Save Manager",
                Content = "No config selected to delete.",
                Duration = 3
            })
            return false
        end

        self:EnsureFolder()
        local path = self.Folder .. "/" .. name .. ".json"
        if isfile and isfile(path) and delfile then
            local success, err = pcall(delfile, path)
            if success then
                self.Library:Notify({
                    Title = "Save Manager",
                    Content = "Deleted config: '" .. name .. "'",
                    Duration = 3
                })
                return true
            else
                self.Library:Notify({
                    Title = "Save Manager",
                    Content = "Failed to delete: " .. tostring(err),
                    Duration = 3
                })
            end
        end
        return false
    end

    function SaveManager:BuildConfigSection(target)
        local section = target
        if target.AddLeftGroupbox then
            section = target:AddLeftGroupbox("Configuration")
        elseif target.CreateSection then
            section = target:CreateSection("Configuration", "Left")
        end

        local configs = self:GetConfigs()
        self.SelectedConfig = configs[1] or ""

        local ConfigNameInput = section:AddInput("SaveManager_CustomConfigName", {
            Text = "Config Name",
            Placeholder = "Enter config name...",
            Default = self.SelectedConfig,
            Callback = function(text)
                self.SelectedConfig = text
            end
        })

        local ConfigList = section:AddListbox("SaveManager_ConfigList", {
            Text = "Config List",
            Items = configs,
            Default = self.SelectedConfig,
            Height = 120,
            Callback = function(selected)
                self.SelectedConfig = selected
                if ConfigNameInput and ConfigNameInput.Set then
                    ConfigNameInput:Set(selected, true)
                end
            end
        })

        local AutoloadStatusLabel = section:AddLabel("Autoload: " .. (self:GetAutoloadName() or "None"))

        local function refreshAutoload()
            local auto = self:GetAutoloadName()
            if AutoloadStatusLabel and AutoloadStatusLabel.SetText then
                AutoloadStatusLabel:SetText("Autoload: " .. (auto or "None"))
            end
        end

        section:AddButton({
            Text = "Create / Save Config",
            Func = function()
                local name = (ConfigNameInput and ConfigNameInput.Value and #ConfigNameInput.Value > 0) and ConfigNameInput.Value or self.SelectedConfig
                if name and #name > 0 then
                    self:Save(name)
                    local updatedList = self:GetConfigs()
                    if ConfigList and ConfigList.Refresh then
                        ConfigList:Refresh(updatedList)
                        ConfigList:Set(name, true)
                    end
                else
                    self.Library:Notify({
                        Title = "Save Manager",
                        Content = "Please enter a valid config name.",
                        Duration = 3
                    })
                end
            end
        })

        section:AddButton({
            Text = "Load Selected Config",
            Func = function()
                local name = (ConfigList and ConfigList.Value and #ConfigList.Value > 0) and ConfigList.Value or self.SelectedConfig or (ConfigNameInput and ConfigNameInput.Value)
                if name and #name > 0 then
                    self:Load(name)
                else
                    self.Library:Notify({
                        Title = "Save Manager",
                        Content = "Please select a config to load.",
                        Duration = 3
                    })
                end
            end
        })

        section:AddButton({
            Text = "Overwrite Config",
            Func = function()
                local name = (ConfigList and ConfigList.Value and #ConfigList.Value > 0) and ConfigList.Value or self.SelectedConfig or (ConfigNameInput and ConfigNameInput.Value)
                if name and #name > 0 then
                    self:Save(name)
                else
                    self.Library:Notify({
                        Title = "Save Manager",
                        Content = "Please select a config to overwrite.",
                        Duration = 3
                    })
                end
            end
        })

        section:AddButton({
            Text = "Delete Config",
            Func = function()
                local name = (ConfigList and ConfigList.Value and #ConfigList.Value > 0) and ConfigList.Value or self.SelectedConfig or (ConfigNameInput and ConfigNameInput.Value)
                if name and #name > 0 then
                    self:Delete(name)
                    local updatedList = self:GetConfigs()
                    self.SelectedConfig = updatedList[1] or ""
                    if ConfigList and ConfigList.Refresh then
                        ConfigList:Refresh(updatedList)
                        if #updatedList > 0 then
                            ConfigList:Set(updatedList[1], true)
                        end
                    end
                    if ConfigNameInput and ConfigNameInput.Set then
                        ConfigNameInput:Set(self.SelectedConfig, true)
                    end
                    refreshAutoload()
                end
            end
        })

        section:AddButton({
            Text = "Set as Autoload",
            Func = function()
                local name = (ConfigList and ConfigList.Value and #ConfigList.Value > 0) and ConfigList.Value or self.SelectedConfig or (ConfigNameInput and ConfigNameInput.Value)
                if name and #name > 0 then
                    self:SetAutoload(name)
                    refreshAutoload()
                else
                    self.Library:Notify({
                        Title = "Save Manager",
                        Content = "Please select or enter a config name first.",
                        Duration = 3
                    })
                end
            end
        })

        section:AddButton({
            Text = "Clear Autoload",
            Func = function()
                self:ClearAutoload()
                refreshAutoload()
            end
        })

        section:AddButton({
            Text = "Refresh List",
            Func = function()
                local updatedList = self:GetConfigs()
                if ConfigList and ConfigList.Refresh then
                    ConfigList:Refresh(updatedList)
                end
                refreshAutoload()
                self.Library:Notify({
                    Title = "Save Manager",
                    Content = "Refreshed: " .. #updatedList .. " config(s) found.",
                    Duration = 2
                })
            end
        })

        return section
    end

    function WindowObj:CreateConfigManager(targetSection, folderName)
        if folderName then
            SaveManager:SetFolder(folderName)
        end
        return SaveManager:BuildConfigSection(targetSection)
    end

    Library.SaveManager = SaveManager
    Library.ThemeManager = {
        Library = Library,
        Folder = "NamelessWare",
        SetLibrary = function(self, lib) self.Library = lib or Library end,
        SetFolder = function(self, folder) self.Folder = folder or "NamelessWare" end,
        ApplyToGroupbox = function(self, section)
            if WindowObj and WindowObj.CreateThemeManager then
                WindowObj:CreateThemeManager(section)
            end
        end,
        ApplyToTab = function(self, tab)
            local sec = (tab.AddLeftGroupbox and tab:AddLeftGroupbox("Theme")) or (tab.CreateSection and tab:CreateSection("Theme", "Left")) or tab
            if WindowObj and WindowObj.CreateThemeManager then
                WindowObj:CreateThemeManager(sec)
            end
        end
    }

    function Library:Unload()
        if ScreenGui then
            ScreenGui:Destroy()
        end
        for _, conn in ipairs(Library.Signals or {}) do
            pcall(function() conn:Disconnect() end)
        end
        table.clear(Library.Registry or {})
        table.clear(Library.Toggles or {})
        table.clear(Library.Options or {})
        table.clear(Library.Flags or {})
        table.clear(Library.Buttons or {})
    end

    -- Toggle Menu Keybind Listener
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local targetKey = Library.ToggleKeybind
            if type(targetKey) == "table" and targetKey.Value then
                targetKey = targetKey.Value
            end
            if typeof(targetKey) == "EnumItem" and input.KeyCode == targetKey and targetKey ~= Enum.KeyCode.Unknown then
                if WindowObj and WindowObj.Toggle then
                    WindowObj:Toggle()
                end
            end
        end
    end)

    local genv = (getgenv and getgenv()) or shared or _G
    if genv then
        genv.Library = Library
        genv.Toggles = Library.Toggles
        genv.Options = Library.Options
        genv.SaveManager = Library.SaveManager
        genv.ThemeManager = Library.ThemeManager
    end

    return WindowObj
end

local genv = (getgenv and getgenv()) or shared or _G
if genv then
    genv.Library = Library
    genv.Toggles = Library.Toggles
    genv.Options = Library.Options
    genv.SaveManager = Library.SaveManager
    genv.ThemeManager = Library.ThemeManager
end

return Library
