local HttpService = game:GetService("HttpService")

local ThemeManager = {
    Library = nil,
    Folder = "NamelessWare/Themes",
    CurrentTheme = "Nameless Violet",
    CurrentCustom = {
        R = 165,
        G = 95,
        B = 255
    },
    Presets = {
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

function ThemeManager:SetLibrary(library)
    self.Library = library
end

function ThemeManager:SetFolder(folderPath)
    self.Folder = folderPath
    EnsureFolder(folderPath)
end

function ThemeManager:GetPresets()
    local names = {}
    for name, _ in pairs(self.Presets) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function ThemeManager:ApplyTheme(themeNameOrData, silent)
    local themeData
    local themeTitle = "Custom Theme"

    if type(themeNameOrData) == "string" then
        if self.Presets[themeNameOrData] then
            themeData = self.Presets[themeNameOrData]
            themeTitle = themeNameOrData
            self.CurrentTheme = themeNameOrData
        else
            themeData = self:LoadCustomThemeData(themeNameOrData)
            if themeData then
                themeTitle = themeNameOrData
                self.CurrentTheme = themeNameOrData
            end
        end
    elseif type(themeNameOrData) == "table" then
        themeData = themeNameOrData
        if themeData.Name then
            themeTitle = themeData.Name
            self.CurrentTheme = themeData.Name
        end
    end

    if not themeData then return false end

    -- Update library theme table & broadcast to all subscribers
    local lib = self.Library or (getgenv and getgenv().NamelessWare)
    if lib then
        if lib.THEME then
            for k, v in pairs(themeData) do
                lib.THEME[k] = v
            end
        end
        if lib.ThemeSubscribers then
            for _, sub in ipairs(lib.ThemeSubscribers) do
                pcall(function() sub(themeData) end)
            end
        end
        if not silent and lib.Notify then
            lib:Notify({
                Title = "Theme Applied",
                Content = "Switched to theme: " .. themeTitle,
                Duration = 2,
                Type = "Success"
            })
        end
    end
    return true
end

function ThemeManager:SetCustomAccent(r, g, b, livePreview)
    r = math.clamp(math.floor(r or 165), 0, 255)
    g = math.clamp(math.floor(g or 95), 0, 255)
    b = math.clamp(math.floor(b or 255), 0, 255)

    self.CurrentCustom = { R = r, G = g, B = b }

    local accent = Color3.fromRGB(r, g, b)
    local accentGrad = Color3.fromRGB(
        math.clamp(r + 30, 0, 255),
        math.clamp(g + 30, 0, 255),
        math.clamp(b + 30, 0, 255)
    )
    local accentDark = Color3.fromRGB(
        math.clamp(r - 40, 0, 255),
        math.clamp(g - 40, 0, 255),
        math.clamp(b - 40, 0, 255)
    )

    local customData = {
        Name = "Custom (" .. r .. "," .. g .. "," .. b .. ")",
        Accent = accent,
        AccentGradient = accentGrad,
        AccentDark = accentDark,
        BgMain = Color3.fromRGB(15, 15, 22),
        BgMainGradient = Color3.fromRGB(19, 19, 28),
        BgSidebar = Color3.fromRGB(12, 12, 17),
        CardBg = Color3.fromRGB(20, 20, 29),
        CardBgGradient = Color3.fromRGB(24, 24, 35),
        CardBorder = Color3.fromRGB(36, 36, 52),
        TextMain = Color3.fromRGB(245, 245, 252),
        TextMuted = Color3.fromRGB(130, 130, 155),
        CircleOff = Color3.fromRGB(26, 26, 36),
        CircleOffBorder = Color3.fromRGB(45, 45, 62)
    }

    if livePreview then
        self:ApplyTheme(customData, true)
    end
    return customData
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
        R = self.CurrentCustom.R,
        G = self.CurrentCustom.G,
        B = self.CurrentCustom.B
    }

    local path = self.Folder .. "/" .. name .. ".json"
    local jsonStr = HttpService:JSONEncode(payload)

    if writefile then
        local success = pcall(function() writefile(path, jsonStr) end)
        if success then
            local lib = self.Library or (getgenv and getgenv().NamelessWare)
            if lib and lib.Notify then
                lib:Notify({
                    Title = "Theme Saved",
                    Content = "Custom theme '" .. name .. "' was saved.",
                    Duration = 2.5,
                    Type = "Success"
                })
            end
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
            if decodeSuccess and type(data) == "table" and data.R and data.G and data.B then
                return self:SetCustomAccent(data.R, data.G, data.B, false)
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
            local lib = self.Library or (getgenv and getgenv().NamelessWare)
            if lib and lib.Notify then
                lib:Notify({
                    Title = "Theme Deleted",
                    Content = "Custom theme '" .. name .. "' was removed.",
                    Duration = 2.5,
                    Type = "Info"
                })
            end
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
        Default = self.CurrentTheme or selectedPreset,
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

return ThemeManager
