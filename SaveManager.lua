local HttpService = game:GetService("HttpService")

local SaveManager = {
    Library = nil,
    Folder = "NamelessWare/Configs",
    AutoLoadPath = "NamelessWare/Configs/autoload.txt",
    InMemoryConfigs = {}
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

function SaveManager:SetLibrary(library)
    self.Library = library
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

    local lib = self.Library or (getgenv and getgenv().NamelessWare)
    local flags = (lib and lib.Flags) or {}
    local data = {}

    for flag, ctrl in pairs(flags) do
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
            if lib and lib.Notify then
                lib:Notify({
                    Title = "Config Saved",
                    Content = "Profile '" .. name .. "' saved successfully.",
                    Duration = 2.5,
                    Type = "Success"
                })
            end
            return true
        end
    end

    -- In-memory fallback
    self.InMemoryConfigs[name] = jsonStr
    if lib and lib.Notify then
        lib:Notify({
            Title = "Config Saved (Memory)",
            Content = "Profile '" .. name .. "' saved in memory.",
            Duration = 2.5,
            Type = "Success"
        })
    end
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
        local lib = self.Library or (getgenv and getgenv().NamelessWare)
        if lib and lib.Notify then
            lib:Notify({
                Title = "Config Not Found",
                Content = "Could not find profile '" .. name .. "'.",
                Duration = 2.5,
                Type = "Error"
            })
        end
        return false
    end

    local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(rawJson) end)
    if not decodeSuccess or type(data) ~= "table" then
        return false
    end

    local lib = self.Library or (getgenv and getgenv().NamelessWare)
    local flags = (lib and lib.Flags) or {}

    for flag, value in pairs(data) do
        local ctrl = flags[flag]
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

    if lib and lib.Notify then
        lib:Notify({
            Title = "Config Loaded",
            Content = "Profile '" .. name .. "' loaded successfully.",
            Duration = 2.5,
            Type = "Success"
        })
    end
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

    local lib = self.Library or (getgenv and getgenv().NamelessWare)
    if removed then
        if lib and lib.Notify then
            lib:Notify({
                Title = "Config Deleted",
                Content = "Profile '" .. name .. "' was removed.",
                Duration = 2.5,
                Type = "Info"
            })
        end
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
        local lib = self.Library or (getgenv and getgenv().NamelessWare)
        if lib and lib.Notify then
            lib:Notify({
                Title = "Auto-Load Set",
                Content = "Default profile set to: " .. name,
                Duration = 2,
                Type = "Info"
            })
        end
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
                local lib = self.Library or (getgenv and getgenv().NamelessWare)
                if lib and lib.Notify then
                    lib:Notify({
                        Title = "Refreshed",
                        Content = "Configuration list updated.",
                        Duration = 1.8,
                        Type = "Info"
                    })
                end
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

return SaveManager
