local SettingsManager = {
    Library = nil,
    ToggleKey = Enum.KeyCode.RightShift,
    MobileVisible = true
}

function SettingsManager:SetLibrary(library)
    self.Library = library
end

function SettingsManager:BuildSettingsSection(Section)
    Section:AddSubHeader("Menu Navigation", "rbxassetid://10734950309")

    local lib = self.Library or (getgenv and getgenv().NamelessWare)
    local currentKey = (lib and lib.ToggleKey) or self.ToggleKey

    Section:AddKeybind({
        Name = "Menu Keybind",
        Default = currentKey,
        Callback = function(key)
            local targetKey = nil
            if typeof(key) == "EnumItem" then
                targetKey = key
            elseif typeof(key) == "string" and Enum.KeyCode[key] then
                targetKey = Enum.KeyCode[key]
            end

            if targetKey then
                self.ToggleKey = targetKey
                if lib then
                    lib.ToggleKey = targetKey
                end
                if lib and lib.Notify then
                    lib:Notify({
                        Title = "Keybind Updated",
                        Content = "Menu toggle key set to: " .. tostring(targetKey.Name),
                        Duration = 2,
                        Type = "Info"
                    })
                end
            end
        end
    })

    if lib and lib.ActiveWindow and lib.ActiveWindow.MobileBtn then
        Section:AddToggle({
            Name = "Mobile Floating Button",
            Default = true,
            Callback = function(state)
                lib.ActiveWindow.MobileBtn.Visible = state
            end
        })

        Section:AddButton({
            Name = "Reset Mobile Button Pos",
            Callback = function()
                lib.ActiveWindow.MobileBtn.Position = UDim2.new(0, 16, 0.5, -25)
                if lib and lib.Notify then
                    lib:Notify({
                        Title = "Button Reset",
                        Content = "Mobile button position restored.",
                        Duration = 1.5,
                        Type = "Info"
                    })
                end
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
            if lib and lib.ActiveWindow and lib.ActiveWindow.ScreenGui then
                pcall(function() lib.ActiveWindow.ScreenGui:Destroy() end)
            end
        end
    })
end

return SettingsManager
