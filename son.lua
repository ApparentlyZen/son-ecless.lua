--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                     NAMELESS UI LIBRARY v2.0                    ║
    ║        Sleek, High-Performance, Dark-Themed Cheat Menu UI       ║
    ╚══════════════════════════════════════════════════════════════════╝
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer and LocalPlayer:GetMouse()

local Library = {
    Version = "2.0.0",
    Flags = {},
    Theme = {
        Background = Color3.fromRGB(14, 14, 18),
        CardBackground = Color3.fromRGB(19, 19, 25),
        CardBorder = Color3.fromRGB(30, 30, 38),
        CardBorderHover = Color3.fromRGB(48, 48, 60),
        
        Accent = Color3.fromRGB(137, 132, 245),      -- Purple / Blue accent
        AccentSecondary = Color3.fromRGB(93, 197, 216), -- Cyan accent
        AccentHover = Color3.fromRGB(155, 150, 255),
        AccentDark = Color3.fromRGB(80, 75, 180),
        
        Text = Color3.fromRGB(240, 240, 245),
        TextDim = Color3.fromRGB(150, 150, 165),
        TextDark = Color3.fromRGB(95, 95, 110),
        
        ItemBg = Color3.fromRGB(24, 24, 32),
        ItemBgHover = Color3.fromRGB(30, 30, 40),
        ItemBorder = Color3.fromRGB(38, 38, 50),
        
        SliderTrack = Color3.fromRGB(26, 26, 35),
        SliderFill = Color3.fromRGB(137, 132, 245),
        
        ToggleOff = Color3.fromRGB(28, 28, 36),
        ToggleOn = Color3.fromRGB(137, 132, 245),
        
        Success = Color3.fromRGB(105, 215, 120),
        Warning = Color3.fromRGB(240, 180, 70),
        Error = Color3.fromRGB(245, 90, 90)
    },
    Open = true,
    Windows = {},
    Signals = {}
}

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

local function makeDraggable(topbar, mainFrame)
    local dragging, dragInput, dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create Main Window
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Nameless"
    local windowSubtitle = config.SubTitle or "Ware"
    local footerUser = config.Footer or (LocalPlayer and LocalPlayer.Name or "User")
    local footerRank = config.FooterRight or "Lifetime"
    local windowSize = config.Size or UDim2.new(0, 640, 0, 520)
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessUI_" .. tostring(math.random(1000, 9999))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = getGuiParent()

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    MainFrame.BackgroundColor3 = Library.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.CardBorder
    MainStroke.Thickness = 1.2
    MainStroke.Parent = MainFrame

    -- Subtle Top Ambient Glow
    local TopGlow = Instance.new("Frame")
    TopGlow.Name = "TopGlow"
    TopGlow.Size = UDim2.new(1, 0, 0, 4)
    TopGlow.Position = UDim2.new(0, 0, 0, 0)
    TopGlow.BackgroundColor3 = Library.Theme.Accent
    TopGlow.BackgroundTransparency = 0.4
    TopGlow.BorderSizePixel = 0
    TopGlow.ZIndex = 2
    TopGlow.Parent = MainFrame

    local TopGlowCorner = Instance.new("UICorner")
    TopGlowCorner.CornerRadius = UDim.new(0, 10)
    TopGlowCorner.Parent = TopGlow

    local TopGlowGradient = Instance.new("UIGradient")
    TopGlowGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0.2),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.7, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })
    TopGlowGradient.Parent = TopGlow

    -- Drag Header Bar
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    makeDraggable(Header, MainFrame)

    -- Tabs Container (Centered/Aligned in Header)
    local TabsList = Instance.new("Frame")
    TabsList.Name = "TabsList"
    TabsList.Size = UDim2.new(1, -30, 0, 36)
    TabsList.Position = UDim2.new(0, 15, 0, 10)
    TabsList.BackgroundTransparency = 1
    TabsList.Parent = Header

    local TabsLayout = Instance.new("UIListLayout")
    TabsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabsLayout.Padding = UDim.new(0, 24)
    TabsLayout.Parent = TabsList

    -- Underline / Active Tab Indicator (Shared)
    local HeaderDivider = Instance.new("Frame")
    HeaderDivider.Name = "HeaderDivider"
    HeaderDivider.Size = UDim2.new(1, -30, 0, 1)
    HeaderDivider.Position = UDim2.new(0, 15, 0, 50)
    HeaderDivider.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    HeaderDivider.BorderSizePixel = 0
    HeaderDivider.Parent = MainFrame

    -- Content Container
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -24, 1, -95)
    ContentHolder.Position = UDim2.new(0, 12, 0, 56)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.ClipsDescendants = true
    ContentHolder.Parent = MainFrame

    -- Footer
    local Footer = Instance.new("Frame")
    Footer.Name = "Footer"
    Footer.Size = UDim2.new(1, 0, 0, 34)
    Footer.Position = UDim2.new(0, 0, 1, -34)
    Footer.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
    Footer.BorderSizePixel = 0
    Footer.Parent = MainFrame

    local FooterCorner = Instance.new("UICorner")
    FooterCorner.CornerRadius = UDim.new(0, 10)
    FooterCorner.Parent = Footer

    local FooterTopFix = Instance.new("Frame")
    FooterTopFix.Size = UDim2.new(1, 0, 0, 10)
    FooterTopFix.Position = UDim2.new(0, 0, 0, 0)
    FooterTopFix.BackgroundColor3 = Color3.fromRGB(11, 11, 14)
    FooterTopFix.BorderSizePixel = 0
    FooterTopFix.Parent = Footer

    local FooterDivider = Instance.new("Frame")
    FooterDivider.Size = UDim2.new(1, 0, 0, 1)
    FooterDivider.Position = UDim2.new(0, 0, 0, 0)
    FooterDivider.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    FooterDivider.BorderSizePixel = 0
    FooterDivider.Parent = Footer

    local FooterUserLabel = Instance.new("TextLabel")
    FooterUserLabel.Size = UDim2.new(0.5, -20, 1, 0)
    FooterUserLabel.Position = UDim2.new(0, 16, 0, 0)
    FooterUserLabel.BackgroundTransparency = 1
    FooterUserLabel.Text = footerUser
    FooterUserLabel.TextColor3 = Library.Theme.TextDim
    FooterUserLabel.Font = Enum.Font.GothamMedium
    FooterUserLabel.TextSize = 12
    FooterUserLabel.TextXAlignment = Enum.TextXAlignment.Left
    FooterUserLabel.Parent = Footer

    local FooterRankLabel = Instance.new("TextLabel")
    FooterRankLabel.Size = UDim2.new(0.5, -20, 1, 0)
    FooterRankLabel.Position = UDim2.new(0.5, 0, 0, 0)
    FooterRankLabel.BackgroundTransparency = 1
    FooterRankLabel.Text = footerRank
    FooterRankLabel.TextColor3 = Library.Theme.TextDark
    FooterRankLabel.Font = Enum.Font.GothamMedium
    FooterRankLabel.TextSize = 12
    FooterRankLabel.TextXAlignment = Enum.TextXAlignment.Right
    FooterRankLabel.Parent = Footer

    -- Floating Popover Overlay (for Dropdowns & ColorPickers)
    local Overlay = Instance.new("Frame")
    Overlay.Name = "Overlay"
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.ZIndex = 50
    Overlay.Parent = MainFrame

    -- Mobile Toggle Button
    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = "NamelessMobileToggle"
    MobileToggle.Size = UDim2.new(0, 44, 0, 44)
    MobileToggle.Position = UDim2.new(0, 20, 0.2, 0)
    MobileToggle.BackgroundColor3 = Library.Theme.Background
    MobileToggle.Text = "N"
    MobileToggle.TextColor3 = Library.Theme.Accent
    MobileToggle.Font = Enum.Font.GothamBold
    MobileToggle.TextSize = 20
    MobileToggle.Visible = false
    MobileToggle.Parent = ScreenGui

    local MobileCorner = Instance.new("UICorner")
    MobileCorner.CornerRadius = UDim.new(1, 0)
    MobileCorner.Parent = MobileToggle

    local MobileStroke = Instance.new("UIStroke")
    MobileStroke.Color = Library.Theme.Accent
    MobileStroke.Thickness = 1.5
    MobileStroke.Parent = MobileToggle

    makeDraggable(MobileToggle, MobileToggle)

    if UserInputService.TouchEnabled then
        MobileToggle.Visible = true
    end

    local WindowObj = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentHolder = ContentHolder,
        Overlay = Overlay,
        Tabs = {},
        CurrentTab = nil,
        IsOpen = true
    }

    -- Toggle Window Visibility
    function WindowObj:Toggle(state)
        if state == nil then state = not self.IsOpen end
        self.IsOpen = state
        
        if self.IsOpen then
            MainFrame.Visible = true
            MainFrame.Size = windowSize - UDim2.new(0, 20, 0, 20)
            createTween(MainFrame, {
                Size = windowSize,
                BackgroundTransparency = 0
            }, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            local tw = createTween(MainFrame, {
                Size = windowSize - UDim2.new(0, 30, 0, 30),
                BackgroundTransparency = 1
            }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw.Completed:Connect(function()
                if not self.IsOpen then MainFrame.Visible = false end
            end)
        end
    end

    MobileToggle.MouseButton1Click:Connect(function()
        WindowObj:Toggle()
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            WindowObj:Toggle()
        end
    end)

    -- Close Popovers when clicking anywhere
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            for _, child in ipairs(Overlay:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then
                    local mousePos = UserInputService:GetMouseLocation()
                    local absPos = child.AbsolutePosition
                    local absSize = child.AbsoluteSize
                    if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                       mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                        -- Check if clicked on activator
                        local tag = child:GetAttribute("ActivatorPos")
                        if not tag or (mousePos - Vector2.new(tag.X, tag.Y)).Magnitude > 40 then
                            child.Visible = false
                        end
                    end
                end
            end
        end
    end)

    -- ==================== TAB SYSTEM ====================
    function WindowObj:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "_Tab"
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = name
        TabBtn.TextColor3 = Library.Theme.TextDark
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 14
        TabBtn.Parent = TabsList

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Name = "Indicator"
        TabIndicator.Size = UDim2.new(1, 0, 0, 2)
        TabIndicator.Position = UDim2.new(0, 0, 1, -2)
        TabIndicator.BackgroundColor3 = Library.Theme.Accent
        TabIndicator.BackgroundTransparency = 1
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Parent = TabBtn

        local TabIndicatorCorner = Instance.new("UICorner")
        TabIndicatorCorner.CornerRadius = UDim.new(1, 0)
        TabIndicatorCorner.Parent = TabIndicator

        -- Tab Page (Contains Left & Right Columns)
        local TabPage = Instance.new("Frame")
        TabPage.Name = name .. "_Page"
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
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
        LeftCol.Parent = TabPage

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
        RightCol.Parent = TabPage

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.Padding = UDim.new(0, 12)
        RightLayout.Parent = RightCol

        local TabObj = {
            Button = TabBtn,
            Page = TabPage,
            LeftColumn = LeftCol,
            RightColumn = RightCol
        }

        local function activateTab()
            for _, tab in pairs(WindowObj.Tabs) do
                tab.Page.Visible = false
                createTween(tab.Button, { TextColor3 = Library.Theme.TextDark }, 0.15)
                createTween(tab.Button:FindFirstChild("Indicator"), { BackgroundTransparency = 1 }, 0.15)
            end
            TabPage.Visible = true
            createTween(TabBtn, { TextColor3 = Library.Theme.Accent }, 0.15)
            createTween(TabIndicator, { BackgroundTransparency = 0 }, 0.15)
            WindowObj.CurrentTab = TabObj
        end

        TabBtn.MouseButton1Click:Connect(activateTab)

        TabBtn.MouseEnter:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                createTween(TabBtn, { TextColor3 = Library.Theme.TextDim }, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if WindowObj.CurrentTab ~= TabObj then
                createTween(TabBtn, { TextColor3 = Library.Theme.TextDark }, 0.15)
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
            Card.Parent = parentCol

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 8)
            CardCorner.Parent = Card

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Library.Theme.CardBorder
            CardStroke.Thickness = 1
            CardStroke.Parent = Card

            -- Card Header
            local CardHeader = Instance.new("Frame")
            CardHeader.Name = "Header"
            CardHeader.Size = UDim2.new(1, 0, 0, 28)
            CardHeader.BackgroundTransparency = 1
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
            TitleLabel.Parent = CardHeader

            local CardContainer = Instance.new("Frame")
            CardContainer.Name = "Container"
            CardContainer.Size = UDim2.new(1, -24, 0, 0)
            CardContainer.Position = UDim2.new(0, 12, 0, 28)
            CardContainer.AutomaticSize = Enum.AutomaticSize.Y
            CardContainer.BackgroundTransparency = 1
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

            -- ==================== TOGGLE COMPONENT ====================
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
                ToggleFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, -60, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = default and Library.Theme.Text or Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ToggleFrame

                -- Right Elements Container (for colorpickers, keybind, checkbox)
                local RightElements = Instance.new("Frame")
                RightElements.Name = "RightElements"
                RightElements.Size = UDim2.new(0, 120, 1, 0)
                RightElements.Position = UDim2.new(1, -120, 0, 0)
                RightElements.BackgroundTransparency = 1
                RightElements.Parent = ToggleFrame

                local RightLayout = Instance.new("UIListLayout")
                RightLayout.FillDirection = Enum.FillDirection.Horizontal
                RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
                RightLayout.Padding = UDim.new(0, 6)
                RightLayout.Parent = RightElements

                -- Checkbox Box
                local CheckBox = Instance.new("TextButton")
                CheckBox.Name = "CheckBox"
                CheckBox.Size = UDim2.new(0, 14, 0, 14)
                CheckBox.LayoutOrder = 100
                CheckBox.BackgroundColor3 = default and Library.Theme.ToggleOn or Library.Theme.ToggleOff
                CheckBox.BorderSizePixel = 0
                CheckBox.Text = ""
                CheckBox.AutoButtonColor = false
                CheckBox.Parent = RightElements

                local CheckCorner = Instance.new("UICorner")
                CheckCorner.CornerRadius = UDim.new(0, 3)
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

                -- ==================== ATTACH COLORPICKER TO TOGGLE ====================
                function ToggleObj:AddColorPicker(cpConfig)
                    cpConfig = cpConfig or {}
                    local cpDefault = cpConfig.Default or Library.Theme.Accent
                    local cpCallback = cpConfig.Callback or function() end
                    local cpFlag = cpConfig.Flag

                    local ColorBox = Instance.new("TextButton")
                    ColorBox.Name = "ColorBox"
                    ColorBox.Size = UDim2.new(0, 16, 0, 12)
                    ColorBox.BackgroundColor3 = cpDefault
                    ColorBox.BorderSizePixel = 0
                    ColorBox.Text = ""
                    ColorBox.AutoButtonColor = false
                    ColorBox.LayoutOrder = 10
                    ColorBox.Parent = RightElements

                    local BoxCorner = Instance.new("UICorner")
                    BoxCorner.CornerRadius = UDim.new(0, 3)
                    BoxCorner.Parent = ColorBox

                    local BoxStroke = Instance.new("UIStroke")
                    BoxStroke.Color = Library.Theme.CardBorder
                    BoxStroke.Thickness = 1
                    BoxStroke.Parent = ColorBox

                    local currentColor = cpDefault
                    if cpFlag then Library.Flags[cpFlag] = currentColor end

                    -- Color Picker Floating Window
                    local PickerFrame = Instance.new("Frame")
                    PickerFrame.Name = "ColorPickerPopup"
                    PickerFrame.Size = UDim2.new(0, 160, 0, 140)
                    PickerFrame.BackgroundColor3 = Library.Theme.CardBackground
                    PickerFrame.BorderSizePixel = 0
                    PickerFrame.Visible = false
                    PickerFrame.ZIndex = 60
                    PickerFrame.Parent = Overlay

                    local PickerCorner = Instance.new("UICorner")
                    PickerCorner.CornerRadius = UDim.new(0, 6)
                    PickerCorner.Parent = PickerFrame

                    local PickerStroke = Instance.new("UIStroke")
                    PickerStroke.Color = Library.Theme.CardBorder
                    PickerStroke.Thickness = 1
                    PickerStroke.Parent = PickerFrame

                    -- Saturation / Value Canvas
                    local SatVal = Instance.new("TextButton")
                    SatVal.Name = "SatVal"
                    SatVal.Size = UDim2.new(1, -16, 0, 90)
                    SatVal.Position = UDim2.new(0, 8, 0, 8)
                    SatVal.BackgroundColor3 = cpDefault
                    SatVal.BorderSizePixel = 0
                    SatVal.Text = ""
                    SatVal.AutoButtonColor = false
                    SatVal.Parent = PickerFrame

                    local SatValCorner = Instance.new("UICorner")
                    SatValCorner.CornerRadius = UDim.new(0, 4)
                    SatValCorner.Parent = SatVal

                    local WhiteGrad = Instance.new("UIGradient")
                    WhiteGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
                    WhiteGrad.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    })
                    WhiteGrad.Parent = SatVal

                    -- Hue Bar
                    local HueBar = Instance.new("TextButton")
                    HueBar.Name = "HueBar"
                    HueBar.Size = UDim2.new(1, -16, 0, 14)
                    HueBar.Position = UDim2.new(0, 8, 0, 106)
                    HueBar.BorderSizePixel = 0
                    HueBar.Text = ""
                    HueBar.AutoButtonColor = false
                    HueBar.Parent = PickerFrame

                    local HueCorner = Instance.new("UICorner")
                    HueCorner.CornerRadius = UDim.new(0, 3)
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

                -- ==================== ATTACH KEYBIND TO TOGGLE ====================
                function ToggleObj:AddKeybind(kbConfig)
                    kbConfig = kbConfig or {}
                    local defaultKey = kbConfig.Default or Enum.KeyCode.Unknown
                    local kbCallback = kbConfig.Callback or function() end
                    local currentKey = defaultKey
                    local binding = false

                    local KeyBtn = Instance.new("TextButton")
                    KeyBtn.Name = "KeybindBtn"
                    KeyBtn.Size = UDim2.new(0, 22, 0, 14)
                    KeyBtn.BackgroundColor3 = Library.Theme.ItemBg
                    KeyBtn.BorderSizePixel = 0
                    KeyBtn.Text = (currentKey == Enum.KeyCode.Unknown and "..." or currentKey.Name)
                    KeyBtn.TextColor3 = Library.Theme.TextDark
                    KeyBtn.Font = Enum.Font.GothamBold
                    KeyBtn.TextSize = 10
                    KeyBtn.AutoButtonColor = false
                    KeyBtn.LayoutOrder = 5
                    KeyBtn.Parent = RightElements

                    local KeyCorner = Instance.new("UICorner")
                    KeyCorner.CornerRadius = UDim.new(0, 3)
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

            -- ==================== SLIDER COMPONENT ====================
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
                SliderFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(0.7, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
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
                ValueLabel.Parent = SliderFrame

                -- Slider Track
                local Track = Instance.new("TextButton")
                Track.Name = "Track"
                Track.Size = UDim2.new(1, 0, 0, 6)
                Track.Position = UDim2.new(0, 0, 0, 22)
                Track.BackgroundColor3 = Library.Theme.SliderTrack
                Track.BorderSizePixel = 0
                Track.Text = ""
                Track.AutoButtonColor = false
                Track.Parent = SliderFrame

                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(1, 0)
                TrackCorner.Parent = Track

                local Fill = Instance.new("Frame")
                Fill.Name = "Fill"
                local initPercent = math.clamp((default - min) / (max - min), 0, 1)
                Fill.Size = UDim2.new(initPercent, 0, 1, 0)
                Fill.BackgroundColor3 = Library.Theme.SliderFill
                Fill.BorderSizePixel = 0
                Fill.Parent = Track

                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(1, 0)
                FillCorner.Parent = Fill

                local FillGradient = Instance.new("UIGradient")
                FillGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library.Theme.AccentSecondary),
                    ColorSequenceKeypoint.new(1, Library.Theme.Accent)
                })
                FillGradient.Parent = Fill

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

            -- ==================== DROPDOWN COMPONENT ====================
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
                DropdownFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = DropdownFrame

                local Selector = Instance.new("TextButton")
                Selector.Name = "Selector"
                Selector.Size = UDim2.new(1, 0, 0, 24)
                Selector.Position = UDim2.new(0, 0, 0, 18)
                Selector.BackgroundColor3 = Library.Theme.ItemBg
                Selector.BorderSizePixel = 0
                Selector.Text = ""
                Selector.AutoButtonColor = false
                Selector.Parent = DropdownFrame

                local SelCorner = Instance.new("UICorner")
                SelCorner.CornerRadius = UDim.new(0, 4)
                SelCorner.Parent = Selector

                local SelStroke = Instance.new("UIStroke")
                SelStroke.Color = Library.Theme.ItemBorder
                SelStroke.Thickness = 1
                SelStroke.Parent = Selector

                local SelText = Instance.new("TextLabel")
                SelText.Size = UDim2.new(1, -30, 1, 0)
                SelText.Position = UDim2.new(0, 10, 0, 0)
                SelText.BackgroundTransparency = 1
                SelText.Text = tostring(default)
                SelText.TextColor3 = Library.Theme.Text
                SelText.Font = Enum.Font.GothamMedium
                SelText.TextSize = 12
                SelText.TextXAlignment = Enum.TextXAlignment.Left
                SelText.Parent = Selector

                -- Menu Icon (3 horizontal dots/lines)
                local MenuIcon = Instance.new("TextLabel")
                MenuIcon.Size = UDim2.new(0, 20, 1, 0)
                MenuIcon.Position = UDim2.new(1, -24, 0, 0)
                MenuIcon.BackgroundTransparency = 1
                MenuIcon.Text = "≡"
                MenuIcon.TextColor3 = Library.Theme.TextDark
                MenuIcon.Font = Enum.Font.GothamBold
                MenuIcon.TextSize = 14
                MenuIcon.Parent = Selector

                -- Dropdown Floating List
                local DropList = Instance.new("Frame")
                DropList.Name = "DropList"
                DropList.Size = UDim2.new(1, 0, 0, 0)
                DropList.AutomaticSize = Enum.AutomaticSize.Y
                DropList.BackgroundColor3 = Library.Theme.CardBackground
                DropList.BorderSizePixel = 0
                DropList.Visible = false
                DropList.ZIndex = 70
                DropList.Parent = Overlay

                local DropCorner = Instance.new("UICorner")
                DropCorner.CornerRadius = UDim.new(0, 4)
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
                        OptBtn.Size = UDim2.new(1, 0, 0, 22)
                        OptBtn.BackgroundColor3 = (opt == currentSelected) and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                        OptBtn.BackgroundTransparency = (opt == currentSelected) and 0 or 1
                        OptBtn.Text = "  " .. tostring(opt)
                        OptBtn.TextColor3 = (opt == currentSelected) and Library.Theme.Accent or Library.Theme.TextDim
                        OptBtn.Font = Enum.Font.GothamMedium
                        OptBtn.TextSize = 11
                        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                        OptBtn.AutoButtonColor = false
                        OptBtn.Parent = DropList

                        local OptCorner = Instance.new("UICorner")
                        OptCorner.CornerRadius = UDim.new(0, 3)
                        OptCorner.Parent = OptBtn

                        OptBtn.MouseEnter:Connect(function()
                            if opt ~= currentSelected then
                                createTween(OptBtn, { TextColor3 = Library.Theme.Text, BackgroundTransparency = 0.5 }, 0.1)
                            end
                        end)

                        OptBtn.MouseLeave:Connect(function()
                            if opt ~= currentSelected then
                                createTween(OptBtn, { TextColor3 = Library.Theme.TextDim, BackgroundTransparency = 1 }, 0.1)
                            end
                        end)

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
                        DropList.Position = UDim2.new(0, absPos.X - mainPos.X, 0, absPos.Y - mainPos.Y + 28)
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

            -- ==================== LISTBOX COMPONENT ====================
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
                ListboxFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
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
                Container.Parent = ListboxFrame

                local ContCorner = Instance.new("UICorner")
                ContCorner.CornerRadius = UDim.new(0, 4)
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
                        ItemBtn.Size = UDim2.new(1, 0, 0, 20)
                        ItemBtn.BackgroundColor3 = isSelected and Library.Theme.ItemBgHover or Color3.fromRGB(0,0,0)
                        ItemBtn.BackgroundTransparency = isSelected and 0.4 or 1
                        ItemBtn.Text = "  " .. tostring(item)
                        ItemBtn.TextColor3 = isSelected and Library.Theme.Accent or Library.Theme.TextDim
                        ItemBtn.Font = Enum.Font.GothamMedium
                        ItemBtn.TextSize = 11
                        ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                        ItemBtn.AutoButtonColor = false
                        ItemBtn.Parent = Container

                        local ItemCorner = Instance.new("UICorner")
                        ItemCorner.CornerRadius = UDim.new(0, 3)
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

            -- ==================== BUTTON COMPONENT ====================
            function SectionObj:AddButton(btnConfig)
                btnConfig = btnConfig or {}
                local name = btnConfig.Name or "Button"
                local callback = btnConfig.Callback or function() end

                local Button = Instance.new("TextButton")
                Button.Name = name .. "_Button"
                Button.Size = UDim2.new(1, 0, 0, 26)
                Button.BackgroundColor3 = Library.Theme.ItemBg
                Button.BorderSizePixel = 0
                Button.Text = name
                Button.TextColor3 = Library.Theme.Text
                Button.Font = Enum.Font.GothamMedium
                Button.TextSize = 12
                Button.AutoButtonColor = false
                Button.Parent = CardContainer

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 4)
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

            -- ==================== TEXT INPUT COMPONENT ====================
            function SectionObj:AddInput(inputConfig)
                inputConfig = inputConfig or {}
                local name = inputConfig.Name or "Input"
                local placeholder = inputConfig.Placeholder or "Type here..."
                local callback = inputConfig.Callback or function() end
                local flag = inputConfig.Flag

                local InputFrame = Instance.new("Frame")
                InputFrame.Name = name .. "_InputFrame"
                InputFrame.Size = UDim2.new(1, 0, 0, 46)
                InputFrame.BackgroundTransparency = 1
                InputFrame.Parent = CardContainer

                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 0, 16)
                Label.BackgroundTransparency = 1
                Label.Text = name
                Label.TextColor3 = Library.Theme.TextDim
                Label.Font = Enum.Font.GothamMedium
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = InputFrame

                local BoxContainer = Instance.new("Frame")
                BoxContainer.Size = UDim2.new(1, 0, 0, 24)
                BoxContainer.Position = UDim2.new(0, 0, 0, 18)
                BoxContainer.BackgroundColor3 = Library.Theme.ItemBg
                BoxContainer.BorderSizePixel = 0
                BoxContainer.Parent = InputFrame

                local BoxCorner = Instance.new("UICorner")
                BoxCorner.CornerRadius = UDim.new(0, 4)
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

    -- Notification System
    function Library:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local title = notifConfig.Title or "Nameless"
        local content = notifConfig.Content or ""
        local duration = notifConfig.Duration or 3

        local NotifFrame = Instance.new("Frame")
        NotifFrame.Name = "Notification"
        NotifFrame.Size = UDim2.new(0, 220, 0, 56)
        NotifFrame.Position = UDim2.new(1, 230, 1, -70)
        NotifFrame.BackgroundColor3 = Library.Theme.Background
        NotifFrame.BorderSizePixel = 0
        NotifFrame.Parent = ScreenGui

        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = NotifFrame

        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Color = Library.Theme.Accent
        NotifStroke.Thickness = 1.2
        NotifStroke.Parent = NotifFrame

        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Size = UDim2.new(1, -20, 0, 18)
        NotifTitle.Position = UDim2.new(0, 10, 0, 8)
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Library.Theme.Accent
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextSize = 13
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = NotifFrame

        local NotifContent = Instance.new("TextLabel")
        NotifContent.Size = UDim2.new(1, -20, 0, 18)
        NotifContent.Position = UDim2.new(0, 10, 0, 28)
        NotifContent.BackgroundTransparency = 1
        NotifContent.Text = content
        NotifContent.TextColor3 = Library.Theme.TextDim
        NotifContent.Font = Enum.Font.GothamMedium
        NotifContent.TextSize = 11
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.Parent = NotifFrame

        createTween(NotifFrame, { Position = UDim2.new(1, -240, 1, -70) }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        task.delay(duration, function()
            local tw = createTween(NotifFrame, { Position = UDim2.new(1, 230, 1, -70) }, 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            tw.Completed:Connect(function()
                NotifFrame:Destroy()
            end)
        end)
    end

    return WindowObj
end

return Library
