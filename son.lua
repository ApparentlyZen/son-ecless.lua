local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local function GetSafeParent()
    local success, result = pcall(function()
        if gethui then return gethui() end
        return CoreGui
    end)
    if success and result then return result end
    return LocalPlayer:WaitForChild("PlayerGui")
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

-- =========================================================
-- THEME DEFINITIONS & PRESETS
-- =========================================================
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

-- =========================================================
-- MAIN LIBRARY OBJECT
-- =========================================================
local NamelessWare = {
    Flags = {},
    ThemeSubscribers = {},
    CurrentTheme = "Nameless Violet",
    ToggleKey = Enum.KeyCode.RightShift,
    ActiveWindow = nil,
    Notifications = nil,
}
NamelessWare.__index = NamelessWare

-- =========================================================
-- THEME MANAGER
-- =========================================================
local ThemeManager = {
    Folder = "NamelessWare/Themes",
    CurrentCustom = {
        R = 165,
        G = 95,
        B = 255
    }
}

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
            -- Try load custom theme from disk
            themeData = self:LoadCustomThemeData(themeNameOrData)
            if themeData then
                themeTitle = themeNameOrData
                NamelessWare.CurrentTheme = themeNameOrData
            end
        end
    elseif type(themeNameOrData) == "table" then
        themeData = themeNameOrData
        NamelessWare.CurrentTheme = "Custom"
    end

    if not themeData then return false end

    -- Update active THEME table
    for k, v in pairs(themeData) do
        THEME[k] = v
    end

    -- Trigger reactive updates on all registered elements
    for _, subscriber in ipairs(NamelessWare.ThemeSubscribers) do
        pcall(function()
            subscriber(THEME)
        end)
    end

    if not silent and NamelessWare.Notify then
        NamelessWare:Notify({
            Title = "Theme Applied",
            Content = "Activated theme: " .. themeTitle,
            Duration = 2.5,
            Type = "Success"
        })
    end

    return true
end

function ThemeManager:SetCustomAccent(r, g, b, silent)
    r = math.clamp(r or 165, 0, 255)
    g = math.clamp(g or 95, 0, 255)
    b = math.clamp(b or 255, 0, 255)

    self.CurrentCustom.R = r
    self.CurrentCustom.G = g
    self.CurrentCustom.B = b

    local accent = Color3.fromRGB(r, g, b)
    local h, s, v = accent:ToHSV()
    local accentGrad = Color3.fromHSV(h, math.clamp(s * 0.75, 0, 1), math.clamp(v * 1.1, 0, 1))
    local accentDark = Color3.fromHSV(h, math.clamp(s * 1.15, 0, 1), math.clamp(v * 0.75, 0, 1))

    local customData = {
        Accent = accent,
        AccentGradient = accentGrad,
        AccentDark = accentDark,
        BgMain = THEME.BgMain,
        BgMainGradient = THEME.BgMainGradient,
        BgSidebar = THEME.BgSidebar,
        CardBg = THEME.CardBg,
        CardBgGradient = THEME.CardBgGradient,
        CardBorder = THEME.CardBorder,
        TextMain = THEME.TextMain,
        TextMuted = THEME.TextMuted,
        CircleOff = THEME.CircleOff,
        CircleOffBorder = THEME.CircleOffBorder
    }

    self:ApplyTheme(customData, silent or true)
end

function ThemeManager:SaveCustomTheme(name)
    if not name or name == "" then return false end
    EnsureFolder(self.Folder)

    local saveData = {
        R = self.CurrentCustom.R,
        G = self.CurrentCustom.G,
        B = self.CurrentCustom.B,
    }

    local jsonStr = HttpService:JSONEncode(saveData)
    local path = self.Folder .. "/" .. name .. ".json"

    if writefile then
        local success, err = pcall(function()
            writefile(path, jsonStr)
        end)
        if success then
            NamelessWare:Notify({
                Title = "Theme Saved",
                Content = "Custom theme '" .. name .. "' saved successfully!",
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
            local decSuccess, parsed = pcall(function() return HttpService:JSONDecode(content) end)
            if decSuccess and parsed and parsed.R then
                local r, g, b = parsed.R, parsed.G, parsed.B
                local accent = Color3.fromRGB(r, g, b)
                local h, s, v = accent:ToHSV()
                return {
                    Accent = accent,
                    AccentGradient = Color3.fromHSV(h, math.clamp(s * 0.75, 0, 1), math.clamp(v * 1.1, 0, 1)),
                    AccentDark = Color3.fromHSV(h, math.clamp(s * 1.15, 0, 1), math.clamp(v * 0.75, 0, 1)),
                    BgMain = THEME.BgMain,
                    BgMainGradient = THEME.BgMainGradient,
                    BgSidebar = THEME.BgSidebar,
                    CardBg = THEME.CardBg,
                    CardBgGradient = THEME.CardBgGradient,
                    CardBorder = THEME.CardBorder,
                    TextMain = THEME.TextMain,
                    TextMuted = THEME.TextMuted,
                    CircleOff = THEME.CircleOff,
                    CircleOffBorder = THEME.CircleOffBorder
                }
            end
        end
    end
    return nil
end

function ThemeManager:GetCustomThemes()
    local list = {}
    EnsureFolder(self.Folder)
    if listfiles and isfolder and isfolder(self.Folder) then
        local success, files = pcall(function() return listfiles(self.Folder) end)
        if success and type(files) == "table" then
            for _, f in ipairs(files) do
                local fileName = f:match("([^/\\]+)%.json$")
                if fileName then
                    table.insert(list, fileName)
                end
            end
        end
    end
    if #list == 0 then
        table.insert(list, "None")
    end
    return list
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

    Section:AddSubHeader("Custom Accent Creator", "rbxassetid://10734975692")

    local SliderR, SliderG, SliderB

    local function OnColorSliderChanged()
        local r = SliderR and SliderR.Get and SliderR.Get() or self.CurrentCustom.R
        local g = SliderG and SliderG.Get and SliderG.Get() or self.CurrentCustom.G
        local b = SliderB and SliderB.Get and SliderB.Get() or self.CurrentCustom.B
        self:SetCustomAccent(r, g, b, true)
    end

    SliderR = Section:AddSlider({
        Name = "Red (R)",
        Min = 0,
        Max = 255,
        Default = self.CurrentCustom.R,
        Callback = function() OnColorSliderChanged() end
    })

    SliderG = Section:AddSlider({
        Name = "Green (G)",
        Min = 0,
        Max = 255,
        Default = self.CurrentCustom.G,
        Callback = function() OnColorSliderChanged() end
    })

    SliderB = Section:AddSlider({
        Name = "Blue (B)",
        Min = 0,
        Max = 255,
        Default = self.CurrentCustom.B,
        Callback = function() OnColorSliderChanged() end
    })

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
                    CustomThemeDropdown.Refresh(self:GetCustomThemes())
                end
            end
        end
    })

    local selectedCustom = "None"
    CustomThemeDropdown = Section:AddDropdown({
        Name = "Saved Themes",
        Options = self:GetCustomThemes(),
        Default = self:GetCustomThemes()[1] or "None",
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
                    CustomThemeDropdown.Refresh(self:GetCustomThemes())
                end
            end
        end
    })
end

-- =========================================================
-- SAVE / CONFIG MANAGER
-- =========================================================
local SaveManager = {
    Folder = "NamelessWare/Configs",
    AutoLoadPath = "NamelessWare/Configs/autoload.txt",
    InMemoryConfigs = {}
}

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
        -- Fallback in-memory
        for name, _ in pairs(self.InMemoryConfigs) do
            table.insert(list, name)
        end
    end

    if #list == 0 then
        table.insert(list, "None")
    end
    table.sort(list)
    return list
end

function SaveManager:Save(name)
    if not name or name == "" or name == "None" then
        NamelessWare:Notify({
            Title = "Save Error",
            Content = "Please enter a valid configuration name.",
            Duration = 2.5,
            Type = "Warning"
        })
        return false
    end

    EnsureFolder(self.Folder)

    local data = {}
    for flagName, flagObj in pairs(NamelessWare.Flags) do
        if flagObj.Get then
            data[flagName] = {
                Type = flagObj.Type,
                Value = flagObj.Get()
            }
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
                Content = "Configuration '" .. name .. "' successfully saved!",
                Duration = 2.5,
                Type = "Success"
            })
            return true
        else
            NamelessWare:Notify({
                Title = "Save Failed",
                Content = "Could not write config file.",
                Duration = 2.5,
                Type = "Error"
            })
        end
    else
        self.InMemoryConfigs[name] = data
        NamelessWare:Notify({
            Title = "Config Saved (Memory)",
            Content = "Configuration '" .. name .. "' saved in memory.",
            Duration = 2.5,
            Type = "Success"
        })
        return true
    end

    return false
end

function SaveManager:Load(name)
    if not name or name == "" or name == "None" then
        NamelessWare:Notify({
            Title = "Load Error",
            Content = "Please select a valid configuration to load.",
            Duration = 2.5,
            Type = "Warning"
        })
        return false
    end

    local parsedData = nil
    local path = self.Folder .. "/" .. name .. ".json"

    if isfile and isfile(path) and readfile then
        local success, content = pcall(function() return readfile(path) end)
        if success and content then
            local decSuccess, decoded = pcall(function() return HttpService:JSONDecode(content) end)
            if decSuccess and type(decoded) == "table" then
                parsedData = decoded
            end
        end
    elseif self.InMemoryConfigs[name] then
        parsedData = self.InMemoryConfigs[name]
    end

    if not parsedData then
        NamelessWare:Notify({
            Title = "Load Failed",
            Content = "Config file '" .. name .. "' not found or corrupted.",
            Duration = 2.5,
            Type = "Error"
        })
        return false
    end

    -- Apply values to registered flags
    for flagName, item in pairs(parsedData) do
        local flagObj = NamelessWare.Flags[flagName]
        if flagObj and flagObj.Set then
            pcall(function()
                local val = (type(item) == "table" and item.Value ~= nil) and item.Value or item
                flagObj.Set(val)
            end)
        end
    end

    NamelessWare:Notify({
        Title = "Config Loaded",
        Content = "Loaded configuration '" .. name .. "' successfully!",
        Duration = 2.5,
        Type = "Success"
    })
    return true
end

function SaveManager:Delete(name)
    if not name or name == "" or name == "None" then return false end
    local path = self.Folder .. "/" .. name .. ".json"

    if isfile and isfile(path) and delfile then
        local success = pcall(function() delfile(path) end)
        if success then
            NamelessWare:Notify({
                Title = "Config Deleted",
                Content = "Configuration '" .. name .. "' was deleted.",
                Duration = 2.5,
                Type = "Info"
            })
            return true
        end
    elseif self.InMemoryConfigs[name] then
        self.InMemoryConfigs[name] = nil
        NamelessWare:Notify({
            Title = "Config Deleted",
            Content = "Configuration '" .. name .. "' deleted from memory.",
            Duration = 2.5,
            Type = "Info"
        })
        return true
    end

    return false
end

function SaveManager:SetAutoLoad(name)
    EnsureFolder(self.Folder)
    if name and name ~= "" and name ~= "None" then
        if writefile then
            pcall(function() writefile(self.AutoLoadPath, name) end)
        end
        NamelessWare:Notify({
            Title = "Auto-Load Set",
            Content = "Config '" .. name .. "' will auto-load on start.",
            Duration = 2.5,
            Type = "Success"
        })
    else
        if isfile and isfile(self.AutoLoadPath) and delfile then
            pcall(function() delfile(self.AutoLoadPath) end)
        end
        NamelessWare:Notify({
            Title = "Auto-Load Disabled",
            Content = "Auto-load has been cleared.",
            Duration = 2.5,
            Type = "Info"
        })
    end
end

function SaveManager:GetAutoLoad()
    if isfile and isfile(self.AutoLoadPath) and readfile then
        local success, content = pcall(function() return readfile(self.AutoLoadPath) end)
        if success and content and content ~= "" then
            return content
        end
    end
    return nil
end

function SaveManager:AutoLoad()
    local autoName = self:GetAutoLoad()
    if autoName and autoName ~= "" and autoName ~= "None" then
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
                    ConfigDropdown.Refresh(self:GetConfigs())
                end
            end
        end
    })

    local selectedConfig = self:GetConfigs()[1] or "None"

    ConfigDropdown = Section:AddDropdown({
        Name = "Select Config",
        Options = self:GetConfigs(),
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
                    ConfigDropdown.Refresh(self:GetConfigs())
                end
            end
        end
    })

    Section:AddButton({
        Name = "Refresh Config List",
        Callback = function()
            if ConfigDropdown and ConfigDropdown.Refresh then
                ConfigDropdown.Refresh(self:GetConfigs())
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
    ToggleKey = Enum.KeyCode.RightShift,
    MobileVisible = true
}

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

ThemeManager:SetLibrary(NamelessWare)
SaveManager:SetLibrary(NamelessWare)
SettingsManager:SetLibrary(NamelessWare)

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
    local toastType = cfg.Type or "Info" -- Success, Info, Warning, Error

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

    -- Entrance animation
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
    if syn and syn.protect_gui then
        pcall(function() syn.protect_gui(ScreenGui) end)
    end
    ScreenGui.Parent = GetSafeParent()
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
    NavScroll.Size = UDim2.new(1, -14, 1, -58)
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

    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = "HeaderFrame"
    HeaderFrame.Size = UDim2.new(1, -165, 0, 48)
    HeaderFrame.Position = UDim2.new(0, 160, 0, 4)
    HeaderFrame.BackgroundTransparency = 1
    HeaderFrame.Parent = MainWindow

    local RegisteredItems = {}
    local RegisteredCards = {}

    local HeaderTabTitle = Instance.new("TextLabel")
    HeaderTabTitle.Size = UDim2.new(1, -185, 0, 20)
    HeaderTabTitle.Position = UDim2.new(0, 6, 0, 6)
    HeaderTabTitle.BackgroundTransparency = 1
    HeaderTabTitle.Text = "Combat"
    HeaderTabTitle.Font = THEME.FontBold
    HeaderTabTitle.TextSize = 15
    HeaderTabTitle.TextColor3 = THEME.TextMain
    HeaderTabTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTabTitle.Parent = HeaderFrame

    local HeaderTabSub = Instance.new("TextLabel")
    HeaderTabSub.Size = UDim2.new(1, -185, 0, 14)
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
    SearchContainer.Size = UDim2.new(0, 160, 0, 26)
    SearchContainer.Position = UDim2.new(1, -168, 0.5, -13)
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
    SearchInput.Size = UDim2.new(1, -46, 1, 0)
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
    ClearSearchBtn.Position = UDim2.new(1, -20, 0.5, -8)
    ClearSearchBtn.BackgroundTransparency = 1
    ClearSearchBtn.Text = "✕"
    ClearSearchBtn.Font = THEME.FontBold
    ClearSearchBtn.TextSize = 9
    ClearSearchBtn.TextColor3 = THEME.TextMuted
    ClearSearchBtn.Visible = false
    ClearSearchBtn.Parent = SearchContainer

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
            MainWindow.Position = UDim2.new(0.5, -300, 0.5, -190)
            Tween(MainWindow, {Position = UDim2.new(0.5, -300, 0.5, -222)}, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            if ActiveDropdown then
                ActiveDropdown()
            end
            Tween(MainWindow, {Position = UDim2.new(0.5, -300, 0.5, -190)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.wait(0.2)
            if not isUIOpen then
                MainWindow.Visible = false
            end
        end
    end

    -- Menu toggle keybind listener
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == NamelessWare.ToggleKey then
            ToggleUI()
        end
    end)

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

    NamelessWare.ActiveWindow = Window

    -- Register Theme Subscriber for Window elements
    table.insert(NamelessWare.ThemeSubscribers, function(theme)
        MobileBtn.BackgroundColor3 = theme.BgSidebar
        MobileBtnStroke.Color = theme.Accent
        MainWindow.BackgroundColor3 = theme.BgMain
        MainGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, theme.BgMainGradient),
            ColorSequenceKeypoint.new(1, theme.BgMain)
        })
        MainStroke.Color = theme.CardBorder
        Sidebar.BackgroundColor3 = theme.BgSidebar
        SidebarStroke.Color = theme.CardBorder
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
        ClearSearchBtn.TextColor3 = theme.TextMuted
    end)

    local FirstTab = true

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

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local name = tabConfig.Name or "Tab"
        local iconId = tabConfig.Icon or "rbxassetid://10734975692"
        local subText = tabConfig.Subtitle or (name .. " - default hotkeys")

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = THEME.Accent
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

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = name .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = THEME.Accent
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

        -- Theme subscriber for Tab
        table.insert(NamelessWare.ThemeSubscribers, function(theme)
            TabBtn.BackgroundColor3 = theme.Accent
            TabGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, theme.AccentGradient),
                ColorSequenceKeypoint.new(1, theme.AccentDark)
            })
            TabPage.ScrollBarImageColor3 = theme.Accent
            if TabObject.IsActive then
                TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            else
                TabLabel.TextColor3 = theme.TextMuted
                TabIcon.ImageColor3 = theme.TextMuted
            end
        end)

        if FirstTab then
            FirstTab = false
            ActivateTab()
        end

        local TabMethods = {}

        function TabMethods:CreateSection(secTitle, secIcon)
            local Card = Instance.new("Frame")
            Card.Size = UDim2.new(0.5, -4, 0, 0)
            Card.AutomaticSize = Enum.AutomaticSize.Y
            Card.BackgroundColor3 = THEME.CardBg
            Card.BorderSizePixel = 0
            Card.ClipsDescendants = false
            Card.ZIndex = 1
            Card.Parent = ColumnsHolder
            table.insert(RegisteredCards, Card)

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
            CardPadding.PaddingBottom = UDim.new(0, 14)
            CardPadding.PaddingLeft = UDim.new(0, 11)
            CardPadding.PaddingRight = UDim.new(0, 11)
            CardPadding.Parent = Card

            local CardLayout = Instance.new("UIListLayout")
            CardLayout.Padding = UDim.new(0, 7)
            CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
            CardLayout.Parent = Card

            local Header = Instance.new("Frame")
            Header.Size = UDim2.new(1, 0, 0, 22)
            Header.BackgroundTransparency = 1
            Header.Parent = Card

            local HeaderIcon = Instance.new("ImageLabel")
            HeaderIcon.Size = UDim2.new(0, 14, 0, 14)
            HeaderIcon.Position = UDim2.new(0, 0, 0.5, -7)
            HeaderIcon.BackgroundTransparency = 1
            HeaderIcon.Image = secIcon or "rbxassetid://10734975692"
            HeaderIcon.ImageColor3 = THEME.Accent
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

            -- Theme subscriber for Card
            table.insert(NamelessWare.ThemeSubscribers, function(theme)
                Card.BackgroundColor3 = theme.CardBg
                CardGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, theme.CardBgGradient),
                    ColorSequenceKeypoint.new(1, theme.CardBg)
                })
                CardStroke.Color = theme.CardBorder
                HeaderIcon.ImageColor3 = theme.Accent
                HeaderLabel.TextColor3 = theme.TextMain
            end)

            local Controls = {}

            function Controls:AddSubHeader(title, icon)
                local SubHeader = Instance.new("Frame")
                SubHeader.Size = UDim2.new(1, 0, 0, 24)
                SubHeader.BackgroundTransparency = 1
                SubHeader.Parent = Card

                local SubIcon = Instance.new("ImageLabel")
                SubIcon.Size = UDim2.new(0, 12, 0, 12)
                SubIcon.Position = UDim2.new(0, 0, 0.5, -6)
                SubIcon.BackgroundTransparency = 1
                SubIcon.Image = icon or "rbxassetid://10734975692"
                SubIcon.ImageColor3 = THEME.Accent
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

                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    SubIcon.ImageColor3 = theme.Accent
                    SubText.TextColor3 = theme.TextMain
                end)
            end

            function Controls:AddToggle(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Toggle"
                local state = cfg.Default or false
                local flag = cfg.Flag or name
                local keybind = cfg.Keybind
                local callback = cfg.Callback or function() end
                local colorBox = cfg.Color

                local RowBtn = Instance.new("TextButton")
                RowBtn.Size = UDim2.new(1, 0, 0, 28)
                RowBtn.BackgroundTransparency = 1
                RowBtn.Text = ""
                RowBtn.AutoButtonColor = false
                RowBtn.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = RowBtn, Card = Card})

                local rightOffset = -26
                if keybind then rightOffset = rightOffset - 24 end
                if colorBox then rightOffset = rightOffset - 22 end

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, rightOffset, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = state and THEME.TextMain or THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = RowBtn

                if colorBox then
                    local ColorPreview = Instance.new("Frame")
                    ColorPreview.Size = UDim2.new(0, 14, 0, 14)
                    ColorPreview.Position = UDim2.new(1, (keybind and -42 or -38) - 18, 0.5, -7)
                    ColorPreview.BackgroundColor3 = typeof(colorBox) == "Color3" and colorBox or Color3.fromRGB(255, 255, 255)
                    ColorPreview.BorderSizePixel = 0
                    ColorPreview.Parent = RowBtn

                    local CPCorner = Instance.new("UICorner")
                    CPCorner.CornerRadius = UDim.new(0, 3)
                    CPCorner.Parent = ColorPreview

                    local CPStroke = Instance.new("UIStroke")
                    CPStroke.Color = THEME.CardBorder
                    CPStroke.Thickness = 1
                    CPStroke.Parent = ColorPreview
                end

                if keybind then
                    local KeyBadge = Instance.new("TextLabel")
                    KeyBadge.Size = UDim2.new(0, 20, 0, 16)
                    KeyBadge.Position = UDim2.new(1, -44, 0.5, -8)
                    KeyBadge.BackgroundTransparency = 1
                    KeyBadge.Text = keybind
                    KeyBadge.Font = THEME.FontBold
                    KeyBadge.TextSize = 10
                    KeyBadge.TextColor3 = THEME.TextMuted
                    KeyBadge.TextXAlignment = Enum.TextXAlignment.Right
                    KeyBadge.Parent = RowBtn
                end

                local BoxFrame = Instance.new("Frame")
                BoxFrame.Size = UDim2.new(0, 18, 0, 18)
                BoxFrame.Position = UDim2.new(1, -18, 0.5, -9)
                BoxFrame.BackgroundColor3 = state and THEME.Accent or THEME.CircleOff
                BoxFrame.BorderSizePixel = 0
                BoxFrame.Parent = RowBtn

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
                BoxCorner.Parent = BoxFrame

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = state and THEME.AccentGradient or THEME.CircleOffBorder
                BoxStroke.Thickness = 1.2
                BoxStroke.Parent = BoxFrame

                local CheckIcon = Instance.new("ImageLabel")
                CheckIcon.Size = UDim2.new(0, 12, 0, 12)
                CheckIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
                CheckIcon.BackgroundTransparency = 1
                CheckIcon.Image = "rbxassetid://10709790948"
                CheckIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                CheckIcon.ImageTransparency = state and 0 or 1
                CheckIcon.ScaleType = Enum.ScaleType.Fit
                CheckIcon.Parent = BoxFrame

                local function SetState(newVal)
                    state = newVal
                    if state then
                        Tween(BoxFrame, {BackgroundColor3 = THEME.Accent}, 0.18)
                        Tween(BoxStroke, {Color = THEME.AccentGradient}, 0.18)
                        Tween(CheckIcon, {ImageTransparency = 0}, 0.18)
                        Tween(Label, {TextColor3 = THEME.TextMain}, 0.18)
                    else
                        Tween(BoxFrame, {BackgroundColor3 = THEME.CircleOff}, 0.18)
                        Tween(BoxStroke, {Color = THEME.CircleOffBorder}, 0.18)
                        Tween(CheckIcon, {ImageTransparency = 1}, 0.18)
                        Tween(Label, {TextColor3 = THEME.TextMuted}, 0.18)
                    end
                    callback(state)
                end

                RowBtn.MouseButton1Click:Connect(function()
                    Tween(BoxFrame, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -19, 0.5, -10)}, 0.06)
                    task.wait(0.06)
                    Tween(BoxFrame, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -18, 0.5, -9)}, 0.1)
                    SetState(not state)
                end)

                -- Theme subscriber for Toggle
                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    if state then
                        BoxFrame.BackgroundColor3 = theme.Accent
                        BoxStroke.Color = theme.AccentGradient
                        Label.TextColor3 = theme.TextMain
                    else
                        BoxFrame.BackgroundColor3 = theme.CircleOff
                        BoxStroke.Color = theme.CircleOffBorder
                        Label.TextColor3 = theme.TextMuted
                    end
                end)

                local controller = {
                    Set = SetState,
                    Get = function() return state end,
                    Type = "Toggle"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddSlider(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Slider"
                local flag = cfg.Flag or name
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local default = cfg.Default or min
                local maxFormat = cfg.MaxFormat or false
                local suffix = cfg.Suffix or ""
                local callback = cfg.Callback or function() end
                local value = default

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 36)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Frame, Card = Card})

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.65, 0, 0, 14)
                Label.Position = UDim2.new(0, 0, 0, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMain
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local ValLabel = Instance.new("TextLabel")
                ValLabel.Size = UDim2.new(0.35, 0, 0, 14)
                ValLabel.Position = UDim2.new(0.65, 0, 0, 0)
                ValLabel.BackgroundTransparency = 1
                ValLabel.Text = maxFormat and (tostring(value) .. " / " .. tostring(max)) or (tostring(value) .. suffix)
                ValLabel.Font = THEME.FontMain
                ValLabel.TextSize = 10
                ValLabel.TextColor3 = THEME.TextMuted
                ValLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValLabel.Parent = Frame

                local TrackBtn = Instance.new("TextButton")
                TrackBtn.Size = UDim2.new(1, 0, 0, 16)
                TrackBtn.Position = UDim2.new(0, 0, 0, 18)
                TrackBtn.BackgroundTransparency = 1
                TrackBtn.Text = ""
                TrackBtn.AutoButtonColor = false
                TrackBtn.Parent = Frame

                local Track = Instance.new("Frame")
                Track.Size = UDim2.new(1, 0, 0, 4)
                Track.Position = UDim2.new(0, 0, 0.5, -2)
                Track.BackgroundColor3 = THEME.CircleOff
                Track.BorderSizePixel = 0
                Track.Parent = TrackBtn

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 2)
                TrackCorner.Parent = Track

                local Fill = Instance.new("Frame")
                local initPct = math.clamp((value - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(initPct, 0, 1, 0)
                Fill.BackgroundColor3 = THEME.Accent
                Fill.BorderSizePixel = 0
                Fill.Parent = Track

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 2)
                FillCorner.Parent = Fill

                local FillGrad = Instance.new("UIGradient")
                FillGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, THEME.AccentGradient),
                    ColorSequenceKeypoint.new(1, THEME.Accent)
                })
                FillGrad.Parent = Fill

                local Thumb = Instance.new("Frame")
                Thumb.Size = UDim2.new(0, 12, 0, 12)
                Thumb.Position = UDim2.new(1, -6, 0.5, -6)
                Thumb.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
                Thumb.BorderSizePixel = 0
                Thumb.ZIndex = 5
                Thumb.Parent = Fill

                local ThumbCorner = Instance.new("UICorner")
                ThumbCorner.CornerRadius = UDim.new(1, 0)
                ThumbCorner.Parent = Thumb

                local ThumbStroke = Instance.new("UIStroke")
                ThumbStroke.Color = THEME.Accent
                ThumbStroke.Thickness = 1.8
                ThumbStroke.Parent = Thumb

                local dragging = false
                local function Update(input)
                    local absPos = Track.AbsolutePosition.X
                    local absSize = Track.AbsoluteSize.X
                    local pct = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                    value = math.floor(min + (max - min) * pct)
                    Fill.Size = UDim2.new(pct, 0, 1, 0)
                    ValLabel.Text = maxFormat and (tostring(value) .. " / " .. tostring(max)) or (tostring(value) .. suffix)
                    callback(value)
                end

                TrackBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        Tween(Thumb, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)}, 0.12)
                        Tween(ValLabel, {TextColor3 = THEME.Accent}, 0.12)
                        Update(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if dragging then
                            dragging = false
                            Tween(Thumb, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}, 0.12)
                            Tween(ValLabel, {TextColor3 = THEME.TextMuted}, 0.12)
                        end
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        Update(input)
                    end
                end)

                -- Theme subscriber for Slider
                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Label.TextColor3 = theme.TextMain
                    Track.BackgroundColor3 = theme.CircleOff
                    Fill.BackgroundColor3 = theme.Accent
                    FillGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, theme.AccentGradient),
                        ColorSequenceKeypoint.new(1, theme.Accent)
                    })
                    ThumbStroke.Color = theme.Accent
                end)

                local controller = {
                    Set = function(newVal)
                        value = math.clamp(newVal, min, max)
                        local pct = (value - min) / (max - min)
                        Tween(Fill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.15)
                        ValLabel.Text = maxFormat and (tostring(value) .. " / " .. tostring(max)) or (tostring(value) .. suffix)
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
                local flag = cfg.Flag or name
                local options = cfg.Options or {}
                local default = cfg.Default or options[1] or "None"
                local callback = cfg.Callback or function() end
                local selected = default
                local open = false

                local DropFrame = Instance.new("Frame")
                DropFrame.Name = "Dropdown_" .. name
                DropFrame.Size = UDim2.new(1, 0, 0, 32)
                DropFrame.BackgroundTransparency = 1
                DropFrame.ClipsDescendants = false
                DropFrame.ZIndex = 1
                DropFrame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = DropFrame, Card = Card})

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.48, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.ZIndex = 1
                Label.Parent = DropFrame

                local DropBtn = Instance.new("TextButton")
                DropBtn.Size = UDim2.new(0.5, 0, 0, 24)
                DropBtn.Position = UDim2.new(0.5, 0, 0.5, -12)
                DropBtn.BackgroundColor3 = THEME.BgSidebar
                DropBtn.Text = ""
                DropBtn.AutoButtonColor = false
                DropBtn.ZIndex = 2
                DropBtn.Parent = DropFrame

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 7)
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
                BtnText.ZIndex = 3
                BtnText.Parent = DropBtn

                local Arrow = Instance.new("TextLabel")
                Arrow.Size = UDim2.new(0, 18, 1, 0)
                Arrow.Position = UDim2.new(1, -20, 0, 0)
                Arrow.BackgroundTransparency = 1
                Arrow.Text = "v"
                Arrow.Font = THEME.FontBold
                Arrow.TextSize = 9
                Arrow.TextColor3 = THEME.TextMuted
                Arrow.ZIndex = 3
                Arrow.Parent = DropBtn

                local maxVisibleItems = 5
                local totalItemsHeight = #options * 26
                local targetHeight = math.min(totalItemsHeight + 6, maxVisibleItems * 26 + 6)

                local MenuList = Instance.new("Frame")
                MenuList.Name = "MenuList"
                MenuList.Size = UDim2.new(0.5, 0, 0, 0)
                MenuList.Position = UDim2.new(0.5, 0, 0, 30)
                MenuList.BackgroundColor3 = THEME.BgMain
                MenuList.BorderSizePixel = 0
                MenuList.Visible = false
                MenuList.ClipsDescendants = false
                MenuList.Active = true
                MenuList.ZIndex = 100
                MenuList.Parent = DropFrame

                local MenuShadow = Instance.new("ImageLabel")
                MenuShadow.Size = UDim2.new(1, 24, 1, 24)
                MenuShadow.Position = UDim2.new(0, -12, 0, -12)
                MenuShadow.BackgroundTransparency = 1
                MenuShadow.Image = "rbxassetid://5028857472"
                MenuShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
                MenuShadow.ImageTransparency = 0.35
                MenuShadow.ScaleType = Enum.ScaleType.Slice
                MenuShadow.SliceCenter = Rect.new(24, 24, 276, 276)
                MenuShadow.Active = false
                MenuShadow.ZIndex = 99
                MenuShadow.Parent = MenuList

                local MenuCorner = Instance.new("UICorner")
                MenuCorner.CornerRadius = UDim.new(0, 8)
                MenuCorner.Parent = MenuList

                local MenuStroke = Instance.new("UIStroke")
                MenuStroke.Color = THEME.CardBorder
                MenuStroke.Thickness = 1
                MenuStroke.Parent = MenuList

                local MenuScroll = Instance.new("ScrollingFrame")
                MenuScroll.Size = UDim2.new(1, -2, 1, -4)
                MenuScroll.Position = UDim2.new(0, 1, 0, 2)
                MenuScroll.BackgroundTransparency = 1
                MenuScroll.BorderSizePixel = 0
                MenuScroll.ScrollBarThickness = (#options > maxVisibleItems) and 3 or 0
                MenuScroll.ScrollBarImageColor3 = THEME.Accent
                MenuScroll.CanvasSize = UDim2.new(0, 0, 0, totalItemsHeight)
                MenuScroll.AutomaticCanvasSize = Enum.AutomaticSize.None
                MenuScroll.ClipsDescendants = true
                MenuScroll.Active = true
                MenuScroll.ZIndex = 100
                MenuScroll.Parent = MenuList

                local MenuLayout = Instance.new("UIListLayout")
                MenuLayout.Padding = UDim.new(0, 0)
                MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
                MenuLayout.Parent = MenuScroll

                local CloseThisDropdown = nil
                local outsideConnection = nil
                local optionItems = {}

                local function SetOpen(v)
                    if open == v then return end
                    open = v

                    if open then
                        if ActiveDropdown and ActiveDropdown ~= CloseThisDropdown then
                            ActiveDropdown()
                        end
                        ActiveDropdown = CloseThisDropdown

                        Card.ZIndex = 100
                        DropFrame.ZIndex = 100
                        DropBtn.ZIndex = 101
                        MenuList.ZIndex = 102
                        MenuScroll.ZIndex = 102

                        MenuList.Visible = true
                        Arrow.Text = "^"
                        Tween(DropStroke, {Color = THEME.Accent}, 0.2)
                        Tween(Arrow, {TextColor3 = THEME.Accent}, 0.2)

                        MenuList.Size = UDim2.new(0.5, 0, 0, 0)
                        Tween(MenuList, {Size = UDim2.new(0.5, 0, 0, targetHeight)}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                        if outsideConnection then outsideConnection:Disconnect() end
                        outsideConnection = UserInputService.InputBegan:Connect(function(input)
                            if not open then
                                if outsideConnection then
                                    outsideConnection:Disconnect()
                                    outsideConnection = nil
                                end
                                return
                            end
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                local mousePos = input.Position
                                local bPos = DropBtn.AbsolutePosition
                                local bSize = DropBtn.AbsoluteSize
                                local mPos = MenuList.AbsolutePosition
                                local mSize = MenuList.AbsoluteSize

                                local inBtn = (mousePos.X >= bPos.X and mousePos.X <= bPos.X + bSize.X and mousePos.Y >= bPos.Y and mousePos.Y <= bPos.Y + bSize.Y)
                                local inMenu = (mousePos.X >= mPos.X and mousePos.X <= mPos.X + mSize.X and mousePos.Y >= mPos.Y and mousePos.Y <= mPos.Y + mSize.Y)

                                if not inBtn and not inMenu then
                                    SetOpen(false)
                                end
                            end
                        end)
                    else
                        if ActiveDropdown == CloseThisDropdown then
                            ActiveDropdown = nil
                        end
                        if outsideConnection then
                            outsideConnection:Disconnect()
                            outsideConnection = nil
                        end

                        Arrow.Text = "v"
                        Tween(DropStroke, {Color = THEME.CardBorder}, 0.2)
                        Tween(Arrow, {TextColor3 = THEME.TextMuted}, 0.2)

                        local tw = Tween(MenuList, {Size = UDim2.new(0.5, 0, 0, 0)}, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        tw.Completed:Connect(function()
                            if not open then
                                MenuList.Visible = false
                                DropFrame.ZIndex = 1
                                DropBtn.ZIndex = 2
                                if ActiveDropdown == nil then
                                    Card.ZIndex = 1
                                end
                            end
                        end)
                    end
                end

                CloseThisDropdown = function()
                    if open then
                        SetOpen(false)
                    end
                end

                local function PopulateOptions(newOptions)
                    for _, child in ipairs(MenuScroll:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    optionItems = {}
                    options = newOptions

                    totalItemsHeight = #options * 26
                    targetHeight = math.min(totalItemsHeight + 6, maxVisibleItems * 26 + 6)
                    MenuScroll.CanvasSize = UDim2.new(0, 0, 0, totalItemsHeight)
                    MenuScroll.ScrollBarThickness = (#options > maxVisibleItems) and 3 or 0

                    for i, opt in ipairs(options) do
                        local isSelected = (opt == selected)

                        local OptItem = Instance.new("TextButton")
                        OptItem.Name = "Option_" .. opt
                        OptItem.Size = UDim2.new(1, 0, 0, 26)
                        OptItem.BackgroundColor3 = THEME.CardBg
                        OptItem.BackgroundTransparency = 1
                        OptItem.Text = ""
                        OptItem.AutoButtonColor = false
                        OptItem.Active = true
                        OptItem.ZIndex = 103
                        OptItem.LayoutOrder = i
                        OptItem.Parent = MenuScroll

                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 5)
                        OptCorner.Parent = OptItem

                        local OptLabel = Instance.new("TextLabel")
                        OptLabel.Size = UDim2.new(1, -24, 1, 0)
                        OptLabel.Position = UDim2.new(0, 8, 0, 0)
                        OptLabel.BackgroundTransparency = 1
                        OptLabel.Text = opt
                        OptLabel.Font = THEME.FontMain
                        OptLabel.TextSize = 10
                        OptLabel.TextColor3 = isSelected and THEME.Accent or THEME.TextMuted
                        OptLabel.TextXAlignment = Enum.TextXAlignment.Left
                        OptLabel.ZIndex = 104
                        OptLabel.Parent = OptItem

                        local OptCheck = Instance.new("ImageLabel")
                        OptCheck.Size = UDim2.new(0, 10, 0, 10)
                        OptCheck.Position = UDim2.new(1, -16, 0.5, -5)
                        OptCheck.BackgroundTransparency = 1
                        OptCheck.Image = "rbxassetid://10709790948"
                        OptCheck.ImageColor3 = THEME.Accent
                        OptCheck.ImageTransparency = isSelected and 0 or 1
                        OptCheck.ScaleType = Enum.ScaleType.Fit
                        OptCheck.ZIndex = 104
                        OptCheck.Parent = OptItem

                        table.insert(optionItems, {
                            Option = opt,
                            Button = OptItem,
                            Label = OptLabel,
                            Check = OptCheck
                        })

                        OptItem.MouseEnter:Connect(function()
                            Tween(OptItem, {BackgroundTransparency = 0.5}, 0.12)
                            Tween(OptLabel, {TextColor3 = THEME.TextMain}, 0.12)
                        end)

                        OptItem.MouseLeave:Connect(function()
                            Tween(OptItem, {BackgroundTransparency = 1}, 0.12)
                            local isSel = (opt == selected)
                            Tween(OptLabel, {TextColor3 = isSel and THEME.Accent or THEME.TextMuted}, 0.12)
                        end)

                        OptItem.MouseButton1Click:Connect(function()
                            if not open then return end
                            selected = opt
                            BtnText.Text = selected

                            for _, item in ipairs(optionItems) do
                                local isSel = (item.Option == selected)
                                item.Label.TextColor3 = isSel and THEME.Accent or THEME.TextMuted
                                item.Check.ImageTransparency = isSel and 0 or 1
                            end

                            SetOpen(false)

                            task.spawn(function()
                                callback(selected)
                            end)
                        end)
                    end
                end

                PopulateOptions(options)

                DropBtn.MouseButton1Click:Connect(function()
                    SetOpen(not open)
                end)

                -- Theme subscriber for Dropdown
                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    DropBtn.BackgroundColor3 = theme.BgSidebar
                    DropStroke.Color = open and theme.Accent or theme.CardBorder
                    BtnText.TextColor3 = theme.TextMain
                    Arrow.TextColor3 = open and theme.Accent or theme.TextMuted
                    MenuList.BackgroundColor3 = theme.BgMain
                    MenuStroke.Color = theme.CardBorder
                    MenuScroll.ScrollBarImageColor3 = theme.Accent
                    for _, item in ipairs(optionItems) do
                        local isSel = (item.Option == selected)
                        item.Label.TextColor3 = isSel and theme.Accent or theme.TextMuted
                        item.Check.ImageColor3 = theme.Accent
                    end
                end)

                local controller = {
                    Set = function(newOpt)
                        selected = newOpt
                        BtnText.Text = selected
                        for _, item in ipairs(optionItems) do
                            local isSel = (item.Option == selected)
                            item.Label.TextColor3 = isSel and THEME.Accent or THEME.TextMuted
                            item.Check.ImageTransparency = isSel and 0 or 1
                        end
                        callback(selected)
                    end,
                    Get = function() return selected end,
                    Refresh = function(newOptions)
                        PopulateOptions(newOptions)
                        if not table.find(newOptions, selected) then
                            selected = newOptions[1] or "None"
                            BtnText.Text = selected
                        end
                    end,
                    Type = "Dropdown"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddTextBox(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "TextBox"
                local flag = cfg.Flag or name
                local placeholder = cfg.Placeholder or "Enter text..."
                local default = cfg.Default or ""
                local callback = cfg.Callback or function() end
                local currentText = default

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 32)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Frame, Card = Card})

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.45, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local InputBox = Instance.new("Frame")
                InputBox.Size = UDim2.new(0.53, 0, 0, 24)
                InputBox.Position = UDim2.new(0.47, 0, 0.5, -12)
                InputBox.BackgroundColor3 = THEME.BgSidebar
                InputBox.Parent = Frame

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 6)
                BoxCorner.Parent = InputBox

                local BoxStroke = Instance.new("UIStroke")
                BoxStroke.Color = THEME.CardBorder
                BoxStroke.Thickness = 1
                BoxStroke.Parent = InputBox

                local BoxInput = Instance.new("TextBox")
                BoxInput.Size = UDim2.new(1, -12, 1, 0)
                BoxInput.Position = UDim2.new(0, 6, 0, 0)
                BoxInput.BackgroundTransparency = 1
                BoxInput.Text = default
                BoxInput.PlaceholderText = placeholder
                BoxInput.PlaceholderColor3 = THEME.TextMuted
                BoxInput.Font = THEME.FontMain
                BoxInput.TextSize = 10
                BoxInput.TextColor3 = THEME.TextMain
                BoxInput.TextXAlignment = Enum.TextXAlignment.Left
                BoxInput.ClearTextOnFocus = false
                BoxInput.Parent = InputBox

                BoxInput.Focused:Connect(function()
                    Tween(BoxStroke, {Color = THEME.Accent}, 0.2)
                end)

                BoxInput.FocusLost:Connect(function()
                    Tween(BoxStroke, {Color = THEME.CardBorder}, 0.2)
                    currentText = BoxInput.Text
                    callback(currentText)
                end)

                -- Theme subscriber for TextBox
                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Label.TextColor3 = theme.TextMuted
                    InputBox.BackgroundColor3 = theme.BgSidebar
                    BoxStroke.Color = theme.CardBorder
                    BoxInput.TextColor3 = theme.TextMain
                    BoxInput.PlaceholderColor3 = theme.TextMuted
                end)

                local controller = {
                    Set = function(newText)
                        currentText = newText
                        BoxInput.Text = currentText
                        callback(currentText)
                    end,
                    Get = function() return currentText end,
                    Type = "TextBox"
                }

                NamelessWare.Flags[flag] = controller
                return controller
            end

            function Controls:AddKeybind(cfg)
                cfg = cfg or {}
                local name = cfg.Name or "Keybind"
                local flag = cfg.Flag or name
                local default = cfg.Default or Enum.KeyCode.RightShift
                local callback = cfg.Callback or function() end

                local currentKey = (typeof(default) == "EnumItem") and default.Name or tostring(default)
                local binding = false

                local Frame = Instance.new("Frame")
                Frame.Size = UDim2.new(1, 0, 0, 30)
                Frame.BackgroundTransparency = 1
                Frame.Parent = Card
                table.insert(RegisteredItems, {Name = name, Element = Frame, Card = Card})

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.55, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.Font = THEME.FontMain
                Label.TextSize = 11
                Label.TextColor3 = THEME.TextMuted
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = Frame

                local BindBtn = Instance.new("TextButton")
                BindBtn.Size = UDim2.new(0.42, 0, 0, 22)
                BindBtn.Position = UDim2.new(0.58, 0, 0.5, -11)
                BindBtn.BackgroundColor3 = THEME.BgSidebar
                BindBtn.Text = "[" .. currentKey .. "]"
                BindBtn.Font = THEME.FontBold
                BindBtn.TextSize = 10
                BindBtn.TextColor3 = THEME.TextMain
                BindBtn.AutoButtonColor = false
                BindBtn.Parent = Frame

                local BindCorner = Instance.new("UICorner")
                BindCorner.CornerRadius = UDim.new(0, 6)
                BindCorner.Parent = BindBtn

                local BindStroke = Instance.new("UIStroke")
                BindStroke.Color = THEME.CardBorder
                BindStroke.Thickness = 1
                BindStroke.Parent = BindBtn

                BindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    BindBtn.Text = "[ ... ]"
                    Tween(BindStroke, {Color = THEME.Accent}, 0.15)
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if binding and input.UserInputType == Enum.UserInputType.Keyboard then
                        binding = false
                        currentKey = input.KeyCode.Name
                        BindBtn.Text = "[" .. currentKey .. "]"
                        Tween(BindStroke, {Color = THEME.CardBorder}, 0.2)
                        callback(input.KeyCode)
                    end
                end)

                -- Theme subscriber for Keybind
                table.insert(NamelessWare.ThemeSubscribers, function(theme)
                    Label.TextColor3 = theme.TextMuted
                    BindBtn.BackgroundColor3 = theme.BgSidebar
                    BindBtn.TextColor3 = theme.TextMain
                    BindStroke.Color = theme.CardBorder
                end)

                local controller = {
                    Set = function(newKey)
                        currentKey = (typeof(newKey) == "EnumItem") and newKey.Name or tostring(newKey)
                        BindBtn.Text = "[" .. currentKey .. "]"
                        callback(Enum.KeyCode[currentKey] or currentKey)
                    end,
                    Get = function() return currentKey end,
                    Type = "Keybind"
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

                -- Theme subscriber for Button
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

        -- 1. Profile Manager Section (SaveManager)
        local ConfigSec = SettingsTab:CreateSection("Profile Manager", "rbxassetid://10709791437")
        NamelessWare.SaveManager:BuildConfigSection(ConfigSec)

        -- 2. Theme Customizer Section (ThemeManager)
        local ThemeSec = SettingsTab:CreateSection("Theme Customizer", "rbxassetid://10709791437")
        NamelessWare.ThemeManager:BuildThemeSection(ThemeSec)

        -- 3. Menu Settings Section (SettingsManager)
        local MenuSec = SettingsTab:CreateSection("Menu Controls", "rbxassetid://10734950309")
        NamelessWare.SettingsManager:BuildSettingsSection(MenuSec)

        -- Automatically run autoload if configured
        NamelessWare.SaveManager:AutoLoad()

        return SettingsTab
    end

    return Window
end

return NamelessWare
