local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

local function SafeParentGui(gui)
    local parented = false
    if gethui then
        local s = pcall(function() gui.Parent = gethui(); parented = true end)
        if s and parented then return end
    end
    if syn and syn.protect_gui then
        pcall(function() syn.protect_gui(gui) end)
    end
    local s = pcall(function() gui.Parent = CoreGui; parented = true end)
    if s and parented then return end
    pcall(function()
        local playerGui = LocalPlayer and (LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3))
        if playerGui then
            gui.Parent = playerGui
        end
    end)
end

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

local ActiveDragSession = nil

local function Tween(obj, props, time, style, dir)
    time = time or 0.18
    style = style or Enum.EasingStyle.Quad
    dir = dir or Enum.EasingDirection.Out
    local tw = TweenService:Create(obj, TweenInfo.new(time, style, dir), props)
    tw:Play()
    return tw
end

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

local function EnsureFolder(folderPath)
    if makefolder and isfolder then
        local parts = string.split(folderPath, "/")
        local current = ""
        for i, part in ipairs(parts) do
            if part ~= "" then
                current = (current == "") and part or (current .. "/" .. part)
                if not isfolder(current) then
                    pcall(function() makefolder(current) end)
                end
            end
        end
    end
end

local THEME_PRESETS = {
    ["Nameless Violet"] = {
        Accent = Color3.fromRGB(165, 95, 255),
        AccentGradient = Color3.fromRGB(195, 135, 255),
        AccentDark = Color3.fromRGB(120, 50, 220),
        BgMain = Color3.fromRGB(15, 15, 22),
        BgMainGradient = Color3.fromRGB(19, 19, 28),
        BgSidebar = Color3.fromRGB(12, 12, 17),
        CardBg = Color3.fromRGB(20, 20, 29),
        CardBgGradient = Color3.fromRGB(24, 24, 35),
        CardBorder = Color3.fromRGB(36, 36, 52),
        TextMain = Color3.fromRGB(245, 245, 252),
        TextMuted = Color3.fromRGB(130, 130, 155),
        CircleOff = Color3.fromRGB(26, 26, 36),
        CircleOffBorder = Color3.fromRGB(45, 45, 62),
    },
    ["Flow Indigo"] = {
        Accent = Color3.fromRGB(130, 90, 255),
        AccentGradient = Color3.fromRGB(160, 120, 255),
        AccentDark = Color3.fromRGB(90, 50, 200),
        BgMain = Color3.fromRGB(13, 13, 20),
        BgMainGradient = Color3.fromRGB(17, 17, 26),
        BgSidebar = Color3.fromRGB(10, 10, 15),
        CardBg = Color3.fromRGB(18, 18, 27),
        CardBgGradient = Color3.fromRGB(22, 22, 33),
        CardBorder = Color3.fromRGB(34, 34, 48),
        TextMain = Color3.fromRGB(240, 240, 255),
        TextMuted = Color3.fromRGB(125, 125, 150),
        CircleOff = Color3.fromRGB(24, 24, 34),
        CircleOffBorder = Color3.fromRGB(42, 42, 58),
    },
    ["Passion Pink"] = {
        Accent = Color3.fromRGB(255, 65, 150),
        AccentGradient = Color3.fromRGB(255, 115, 185),
        AccentDark = Color3.fromRGB(200, 30, 105),
        BgMain = Color3.fromRGB(20, 14, 18),
        BgMainGradient = Color3.fromRGB(26, 17, 23),
        BgSidebar = Color3.fromRGB(15, 10, 13),
        CardBg = Color3.fromRGB(26, 18, 24),
        CardBgGradient = Color3.fromRGB(32, 22, 29),
        CardBorder = Color3.fromRGB(55, 30, 48),
        TextMain = Color3.fromRGB(255, 245, 250),
        TextMuted = Color3.fromRGB(165, 125, 145),
        CircleOff = Color3.fromRGB(32, 20, 28),
        CircleOffBorder = Color3.fromRGB(58, 35, 50),
    },
    ["Nebula Cyan"] = {
        Accent = Color3.fromRGB(0, 225, 255),
        AccentGradient = Color3.fromRGB(80, 240, 255),
        AccentDark = Color3.fromRGB(0, 160, 210),
        BgMain = Color3.fromRGB(10, 18, 24),
        BgMainGradient = Color3.fromRGB(13, 24, 32),
        BgSidebar = Color3.fromRGB(8, 14, 18),
        CardBg = Color3.fromRGB(14, 25, 34),
        CardBgGradient = Color3.fromRGB(18, 31, 42),
        CardBorder = Color3.fromRGB(25, 52, 68),
        TextMain = Color3.fromRGB(240, 252, 255),
        TextMuted = Color3.fromRGB(115, 150, 165),
        CircleOff = Color3.fromRGB(18, 28, 36),
        CircleOffBorder = Color3.fromRGB(32, 54, 68),
    },
    ["Crimson Obsidian"] = {
        Accent = Color3.fromRGB(255, 45, 75),
        AccentGradient = Color3.fromRGB(255, 95, 120),
        AccentDark = Color3.fromRGB(190, 20, 45),
        BgMain = Color3.fromRGB(20, 12, 14),
        BgMainGradient = Color3.fromRGB(26, 15, 18),
        BgSidebar = Color3.fromRGB(14, 8, 10),
        CardBg = Color3.fromRGB(27, 16, 19),
        CardBgGradient = Color3.fromRGB(33, 19, 23),
        CardBorder = Color3.fromRGB(58, 28, 34),
        TextMain = Color3.fromRGB(255, 242, 244),
        TextMuted = Color3.fromRGB(165, 120, 128),
        CircleOff = Color3.fromRGB(34, 18, 22),
        CircleOffBorder = Color3.fromRGB(60, 32, 38),
    },
    ["Emerald Viper"] = {
        Accent = Color3.fromRGB(0, 230, 135),
        AccentGradient = Color3.fromRGB(70, 245, 175),
        AccentDark = Color3.fromRGB(0, 170, 95),
        BgMain = Color3.fromRGB(10, 20, 16),
        BgMainGradient = Color3.fromRGB(13, 26, 21),
        BgSidebar = Color3.fromRGB(8, 15, 12),
        CardBg = Color3.fromRGB(14, 27, 22),
        CardBgGradient = Color3.fromRGB(18, 34, 28),
        CardBorder = Color3.fromRGB(25, 56, 42),
        TextMain = Color3.fromRGB(240, 255, 248),
        TextMuted = Color3.fromRGB(115, 165, 140),
        CircleOff = Color3.fromRGB(16, 30, 24),
        CircleOffBorder = Color3.fromRGB(30, 58, 46),
    },
    ["Amber Gold"] = {
        Accent = Color3.fromRGB(255, 180, 35),
        AccentGradient = Color3.fromRGB(255, 205, 85),
        AccentDark = Color3.fromRGB(200, 130, 10),
        BgMain = Color3.fromRGB(20, 17, 12),
        BgMainGradient = Color3.fromRGB(26, 22, 15),
        BgSidebar = Color3.fromRGB(15, 12, 8),
        CardBg = Color3.fromRGB(27, 23, 16),
        CardBgGradient = Color3.fromRGB(33, 28, 20),
        CardBorder = Color3.fromRGB(58, 48, 28),
        TextMain = Color3.fromRGB(255, 250, 240),
        TextMuted = Color3.fromRGB(165, 150, 120),
        CircleOff = Color3.fromRGB(32, 26, 18),
        CircleOffBorder = Color3.fromRGB(58, 46, 30),
    },
    ["Monochrome Slate"] = {
        Accent = Color3.fromRGB(210, 210, 225),
        AccentGradient = Color3.fromRGB(240, 240, 255),
        AccentDark = Color3.fromRGB(160, 160, 180),
        BgMain = Color3.fromRGB(16, 16, 18),
        BgMainGradient = Color3.fromRGB(21, 21, 24),
        BgSidebar = Color3.fromRGB(12, 12, 14),
        CardBg = Color3.fromRGB(22, 22, 25),
        CardBgGradient = Color3.fromRGB(27, 27, 31),
        CardBorder = Color3.fromRGB(42, 42, 50),
        TextMain = Color3.fromRGB(250, 250, 255),
        TextMuted = Color3.fromRGB(135, 135, 145),
        CircleOff = Color3.fromRGB(26, 26, 30),
        CircleOffBorder = Color3.fromRGB(46, 46, 54),
    }
}

local THEME = {}
for k, v in pairs(THEME_PRESETS["Nameless Violet"]) do
    THEME[k] = v
end
THEME.FontMain = Enum.Font.GothamMedium
THEME.FontBold = Enum.Font.GothamBold

local RAW_LOGO_URL = "https://raw.githubusercontent.com/ApparentlyZen/image-namelessWare/main/165abdd521328d77324b02ce8a77e090_1780162334922.webp"

local isMobileDevice = UserInputService.TouchEnabled and not (UserInputService.KeyboardEnabled and UserInputService.MouseEnabled)

local NamelessWare = {
    Flags = {},
    ThemeSubscribers = {},
    KeybindRegistry = {},
    KeybindElements = {},
    CardElements = {},
    Transparency = 0,
    CardTransparency = 0,
    ShowKeybinds = not isMobileDevice,
    ShowKeybindsHud = false,
    KeybindHUD = nil,
    CurrentTheme = "Nameless Violet",
    ToggleKey = Enum.KeyCode.RightShift,
    ActiveWindow = nil,
    Notifications = nil,
}
NamelessWare.__index = NamelessWare

function NamelessWare:RegisterKeybind(info)
    if not info or not info.Name then return end
    for i, item in ipairs(self.KeybindRegistry) do
        if item.Name == info.Name and item.Tab == info.Tab then
            self.KeybindRegistry[i] = info
            self:UpdateKeybindsHud()
            return
        end
    end
    table.insert(self.KeybindRegistry, info)
    self:UpdateKeybindsHud()
end

function NamelessWare:SetKeybindsVisibility(visible)
    self.ShowKeybinds = visible
    local isPC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
    for _, el in ipairs(self.KeybindElements) do
        pcall(function()
            if typeof(el) == "function" then
                el(visible)
            elseif el and el.IsA and el:IsA("GuiObject") then
                el.Visible = visible and isPC
            end
        end)
    end
end

function NamelessWare:UpdateKeybindsHud()
    if not self.KeybindHUD or not self.KeybindHUD.Parent then return end
    local container = self.KeybindHUD:FindFirstChild("ListContainer")
    if not container then return end

    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local count = 0
    for _, kb in ipairs(self.KeybindRegistry) do
        if kb.Key and kb.Key ~= "-" and kb.Key ~= "None" then
            count = count + 1
            local isActive = (kb.GetState and kb.GetState() == true)
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 18)
            Row.BackgroundTransparency = 1
            Row.Parent = container

            local FeatLabel = Instance.new("TextLabel")
            FeatLabel.Size = UDim2.new(1, -60, 1, 0)
            FeatLabel.Position = UDim2.new(0, 0, 0, 0)
            FeatLabel.BackgroundTransparency = 1
            FeatLabel.Text = "[" .. (kb.Tab or "General") .. "] " .. (kb.Name or "Feature")
            FeatLabel.Font = THEME.FontMain
            FeatLabel.TextSize = 9
            FeatLabel.TextColor3 = isActive and THEME.TextMain or THEME.TextMuted
            FeatLabel.TextXAlignment = Enum.TextXAlignment.Left
            FeatLabel.TextTruncate = Enum.TextTruncate.AtEnd
            FeatLabel.Parent = Row

            local StatusLabel = Instance.new("TextLabel")
            StatusLabel.Size = UDim2.new(0, 55, 1, 0)
            StatusLabel.Position = UDim2.new(1, -55, 0, 0)
            StatusLabel.BackgroundTransparency = 1
            StatusLabel.Text = "[" .. tostring(kb.Key) .. "] " .. (isActive and "ON" or "OFF")
            StatusLabel.Font = THEME.FontBold
            StatusLabel.TextSize = 8
            StatusLabel.TextColor3 = isActive and THEME.Accent or Color3.fromRGB(110, 110, 130)
            StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
            StatusLabel.Parent = Row
        end
    end

    if count == 0 then
        local Empty = Instance.new("TextLabel")
        Empty.Size = UDim2.new(1, 0, 0, 18)
        Empty.BackgroundTransparency = 1
        Empty.Text = "No active keybinds"
        Empty.Font = THEME.FontMain
        Empty.TextSize = 9
        Empty.TextColor3 = THEME.TextMuted
        Empty.Parent = container
    end
end

function NamelessWare:SetKeybindsHud(visible)
    self.ShowKeybindsHud = visible
    if not self.ActiveWindow or not self.ActiveWindow.ScreenGui then return end
    local screenGui = self.ActiveWindow.ScreenGui

    if visible then
        if not self.KeybindHUD then
            local HUD = Instance.new("Frame")
            HUD.Name = "NamelessKeybindsHUD"
            HUD.Size = UDim2.new(0, 190, 0, 0)
            HUD.AutomaticSize = Enum.AutomaticSize.Y
            HUD.Position = UDim2.new(0, 20, 0.45, 0)
            HUD.BackgroundColor3 = THEME.CardBg
            HUD.BorderSizePixel = 0
            HUD.ZIndex = 400
            HUD.Parent = screenGui
            self.KeybindHUD = HUD

            local HUDCorner = Instance.new("UICorner")
            HUDCorner.CornerRadius = UDim.new(0, 8)
            HUDCorner.Parent = HUD

            local HUDStroke = Instance.new("UIStroke")
            HUDStroke.Color = THEME.CardBorder
            HUDStroke.Thickness = 1
            HUDStroke.Parent = HUD

            local HUDPadding = Instance.new("UIPadding")
            HUDPadding.PaddingTop = UDim.new(0, 8)
            HUDPadding.PaddingBottom = UDim.new(0, 10)
            HUDPadding.PaddingLeft = UDim.new(0, 10)
            HUDPadding.PaddingRight = UDim.new(0, 10)
            HUDPadding.Parent = HUD

            local TitleRow = Instance.new("Frame")
            TitleRow.Size = UDim2.new(1, 0, 0, 18)
            TitleRow.BackgroundTransparency = 1
            TitleRow.Parent = HUD

            local Title = Instance.new("TextLabel")
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.BackgroundTransparency = 1
            Title.Text = "Keybinds"
            Title.Font = THEME.FontBold
            Title.TextSize = 11
            Title.TextColor3 = THEME.Accent
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Parent = TitleRow

            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, 0, 0, 1)
            Line.Position = UDim2.new(0, 0, 0, 22)
            Line.BackgroundColor3 = THEME.CardBorder
            Line.BorderSizePixel = 0
            Line.Parent = HUD

            local ListContainer = Instance.new("Frame")
            ListContainer.Name = "ListContainer"
            ListContainer.Size = UDim2.new(1, 0, 0, 0)
            ListContainer.Position = UDim2.new(0, 0, 0, 26)
            ListContainer.AutomaticSize = Enum.AutomaticSize.Y
            ListContainer.BackgroundTransparency = 1
            ListContainer.Parent = HUD

            local ListLay = Instance.new("UIListLayout")
            ListLay.Padding = UDim.new(0, 4)
            ListLay.SortOrder = Enum.SortOrder.LayoutOrder
            ListLay.Parent = ListContainer

            MakeDraggable(HUD, TitleRow)

            table.insert(self.ThemeSubscribers, function(theme)
                HUD.BackgroundColor3 = theme.CardBg
                HUDStroke.Color = theme.CardBorder
                Title.TextColor3 = theme.Accent
                Line.BackgroundColor3 = theme.CardBorder
            end)
        end
        self.KeybindHUD.Visible = true
        self:UpdateKeybindsHud()
    else
        if self.KeybindHUD then
            self.KeybindHUD.Visible = false
        end
    end
end

function NamelessWare:SetTransparency(alpha)
    self.Transparency = math.clamp(alpha or 0, 0, 0.95)
    if self.ActiveWindow then
        if self.ActiveWindow.MainWindow then
            self.ActiveWindow.MainWindow.BackgroundTransparency = self.Transparency
        end
        if self.ActiveWindow.Sidebar then
            self.ActiveWindow.Sidebar.BackgroundTransparency = math.clamp(self.Transparency * 0.9, 0, 0.95)
        end
        if self.ActiveWindow.UserCard then
            self.ActiveWindow.UserCard.BackgroundTransparency = math.clamp(self.Transparency * 0.8, 0, 0.95)
        end
        if self.ActiveWindow.SearchContainer then
            self.ActiveWindow.SearchContainer.BackgroundTransparency = math.clamp(self.Transparency * 0.8, 0, 0.95)
        end
        if self.ActiveWindow.DeviceBadge then
            self.ActiveWindow.DeviceBadge.BackgroundTransparency = math.clamp(self.Transparency * 0.8, 0, 0.95)
        end
    end
end

function NamelessWare:SetCardTransparency(alpha)
    self.CardTransparency = math.clamp(alpha or 0, 0, 0.95)
    for _, card in ipairs(self.CardElements) do
        pcall(function()
            if card and card.IsA and card:IsA("GuiObject") then
                card.BackgroundTransparency = self.CardTransparency
            end
        end)
    end
end

-- =========================================================
-- THEME MANAGER
-- =========================================================
local ThemeManager = {
    Library = NamelessWare,
    Folder = "NamelessWare/Themes",
    CurrentCustom = { R = 165, G = 95, B = 255 },
    Presets = THEME_PRESETS
}

function ThemeManager:SetLibrary(library)
    self.Library = library or NamelessWare
end

function ThemeManager:SetFolder(folderPath)
    self.Folder = folderPath
    EnsureFolder(folderPath)
end

function ThemeManager:GetPresets()
    local names = {}
    for name, _ in pairs(THEME_PRESETS) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function ThemeManager:ApplyTheme(themeNameOrData, silent)
    local themeData
    local themeTitle = "Custom Theme"

    if type(themeNameOrData) == "string" then
        if THEME_PRESETS[themeNameOrData] then
            themeData = THEME_PRESETS[themeNameOrData]
            themeTitle = themeNameOrData
            NamelessWare.CurrentTheme = themeNameOrData
        else
            themeData = self:LoadCustomThemeData(themeNameOrData)
            if themeData then
                themeTitle = themeNameOrData
                NamelessWare.CurrentTheme = themeNameOrData
            end
        end
    elseif type(themeNameOrData) == "table" then
        themeData = themeNameOrData
        if themeData.Name then
            themeTitle = themeData.Name
            NamelessWare.CurrentTheme = themeData.Name
        end
    end

    if not themeData then return false end

    for k, v in pairs(themeData) do
        THEME[k] = v
    end

    for _, sub in ipairs(NamelessWare.ThemeSubscribers) do
        pcall(function() sub(themeData) end)
    end

    if not silent and NamelessWare.ActiveWindow then
        NamelessWare:Notify({
            Title = "Theme Applied",
            Content = "Switched to theme: " .. themeTitle,
            Duration = 2,
            Type = "Success"
        })
    end
    return true
end

function ThemeManager:SetColor(key, color3)
    if not color3 or typeof(color3) ~= "Color3" then return end
    if THEME[key] == color3 then return end
    THEME[key] = color3
    for _, sub in ipairs(NamelessWare.ThemeSubscribers) do
        pcall(function() sub(THEME) end)
    end
end

function ThemeManager:GetCustomThemes()
    local list = {}
    EnsureFolder(self.Folder)

    if listfiles and isfolder and isfolder(self.Folder) then
        local success, files = pcall(function() return listfiles(self.Folder) end)
        if success and type(files) == "table" then
            for _, f in ipairs(files) do
                local name = f:match("([^/\\]+)%.json$")
                if name then
                    table.insert(list, name)
                end
            end
        end
    end
    table.sort(list)
    return list
end

function ThemeManager:SaveCustomTheme(name)
    if not name or name == "" then return false end
    EnsureFolder(self.Folder)

    local payload = {
        Name = name,
        Colors = {
            Accent = { R = math.floor(THEME.Accent.R * 255), G = math.floor(THEME.Accent.G * 255), B = math.floor(THEME.Accent.B * 255) },
            AccentGradient = { R = math.floor(THEME.AccentGradient.R * 255), G = math.floor(THEME.AccentGradient.G * 255), B = math.floor(THEME.AccentGradient.B * 255) },
            BgMain = { R = math.floor(THEME.BgMain.R * 255), G = math.floor(THEME.BgMain.G * 255), B = math.floor(THEME.BgMain.B * 255) },
            BgMainGradient = { R = math.floor(THEME.BgMainGradient.R * 255), G = math.floor(THEME.BgMainGradient.G * 255), B = math.floor(THEME.BgMainGradient.B * 255) },
            BgSidebar = { R = math.floor(THEME.BgSidebar.R * 255), G = math.floor(THEME.BgSidebar.G * 255), B = math.floor(THEME.BgSidebar.B * 255) },
            CardBg = { R = math.floor(THEME.CardBg.R * 255), G = math.floor(THEME.CardBg.G * 255), B = math.floor(THEME.CardBg.B * 255) },
            CardBorder = { R = math.floor(THEME.CardBorder.R * 255), G = math.floor(THEME.CardBorder.G * 255), B = math.floor(THEME.CardBorder.B * 255) },
            TextMain = { R = math.floor(THEME.TextMain.R * 255), G = math.floor(THEME.TextMain.G * 255), B = math.floor(THEME.TextMain.B * 255) },
            TextMuted = { R = math.floor(THEME.TextMuted.R * 255), G = math.floor(THEME.TextMuted.G * 255), B = math.floor(THEME.TextMuted.B * 255) },
        }
    }

    local path = self.Folder .. "/" .. name .. ".json"
    local jsonStr = HttpService:JSONEncode(payload)

    if writefile then
        local success = pcall(function() writefile(path, jsonStr) end)
        if success then
            NamelessWare:Notify({
                Title = "Theme Saved",
                Content = "Custom palette '" .. name .. "' was saved.",
                Duration = 2.5,
                Type = "Success"
            })
            return true
        end
    end
    return false
end

function ThemeManager:LoadCustomThemeData(name)
    local path = self.Folder .. "/" .. name .. ".json"
    if isfile and isfile(path) and readfile then
        local success, content = pcall(function() return readfile(path) end)
        if success and content then
            local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
            if decodeSuccess and type(data) == "table" then
                if data.Colors then
                    local themeData = { Name = name }
                    for colKey, rgb in pairs(data.Colors) do
                        themeData[colKey] = Color3.fromRGB(rgb.R or 255, rgb.G or 255, rgb.B or 255)
                    end
                    return themeData
                elseif data.R and data.G and data.B then
                    return self:SetCustomAccent(data.R, data.G, data.B, false)
                end
            end
        end
    end
    return nil
end

function ThemeManager:DeleteCustomTheme(name)
    local path = self.Folder .. "/" .. name .. ".json"
    if isfile and isfile(path) and delfile then
        local success = pcall(function() delfile(path) end)
        if success then
            NamelessWare:Notify({
                Title = "Theme Deleted",
                Content = "Custom theme '" .. name .. "' was removed.",
                Duration = 2.5,
                Type = "Info"
            })
            return true
        end
    end
    return false
end

function ThemeManager:BuildThemeSection(Section)
    Section:AddSubHeader("Theme Presets", "rbxassetid://10709791437")

    local presets = self:GetPresets()
    local selectedPreset = presets[1] or "Nameless Violet"

    local PresetDropdown = Section:AddDropdown({
        Name = "Preset",
        Options = presets,
        Default = NamelessWare.CurrentTheme or selectedPreset,
        Callback = function(choice)
            selectedPreset = choice
            self:ApplyTheme(choice)
        end
    })

    Section:AddSubHeader("Color Palette Customizer", "rbxassetid://10734975692")

    local AccentPicker = Section:AddColorPicker({
        Name = "Accent Color",
        Default = THEME.Accent,
        Callback = function(col)
            self:SetColor("Accent", col)
            self:SetColor("AccentDark", Color3.fromRGB(math.clamp(math.floor(col.R * 255) - 40, 0, 255), math.clamp(math.floor(col.G * 255) - 40, 0, 255), math.clamp(math.floor(col.B * 255) - 40, 0, 255)))
        end
    })

    local AccentGradPicker = Section:AddColorPicker({
        Name = "Accent Highlight",
        Default = THEME.AccentGradient,
        Callback = function(col)
            self:SetColor("AccentGradient", col)
        end
    })

    local BgMainPicker = Section:AddColorPicker({
        Name = "Window Background",
        Default = THEME.BgMain,
        Callback = function(col)
            self:SetColor("BgMain", col)
            self:SetColor("BgMainGradient", Color3.fromRGB(math.clamp(math.floor(col.R * 255) + 4, 0, 255), math.clamp(math.floor(col.G * 255) + 4, 0, 255), math.clamp(math.floor(col.B * 255) + 6, 0, 255)))
        end
    })

    local BgSidebarPicker = Section:AddColorPicker({
        Name = "Sidebar Background",
        Default = THEME.BgSidebar,
        Callback = function(col)
            self:SetColor("BgSidebar", col)
        end
    })

    local CardBgPicker = Section:AddColorPicker({
        Name = "Card Background",
        Default = THEME.CardBg,
        Callback = function(col)
            self:SetColor("CardBg", col)
            self:SetColor("CardBgGradient", Color3.fromRGB(math.clamp(math.floor(col.R * 255) + 4, 0, 255), math.clamp(math.floor(col.G * 255) + 4, 0, 255), math.clamp(math.floor(col.B * 255) + 6, 0, 255)))
        end
    })

    local BorderPicker = Section:AddColorPicker({
        Name = "Borders & Outlines",
        Default = THEME.CardBorder,
        Callback = function(col)
            self:SetColor("CardBorder", col)
        end
    })

    local TextMainPicker = Section:AddColorPicker({
        Name = "Primary Text",
        Default = THEME.TextMain,
        Callback = function(col)
            self:SetColor("TextMain", col)
        end
    })

    local TextMutedPicker = Section:AddColorPicker({
        Name = "Muted Text",
        Default = THEME.TextMuted,
        Callback = function(col)
            self:SetColor("TextMuted", col)
        end
    })

    table.insert(NamelessWare.ThemeSubscribers, function(theme)
        if AccentPicker and AccentPicker.Set then AccentPicker.Set(theme.Accent) end
        if AccentGradPicker and AccentGradPicker.Set then AccentGradPicker.Set(theme.AccentGradient) end
        if BgMainPicker and BgMainPicker.Set then BgMainPicker.Set(theme.BgMain) end
        if BgSidebarPicker and BgSidebarPicker.Set then BgSidebarPicker.Set(theme.BgSidebar) end
        if CardBgPicker and CardBgPicker.Set then CardBgPicker.Set(theme.CardBg) end
        if BorderPicker and BorderPicker.Set then BorderPicker.Set(theme.CardBorder) end
        if TextMainPicker and TextMainPicker.Set then TextMainPicker.Set(theme.TextMain) end
        if TextMutedPicker and TextMutedPicker.Set then TextMutedPicker.Set(theme.TextMuted) end
    end)

    Section:AddSubHeader("Transparency & Opacity", "rbxassetid://10734950309")

    Section:AddSlider({
        Name = "Menu Transparency",
        Min = 0,
        Max = 85,
        Default = math.floor((NamelessWare.Transparency or 0) * 100),
        Suffix = "%",
        Callback = function(val)
            NamelessWare:SetTransparency(val / 100)
        end
    })

    Section:AddSlider({
        Name = "Cards Transparency",
        Min = 0,
        Max = 80,
        Default = math.floor((NamelessWare.CardTransparency or 0) * 100),
        Suffix = "%",
        Callback = function(val)
            NamelessWare:SetCardTransparency(val / 100)
        end
    })

    Section:AddSubHeader("Theme Profiles", "rbxassetid://10709791437")

    local customThemeName = "MyTheme"
    Section:AddTextBox({
        Name = "Theme Name",
        Placeholder = "Custom theme name...",
        Default = customThemeName,
        Callback = function(txt)
            customThemeName = txt
        end
    })

    local CustomThemeDropdown

    Section:AddButton({
        Name = "Save Custom Theme",
        Callback = function()
            if customThemeName and customThemeName ~= "" then
                self:SaveCustomTheme(customThemeName)
                if CustomThemeDropdown and CustomThemeDropdown.Refresh then
                    local updated = self:GetCustomThemes()
                    CustomThemeDropdown.Refresh((#updated > 0) and updated or {"None"})
                end
            end
        end
    })

    local selectedCustom = self:GetCustomThemes()[1] or "None"
    CustomThemeDropdown = Section:AddDropdown({
        Name = "Saved Themes",
        Options = (#self:GetCustomThemes() > 0) and self:GetCustomThemes() or {"None"},
        Default = selectedCustom,
        Callback = function(v)
            selectedCustom = v
        end
    })

    Section:AddButton({
        Name = "Load Custom Theme",
        Callback = function()
            if selectedCustom and selectedCustom ~= "None" then
                self:ApplyTheme(selectedCustom)
            end
        end
    })

    Section:AddButton({
        Name = "Delete Custom Theme",
        Callback = function()
            if selectedCustom and selectedCustom ~= "None" then
                self:DeleteCustomTheme(selectedCustom)
                if CustomThemeDropdown and CustomThemeDropdown.Refresh then
                    local updated = self:GetCustomThemes()
                    CustomThemeDropdown.Refresh((#updated > 0) and updated or {"None"})
                end
            end
        end
    })
end

-- =========================================================
-- SAVE / CONFIG MANAGER
-- =========================================================
local SaveManager = {
    Library = NamelessWare,
    Folder = "NamelessWare/Configs",
    AutoLoadPath = "NamelessWare/Configs/autoload.txt",
    InMemoryConfigs = {}
}

function SaveManager:SetLibrary(library)
    self.Library = library or NamelessWare
end

function SaveManager:SetFolder(folderPath)
    self.Folder = folderPath
    self.AutoLoadPath = folderPath .. "/autoload.txt"
    EnsureFolder(folderPath)
end

function SaveManager:GetConfigs()
    local list = {}
    EnsureFolder(self.Folder)

    if listfiles and isfolder and isfolder(self.Folder) then
        local success, files = pcall(function() return listfiles(self.Folder) end)
        if success and type(files) == "table" then
            for _, f in ipairs(files) do
                local name = f:match("([^/\\]+)%.json$")
                if name then
                    table.insert(list, name)
                end
            end
        end
    else
        for name, _ in pairs(self.InMemoryConfigs) do
            table.insert(list, name)
        end
    end
    table.sort(list)
    return list
end

function SaveManager:Save(name)
    if not name or name == "" then return false end
    EnsureFolder(self.Folder)

    local data = {}
    for flag, ctrl in pairs(NamelessWare.Flags) do
        if ctrl and ctrl.Get then
            local val = ctrl.Get()
            if typeof(val) == "Color3" then
                data[flag] = { __type = "Color3", R = val.R, G = val.G, B = val.B }
            elseif typeof(val) == "EnumItem" then
                data[flag] = { __type = "EnumItem", EnumType = tostring(val.EnumType), Name = val.Name }
            else
                data[flag] = val
            end
        end
    end

    local jsonStr = HttpService:JSONEncode(data)
    local path = self.Folder .. "/" .. name .. ".json"

    if writefile then
        local success, err = pcall(function()
            writefile(path, jsonStr)
        end)
        if success then
            NamelessWare:Notify({
                Title = "Config Saved",
                Content = "Profile '" .. name .. "' saved successfully.",
                Duration = 2.5,
                Type = "Success"
            })
            return true
        end
    end

    self.InMemoryConfigs[name] = jsonStr
    NamelessWare:Notify({
        Title = "Config Saved (Memory)",
        Content = "Profile '" .. name .. "' saved in memory.",
        Duration = 2.5,
        Type = "Success"
    })
    return true
end

function SaveManager:Load(name)
    if not name or name == "" then return false end
    EnsureFolder(self.Folder)

    local path = self.Folder .. "/" .. name .. ".json"
    local rawJson = nil

    if isfile and isfile(path) and readfile then
        local success, content = pcall(function() return readfile(path) end)
        if success and content then
            rawJson = content
        end
    elseif self.InMemoryConfigs[name] then
        rawJson = self.InMemoryConfigs[name]
    end

    if not rawJson then
        NamelessWare:Notify({
            Title = "Config Not Found",
            Content = "Could not find profile '" .. name .. "'.",
            Duration = 2.5,
            Type = "Error"
        })
        return false
    end

    local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(rawJson) end)
    if not decodeSuccess or type(data) ~= "table" then
        return false
    end

    for flag, value in pairs(data) do
        local ctrl = NamelessWare.Flags[flag]
        if ctrl and ctrl.Set then
            if type(value) == "table" and value.__type then
                if value.__type == "Color3" then
                    ctrl.Set(Color3.new(value.R, value.G, value.B))
                elseif value.__type == "EnumItem" and value.EnumType == "KeyCode" then
                    if Enum.KeyCode[value.Name] then
                        ctrl.Set(Enum.KeyCode[value.Name])
                    end
                end
            else
                ctrl.Set(value)
            end
        end
    end

    NamelessWare:Notify({
        Title = "Config Loaded",
        Content = "Profile '" .. name .. "' loaded successfully.",
        Duration = 2.5,
        Type = "Success"
    })
    return true
end

function SaveManager:Delete(name)
    if not name or name == "" then return false end
    EnsureFolder(self.Folder)

    local path = self.Folder .. "/" .. name .. ".json"
    local removed = false

    if isfile and isfile(path) and delfile then
        local success = pcall(function() delfile(path) end)
        if success then removed = true end
    end

    if self.InMemoryConfigs[name] then
        self.InMemoryConfigs[name] = nil
        removed = true
    end

    if removed then
        NamelessWare:Notify({
            Title = "Config Deleted",
            Content = "Profile '" .. name .. "' was removed.",
            Duration = 2.5,
            Type = "Info"
        })
        return true
    end
    return false
end

function SaveManager:SetAutoLoad(name)
    EnsureFolder(self.Folder)
    if name and name ~= "" then
        if writefile then
            pcall(function() writefile(self.AutoLoadPath, name) end)
        end
        self.InMemoryConfigs["__autoload"] = name
        NamelessWare:Notify({
            Title = "Auto-Load Set",
            Content = "Default profile set to: " .. name,
            Duration = 2,
            Type = "Info"
        })
    else
        if isfile and isfile(self.AutoLoadPath) and delfile then
            pcall(function() delfile(self.AutoLoadPath) end)
        end
        self.InMemoryConfigs["__autoload"] = nil
    end
end

function SaveManager:GetAutoLoad()
    EnsureFolder(self.Folder)
    if isfile and isfile(self.AutoLoadPath) and readfile then
        local success, res = pcall(function() return readfile(self.AutoLoadPath) end)
        if success and res and res ~= "" then
            return res
        end
    end
    return self.InMemoryConfigs["__autoload"] or nil
end

function SaveManager:AutoLoad()
    local autoName = self:GetAutoLoad()
    if autoName and autoName ~= "" then
        task.spawn(function()
            task.wait(0.5)
            self:Load(autoName)
        end)
    end
end

function SaveManager:BuildConfigSection(Section)
    Section:AddSubHeader("Save / Load Profiles", "rbxassetid://10709791437")

    local configNameInput = "Default"
    Section:AddTextBox({
        Name = "Config Name",
        Placeholder = "Enter profile name...",
        Default = configNameInput,
        Callback = function(val)
            configNameInput = val
        end
    })

    local ConfigDropdown

    Section:AddButton({
        Name = "Create / Save Config",
        Callback = function()
            if configNameInput and configNameInput ~= "" then
                self:Save(configNameInput)
                if ConfigDropdown and ConfigDropdown.Refresh then
                    local updated = self:GetConfigs()
                    ConfigDropdown.Refresh((#updated > 0) and updated or {"None"})
                end
            end
        end
    })

    local selectedConfig = self:GetConfigs()[1] or "None"

    ConfigDropdown = Section:AddDropdown({
        Name = "Select Config",
        Options = (#self:GetConfigs() > 0) and self:GetConfigs() or {"None"},
        Default = selectedConfig,
        Callback = function(v)
            selectedConfig = v
        end
    })

    Section:AddButton({
        Name = "Load Selected Config",
        Callback = function()
            if selectedConfig and selectedConfig ~= "None" then
                self:Load(selectedConfig)
            end
        end
    })

    Section:AddButton({
        Name = "Delete Selected Config",
        Callback = function()
            if selectedConfig and selectedConfig ~= "None" then
                self:Delete(selectedConfig)
                if ConfigDropdown and ConfigDropdown.Refresh then
                    local updated = self:GetConfigs()
                    ConfigDropdown.Refresh((#updated > 0) and updated or {"None"})
                end
            end
        end
    })

    Section:AddButton({
        Name = "Refresh Config List",
        Callback = function()
            if ConfigDropdown and ConfigDropdown.Refresh then
                local updated = self:GetConfigs()
                ConfigDropdown.Refresh((#updated > 0) and updated or {"None"})
                NamelessWare:Notify({
                    Title = "Refreshed",
                    Content = "Configuration list updated.",
                    Duration = 1.8,
                    Type = "Info"
                })
            end
        end
    })

    local isAutoLoad = (self:GetAutoLoad() == selectedConfig and selectedConfig ~= "None")
    Section:AddToggle({
        Name = "Set as Auto-Load",
        Default = isAutoLoad,
        Callback = function(state)
            if state then
                self:SetAutoLoad(selectedConfig)
            else
                self:SetAutoLoad(nil)
            end
        end
    })
end

-- =========================================================
-- SETTINGS MANAGER
-- =========================================================
local SettingsManager = {
    Library = NamelessWare,
    ToggleKey = Enum.KeyCode.RightShift,
    MobileVisible = true
}

function SettingsManager:SetLibrary(library)
    self.Library = library or NamelessWare
end

function SettingsManager:BuildSettingsSection(Section)
    Section:AddSubHeader("Menu Navigation", "rbxassetid://10734950309")

    Section:AddKeybind({
        Name = "Menu Keybind",
        Default = NamelessWare.ToggleKey or Enum.KeyCode.RightShift,
        Callback = function(key)
            if typeof(key) == "EnumItem" then
                NamelessWare.ToggleKey = key
            elseif typeof(key) == "string" and Enum.KeyCode[key] then
                NamelessWare.ToggleKey = Enum.KeyCode[key]
            end
            NamelessWare:Notify({
                Title = "Keybind Updated",
                Content = "Menu toggle key set to: " .. tostring(NamelessWare.ToggleKey.Name),
                Duration = 2,
                Type = "Info"
            })
        end
    })

    if NamelessWare.ActiveWindow and NamelessWare.ActiveWindow.MobileBtn then
        Section:AddToggle({
            Name = "Mobile Floating Button",
            Default = true,
            Callback = function(state)
                NamelessWare.ActiveWindow.MobileBtn.Visible = state
            end
        })

        Section:AddButton({
            Name = "Reset Mobile Button Pos",
            Callback = function()
                NamelessWare.ActiveWindow.MobileBtn.Position = UDim2.new(0, 16, 0.5, -25)
                NamelessWare:Notify({
                    Title = "Button Reset",
                    Content = "Mobile button position restored.",
                    Duration = 1.5,
                    Type = "Info"
                })
            end
        })
    end

    Section:AddSubHeader("Keybinds & HUD", "rbxassetid://10734975692")

    Section:AddToggle({
        Name = "Show Keybinds in Menu",
        Default = NamelessWare.ShowKeybinds,
        Callback = function(state)
            NamelessWare:SetKeybindsVisibility(state)
        end
    })

    Section:AddToggle({
        Name = "Floating Keybinds HUD",
        Default = NamelessWare.ShowKeybindsHud,
        Callback = function(state)
            NamelessWare:SetKeybindsHud(state)
        end
    })

    Section:AddSubHeader("Active Keybinds Tracker", "rbxassetid://10734975692")

    local KeybindListContainer = Instance.new("Frame")
    KeybindListContainer.Size = UDim2.new(1, 0, 0, 0)
    KeybindListContainer.AutomaticSize = Enum.AutomaticSize.Y
    KeybindListContainer.BackgroundTransparency = 1
    KeybindListContainer.Parent = Section.Card

    local ListLay = Instance.new("UIListLayout")
    ListLay.Padding = UDim.new(0, 6)
    ListLay.SortOrder = Enum.SortOrder.LayoutOrder
    ListLay.Parent = KeybindListContainer

    local function RefreshKeybindDisplay()
        for _, child in ipairs(KeybindListContainer:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        local total = 0
        local registry = NamelessWare.KeybindRegistry or {}

        for _, kb in ipairs(registry) do
            total = total + 1
            local Row = Instance.new("Frame")
            Row.Size = UDim2.new(1, 0, 0, 26)
            Row.BackgroundColor3 = THEME.BgSidebar
            Row.BorderSizePixel = 0
            Row.Parent = KeybindListContainer

            local RowCorner = Instance.new("UICorner")
            RowCorner.CornerRadius = UDim.new(0, 6)
            RowCorner.Parent = Row

            local RowStroke = Instance.new("UIStroke")
            RowStroke.Color = THEME.CardBorder
            RowStroke.Thickness = 1
            RowStroke.Parent = Row

            local TabBadge = Instance.new("TextLabel")
            TabBadge.Size = UDim2.new(0, 64, 0, 16)
            TabBadge.Position = UDim2.new(0, 5, 0.5, -8)
            TabBadge.BackgroundColor3 = THEME.CardBg
            TabBadge.Text = "[" .. (kb.Tab or "General") .. "]"
            TabBadge.Font = THEME.FontBold
            TabBadge.TextSize = 8
            TabBadge.TextColor3 = THEME.Accent
            TabBadge.Parent = Row

            local BadgeCorner = Instance.new("UICorner")
            BadgeCorner.CornerRadius = UDim.new(0, 4)
            BadgeCorner.Parent = TabBadge

            local FeatLabel = Instance.new("TextLabel")
            FeatLabel.Size = UDim2.new(1, -140, 1, 0)
            FeatLabel.Position = UDim2.new(0, 74, 0, 0)
            FeatLabel.BackgroundTransparency = 1
            FeatLabel.Text = kb.Name or "Feature"
            FeatLabel.Font = THEME.FontMain
            FeatLabel.TextSize = 9
            FeatLabel.TextColor3 = THEME.TextMain
            FeatLabel.TextXAlignment = Enum.TextXAlignment.Left
            FeatLabel.Parent = Row

            local KeyBadge = Instance.new("TextLabel")
            KeyBadge.Size = UDim2.new(0, 55, 0, 16)
            KeyBadge.Position = UDim2.new(1, -60, 0.5, -8)
            KeyBadge.BackgroundColor3 = THEME.CardBg
            KeyBadge.Text = tostring(kb.Key or "None")
            KeyBadge.Font = THEME.FontBold
            KeyBadge.TextSize = 8
            KeyBadge.TextColor3 = THEME.TextMuted
            KeyBadge.Parent = Row

            local KeyCorner = Instance.new("UICorner")
            KeyCorner.CornerRadius = UDim.new(0, 4)
            KeyCorner.Parent = KeyBadge

            local KeyStroke = Instance.new("UIStroke")
            KeyStroke.Color = THEME.CardBorder
            KeyStroke.Thickness = 1
            KeyStroke.Parent = KeyBadge

            table.insert(NamelessWare.ThemeSubscribers, function(theme)
                Row.BackgroundColor3 = theme.BgSidebar
                RowStroke.Color = theme.CardBorder
                TabBadge.BackgroundColor3 = theme.CardBg
                TabBadge.TextColor3 = theme.Accent
                FeatLabel.TextColor3 = theme.TextMain
                KeyBadge.BackgroundColor3 = theme.CardBg
                KeyBadge.TextColor3 = theme.TextMuted
                KeyStroke.Color = theme.CardBorder
            end)
        end

        if total == 0 then
            local EmptyLabel = Instance.new("TextLabel")
            EmptyLabel.Size = UDim2.new(1, 0, 0, 24)
            EmptyLabel.BackgroundTransparency = 1
            EmptyLabel.Text = "No active keybinds registered."
            EmptyLabel.Font = THEME.FontMain
            EmptyLabel.TextSize = 9
            EmptyLabel.TextColor3 = THEME.TextMuted
            EmptyLabel.Parent = KeybindListContainer
        end
    end

    RefreshKeybindDisplay()

    Section:AddButton({
        Name = "Refresh Keybinds Tracker",
        Callback = function()
            RefreshKeybindDisplay()
            NamelessWare:Notify({
                Title = "Keybinds Refreshed",
                Content = "Updated list of active feature keybinds.",
                Duration = 1.5,
                Type = "Info"
            })
        end
    })

    Section:AddSubHeader("Appearance & Transparency", "rbxassetid://10734950309")

    Section:AddSlider({
        Name = "Menu Transparency",
        Min = 0,
        Max = 85,
        Default = math.floor((NamelessWare.Transparency or 0) * 100),
        Suffix = "%",
        Callback = function(val)
            NamelessWare:SetTransparency(val / 100)
        end
    })

    Section:AddSlider({
        Name = "Cards Transparency",
        Min = 0,
        Max = 80,
        Default = math.floor((NamelessWare.CardTransparency or 0) * 100),
        Suffix = "%",
        Callback = function(val)
            NamelessWare:SetCardTransparency(val / 100)
        end
    })

    Section:AddSubHeader("Actions", "rbxassetid://10734950309")

    Section:AddButton({
        Name = "Unload NamelessWare",
        Callback = function()
            if _G.NamelessWareInstance then
                pcall(function() _G.NamelessWareInstance:Destroy() end)
                _G.NamelessWareInstance = nil
            end
        end
    })
end

NamelessWare.THEME = THEME
NamelessWare.ThemeManager = ThemeManager
NamelessWare.SaveManager = SaveManager
NamelessWare.SettingsManager = SettingsManager

if getgenv then
    getgenv().NamelessWare = NamelessWare
end

-- =========================================================
-- NOTIFICATION TOAST COMPONENT
-- =========================================================
function NamelessWare:Notify(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Notification"
    local content = cfg.Content or ""
    local duration = cfg.Duration or 3
    local toastType = cfg.Type or "Info"

    if not self.ActiveWindow or not self.ActiveWindow.ScreenGui then return end
    local screenGui = self.ActiveWindow.ScreenGui

    local notifHolder = screenGui:FindFirstChild("NamelessNotificationHolder")
    if not notifHolder then
        notifHolder = Instance.new("Frame")
        notifHolder.Name = "NamelessNotificationHolder"
        notifHolder.Size = UDim2.new(0, 270, 1, -20)
        notifHolder.Position = UDim2.new(1, -15, 1, -10)
        notifHolder.AnchorPoint = Vector2.new(1, 1)
        notifHolder.BackgroundTransparency = 1
        notifHolder.ZIndex = 500
        notifHolder.Parent = screenGui

        local holderLayout = Instance.new("UIListLayout")
        holderLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        holderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        holderLayout.Padding = UDim.new(0, 8)
        holderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        holderLayout.Parent = notifHolder
    end

    local typeColors = {
        Success = THEME.Accent,
        Info = THEME.AccentGradient,
        Warning = Color3.fromRGB(255, 185, 45),
        Error = Color3.fromRGB(255, 60, 80)
    }
    local accentCol = typeColors[toastType] or THEME.Accent

    local Toast = Instance.new("Frame")
    Toast.Name = "Toast"
    Toast.Size = UDim2.new(1, 0, 0, 0)
    Toast.AutomaticSize = Enum.AutomaticSize.Y
    Toast.Position = UDim2.new(1, 30, 0, 0)
    Toast.BackgroundColor3 = THEME.CardBg
    Toast.BorderSizePixel = 0
    Toast.ZIndex = 501
    Toast.Parent = notifHolder

    local ToastCorner = Instance.new("UICorner")
    ToastCorner.CornerRadius = UDim.new(0, 8)
    ToastCorner.Parent = Toast

    local ToastStroke = Instance.new("UIStroke")
    ToastStroke.Color = THEME.CardBorder
    ToastStroke.Thickness = 1
    ToastStroke.Parent = Toast

    local ToastPadding = Instance.new("UIPadding")
    ToastPadding.PaddingTop = UDim.new(0, 10)
    ToastPadding.PaddingBottom = UDim.new(0, 12)
    ToastPadding.PaddingLeft = UDim.new(0, 12)
    ToastPadding.PaddingRight = UDim.new(0, 12)
    ToastPadding.Parent = Toast

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 3, 1, -20)
    Bar.Position = UDim2.new(0, 0, 0, 0)
    Bar.BackgroundColor3 = accentCol
    Bar.BorderSizePixel = 0
    Bar.ZIndex = 502
    Bar.Parent = Toast

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -12, 0, 16)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.Font = THEME.FontBold
    TitleLabel.TextSize = 11
    TitleLabel.TextColor3 = THEME.TextMain
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 502
    TitleLabel.Parent = Toast

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -12, 0, 0)
    ContentLabel.Position = UDim2.new(0, 10, 0, 18)
    ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = content
    ContentLabel.Font = THEME.FontMain
    ContentLabel.TextSize = 10
    ContentLabel.TextColor3 = THEME.TextMuted
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.ZIndex = 502
    ContentLabel.Parent = Toast

    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(1, 24, 0, 2)
    Progress.Position = UDim2.new(0, -12, 1, 10)
    Progress.BackgroundColor3 = accentCol
    Progress.BorderSizePixel = 0
    Progress.ZIndex = 502
    Progress.Parent = Toast

    Toast.Position = UDim2.new(1, 50, 0, 0)
    Tween(Toast, {Position = UDim2.new(0, 0, 0, 0)}, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    Tween(Progress, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    task.spawn(function()
        task.wait(duration)
        Tween(Toast, {Position = UDim2.new(1, 50, 0, 0), BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        Tween(ToastStroke, {Transparency = 1}, 0.22)
        Tween(TitleLabel, {TextTransparency = 1}, 0.22)
        Tween(ContentLabel, {TextTransparency = 1}, 0.22)
        Tween(Bar, {BackgroundTransparency = 1}, 0.22)
        Tween(Progress, {BackgroundTransparency = 1}, 0.22)
        task.wait(0.25)
        pcall(function() Toast:Destroy() end)
    end)
end

-- =========================================================
-- CREATE WINDOW
-- =========================================================
function NamelessWare:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "NAMELESS WARE"
    local SubTitle = config.SubTitle or "Combat - default hotkeys"
    local AccentColor = config.Accent or THEME.Accent
    local LogoUrl = config.LogoUrl or RAW_LOGO_URL

    if _G.NamelessWareInstance then
        pcall(function() _G.NamelessWareInstance:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessWare_UI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    SafeParentGui(ScreenGui)
    _G.NamelessWareInstance = ScreenGui

    local customLogoAsset = FetchCustomAsset(LogoUrl, "NamelessWare_Logo.webp")

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

    local MainWindow = Instance.new("Frame")
    MainWindow.Name = "MainWindow"
    MainWindow.Size = UDim2.new(0, 600, 0, 445)
    MainWindow.Position = UDim2.new(0.5, -300, 0.5, -222)
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

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 155, 1, 0)
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

    local BrandFrame = Instance.new("Frame")
    BrandFrame.Size = UDim2.new(1, 0, 0, 52)
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

    local NavScroll = Instance.new("ScrollingFrame")
    NavScroll.Size = UDim2.new(1, -14, 1, -116)
    NavScroll.Position = UDim2.new(0, 7, 0, 52)
    NavScroll.BackgroundTransparency = 1
    NavScroll.ScrollBarThickness = 0
    NavScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    NavScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    NavScroll.Parent = Sidebar

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Padding = UDim.new(0, 4)
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Parent = NavScroll

    -- =====================================================
    -- USER PROFILE & USAGE TRACKER (FOOTER)
    -- =====================================================
    local UserCard = Instance.new("Frame")
    UserCard.Name = "UserProfileTracker"
    UserCard.Size = UDim2.new(1, -14, 0, 50)
    UserCard.Position = UDim2.new(0, 7, 1, -56)
    UserCard.BackgroundColor3 = THEME.CardBg
    UserCard.BorderSizePixel = 0
    UserCard.Parent = Sidebar

    local UserCardCorner = Instance.new("UICorner")
    UserCardCorner.CornerRadius = UDim.new(0, 8)
    UserCardCorner.Parent = UserCard

    local UserCardStroke = Instance.new("UIStroke")
    UserCardStroke.Color = THEME.CardBorder
    UserCardStroke.Thickness = 1
    UserCardStroke.Parent = UserCard

    local AvatarBox = Instance.new("Frame")
    AvatarBox.Size = UDim2.new(0, 32, 0, 32)
    AvatarBox.Position = UDim2.new(0, 8, 0.5, -16)
    AvatarBox.BackgroundColor3 = THEME.BgSidebar
    AvatarBox.BorderSizePixel = 0
    AvatarBox.Parent = UserCard

    local AvatarBoxCorner = Instance.new("UICorner")
    AvatarBoxCorner.CornerRadius = UDim.new(1, 0)
    AvatarBoxCorner.Parent = AvatarBox

    local AvatarImg = Instance.new("ImageLabel")
    AvatarImg.Size = UDim2.new(1, 0, 1, 0)
    AvatarImg.BackgroundTransparency = 1
    AvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer and LocalPlayer.UserId or 1) .. "&w=100&h=100"
    AvatarImg.Parent = AvatarBox

    local AvatarImgCorner = Instance.new("UICorner")
    AvatarImgCorner.CornerRadius = UDim.new(1, 0)
    AvatarImgCorner.Parent = AvatarImg

    local AvatarStroke = Instance.new("UIStroke")
    AvatarStroke.Color = AccentColor
    AvatarStroke.Thickness = 1.2
    AvatarStroke.Parent = AvatarBox

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(1, -7, 1, -7)
    StatusDot.BackgroundColor3 = Color3.fromRGB(0, 230, 130)
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = AvatarBox

    local StatusDotCorner = Instance.new("UICorner")
    StatusDotCorner.CornerRadius = UDim.new(1, 0)
    StatusDotCorner.Parent = StatusDot

    local StatusDotStroke = Instance.new("UIStroke")
    StatusDotStroke.Color = THEME.BgSidebar
    StatusDotStroke.Thickness = 1
    StatusDotStroke.Parent = StatusDot

    local UserNameLabel = Instance.new("TextLabel")
    UserNameLabel.Size = UDim2.new(1, -48, 0, 14)
    UserNameLabel.Position = UDim2.new(0, 46, 0, 9)
    UserNameLabel.BackgroundTransparency = 1
    UserNameLabel.Text = LocalPlayer and LocalPlayer.DisplayName or "Player"
    UserNameLabel.Font = THEME.FontBold
    UserNameLabel.TextSize = 10
    UserNameLabel.TextColor3 = THEME.TextMain
    UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UserNameLabel.Parent = UserCard

    local UserTimerLabel = Instance.new("TextLabel")
    UserTimerLabel.Size = UDim2.new(1, -48, 0, 12)
    UserTimerLabel.Position = UDim2.new(0, 46, 0, 25)
    UserTimerLabel.BackgroundTransparency = 1
    UserTimerLabel.Text = "⏱ 00:00:00"
    UserTimerLabel.Font = THEME.FontMain
    UserTimerLabel.TextSize = 9
    UserTimerLabel.TextColor3 = THEME.Accent
    UserTimerLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserTimerLabel.Parent = UserCard

    local sessionStart = tick()
    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            local elapsed = math.floor(tick() - sessionStart)
            local hrs = math.floor(elapsed / 3600)
            local mins = math.floor((elapsed % 3600) / 60)
            local secs = elapsed % 60
            UserTimerLabel.Text = string.format("⏱ %02d:%02d:%02d", hrs, mins, secs)
            task.wait(1)
        end
    end)

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, -165, 0, 48)
    HeaderFrame.Position = UDim2.new(0, 160, 0, 4)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = MainWindow

    local RegisteredItems = {}
    local RegisteredCards = {}

    local isMobilePlatform = UserInputService.TouchEnabled and not (UserInputService.KeyboardEnabled and UserInputService.MouseEnabled)
    local isConsolePlatform = false
    pcall(function()
        if GuiService and GuiService.IsTenFootInterface then
            isConsolePlatform = GuiService:IsTenFootInterface()
        end
    end)
    local platformName = "PC"
    local platformIcon = "rbxassetid://105451070737074"

    if isConsolePlatform then
        platformName = "Console"
        platformIcon = "rbxassetid://10734975692"
    elseif isMobilePlatform then
        platformName = "Mobile"
        platformIcon = "rbxassetid://133870842381885"
    else
        platformName = "PC"
        platformIcon = "rbxassetid://105451070737074"
    end

    local HeaderTabTitle = Instance.new("TextLabel")
    HeaderTabTitle.Size = UDim2.new(1, -225, 0, 20)
    HeaderTabTitle.Position = UDim2.new(0, 6, 0, 6)
    HeaderTabTitle.BackgroundTransparency = 1
    HeaderTabTitle.Text = "Combat"
    HeaderTabTitle.Font = THEME.FontBold
    HeaderTabTitle.TextSize = 15
    HeaderTabTitle.TextColor3 = THEME.TextMain
    HeaderTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabTitle.Parent = HeaderFrame

    local HeaderTabSub = Instance.new("TextLabel")
    HeaderTabSub.Size = UDim2.new(1, -225, 0, 14)
    HeaderTabSub.Position = UDim2.new(0, 6, 0, 26)
    HeaderTabSub.BackgroundTransparency = 1
    HeaderTabSub.Text = SubTitle
    HeaderTabSub.Font = THEME.FontMain
    HeaderTabSub.TextSize = 10
    HeaderTabSub.TextColor3 = THEME.TextMuted
    HeaderTabSub.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabSub.Parent = HeaderFrame

    local SearchContainer = Instance.new("Frame")
    SearchContainer.Name = "SearchContainer"
    SearchContainer.Size = UDim2.new(0, 135, 0, 26)
    SearchContainer.Position = UDim2.new(1, -212, 0.5, -13)
    SearchContainer.BackgroundColor3 = THEME.CardBg
    SearchContainer.BorderSizePixel = 0
    SearchContainer.Parent = HeaderFrame

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchContainer

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.Color = THEME.CardBorder
    SearchStroke.Thickness = 1
    SearchStroke.Parent = SearchContainer

    local SearchIcon = Instance.new("ImageLabel")
    SearchIcon.Size = UDim2.new(0, 12, 0, 12)
    SearchIcon.Position = UDim2.new(0, 8, 0.5, -6)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Image = "rbxassetid://10734943777"
    SearchIcon.ImageColor3 = THEME.TextMuted
    SearchIcon.ScaleType = Enum.ScaleType.Fit
    SearchIcon.Parent = SearchContainer

    local SearchInput = Instance.new("TextBox")
    SearchInput.Size = UDim2.new(1, -44, 1, 0)
    SearchInput.Position = UDim2.new(0, 24, 0, 0)
    SearchInput.BackgroundTransparency = 1
    SearchInput.Text = ""
    SearchInput.PlaceholderText = "Search..."
    SearchInput.PlaceholderColor3 = THEME.TextMuted
    SearchInput.Font = THEME.FontMain
    SearchInput.TextSize = 10
    SearchInput.TextColor3 = THEME.TextMain
    SearchInput.TextXAlignment = Enum.TextXAlignment.Left
    SearchInput.ClearTextOnFocus = false
    SearchInput.Parent = SearchContainer

    local ClearSearchBtn = Instance.new("TextButton")
    ClearSearchBtn.Size = UDim2.new(0, 16, 0, 16)
    ClearSearchBtn.Position = UDim2.new(1, -19, 0.5, -8)
    ClearSearchBtn.BackgroundTransparency = 1
    ClearSearchBtn.Text = "✕"
    ClearSearchBtn.Font = THEME.FontBold
    ClearSearchBtn.TextSize = 9
    ClearSearchBtn.TextColor3 = THEME.TextMuted
    ClearSearchBtn.Visible = false
    ClearSearchBtn.Parent = SearchContainer

    local DeviceBadge = Instance.new("Frame")
    DeviceBadge.Name = "DeviceBadge"
    DeviceBadge.Size = UDim2.new(0, 66, 0, 26)
    DeviceBadge.Position = UDim2.new(1, -70, 0.5, -13)
    DeviceBadge.BackgroundColor3 = THEME.CardBg
    DeviceBadge.BorderSizePixel = 0
    DeviceBadge.Parent = HeaderFrame

    local DeviceCorner = Instance.new("UICorner")
    DeviceCorner.CornerRadius = UDim.new(0, 6)
    DeviceCorner.Parent = DeviceBadge

    local DeviceStroke = Instance.new("UIStroke")
    DeviceStroke.Color = THEME.CardBorder
    DeviceStroke.Thickness = 1
    DeviceStroke.Parent = DeviceBadge

    local DeviceIcon = Instance.new("ImageLabel")
    DeviceIcon.Size = UDim2.new(0, 13, 0, 13)
    DeviceIcon.Position = UDim2.new(0, 7, 0.5, -6.5)
    DeviceIcon.BackgroundTransparency = 1
    DeviceIcon.Image = platformIcon
    DeviceIcon.ImageColor3 = THEME.Accent
    DeviceIcon.ScaleType = Enum.ScaleType.Fit
    DeviceIcon.Parent = DeviceBadge

    local DeviceLabel = Instance.new("TextLabel")
    DeviceLabel.Size = UDim2.new(1, -23, 1, 0)
    DeviceLabel.Position = UDim2.new(0, 23, 0, 0)
    DeviceLabel.BackgroundTransparency = 1
    DeviceLabel.Text = platformName
    DeviceLabel.Font = THEME.FontBold
    DeviceLabel.TextSize = 9
    DeviceLabel.TextColor3 = THEME.TextMain
    DeviceLabel.TextXAlignment = Enum.TextXAlignment.Left
    DeviceLabel.Parent = DeviceBadge

    local function PerformSearch(query)
        query = string.lower(query or "")
        if query == "" then
            ClearSearchBtn.Visible = false
            for _, item in ipairs(RegisteredItems) do
                item.Element.Visible = true
            end
            for _, card in ipairs(RegisteredCards) do
                card.Visible = true
            end
        else
            ClearSearchBtn.Visible = true
            local cardCounts = {}
            for _, card in ipairs(RegisteredCards) do
                cardCounts[card] = 0
            end

            for _, item in ipairs(RegisteredItems) do
                local matches = string.find(string.lower(item.Name), query, 1, true) ~= nil
                item.Element.Visible = matches
                if matches and cardCounts[item.Card] then
                    cardCounts[item.Card] = cardCounts[item.Card] + 1
                end
            end

            for card, count in pairs(cardCounts) do
                card.Visible = (count > 0)
            end
        end
    end

    SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
        PerformSearch(SearchInput.Text)
    end)

    ClearSearchBtn.MouseButton1Click:Connect(function()
        SearchInput.Text = ""
        PerformSearch("")
    end)

    SearchInput.Focused:Connect(function()
        Tween(SearchStroke, {Color = THEME.Accent}, 0.2)
        Tween(SearchIcon, {ImageColor3 = THEME.Accent}, 0.2)
    end)

    SearchInput.FocusLost:Connect(function()
        Tween(SearchStroke, {Color = THEME.CardBorder}, 0.2)
        Tween(SearchIcon, {ImageColor3 = THEME.TextMuted}, 0.2)
    end)

    MakeDraggable(MainWindow, HeaderFrame)

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -165, 1, -58)
    ContentArea.Position = UDim2.new(0, 160, 0, 52)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainWindow

    local isUIOpen = true
    local ActiveDropdown = nil

    local function ToggleUI()
        isUIOpen = not isUIOpen
        if isUIOpen then
            MainWindow.Visible = true
            MainWindow.Position = UDim2.new(0.5, -300, 0.5, -200)
            Tween(MainWindow, {Position = UDim2.new(0.5, -300, 0.5, -222)}, 0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            if ActiveDropdown then
                ActiveDropdown()
            end
            local tw = Tween(MainWindow, {Position = UDim2.new(0.5, -300, 0.5, -200)}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw.Completed:Connect(function()
                if not isUIOpen then MainWindow.Visible = false end
            end)
        end
    end

    MobileBtn.MouseButton1Click:Connect(ToggleUI)

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == NamelessWare.ToggleKey then
            ToggleUI()
        end
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if ActiveDropdown and not gp then
                ActiveDropdown()
            end
        end
    end)

    local Window = {
        ScreenGui = ScreenGui,
        MainWindow = MainWindow,
        MobileBtn = MobileBtn,
        Sidebar = Sidebar,
        UserCard = UserCard,
        SearchContainer = SearchContainer,
        DeviceBadge = DeviceBadge,
        NavScroll = NavScroll,
        ContentArea = ContentArea,
        Tabs = {}
    }
    NamelessWare.ActiveWindow = Window

    table.insert(NamelessWare.ThemeSubscribers, function(theme)
        MainWindow.BackgroundColor3 = theme.BgMain
        MainGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.BgMainGradient),
            ColorSequenceKeypoint.new(1, theme.BgMain)
        })
        MainStroke.Color = theme.CardBorder
        Sidebar.BackgroundColor3 = theme.BgSidebar
        SidebarStroke.Color = theme.CardBorder
        MobileBtn.BackgroundColor3 = theme.BgSidebar
        MobileBtnStroke.Color = theme.Accent
        LogoBox.BackgroundColor3 = theme.CardBg
        LogoGlow.Color = theme.Accent
        BrandTitle.TextColor3 = theme.TextMain
        HeaderTabTitle.TextColor3 = theme.TextMain
        HeaderTabSub.TextColor3 = theme.TextMuted
        SearchContainer.BackgroundColor3 = theme.CardBg
        SearchStroke.Color = theme.CardBorder
        SearchIcon.ImageColor3 = theme.TextMuted
        SearchInput.TextColor3 = theme.TextMain
        SearchInput.PlaceholderColor3 = theme.TextMuted
        DeviceBadge.BackgroundColor3 = theme.CardBg
        DeviceStroke.Color = theme.CardBorder
        DeviceIcon.ImageColor3 = theme.Accent
        DeviceLabel.TextColor3 = theme.TextMain
        UserCard.BackgroundColor3 = theme.CardBg
        UserCardStroke.Color = theme.CardBorder
        AvatarBox.BackgroundColor3 = theme.BgSidebar
        AvatarStroke.Color = theme.Accent
        StatusDotStroke.Color = theme.BgSidebar
        UserNameLabel.TextColor3 = theme.TextMain
        UserTimerLabel.TextColor3 = theme.Accent
    end)

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

    local FirstTab = true

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local currentTabName = tabConfig.Name or "Tab"
        local name = currentTabName
        local icon = tabConfig.Icon or "rbxassetid://10734975692"
        local subText = tabConfig.Subtitle or SubTitle

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = THEME.Accent
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        TabBtn.Parent = NavScroll

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabBtn

        local TabGrad = Instance.new("UIGradient")
        TabGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME.AccentGradient),
            ColorSequenceKeypoint.new(1, THEME.Accent)
        })
        TabGrad.Rotation = 90
        TabGrad.Parent = TabBtn

        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = icon
        TabIcon.ImageColor3 = THEME.TextMuted
        TabIcon.ScaleType = Enum.ScaleType.Fit
        TabIcon.Parent = TabBtn

        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -36, 1, 0)
        TabLabel.Position = UDim2.new(0, 34, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.Font = THEME.FontMain
        TabLabel.TextSize = 11
        TabLabel.TextColor3 = THEME.TextMuted
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabBtn

        local TabPage = Instance.new("Frame")
        TabPage.Name = name .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.Parent = ContentArea

        local LeftColumn = Instance.new("ScrollingFrame")
        LeftColumn.Name = "LeftColumn"
        LeftColumn.Size = UDim2.new(0.5, -5, 1, 0)
        LeftColumn.Position = UDim2.new(0, 0, 0, 0)
        LeftColumn.BackgroundTransparency = 1
        LeftColumn.BorderSizePixel = 0
        LeftColumn.ScrollBarThickness = 2
        LeftColumn.ScrollBarImageColor3 = THEME.Accent
        LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
        LeftColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
        LeftColumn.Parent = TabPage

        local LeftPadding = Instance.new("UIPadding")
        LeftPadding.PaddingTop = UDim.new(0, 6)
        LeftPadding.PaddingBottom = UDim.new(0, 14)
        LeftPadding.PaddingLeft = UDim.new(0, 4)
        LeftPadding.PaddingRight = UDim.new(0, 6)
        LeftPadding.Parent = LeftColumn

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.Parent = LeftColumn

        local RightColumn = Instance.new("ScrollingFrame")
        RightColumn.Name = "RightColumn"
        RightColumn.Size = UDim2.new(0.5, -5, 1, 0)
        RightColumn.Position = UDim2.new(0.5, 5, 0, 0)
        RightColumn.BackgroundTransparency = 1
        RightColumn.BorderSizePixel = 0
        RightColumn.ScrollBarThickness = 2
        RightColumn.ScrollBarImageColor3 = THEME.Accent
        RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
        RightColumn.AutomaticCanvasSize = Enum.AutomaticSize.Y
        RightColumn.Parent = TabPage

        local RightPadding = Instance.new("UIPadding")
        RightPadding.PaddingTop = UDim.new(0, 6)
        RightPadding.PaddingBottom = UDim.new(0, 14)
        RightPadding.PaddingLeft = UDim.new(0, 4)
        RightPadding.PaddingRight = UDim.new(0, 6)
        RightPadding.Parent = RightColumn

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0, 8)
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Parent = RightColumn

        local isCurrentTab = false

        local function ActivateTab()
            if ActiveDropdown then
                ActiveDropdown()
            end
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

        TabBtn.MouseButton1Click:Connect(ActivateTab)

        TabBtn.MouseEnter:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 0.85}, 0.15)
                Tween(TabLabel, {TextColor3 = THEME.TextMain}, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not isCurrentTab then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
                Tween(TabLabel, {TextColor3 = THEME.TextMuted}, 0.15)
            end
        end)

        local TabObject = {
            Button = TabBtn,
            Label = TabLabel,
            Icon = TabIcon,
            Page = TabPage,
            IsActive = isCurrentTab
        }
        table.insert(Window.Tabs, TabObject)

        table.insert(NamelessWare.ThemeSubscribers, function(theme)
            TabBtn.BackgroundColor3 = theme.Accent
            TabGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.AccentGradient),
                ColorSequenceKeypoint.new(1, theme.Accent)
            })
            LeftColumn.ScrollBarImageColor3 = theme.Accent
            RightColumn.ScrollBarImageColor3 = theme.Accent
            if isCurrentTab then
                TabBtn.BackgroundTransparency = 0
                TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            else
                TabBtn.BackgroundTransparency = 1
                TabLabel.TextColor3 = theme.TextMuted
                TabIcon.ImageColor3 = theme.TextMuted
            end
        end)

        if FirstTab then
            FirstTab = false
            ActivateTab()
        end

        local TabMethods = {}
        local leftCount = 0
        local rightCount = 0

        function TabMethods:CreateSection(secTitle, secIcon, side)
            local targetColumn
            if side == "Left" or side == 1 then
                targetColumn = LeftColumn
                leftCount = leftCount + 1
            elseif side == "Right" or side == 2 then
                targetColumn = RightColumn
                rightCount = rightCount + 1
            else
                if leftCount <= rightCount then
                    targetColumn = LeftColumn
                    leftCount = leftCount + 1
                else
                    targetColumn = RightColumn
                    rightCount = rightCount + 1
                end
            end

            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(1, 0, 0, 0)
            Card.AutomaticSize = Enum.AutomaticSize.Y
            Card.BackgroundColor3 = THEME.CardBg
            Card.BorderSizePixel = 0
            Card.ClipsDescendants = false
            Card.ZIndex = 1
            Card.Parent = targetColumn
            Card.BackgroundTransparency = NamelessWare.CardTransparency or 0
            table.insert(RegisteredCards, Card)
            table.insert(NamelessWare.CardElements, Card)

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
            CardPadding.PaddingTop = UDim.new(0, 10)
            CardPadding.PaddingBottom = UDim.new(0, 12)
            CardPadding.PaddingLeft = UDim.new(0, 10)
            CardPadding.PaddingRight = UDim.new(0, 10)
            CardPadding.Parent = Card

            local CardLayout = Instance.new("UIListLayout")
            CardLayout.Padding = UDim.new(0, 8)
            CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
            CardLayout.Parent = Card

            local SecHeader = Instance.new("Frame")
            SecHeader.Size = UDim2.new(1, 0, 0, 20)
            SecHeader.BackgroundTransparency = 1
            SecHeader.Parent = Card

            local SecIconImg
            if secIcon then
                SecIconImg = Instance.new("ImageLabel")
                SecIconImg.Size = UDim2.new(0, 14, 0, 14)
                SecIconImg.Position = UDim2.new(0, 0, 0.5, -7)
                SecIconImg.BackgroundTransparency = 1
                SecIconImg.Image = secIcon
                SecIconImg.ImageColor3 = THEME.Accent
                SecIconImg.ScaleType = Enum.ScaleType.Fit
                SecIconImg.Parent = SecHeader
            end

            local SecLabel = Instance.new("TextLabel")
            SecLabel.Size = UDim2.new(1, secIcon and -20 or 0, 1, 0)
            SecLabel.Position = UDim2.new(0, secIcon and 20 or 0, 0, 0)
            SecLabel.BackgroundTransparency = 1
            SecLabel.Text = secTitle
            SecLabel.Font = THEME.FontBold
            SecLabel.TextSize = 11
            SecLabel.TextColor3 = THEME.TextMain
            SecLabel.TextXAlignment = Enum.TextXAlignment.Left
            SecLabel.Parent = SecHeader

            table.insert(NamelessWare.ThemeSubscribers, function(theme)
                Card.BackgroundColor3 = theme.CardBg
                CardGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, theme.CardBgGradient),
                    ColorSequenceKeypoint.new(1, theme.CardBg)
                })
                CardStroke.Color = theme.CardBorder
                SecLabel.TextColor3 = theme.TextMain
                if SecIconImg then
                    SecIconImg.ImageColor3 = theme.Accent
                end
            end)

            local Controls = {}

            function Controls:AddSubHeader(title, icon)
                local SubFrame = Instance.new("Frame")
                SubFrame.Size = UDim2.new(1, 0, 0, 18)
                SubFrame.BackgroundTransparency = 1
                SubFrame.Parent = Card

                local SubLabel = Instance.new("TextLabel")
                SubLabel.Size = UDim2.new(1, icon and -20 or 0, 1, 0)
                SubLabel.Position = UDim2.new(0, icon and 20 or 0, 0, 0)
                SubLabel.BackgroundTransparency = 1
                SubLabel.Text = title
                SubLabel.Font = THEME.FontBold
                SubLabel.TextSize = 10
                SubLabel.TextColor3 = THEME.Accent
                SubLabel.TextXAlignment = Enum.TextXAlignment.Left
                SubLabel.Parent = SubFrame

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    SubLabel.TextColor3 = theme.Accent
                end)
            end

            function Controls:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local state = cfg.Default or false
                local flag = cfg.Flag or name
                local callback = cfg.Callback or function() end
                local keybindKey = cfg.Keybind
                local colorPicker = cfg.Color

                local Row = Instance.new("TextButton")
                Row.Size = UDim2.new(1, 0, 0, 24)
                Row.BackgroundTransparency = 1
                Row.Text = ""
                Row.AutoButtonColor = false
                Row.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Row, Card = Card})

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -70, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 10
                Label.TextColor3 = state and THEME.TextMain or THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                local RightHold = Instance.new("Frame")
                RightHold.Size = UDim2.new(0, 65, 1, 0)
                RightHold.Position = UDim2.new(1, -65, 0, 0)
                RightHold.BackgroundTransparency = 1
                RightHold.Parent = Row

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.Padding = UDim.new(0, 5)
                RightLayout.Parent = RightHold

                local isPC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
                local boundKey = keybindKey and (typeof(keybindKey) == "EnumItem" and keybindKey or (Enum.KeyCode[tostring(keybindKey)] or nil)) or nil
                local isBinding = false

                local KeyBtn
                if isPC or boundKey then
                    KeyBtn = Instance.new("TextButton")
                    KeyBtn.Size = UDim2.new(0, boundKey and math.max(18, #boundKey.Name * 6 + 8) or 16, 0, 14)
                    KeyBtn.BackgroundColor3 = THEME.BgSidebar
                    KeyBtn.Text = boundKey and boundKey.Name or "-"
                    KeyBtn.Font = THEME.FontBold
                    KeyBtn.TextSize = 8
                    KeyBtn.TextColor3 = THEME.TextMuted
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.Visible = NamelessWare.ShowKeybinds and isPC
                    KeyBtn.Parent = RightHold

                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 3)
                    KeyCorner.Parent = KeyBtn

                    local KeyStroke = Instance.new("UIStroke")
                    KeyStroke.Color = THEME.CardBorder
                    KeyStroke.Thickness = 1
                    KeyStroke.Parent = KeyBtn

                    local function RegisterSelf()
                        NamelessWare:RegisterKeybind({
                            Name = name,
                            Tab = currentTabName,
                            Key = boundKey and boundKey.Name or "-",
                            GetState = function() return state end
                        })
                    end
                    RegisterSelf()

                    KeyBtn.MouseButton1Click:Connect(function()
                        if isBinding then return end
                        isBinding = true
                        KeyBtn.Text = "..."
                        Tween(KeyStroke, {Color = THEME.Accent}, 0.15)
                        Tween(KeyBtn, {TextColor3 = THEME.Accent}, 0.15)

                        local conn
                        conn = UserInputService.InputBegan:Connect(function(input, gp)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                conn:Disconnect()
                                isBinding = false
                                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Escape then
                                    boundKey = nil
                                    KeyBtn.Text = "-"
                                    KeyBtn.Size = UDim2.new(0, 16, 0, 14)
                                else
                                    boundKey = input.KeyCode
                                    KeyBtn.Text = boundKey.Name
                                    KeyBtn.Size = UDim2.new(0, math.max(18, #boundKey.Name * 6 + 8), 0, 14)
                                end
                                Tween(KeyStroke, {Color = THEME.CardBorder}, 0.15)
                                Tween(KeyBtn, {TextColor3 = THEME.TextMuted}, 0.15)
                                RegisterSelf()
                            end
                        end)
                    end)

                    table.insert(NamelessWare.KeybindElements, KeyBtn)
                end

                local ColorBox
                if colorPicker then
                    ColorBox = Instance.new("Frame")
                    ColorBox.Size = UDim2.new(0, 12, 0, 12)
                    ColorBox.BackgroundColor3 = colorPicker
                    ColorBox.BorderSizePixel = 0
                    ColorBox.Parent = RightHold

                    local ColorCorner = Instance.new("UICorner")
                    ColorCorner.CornerRadius = UDim.new(1, 0)
                    ColorCorner.Parent = ColorBox

                    local ColorStroke = Instance.new("UIStroke")
                    ColorStroke.Color = Color3.fromRGB(55, 55, 75)
                    ColorStroke.Thickness = 1
                    ColorStroke.Parent = ColorBox
                end

                local Circle = Instance.new("Frame")
                Circle.Size = UDim2.new(0, 12, 0, 12)
                Circle.BackgroundColor3 = state and THEME.Accent or THEME.CircleOff
                Circle.BorderSizePixel = 0
                Circle.Parent = RightHold

                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = Circle

                local CircleStroke = Instance.new("UIStroke")
                CircleStroke.Color = state and THEME.Accent or THEME.CircleOffBorder
                CircleStroke.Thickness = 1.2
                CircleStroke.Parent = Circle

                local function UpdateState(val)
                    state = val
                    Tween(Label, {TextColor3 = state and THEME.TextMain or THEME.TextMuted}, 0.15)
                    Tween(Circle, {BackgroundColor3 = state and THEME.Accent or THEME.CircleOff}, 0.15)
                    Tween(CircleStroke, {Color = state and THEME.Accent or THEME.CircleOffBorder}, 0.15)
                    callback(state)
                    NamelessWare:UpdateKeybindsHud()
                end

                Row.MouseButton1Click:Connect(function()
                    UpdateState(not state)
                end)

                UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and not isBinding and boundKey and input.KeyCode == boundKey and not UserInputService:GetFocusedTextBox() then
                        UpdateState(not state)
                    end
                end)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Label.TextColor3 = state and theme.TextMain or theme.TextMuted
                    Circle.BackgroundColor3 = state and theme.Accent or theme.CircleOff
                    CircleStroke.Color = state and theme.Accent or theme.CircleOffBorder
                    if KeyBtn then
                        KeyBtn.BackgroundColor3 = theme.BgSidebar
                        KeyBtn.TextColor3 = isBinding and theme.Accent or theme.TextMuted
                    end
                end)

                local controller = {
                    Set = function(v) UpdateState(v) end,
                    Get = function() return state end,
                    Type = "Toggle"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddSlider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local def = cfg.Default or min
                local suffix = cfg.Suffix or ""
                local flag = cfg.Flag or name
                local callback = cfg.Callback or function() end
                local value = def

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Frame, Card = Card})

                local TopLabel = Instance.new("TextLabel")
                TopLabel.Size = UDim2.new(1, -50, 0, 14)
                TopLabel.Position = UDim2.new(0, 0, 0, 0)
                TopLabel.BackgroundTransparency = 1
                TopLabel.Text = name
                TopLabel.Font = THEME.FontMain
                TopLabel.TextSize = 10
                TopLabel.TextColor3 = THEME.TextMuted
                TopLabel.TextXAlignment = Enum.TextXAlignment.Left
                TopLabel.Parent = Frame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(0, 50, 0, 14)
                ValLabel.Position = UDim2.new(1, -50, 0, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = tostring(value) .. suffix
                ValLabel.Font = THEME.FontBold
                ValLabel.TextSize = 10
                ValLabel.TextColor3 = THEME.TextMain
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent = Frame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 6)
                Track.Position = UDim2.new(0, 0, 0, 22)
                Track.BackgroundColor3 = THEME.BgSidebar
                Track.BorderSizePixel = 0
                Track.Parent = Frame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local startPercent = math.clamp((value - min) / ((max > min and (max - min)) or 1), 0, 1)

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new(startPercent, 0, 1, 0)
                Fill.BackgroundColor3 = THEME.Accent
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

                local Dot = Instance.new("Frame")
                Dot.Size = UDim2.new(0, 14, 0, 14)
                Dot.AnchorPoint = Vector2.new(0.5, 0.5)
                Dot.Position = UDim2.new(startPercent, 0, 0.5, 0)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dot.BorderSizePixel = 0
                Dot.ZIndex = 3
                Dot.Parent = Track

                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = Dot

                local DotStroke = Instance.new("UIStroke")
                DotStroke.Color = Color3.fromRGB(30, 30, 40)
                DotStroke.Thickness = 1.2
                DotStroke.Parent = Dot

                local TouchHitbox = Instance.new("TextButton")
                TouchHitbox.Name = "SliderHitbox"
                TouchHitbox.Size = UDim2.new(1, 0, 0, 26)
                TouchHitbox.Position = UDim2.new(0, 0, 0, 10)
                TouchHitbox.BackgroundTransparency = 1
                TouchHitbox.Text = ""
                TouchHitbox.AutoButtonColor = false
                TouchHitbox.ZIndex = 5
                TouchHitbox.Parent = Frame

                local sliderId = {}

                local function StartDrag(screenX)
                    if ActiveDragSession ~= nil and ActiveDragSession ~= sliderId then
                        return
                    end
                    ActiveDragSession = sliderId
                    UpdateValFromX(screenX)
                end

                TouchHitbox.MouseButton1Down:Connect(function(x, y)
                    StartDrag(x)
                end)

                TouchHitbox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        StartDrag(input.Position.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if ActiveDragSession == sliderId and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateValFromX(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and ActiveDragSession == sliderId then
                        ActiveDragSession = nil
                    end
                end)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    TopLabel.TextColor3 = theme.TextMuted
                    ValLabel.TextColor3 = theme.TextMain
                    Track.BackgroundColor3 = theme.BgSidebar
                    Fill.BackgroundColor3 = theme.Accent
                    FillGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, theme.AccentGradient),
                        ColorSequenceKeypoint.new(1, theme.Accent)
                    })
                end)

                local controller = {
                    Set = function(v)
                        value = math.clamp(v, min, max)
                        local percent = math.clamp((value - min) / ((max > min and (max - min)) or 1), 0, 1)
                        Fill.Size = UDim2.new(percent, 0, 1, 0)
                        Dot.Position = UDim2.new(percent, 0, 0.5, 0)
                        ValLabel.Text = tostring(value) .. suffix
                        callback(value)
                    end,
                    Get = function() return value end,
                    Type = "Slider"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddDropdown(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Dropdown"
                local options = cfg.Options or {}
                local def = cfg.Default or options[1] or ""
                local flag = cfg.Flag or name
                local callback = cfg.Callback or function() end
                local selected = def
                local isOpen = false

                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, 0, 0, 46)
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = false
                DropFrame.ZIndex = 1
                DropFrame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = DropFrame, Card = Card})

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, 0, 0, 14)
                Title.Position = UDim2.new(0, 0, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = name
                Title.Font = THEME.FontMain
                Title.TextSize = 10
                Title.TextColor3 = THEME.TextMuted
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.ZIndex = 1
                Title.Parent = DropFrame

                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(1, 0, 0, 26)
                DropBtn.Position = UDim2.new(0, 0, 0, 18)
                DropBtn.BackgroundColor3 = THEME.BgSidebar
                DropBtn.Text = ""
                DropBtn.AutoButtonColor = false
                DropBtn.ZIndex = 2
                DropBtn.Parent = DropFrame

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 6)
                DropCorner.Parent = DropBtn

                local DropStroke = Instance.new("UIStroke")
                DropStroke.Color = THEME.CardBorder
                DropStroke.Thickness = 1
                DropStroke.Parent = DropBtn

                local SelLabel = Instance.new("TextLabel")
                SelLabel.Size = UDim2.new(1, -28, 1, 0)
                SelLabel.Position = UDim2.new(0, 8, 0, 0)
                SelLabel.BackgroundTransparency = 1
                SelLabel.Text = selected
                SelLabel.Font = THEME.FontMain
                SelLabel.TextSize = 10
                SelLabel.TextColor3 = THEME.TextMain
                SelLabel.TextXAlignment = Enum.TextXAlignment.Left
                SelLabel.ZIndex = 3
                SelLabel.Parent = DropBtn

                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 16, 1, 0)
                Arrow.Position = UDim2.new(1, -20, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "▾"
                Arrow.Font = THEME.FontBold
                Arrow.TextSize = 12
                Arrow.TextColor3 = THEME.TextMuted
                Arrow.ZIndex = 3
                Arrow.Parent = DropBtn

                local MenuList = Instance.new("Frame")
                MenuList.Size = UDim2.new(1, 0, 0, 0)
                MenuList.Position = UDim2.new(0, 0, 0, 48)
                MenuList.BackgroundColor3 = THEME.CardBg
                MenuList.BorderSizePixel = 0
                MenuList.ClipsDescendants = true
                MenuList.Visible = false
                MenuList.Active = true
                MenuList.ZIndex = 100
                MenuList.Parent = DropFrame

                local MenuCorner = Instance.new("UICorner")
                MenuCorner.CornerRadius = UDim.new(0, 6)
                MenuCorner.Parent = MenuList

                local MenuStroke = Instance.new("UIStroke")
                MenuStroke.Color = THEME.Accent
                MenuStroke.Thickness = 1
                MenuStroke.Parent = MenuList

                local MenuScroll = Instance.new("ScrollingFrame")
                MenuScroll.Size = UDim2.new(1, -4, 1, -4)
                MenuScroll.Position = UDim2.new(0, 2, 0, 2)
                MenuScroll.BackgroundTransparency = 1
                MenuScroll.ScrollBarThickness = 2
                MenuScroll.ScrollBarImageColor3 = THEME.Accent
                MenuScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
                MenuScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
                MenuScroll.Active = true
                MenuScroll.ZIndex = 101
                MenuScroll.Parent = MenuList

                local MenuLayout = Instance.new("UIListLayout")
                MenuLayout.Padding = UDim.new(0, 2)
                MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
                MenuLayout.Parent = MenuScroll

                local function CloseDropdown()
                    if not isOpen then return end
                    isOpen = false
                    Tween(Arrow, {Rotation = 0}, 0.15)
                    Tween(DropStroke, {Color = THEME.CardBorder}, 0.15)
                    local tw = Tween(MenuList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                    tw.Completed:Connect(function()
                        if not isOpen then
                            MenuList.Visible = false
                            DropFrame.ZIndex = 1
                            Card.ZIndex = 1
                        end
                    end)
                    if ActiveDropdown == CloseDropdown then
                        ActiveDropdown = nil
                    end
                end

                local function OpenDropdown()
                    if ActiveDropdown and ActiveDropdown ~= CloseDropdown then
                        ActiveDropdown()
                    end
                    isOpen = true
                    ActiveDropdown = CloseDropdown

                    Card.ZIndex = 100
                    DropFrame.ZIndex = 100
                    MenuList.Visible = true

                    local targetHeight = math.min(#options * 24 + 6, 120)
                    Tween(Arrow, {Rotation = 180}, 0.15)
                    Tween(DropStroke, {Color = THEME.Accent}, 0.15)
                    Tween(MenuList, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                end

                local function RebuildOptions()
                    for _, ch in ipairs(MenuScroll:GetChildren()) do
                        if ch:IsA("TextButton") then ch:Destroy() end
                    end

                    for _, opt in ipairs(options) do
                        local OptItem = Instance.new("TextButton")
                        OptItem.Size = UDim2.new(1, 0, 0, 22)
                        OptItem.BackgroundColor3 = (opt == selected) and THEME.Accent or THEME.CardBg
                        OptItem.BackgroundTransparency = (opt == selected) and 0.8 or 1
                        OptItem.Text = "  " .. opt
                        OptItem.Font = THEME.FontMain
                        OptItem.TextSize = 10
                        OptItem.TextColor3 = (opt == selected) and THEME.Accent or THEME.TextMain
                        OptItem.TextXAlignment = Enum.TextXAlignment.Left
                        OptItem.AutoButtonColor = false
                        OptItem.Active = true
                        OptItem.ZIndex = 102
                        OptItem.Parent = MenuScroll

                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 4)
                        OptCorner.Parent = OptItem

                        OptItem.MouseEnter:Connect(function()
                            if opt ~= selected then
                                Tween(OptItem, {BackgroundTransparency = 0.9, TextColor3 = THEME.Accent}, 0.1)
                            end
                        end)

                        OptItem.MouseLeave:Connect(function()
                            if opt ~= selected then
                                Tween(OptItem, {BackgroundTransparency = 1, TextColor3 = THEME.TextMain}, 0.1)
                            end
                        end)

                        OptItem.MouseButton1Click:Connect(function()
                            selected = opt
                            SelLabel.Text = selected
                            callback(selected)
                            CloseDropdown()
                            RebuildOptions()
                        end)
                    end
                end

                RebuildOptions()

                DropBtn.MouseButton1Click:Connect(function()
                    if isOpen then
                        CloseDropdown()
                    else
                        OpenDropdown()
                    end
                end)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Title.TextColor3 = theme.TextMuted
                    DropBtn.BackgroundColor3 = theme.BgSidebar
                    DropStroke.Color = isOpen and theme.Accent or theme.CardBorder
                    SelLabel.TextColor3 = theme.TextMain
                    Arrow.TextColor3 = theme.TextMuted
                    MenuList.BackgroundColor3 = theme.CardBg
                    MenuStroke.Color = theme.Accent
                    MenuScroll.ScrollBarImageColor3 = theme.Accent
                    RebuildOptions()
                end)

                local controller = {
                    Set = function(v)
                        selected = v
                        SelLabel.Text = selected
                        callback(selected)
                        RebuildOptions()
                    end,
                    Get = function() return selected end,
                    Refresh = function(newOpts)
                        options = newOpts or {}
                        if not table.find(options, selected) then
                            selected = options[1] or ""
                            SelLabel.Text = selected
                        end
                        RebuildOptions()
                    end,
                    Type = "Dropdown"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddTextBox(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Input"
                local placeholder = cfg.Placeholder or "Enter text..."
                local def = cfg.Default or ""
                local flag = cfg.Flag or name
                local callback = cfg.Callback or function() end
                local value = def

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 46)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Frame, Card = Card})

                local Title = Instance.new("TextLabel")
                Title.Size = UDim2.new(1, 0, 0, 14)
                Title.Position = UDim2.new(0, 0, 0, 0)
                Title.BackgroundTransparency = 1
                Title.Text = name
                Title.Font = THEME.FontMain
                Title.TextSize = 10
                Title.TextColor3 = THEME.TextMuted
                Title.TextXAlignment = Enum.TextXAlignment.Left
                Title.Parent = Frame

                local BoxContainer = Instance.new("Frame")
                BoxContainer.Size = UDim2.new(1, 0, 0, 26)
                BoxContainer.Position = UDim2.new(0, 0, 0, 18)
                BoxContainer.BackgroundColor3 = THEME.BgSidebar
                BoxContainer.BorderSizePixel = 0
                BoxContainer.Parent = Frame

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = BoxContainer

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = THEME.CardBorder
                BoxStroke.Thickness = 1
                BoxStroke.Parent = BoxContainer

                local Input = Instance.new("TextBox")
                Input.Size = UDim2.new(1, -12, 1, 0)
                Input.Position = UDim2.new(0, 6, 0, 0)
                Input.BackgroundTransparency = 1
                Input.Text = def
                Input.PlaceholderText = placeholder
                Input.PlaceholderColor3 = THEME.TextMuted
                Input.Font = THEME.FontMain
                Input.TextSize = 10
                Input.TextColor3 = THEME.TextMain
                Input.TextXAlignment = Enum.TextXAlignment.Left
                Input.ClearTextOnFocus = false
                Input.Parent = BoxContainer

                Input.Focused:Connect(function()
                    Tween(BoxStroke, {Color = THEME.Accent}, 0.15)
                end)

                Input.FocusLost:Connect(function()
                    Tween(BoxStroke, {Color = THEME.CardBorder}, 0.15)
                    value = Input.Text
                    callback(value)
                end)

                Input:GetPropertyChangedSignal("Text"):Connect(function()
                    value = Input.Text
                end)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Title.TextColor3 = theme.TextMuted
                    BoxContainer.BackgroundColor3 = theme.BgSidebar
                    BoxStroke.Color = theme.CardBorder
                    Input.TextColor3 = theme.TextMain
                    Input.PlaceholderColor3 = theme.TextMuted
                end)

                local controller = {
                    Set = function(v)
                        value = tostring(v or "")
                        Input.Text = value
                        callback(value)
                    end,
                    Get = function() return value end,
                    Type = "TextBox"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddKeybind(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Keybind"
                local def = cfg.Default or Enum.KeyCode.RightShift
                local flag = cfg.Flag or name
                local callback = cfg.Callback or function() end
                local key = def
                local isBinding = false

                local Row = Instance.new("Frame")
                Row.Size = UDim2.new(1, 0, 0, 24)
                Row.BackgroundTransparency = 1
                Row.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Row, Card = Card})

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -80, 1, 0)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 10
                Label.TextColor3 = THEME.TextMain
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Row

                local KeyBtn = Instance.new("TextButton")
                KeyBtn.Size = UDim2.new(0, 75, 0, 20)
                KeyBtn.Position = UDim2.new(1, -75, 0.5, -10)
                KeyBtn.BackgroundColor3 = THEME.BgSidebar
                KeyBtn.Text = tostring(typeof(key) == "EnumItem" and key.Name or key)
                KeyBtn.Font = THEME.FontBold
                KeyBtn.TextSize = 9
                KeyBtn.TextColor3 = THEME.TextMuted
                KeyBtn.AutoButtonColor = false
                KeyBtn.Parent = Row

                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 4)
                KeyCorner.Parent = KeyBtn

                local KeyStroke = Instance.new("UIStroke")
                KeyStroke.Color = THEME.CardBorder
                KeyStroke.Thickness = 1
                KeyStroke.Parent = KeyBtn

                NamelessWare:RegisterKeybind({
                    Name = name,
                    Tab = currentTabName,
                    Key = tostring(typeof(key) == "EnumItem" and key.Name or key),
                    GetState = function() return true end
                })

                KeyBtn.MouseButton1Click:Connect(function()
                    if isBinding then return end
                    isBinding = true
                    KeyBtn.Text = "..."
                    Tween(KeyStroke, {Color = THEME.Accent}, 0.15)
                    Tween(KeyBtn, {TextColor3 = THEME.Accent}, 0.15)

                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input, gp)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            conn:Disconnect()
                            isBinding = false
                            key = input.KeyCode
                            KeyBtn.Text = key.Name
                            Tween(KeyStroke, {Color = THEME.CardBorder}, 0.15)
                            Tween(KeyBtn, {TextColor3 = THEME.TextMuted}, 0.15)
                            NamelessWare:RegisterKeybind({
                                Name = name,
                                Tab = currentTabName,
                                Key = key.Name,
                                GetState = function() return true end
                            })
                            callback(key)
                        end
                    end)
                end)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Label.TextColor3 = theme.TextMain
                    KeyBtn.BackgroundColor3 = theme.BgSidebar
                    KeyBtn.TextColor3 = isBinding and theme.Accent or theme.TextMuted
                    KeyStroke.Color = isBinding and theme.Accent or theme.CardBorder
                end)

                local controller = {
                    Set = function(newKey)
                        if typeof(newKey) == "EnumItem" then
                            key = newKey
                        elseif typeof(newKey) == "string" and Enum.KeyCode[newKey] then
                            key = Enum.KeyCode[newKey]
                        end
                        KeyBtn.Text = tostring(typeof(key) == "EnumItem" and key.Name or key)
                        NamelessWare:RegisterKeybind({
                            Name = name,
                            Tab = currentTabName,
                            Key = tostring(typeof(key) == "EnumItem" and key.Name or key),
                            GetState = function() return true end
                        })
                        callback(key)
                    end,
                    Get = function() return key end,
                    Type = "Keybind"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddColorPicker(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Color Picker"
                local defColor = cfg.Default or THEME.Accent
                local flag = cfg.Flag or name
                local callback = cfg.Callback or function() end
                local currentColor = defColor
                local isPickerOpen = false

                local ColorPickerRow = Instance.new("Frame")
                ColorPickerRow.Size = UDim2.new(1, 0, 0, 26)
                ColorPickerRow.AutomaticSize = Enum.AutomaticSize.Y
                ColorPickerRow.BackgroundTransparency = 1
                ColorPickerRow.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = ColorPickerRow, Card = Card})

                local HeaderRow = Instance.new("Frame")
                HeaderRow.Size = UDim2.new(1, 0, 0, 26)
                HeaderRow.BackgroundTransparency = 1
                HeaderRow.Parent = ColorPickerRow

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -95, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 10
                Label.TextColor3 = THEME.TextMain
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = HeaderRow

                local SwatchHolder = Instance.new("Frame")
                SwatchHolder.Size = UDim2.new(0, 90, 1, 0)
                SwatchHolder.Position = UDim2.new(1, -90, 0, 0)
                SwatchHolder.BackgroundTransparency = 1
                SwatchHolder.Parent = HeaderRow

                local SwatchBtn = Instance.new("TextButton")
                SwatchBtn.Size = UDim2.new(0, 16, 0, 16)
                SwatchBtn.Position = UDim2.new(1, -16, 0.5, -8)
                SwatchBtn.BackgroundColor3 = currentColor
                SwatchBtn.Text = ""
                SwatchBtn.AutoButtonColor = false
                SwatchBtn.Parent = SwatchHolder

                local SwatchCorner = Instance.new("UICorner")
                SwatchCorner.CornerRadius = UDim.new(1, 0)
                SwatchCorner.Parent = SwatchBtn

                local SwatchStroke = Instance.new("UIStroke")
                SwatchStroke.Color = THEME.CardBorder
                SwatchStroke.Thickness = 1.5
                SwatchStroke.Parent = SwatchBtn

                local HexLabel = Instance.new("TextLabel")
                HexLabel.Size = UDim2.new(1, -22, 1, 0)
                HexLabel.Position = UDim2.new(0, 0, 0, 0)
                HexLabel.BackgroundTransparency = 1
                HexLabel.Text = "#" .. currentColor:ToHex():upper()
                HexLabel.Font = THEME.FontMain
                HexLabel.TextSize = 9
                HexLabel.TextColor3 = THEME.TextMuted
                HexLabel.TextXAlignment = Enum.TextXAlignment.Right
                HexLabel.Parent = SwatchHolder

                local PickerPanel = Instance.new("Frame")
                PickerPanel.Size = UDim2.new(1, 0, 0, 0)
                PickerPanel.Position = UDim2.new(0, 0, 0, 28)
                PickerPanel.BackgroundColor3 = THEME.BgSidebar
                PickerPanel.BorderSizePixel = 0
                PickerPanel.ClipsDescendants = true
                PickerPanel.Visible = false
                PickerPanel.Parent = ColorPickerRow

                local PanelCorner = Instance.new("UICorner")
                PanelCorner.CornerRadius = UDim.new(0, 8)
                PanelCorner.Parent = PickerPanel

                local PanelStroke = Instance.new("UIStroke")
                PanelStroke.Color = THEME.CardBorder
                PanelStroke.Thickness = 1
                PanelStroke.Parent = PickerPanel

                local PanelPadding = Instance.new("UIPadding")
                PanelPadding.PaddingTop = UDim.new(0, 8)
                PanelPadding.PaddingBottom = UDim.new(0, 8)
                PanelPadding.PaddingLeft = UDim.new(0, 8)
                PanelPadding.PaddingRight = UDim.new(0, 8)
                PanelPadding.Parent = PickerPanel

                local currentHue, currentSat, currentVal = Color3.toHSV(currentColor)

                local Wheel = Instance.new("ImageButton")
                Wheel.Name = "ColorWheel"
                Wheel.Size = UDim2.new(0, 82, 0, 82)
                Wheel.Position = UDim2.new(0, 0, 0, 0)
                Wheel.BackgroundTransparency = 1
                Wheel.Image = "rbxassetid://6020299385"
                Wheel.AutoButtonColor = false
                Wheel.Parent = PickerPanel

                local WheelCorner = Instance.new("UICorner")
                WheelCorner.CornerRadius = UDim.new(1, 0)
                WheelCorner.Parent = Wheel

                local WheelStroke = Instance.new("UIStroke")
                WheelStroke.Color = Color3.fromRGB(45, 45, 60)
                WheelStroke.Thickness = 1.2
                WheelStroke.Parent = Wheel

                local WheelDot = Instance.new("Frame")
                WheelDot.Name = "Dot"
                WheelDot.Size = UDim2.new(0, 10, 0, 10)
                WheelDot.AnchorPoint = Vector2.new(0.5, 0.5)
                WheelDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                WheelDot.BorderSizePixel = 0
                WheelDot.Active = false
                WheelDot.Parent = Wheel

                local DotCorner = Instance.new("UICorner")
                DotCorner.CornerRadius = UDim.new(1, 0)
                DotCorner.Parent = WheelDot

                local DotStroke = Instance.new("UIStroke")
                DotStroke.Color = Color3.fromRGB(0, 0, 0)
                DotStroke.Thickness = 1.5
                DotStroke.Parent = WheelDot

                local RightControls = Instance.new("Frame")
                RightControls.Size = UDim2.new(1, -90, 0, 82)
                RightControls.Position = UDim2.new(0, 90, 0, 0)
                RightControls.BackgroundTransparency = 1
                RightControls.Parent = PickerPanel

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.Padding = UDim.new(0, 6)
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Parent = RightControls

                local SwatchGrid = Instance.new("Frame")
                SwatchGrid.Size = UDim2.new(1, 0, 0, 16)
                SwatchGrid.BackgroundTransparency = 1
                SwatchGrid.Parent = RightControls

                local GridLay = Instance.new("UIListLayout")
                GridLay.FillDirection = Enum.FillDirection.Horizontal
                GridLay.Padding = UDim.new(0, 4)
                GridLay.Parent = SwatchGrid

                local QuickColors = {
                    Color3.fromRGB(165, 95, 255),
                    Color3.fromRGB(130, 90, 255),
                    Color3.fromRGB(0, 225, 255),
                    Color3.fromRGB(0, 230, 135),
                    Color3.fromRGB(255, 65, 150),
                    Color3.fromRGB(255, 45, 75),
                    Color3.fromRGB(255, 180, 35),
                    Color3.fromRGB(255, 255, 255),
                }

                local ValRow = Instance.new("Frame")
                ValRow.Size = UDim2.new(1, 0, 0, 20)
                ValRow.BackgroundTransparency = 1
                ValRow.Parent = RightControls

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(0, 48, 1, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = "Light"
                ValLabel.Font = THEME.FontMain
                ValLabel.TextSize = 9
                ValLabel.TextColor3 = THEME.TextMuted
                ValLabel.TextXAlignment = Enum.TextXAlignment.Left
                ValLabel.Parent = ValRow

                local ValTrack = Instance.new("TextButton")
                ValTrack.Size = UDim2.new(1, -52, 0, 6)
                ValTrack.Position = UDim2.new(0, 52, 0.5, -3)
                ValTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ValTrack.Text = ""
                ValTrack.AutoButtonColor = false
                ValTrack.Parent = ValRow

                local ValCorner = Instance.new("UICorner")
                ValCorner.CornerRadius = UDim.new(1, 0)
                ValCorner.Parent = ValTrack

                local ValGrad = Instance.new("UIGradient")
                ValGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, currentSat, 1))
                })
                ValGrad.Parent = ValTrack

                local ValThumb = Instance.new("Frame")
                ValThumb.Size = UDim2.new(0, 10, 0, 10)
                ValThumb.AnchorPoint = Vector2.new(0.5, 0.5)
                ValThumb.Position = UDim2.new(currentVal, 0, 0.5, 0)
                ValThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ValThumb.BorderSizePixel = 0
                ValThumb.Parent = ValTrack

                local ValThumbCorner = Instance.new("UICorner")
                ValThumbCorner.CornerRadius = UDim.new(1, 0)
                ValThumbCorner.Parent = ValThumb

                local ValThumbStroke = Instance.new("UIStroke")
                ValThumbStroke.Color = Color3.fromRGB(0, 0, 0)
                ValThumbStroke.Thickness = 1
                ValThumbStroke.Parent = ValThumb

                local PreviewBar = Instance.new("Frame")
                PreviewBar.Size = UDim2.new(1, 0, 0, 20)
                PreviewBar.BackgroundColor3 = currentColor
                PreviewBar.BorderSizePixel = 0
                PreviewBar.Parent = RightControls

                local PreviewCorner = Instance.new("UICorner")
                PreviewCorner.CornerRadius = UDim.new(0, 5)
                PreviewCorner.Parent = PreviewBar

                local PreviewStroke = Instance.new("UIStroke")
                PreviewStroke.Color = THEME.CardBorder
                PreviewStroke.Thickness = 1
                PreviewStroke.Parent = PreviewBar

                local PreviewHex = Instance.new("TextLabel")
                PreviewHex.Size = UDim2.new(1, 0, 1, 0)
                PreviewHex.BackgroundTransparency = 1
                PreviewHex.Text = "#" .. currentColor:ToHex():upper()
                PreviewHex.Font = THEME.FontBold
                PreviewHex.TextSize = 9
                PreviewHex.TextColor3 = (currentVal > 0.5) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
                PreviewHex.Parent = PreviewBar

                local function UpdateDotPosition()
                    local radius = ((Wheel.AbsoluteSize.X > 0 and Wheel.AbsoluteSize.X or 82) / 2)
                    local angle = currentHue * math.pi * 2
                    local clampedDist = currentSat * radius
                    local dotX = radius + math.cos(angle) * clampedDist
                    local dotY = radius + math.sin(angle) * clampedDist
                    WheelDot.Position = UDim2.new(0, dotX, 0, dotY)
                end

                local function UpdateColor(col, triggerCallback)
                    currentColor = col
                    currentHue, currentSat, currentVal = Color3.toHSV(col)
                    SwatchBtn.BackgroundColor3 = currentColor
                    HexLabel.Text = "#" .. currentColor:ToHex():upper()
                    PreviewBar.BackgroundColor3 = currentColor
                    PreviewHex.Text = "#" .. currentColor:ToHex():upper()
                    PreviewHex.TextColor3 = (currentVal > 0.5) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)

                    ValGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, currentSat, 1))
                    })
                    ValThumb.Position = UDim2.new(currentVal, 0, 0.5, 0)
                    UpdateDotPosition()

                    if triggerCallback ~= false then
                        callback(currentColor)
                    end
                end

                for _, qCol in ipairs(QuickColors) do
                    local QBtn = Instance.new("TextButton")
                    QBtn.Size = UDim2.new(0, 14, 0, 14)
                    QBtn.BackgroundColor3 = qCol
                    QBtn.Text = ""
                    QBtn.AutoButtonColor = false
                    QBtn.Parent = SwatchGrid

                    local QCorner = Instance.new("UICorner")
                    QCorner.CornerRadius = UDim.new(1, 0)
                    QCorner.Parent = QBtn

                    local QStroke = Instance.new("UIStroke")
                    QStroke.Color = Color3.fromRGB(50, 50, 65)
                    QStroke.Thickness = 1
                    QStroke.Parent = QBtn

                    QBtn.MouseButton1Click:Connect(function()
                        UpdateColor(qCol, true)
                    end)
                end

                local wheelDragging = false
                local valDragging = false

                local function UpdateFromWheelPos(screenX, screenY)
                    local wheelAbsPos = Wheel.AbsolutePosition
                    local wheelAbsSize = Wheel.AbsoluteSize
                    local radius = (wheelAbsSize.X > 0 and wheelAbsSize.X or 82) / 2
                    local center = wheelAbsPos + Vector2.new(radius, radius)

                    local delta = Vector2.new(screenX, screenY) - center
                    local dist = delta.Magnitude
                    local clampedDist = math.clamp(dist, 0, radius)

                    local angle = math.atan2(delta.Y, delta.X)
                    if angle < 0 then angle = angle + (math.pi * 2) end

                    currentHue = (angle / (math.pi * 2)) % 1
                    currentSat = math.clamp(clampedDist / radius, 0, 1)

                    local dotX = radius + math.cos(angle) * clampedDist
                    local dotY = radius + math.sin(angle) * clampedDist
                    WheelDot.Position = UDim2.new(0, dotX, 0, dotY)

                    currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
                    SwatchBtn.BackgroundColor3 = currentColor
                    HexLabel.Text = "#" .. currentColor:ToHex():upper()
                    PreviewBar.BackgroundColor3 = currentColor
                    PreviewHex.Text = "#" .. currentColor:ToHex():upper()
                    PreviewHex.TextColor3 = (currentVal > 0.5) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)

                    ValGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(currentHue, currentSat, 1))
                    })

                    callback(currentColor)
                end

                local function UpdateFromValPos(screenX)
                    local trackAbsPos = ValTrack.AbsolutePosition
                    local trackAbsSize = ValTrack.AbsoluteSize
                    local percent = math.clamp((screenX - trackAbsPos.X) / (trackAbsSize.X > 0 and trackAbsSize.X or 1), 0, 1)
                    currentVal = percent

                    ValThumb.Position = UDim2.new(currentVal, 0, 0.5, 0)

                    currentColor = Color3.fromHSV(currentHue, currentSat, currentVal)
                    SwatchBtn.BackgroundColor3 = currentColor
                    HexLabel.Text = "#" .. currentColor:ToHex():upper()
                    PreviewBar.BackgroundColor3 = currentColor
                    PreviewHex.Text = "#" .. currentColor:ToHex():upper()
                    PreviewHex.TextColor3 = (currentVal > 0.5) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)

                    callback(currentColor)
                end

                local wheelId = {}
                local valId = {}

                Wheel.MouseButton1Down:Connect(function(x, y)
                    if ActiveDragSession ~= nil and ActiveDragSession ~= wheelId then return end
                    ActiveDragSession = wheelId
                    wheelDragging = true
                    UpdateFromWheelPos(x, y)
                end)

                Wheel.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if ActiveDragSession ~= nil and ActiveDragSession ~= wheelId then return end
                        ActiveDragSession = wheelId
                        wheelDragging = true
                        UpdateFromWheelPos(input.Position.X, input.Position.Y)
                    end
                end)

                ValTrack.MouseButton1Down:Connect(function(x, y)
                    if ActiveDragSession ~= nil and ActiveDragSession ~= valId then return end
                    ActiveDragSession = valId
                    valDragging = true
                    UpdateFromValPos(x)
                end)

                ValTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if ActiveDragSession ~= nil and ActiveDragSession ~= valId then return end
                        ActiveDragSession = valId
                        valDragging = true
                        UpdateFromValPos(input.Position.X)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if ActiveDragSession == wheelId and wheelDragging then
                            UpdateFromWheelPos(input.Position.X, input.Position.Y)
                        elseif ActiveDragSession == valId and valDragging then
                            UpdateFromValPos(input.Position.X)
                        end
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if ActiveDragSession == wheelId then
                            ActiveDragSession = nil
                            wheelDragging = false
                        elseif ActiveDragSession == valId then
                            ActiveDragSession = nil
                            valDragging = false
                        end
                    end
                end)

                local function TogglePicker()
                    isPickerOpen = not isPickerOpen
                    if isPickerOpen then
                        UpdateColor(currentColor, false)
                        PickerPanel.Visible = true
                        Tween(PickerPanel, {Size = UDim2.new(1, 0, 0, 100)}, 0.18)
                        Tween(SwatchStroke, {Color = THEME.Accent}, 0.15)
                    else
                        local tw = Tween(PickerPanel, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        tw.Completed:Connect(function()
                            if not isPickerOpen then PickerPanel.Visible = false end
                        end)
                        Tween(SwatchStroke, {Color = THEME.CardBorder}, 0.15)
                    end
                end

                SwatchBtn.MouseButton1Click:Connect(TogglePicker)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Label.TextColor3 = theme.TextMain
                    HexLabel.TextColor3 = theme.TextMuted
                    PickerPanel.BackgroundColor3 = theme.BgSidebar
                    PanelStroke.Color = theme.CardBorder
                    SwatchStroke.Color = isPickerOpen and theme.Accent or theme.CardBorder
                end)

                local controller = {
                    Set = function(newCol)
                        if typeof(newCol) == "Color3" then
                            UpdateColor(newCol, false)
                        end
                    end,
                    Get = function() return currentColor end,
                    Type = "ColorPicker"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

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
                table.insert(RegisteredItems, {Name = text, Element = Btn, Card = Card})

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 7)
                BtnCorner.Parent = Btn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = THEME.CardBorder
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn

                Btn.MouseEnter:Connect(function()
                    Tween(Btn, {BackgroundColor3 = THEME.CardBg}, 0.2)
                    Tween(BtnStroke, {Color = THEME.Accent}, 0.2)
                end)

                Btn.MouseLeave:Connect(function()
                    Tween(Btn, {BackgroundColor3 = THEME.BgSidebar}, 0.2)
                    Tween(BtnStroke, {Color = THEME.CardBorder}, 0.2)
                end)

                Btn.MouseButton1Click:Connect(function()
                    Tween(Btn, {BackgroundColor3 = THEME.Accent}, 0.1)
                    task.wait(0.1)
                    Tween(Btn, {BackgroundColor3 = THEME.BgSidebar}, 0.2)
                    callback()
                end)

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Btn.BackgroundColor3 = theme.BgSidebar
                    Btn.TextColor3 = theme.TextMain
                    BtnStroke.Color = theme.CardBorder
                end)
            end

            return Controls
        end

        return TabMethods
    end

    function Window:CreateSettingsTab(customConfig)
        customConfig = customConfig or {}
        local categoryName = customConfig.Category or "Misc"
        local tabName = customConfig.Name or "Settings"
        local tabIcon = customConfig.Icon or "rbxassetid://10709791437"
        local tabSubtitle = customConfig.Subtitle or "Profiles, Themes & Menu Controls"

        self:AddCategory(categoryName)

        local SettingsTab = self:CreateTab({
            Name = tabName,
            Icon = tabIcon,
            Subtitle = tabSubtitle
        })

        local ConfigSec = SettingsTab:CreateSection("Profile Manager", "rbxassetid://10709791437", "Left")
        SaveManager:BuildConfigSection(ConfigSec)

        local ThemeSec = SettingsTab:CreateSection("Theme Customizer", "rbxassetid://10709791437", "Right")
        ThemeManager:BuildThemeSection(ThemeSec)

        local MenuSec = SettingsTab:CreateSection("Menu Controls", "rbxassetid://10734950309", "Left")
        SettingsManager:BuildSettingsSection(MenuSec)

        SaveManager:AutoLoad()

        return SettingsTab
    end

    return Window
end

return NamelessWare
