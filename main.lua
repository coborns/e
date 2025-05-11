--[[
    Roblox GUI Framework
    A customizable framework for creating and managing GUI elements in Roblox
]]

local GuiFramework = {}
GuiFramework.__index = GuiFramework

-- Default theme
GuiFramework.DefaultTheme = {
    Primary = Color3.fromRGB(41, 128, 185),    -- Blue
    Secondary = Color3.fromRGB(231, 76, 60),   -- Red
    Background = Color3.fromRGB(44, 62, 80),   -- Dark Blue
    Surface = Color3.fromRGB(52, 73, 94),      -- Lighter Dark Blue
    Text = Color3.fromRGB(236, 240, 241),      -- White
    TextDark = Color3.fromRGB(44, 62, 80),     -- Dark Blue
    Success = Color3.fromRGB(46, 204, 113),    -- Green
    Warning = Color3.fromRGB(241, 196, 15),    -- Yellow
    Error = Color3.fromRGB(231, 76, 60),       -- Red
    
    -- UI Properties
    CornerRadius = UDim.new(0, 8),
    ButtonHeight = UDim.new(0, 40),
    Padding = UDim.new(0, 10),
    BorderSize = 2,
    
    -- Font settings
    FontRegular = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    FontSemiBold = Enum.Font.GothamSemibold,
    FontSize = Enum.FontSize.Size14,
    
    -- Animation settings
    AnimationDuration = 0.2,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out,
}

-- Custom themes storage
GuiFramework.Themes = {
    Default = GuiFramework.DefaultTheme,
    
    Dark = {
        Primary = Color3.fromRGB(90, 106, 207),      -- Purple Blue
        Secondary = Color3.fromRGB(214, 48, 98),     -- Pink
        Background = Color3.fromRGB(26, 32, 44),     -- Very Dark Blue
        Surface = Color3.fromRGB(45, 55, 72),        -- Dark Blue Gray
        Text = Color3.fromRGB(237, 242, 247),        -- White
        TextDark = Color3.fromRGB(26, 32, 44),       -- Very Dark Blue
        Success = Color3.fromRGB(72, 187, 120),      -- Green
        Warning = Color3.fromRGB(237, 137, 54),      -- Orange
        Error = Color3.fromRGB(229, 62, 62),         -- Red
        
        CornerRadius = UDim.new(0, 6),
        ButtonHeight = UDim.new(0, 40),
        Padding = UDim.new(0, 12),
        BorderSize = 0,
        
        FontRegular = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,
        FontSemiBold = Enum.Font.GothamSemibold,
        FontSize = Enum.FontSize.Size14,
        
        AnimationDuration = 0.15,
        EasingStyle = Enum.EasingStyle.Cubic,
        EasingDirection = Enum.EasingDirection.Out,
    },
    
    Light = {
        Primary = Color3.fromRGB(66, 153, 225),      -- Blue
        Secondary = Color3.fromRGB(237, 100, 166),   -- Pink
        Background = Color3.fromRGB(247, 250, 252),  -- White
        Surface = Color3.fromRGB(226, 232, 240),     -- Light Gray
        Text = Color3.fromRGB(44, 82, 130),          -- Dark Blue
        TextDark = Color3.fromRGB(26, 32, 44),       -- Very Dark Blue
        Success = Color3.fromRGB(72, 187, 120),      -- Green
        Warning = Color3.fromRGB(237, 137, 54),      -- Orange
        Error = Color3.fromRGB(229, 62, 62),         -- Red
        
        CornerRadius = UDim.new(0, 10),
        ButtonHeight = UDim.new(0, 38),
        Padding = UDim.new(0, 10),
        BorderSize = 1,
        
        FontRegular = Enum.Font.Gotham,
        FontBold = Enum.Font.GothamBold,
        FontSemiBold = Enum.Font.GothamSemibold,
        FontSize = Enum.FontSize.Size14,
        
        AnimationDuration = 0.2,
        EasingStyle = Enum.EasingStyle.Back,
        EasingDirection = Enum.EasingDirection.Out,
    }
}

-- Current theme
GuiFramework.CurrentTheme = GuiFramework.DefaultTheme

-- Create a new GUI Framework instance
function GuiFramework.new(parent)
    local self = setmetatable({}, GuiFramework)
    
    -- Store the parent
    self.Parent = parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create a ScreenGui to hold all our UI elements
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomGuiFramework"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = self.Parent
    
    -- Create a main container for our UI
    self.MainContainer = Instance.new("Frame")
    self.MainContainer.Name = "MainContainer"
    self.MainContainer.BackgroundTransparency = 1
    self.MainContainer.Size = UDim2.new(1, 0, 1, 0)
    self.MainContainer.Parent = self.ScreenGui
    
    -- Store all created UI elements
    self.Elements = {}
    
    -- Store custom functions
    self.CustomFunctions = {}
    
    -- Initialize TweenService for animations
    self.TweenService = game:GetService("TweenService")
    
    return self
end

-- Set the active theme
function GuiFramework:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = self.Themes[themeName]
        
        -- Update all existing elements with the new theme
        self:UpdateAllElements()
        
        return true
    end
    return false
end

-- Add a new custom theme
function GuiFramework:AddTheme(name, themeTable)
    -- Validate theme table
    if type(themeTable) ~= "table" then
        warn("Theme must be a table")
        return false
    end
    
    -- Create a new theme by merging with default theme
    local newTheme = {}
    for key, value in pairs(self.DefaultTheme) do
        newTheme[key] = themeTable[key] or value
    end
    
    -- Add the theme
    self.Themes[name] = newTheme
    return true
end

-- Update all elements with current theme
function GuiFramework:UpdateAllElements()
    for _, element in pairs(self.Elements) do
        if element.UpdateTheme then
            element:UpdateTheme(self.CurrentTheme)
        end
    end
end

-- Add a custom function to the framework
function GuiFramework:AddCustomFunction(name, func)
    if type(func) ~= "function" then
        warn("Custom function must be a function")
        return false
    end
    
    self.CustomFunctions[name] = func
    return true
end

-- Call a custom function
function GuiFramework:CallCustomFunction(name, ...)
    if self.CustomFunctions[name] then
        return self.CustomFunctions[name](self, ...)
    end
    warn("Custom function '" .. name .. "' not found")
    return nil
end

-- Create a rounded corner for an element
function GuiFramework:ApplyRoundedCorners(element, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or self.CurrentTheme.CornerRadius
    corner.Parent = element
    return corner
end

-- Apply padding to an element
function GuiFramework:ApplyPadding(element, padding)
    local uiPadding = Instance.new("UIPadding")
    local paddingValue = padding or self.CurrentTheme.Padding
    
    uiPadding.PaddingTop = paddingValue
    uiPadding.PaddingBottom = paddingValue
    uiPadding.PaddingLeft = paddingValue
    uiPadding.PaddingRight = paddingValue
    uiPadding.Parent = element
    
    return uiPadding
end

-- Create a frame
function GuiFramework:CreateFrame(name, parent, position, size, backgroundColor)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = backgroundColor or self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(1, 0, 1, 0)
    frame.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(frame)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        Type = "Frame",
        UpdateTheme = function(self, theme)
            frame.BackgroundColor3 = backgroundColor or theme.Surface
        end
    }
    
    return frame
end

-- Create a button
function GuiFramework:CreateButton(name, parent, position, size, text, onClick)
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = self.CurrentTheme.Primary
    button.BorderSizePixel = 0
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Size = size or UDim2.new(0, 200, 0, 50)
    button.Font = self.CurrentTheme.FontSemiBold
    button.TextColor3 = self.CurrentTheme.Text
    button.TextSize = 14
    button.Text = text or "Button"
    button.AutoButtonColor = false
    button.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(button)
    
    -- Create hover and click effects
    local originalColor = self.CurrentTheme.Primary
    local hoverColor = self.CurrentTheme.Primary:Lerp(Color3.new(1, 1, 1), 0.2)
    local pressedColor = self.CurrentTheme.Primary:Lerp(Color3.new(0, 0, 0), 0.2)
    
    -- Mouse enter event
    button.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    -- Mouse leave event
    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(button, tweenInfo, {BackgroundColor3 = originalColor})
        tween:Play()
    end)
    
    -- Mouse button down event
    button.MouseButton1Down:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration / 2,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(button, tweenInfo, {BackgroundColor3 = pressedColor})
        tween:Play()
    end)
    
    -- Mouse button up event
    button.MouseButton1Up:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration / 2,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(button, tweenInfo, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    -- Click event
    if onClick then
        button.MouseButton1Click:Connect(onClick)
    end
    
    -- Store the element
    self.Elements[name] = {
        Instance = button,
        Type = "Button",
        UpdateTheme = function(self, theme)
            button.BackgroundColor3 = theme.Primary
            button.TextColor3 = theme.Text
            button.Font = theme.FontSemiBold
            
            originalColor = theme.Primary
            hoverColor = theme.Primary:Lerp(Color3.new(1, 1, 1), 0.2)
            pressedColor = theme.Primary:Lerp(Color3.new(0, 0, 0), 0.2)
        end
    }
    
    return button
end

-- Create a text label
function GuiFramework:CreateLabel(name, parent, position, size, text, textColor, fontSize)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.Size = size or UDim2.new(1, 0, 0, 30)
    label.Font = self.CurrentTheme.FontRegular
    label.TextColor3 = textColor or self.CurrentTheme.Text
    label.TextSize = fontSize or 14
    label.Text = text or "Label"
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent or self.MainContainer
    
    -- Store the element
    self.Elements[name] = {
        Instance = label,
        Type = "Label",
        UpdateTheme = function(self, theme)
            label.TextColor3 = textColor or theme.Text
            label.Font = theme.FontRegular
        end
    }
    
    return label
end

-- Create a text input
function GuiFramework:CreateTextInput(name, parent, position, size, placeholderText, onTextChanged)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(0, 200, 0, 40)
    frame.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(frame)
    
    -- Create the text box
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.BackgroundTransparency = 1
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.Size = UDim2.new(1, -20, 1, 0)
    textBox.Font = self.CurrentTheme.FontRegular
    textBox.PlaceholderText = placeholderText or "Enter text..."
    textBox.PlaceholderColor3 = self.CurrentTheme.Text:Lerp(self.CurrentTheme.Surface, 0.5)
    textBox.TextColor3 = self.CurrentTheme.Text
    textBox.TextSize = 14
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Text = ""
    textBox.Parent = frame
    
    -- Text changed event
    if onTextChanged then
        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            onTextChanged(textBox.Text)
        end)
    end
    
    -- Focus and unfocus effects
    local originalColor = self.CurrentTheme.Surface
    local focusColor = self.CurrentTheme.Primary:Lerp(self.CurrentTheme.Surface, 0.7)
    
    textBox.Focused:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(frame, tweenInfo, {BackgroundColor3 = focusColor})
        tween:Play()
    end)
    
    textBox.FocusLost:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(frame, tweenInfo, {BackgroundColor3 = originalColor})
        tween:Play()
    end)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        TextBox = textBox,
        Type = "TextInput",
        UpdateTheme = function(self, theme)
            frame.BackgroundColor3 = theme.Surface
            textBox.Font = theme.FontRegular
            textBox.TextColor3 = theme.Text
            textBox.PlaceholderColor3 = theme.Text:Lerp(theme.Surface, 0.5)
            
            originalColor = theme.Surface
            focusColor = theme.Primary:Lerp(theme.Surface, 0.7)
        end
    }
    
    return frame, textBox
end

-- Create a checkbox
function GuiFramework:CreateCheckbox(name, parent, position, text, initialValue, onValueChanged)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundTransparency = 1
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = UDim2.new(0, 200, 0, 30)
    frame.Parent = parent or self.MainContainer
    
    -- Create the checkbox box
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.BackgroundColor3 = self.CurrentTheme.Surface
    box.BorderSizePixel = 0
    box.Position = UDim2.new(0, 0, 0, 0)
    box.Size = UDim2.new(0, 24, 0, 24)
    box.Parent = frame
    
    -- Apply rounded corners to the box
    self:ApplyRoundedCorners(box, UDim.new(0, 4))
    
    -- Create the checkmark (initially invisible)
    local checkmark = Instance.new("ImageLabel")
    checkmark.Name = "Checkmark"
    checkmark.BackgroundTransparency = 1
    checkmark.Position = UDim2.new(0, 4, 0, 4)
    checkmark.Size = UDim2.new(0, 16, 0, 16)
    checkmark.Image = "rbxassetid://3926305904" -- Roblox checkmark icon
    checkmark.ImageRectOffset = Vector2.new(312, 4)
    checkmark.ImageRectSize = Vector2.new(24, 24)
    checkmark.ImageColor3 = self.CurrentTheme.Text
    checkmark.Visible = initialValue or false
    checkmark.Parent = box
    
    -- Create the label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 34, 0, 0)
    label.Size = UDim2.new(1, -34, 1, 0)
    label.Font = self.CurrentTheme.FontRegular
    label.TextColor3 = self.CurrentTheme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text or "Checkbox"
    label.Parent = frame
    
    -- Create a button to handle clicks
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Position = UDim2.new(0, 0, 0, 0)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = frame
    
    -- Track the current value
    local isChecked = initialValue or false
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        isChecked = not isChecked
        checkmark.Visible = isChecked
        
        if onValueChanged then
            onValueChanged(isChecked)
        end
    end)
    
    -- Hover effects
    local originalColor = self.CurrentTheme.Surface
    local hoverColor = self.CurrentTheme.Surface:Lerp(Color3.new(1, 1, 1), 0.2)
    
    button.MouseEnter:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(box, tweenInfo, {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local tween = self.TweenService:Create(box, tweenInfo, {BackgroundColor3 = originalColor})
        tween:Play()
    end)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        Box = box,
        Checkmark = checkmark,
        Label = label,
        Button = button,
        Type = "Checkbox",
        Value = isChecked,
        SetValue = function(self, value)
            isChecked = value
            checkmark.Visible = value
            self.Value = value
            
            if onValueChanged then
                onValueChanged(value)
            end
        end,
        GetValue = function(self)
            return isChecked
        end,
        UpdateTheme = function(self, theme)
            box.BackgroundColor3 = theme.Surface
            checkmark.ImageColor3 = theme.Text
            label.TextColor3 = theme.Text
            label.Font = theme.FontRegular
            
            originalColor = theme.Surface
            hoverColor = theme.Surface:Lerp(Color3.new(1, 1, 1), 0.2)
        end
    }
    
    return self.Elements[name]
end

-- Create a slider
function GuiFramework:CreateSlider(name, parent, position, size, min, max, initialValue, onValueChanged)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundTransparency = 1
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(0, 200, 0, 40)
    frame.Parent = parent or self.MainContainer
    
    -- Create the track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = self.CurrentTheme.Surface
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 0, 0.5, -4)
    track.Size = UDim2.new(1, 0, 0, 8)
    track.Parent = frame
    
    -- Apply rounded corners to the track
    self:ApplyRoundedCorners(track, UDim.new(0, 4))
    
    -- Create the fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = self.CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.Size = UDim2.new(0.5, 0, 1, 0)
    fill.Parent = track
    
    -- Apply rounded corners to the fill
    self:ApplyRoundedCorners(fill, UDim.new(0, 4))
    
    -- Create the handle
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.BackgroundColor3 = self.CurrentTheme.Primary
    handle.BorderSizePixel = 0
    handle.Position = UDim2.new(0.5, -8, 0.5, -8)
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.ZIndex = 2
    handle.Parent = frame
    
    -- Apply rounded corners to the handle (make it circular)
    self:ApplyRoundedCorners(handle, UDim.new(1, 0))
    
    -- Create a value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 0, 0, -20)
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Font = self.CurrentTheme.FontRegular
    valueLabel.TextColor3 = self.CurrentTheme.Text
    valueLabel.TextSize = 12
    valueLabel.Text = tostring(initialValue or math.floor((min + max) / 2))
    valueLabel.Parent = handle
    
    -- Set up slider functionality
    local minValue = min or 0
    local maxValue = max or 100
    local currentValue = initialValue or math.floor((minValue + maxValue) / 2)
    
    -- Function to update the slider position
    local function updateSlider(value)
        -- Clamp the value
        value = math.max(minValue, math.min(maxValue, value))
        currentValue = value
        
        -- Calculate the position
        local percentage = (value - minValue) / (maxValue - minValue)
        
        -- Update the fill and handle
        fill.Size = UDim2.new(percentage, 0, 1, 0)
        handle.Position = UDim2.new(percentage, -8, 0.5, -8)
        
        -- Update the value label
        valueLabel.Text = tostring(math.floor(value))
        
        -- Call the callback
        if onValueChanged then
            onValueChanged(value)
        end
    end
    
    -- Initialize the slider
    updateSlider(currentValue)
    
    -- Create a button to handle interaction
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Position = UDim2.new(0, 0, 0, 0)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = frame
    
    -- Track if the slider is being dragged
    local isDragging = false
    
    -- Mouse button down event
    button.MouseButton1Down:Connect(function(x)
        isDragging = true
        
        -- Calculate the value based on mouse position
        local percentage = (x - frame.AbsolutePosition.X) / frame.AbsoluteSize.X
        percentage = math.max(0, math.min(1, percentage))
        local value = minValue + percentage * (maxValue - minValue)
        
        -- Update the slider
        updateSlider(value)
    end)
    
    -- Mouse move event
    button.MouseMoved:Connect(function(x)
        if isDragging then
            -- Calculate the value based on mouse position
            local percentage = (x - frame.AbsolutePosition.X) / frame.AbsoluteSize.X
            percentage = math.max(0, math.min(1, percentage))
            local value = minValue + percentage * (maxValue - minValue)
            
            -- Update the slider
            updateSlider(value)
        end
    end)
    
    -- Mouse button up event
    button.MouseButton1Up:Connect(function()
        isDragging = false
    end)
    
    -- Mouse leave event
    button.MouseLeave:Connect(function()
        isDragging = false
    end)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        Track = track,
        Fill = fill,
        Handle = handle,
        ValueLabel = valueLabel,
        Type = "Slider",
        MinValue = minValue,
        MaxValue = maxValue,
        Value = currentValue,
        SetValue = function(self, value)
            updateSlider(value)
            self.Value = value
        end,
        GetValue = function(self)
            return currentValue
        end,
        UpdateTheme = function(self, theme)
            track.BackgroundColor3 = theme.Surface
            fill.BackgroundColor3 = theme.Primary
            handle.BackgroundColor3 = theme.Primary
            valueLabel.TextColor3 = theme.Text
            valueLabel.Font = theme.FontRegular
        end
    }
    
    return self.Elements[name]
end

-- Create a dropdown
function GuiFramework:CreateDropdown(name, parent, position, size, options, initialSelection, onSelectionChanged)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(0, 200, 0, 40)
    frame.ClipsDescendants = true
    frame.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(frame)
    
    -- Create the selected option label
    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Name = "SelectedLabel"
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Position = UDim2.new(0, 10, 0, 0)
    selectedLabel.Size = UDim2.new(1, -50, 1, 0)
    selectedLabel.Font = self.CurrentTheme.FontRegular
    selectedLabel.TextColor3 = self.CurrentTheme.Text
    selectedLabel.TextSize = 14
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.Text = options[initialSelection or 1] or "Select an option"
    selectedLabel.Parent = frame
    
    -- Create the arrow
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -30, 0.5, -8)
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Image = "rbxassetid://3926305904" -- Roblox icons asset
    arrow.ImageRectOffset = Vector2.new(564, 284)
    arrow.ImageRectSize = Vector2.new(36, 36)
    arrow.ImageColor3 = self.CurrentTheme.Text
    arrow.Parent = frame
    
    -- Create the options container
    local optionsContainer = Instance.new("Frame")
    optionsContainer.Name = "OptionsContainer"
    optionsContainer.BackgroundColor3 = self.CurrentTheme.Surface
    optionsContainer.BorderSizePixel = 0
    optionsContainer.Position = UDim2.new(0, 0, 1, 5)
    optionsContainer.Size = UDim2.new(1, 0, 0, #options * 30)
    optionsContainer.Visible = false
    optionsContainer.ZIndex = 5
    optionsContainer.Parent = frame
    
    -- Apply rounded corners to the options container
    self:ApplyRoundedCorners(optionsContainer)
    
    -- Create the options
    local optionButtons = {}
    for i, option in ipairs(options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. i
        optionButton.BackgroundTransparency = 1
        optionButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.Font = self.CurrentTheme.FontRegular
        optionButton.TextColor3 = self.CurrentTheme.Text
        optionButton.TextSize = 14
        optionButton.Text = option
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.ZIndex = 6
        
        -- Add padding
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.Parent = optionButton
        
        -- Hover effect
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundTransparency = 0.8
            optionButton.BackgroundColor3 = self.CurrentTheme.Primary
        end)
        
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundTransparency = 1
        end)
        
        -- Click event
        optionButton.MouseButton1Click:Connect(function()
            selectedLabel.Text = option
            optionsContainer.Visible = false
            
            -- Reset arrow rotation
            local tweenInfo = TweenInfo.new(
                self.CurrentTheme.AnimationDuration,
                self.CurrentTheme.EasingStyle,
                self.CurrentTheme.EasingDirection
            )
            local tween = self.TweenService:Create(arrow, tweenInfo, {Rotation = 0})
            tween:Play()
            
            if onSelectionChanged then
                onSelectionChanged(i, option)
            end
        end)
        
        optionButton.Parent = optionsContainer
        table.insert(optionButtons, optionButton)
    end
    
    -- Create a button to handle dropdown toggle
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Position = UDim2.new(0, 0, 0, 0)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = frame
    
    -- Track if the dropdown is open
    local isOpen = false
    
    -- Click event to toggle dropdown
    button.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsContainer.Visible = isOpen
        
        -- Rotate arrow
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        local rotation = isOpen and 180 or 0
        local tween = self.TweenService:Create(arrow, tweenInfo, {Rotation = rotation})
        tween:Play()
    end)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        OptionsContainer = optionsContainer,
        SelectedLabel = selectedLabel,
        Arrow = arrow,
        Options = options,
        OptionButtons = optionButtons,
        Type = "Dropdown",
        SelectedIndex = initialSelection or 1,
        SelectedOption = options[initialSelection or 1],
        SetSelection = function(self, index)
            if options[index] then
                selectedLabel.Text = options[index]
                self.SelectedIndex = index
                self.SelectedOption = options[index]
                
                if onSelectionChanged then
                    onSelectionChanged(index, options[index])
                end
            end
        end,
        GetSelection = function(self)
            return self.SelectedIndex, self.SelectedOption
        end,
        UpdateTheme = function(self, theme)
            frame.BackgroundColor3 = theme.Surface
            optionsContainer.BackgroundColor3 = theme.Surface
            selectedLabel.TextColor3 = theme.Text
            selectedLabel.Font = theme.FontRegular
            arrow.ImageColor3 = theme.Text
            
            for _, optionButton in ipairs(optionButtons) do
                optionButton.TextColor3 = theme.Text
                optionButton.Font = theme.FontRegular
            end
        end
    }
    
    return self.Elements[name]
end

-- Create a toggle switch
function GuiFramework:CreateToggle(name, parent, position, initialValue, onValueChanged)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundTransparency = 1
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = UDim2.new(0, 50, 0, 24)
    frame.Parent = parent or self.MainContainer
    
    -- Create the track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.BackgroundColor3 = initialValue and self.CurrentTheme.Primary or self.CurrentTheme.Surface
    track.BorderSizePixel = 0
    track.Position = UDim2.new(0, 0, 0, 0)
    track.Size = UDim2.new(1, 0, 1, 0)
    track.Parent = frame
    
    -- Apply rounded corners to the track
    self:ApplyRoundedCorners(track, UDim.new(1, 0))
    
    -- Create the handle
    local handle = Instance.new("Frame")
    handle.Name = "Handle"
    handle.BackgroundColor3 = self.CurrentTheme.Text
    handle.BorderSizePixel = 0
    handle.Position = UDim2.new(initialValue and 0.6 or 0.1, 0, 0.5, -8)
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.ZIndex = 2
    handle.Parent = track
    
    -- Apply rounded corners to the handle (make it circular)
    self:ApplyRoundedCorners(handle, UDim.new(1, 0))
    
    -- Create a button to handle interaction
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Position = UDim2.new(0, 0, 0, 0)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = frame
    
    -- Track the current value
    local isOn = initialValue or false
    
    -- Function to update the toggle state
    local function updateToggle(value)
        isOn = value
        
        -- Create tween info
        local tweenInfo = TweenInfo.new(
            self.CurrentTheme.AnimationDuration,
            self.CurrentTheme.EasingStyle,
            self.CurrentTheme.EasingDirection
        )
        
        -- Tween the track color
        local trackTween = self.TweenService:Create(track, tweenInfo, {
            BackgroundColor3 = isOn and self.CurrentTheme.Primary or self.CurrentTheme.Surface
        })
        trackTween:Play()
        
        -- Tween the handle position
        local handleTween = self.TweenService:Create(handle, tweenInfo, {
            Position = UDim2.new(isOn and 0.6 or 0.1, 0, 0.5, -8)
        })
        handleTween:Play()
        
        -- Call the callback
        if onValueChanged then
            onValueChanged(isOn)
        end
    end
    
    -- Click event
    button.MouseButton1Click:Connect(function()
        updateToggle(not isOn)
    end)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        Track = track,
        Handle = handle,
        Type = "Toggle",
        Value = isOn,
        SetValue = function(self, value)
            updateToggle(value)
            self.Value = value
        end,
        GetValue = function(self)
            return isOn
        end,
        UpdateTheme = function(self, theme)
            track.BackgroundColor3 = isOn and theme.Primary or theme.Surface
            handle.BackgroundColor3 = theme.Text
        end
    }
    
    return self.Elements[name]
end

-- Create a progress bar
function GuiFramework:CreateProgressBar(name, parent, position, size, initialValue, color)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(0, 200, 0, 20)
    frame.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(frame)
    
    -- Create the fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = color or self.CurrentTheme.Primary
    fill.BorderSizePixel = 0
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.Size = UDim2.new(initialValue or 0.5, 0, 1, 0)
    fill.Parent = frame
    
    -- Apply rounded corners to the fill
    self:ApplyRoundedCorners(fill)
    
    -- Create a value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0, 0, 0, 0)
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Font = self.CurrentTheme.FontSemiBold
    valueLabel.TextColor3 = self.CurrentTheme.Text
    valueLabel.TextSize = 12
    valueLabel.Text = tostring(math.floor((initialValue or 0.5) * 100)) .. "%"
    valueLabel.Parent = frame
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        Fill = fill,
        ValueLabel = valueLabel,
        Type = "ProgressBar",
        Value = initialValue or 0.5,
        SetValue = function(self, value)
            -- Clamp the value
            value = math.max(0, math.min(1, value))
            self.Value = value
            
            -- Create tween info
            local tweenInfo = TweenInfo.new(
                0.3,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )
            
            -- Tween the fill size
            local fillTween = self.TweenService:Create(fill, tweenInfo, {
                Size = UDim2.new(value, 0, 1, 0)
            })
            fillTween:Play()
            
            -- Update the value label
            valueLabel.Text = tostring(math.floor(value * 100)) .. "%"
        end,
        GetValue = function(self)
            return self.Value
        end,
        UpdateTheme = function(self, theme)
            frame.BackgroundColor3 = theme.Surface
            fill.BackgroundColor3 = color or theme.Primary
            valueLabel.TextColor3 = theme.Text
            valueLabel.Font = theme.FontSemiBold
        end
    }
    
    return self.Elements[name]
end

-- Create a tab container
function GuiFramework:CreateTabContainer(name, parent, position, size, tabs)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = size or UDim2.new(0, 400, 0, 300)
    frame.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(frame)
    
    -- Create the tab buttons container
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.BackgroundColor3 = self.CurrentTheme.Background
    tabButtons.BorderSizePixel = 0
    tabButtons.Position = UDim2.new(0, 0, 0, 0)
    tabButtons.Size = UDim2.new(1, 0, 0, 40)
    tabButtons.Parent = frame
    
    -- Apply rounded corners to the top of the tab buttons
    local tabButtonsCorner = Instance.new("UICorner")
    tabButtonsCorner.CornerRadius = self.CurrentTheme.CornerRadius
    tabButtonsCorner.Parent = tabButtons
    
    -- Create a list layout for the tab buttons
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = tabButtons
    
    -- Add padding to the tab buttons
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 5)
    padding.Parent = tabButtons
    
    -- Create the content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 0, 0, 40)
    contentContainer.Size = UDim2.new(1, 0, 1, -40)
    contentContainer.Parent = frame
    
    -- Create tab buttons and content frames
    local tabFrames = {}
    local activeTab = 1
    
    for i, tab in ipairs(tabs) do
        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Tab_" .. i
        tabButton.BackgroundColor3 = i == activeTab and self.CurrentTheme.Primary or self.CurrentTheme.Background
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(0, 100, 0, 30)
        tabButton.Font = self.CurrentTheme.FontSemiBold
        tabButton.TextColor3 = i == activeTab and self.CurrentTheme.Text or self.CurrentTheme.Text:Lerp(self.CurrentTheme.Background, 0.3)
        tabButton.TextSize = 14
        tabButton.Text = tab.name or "Tab " .. i
        tabButton.LayoutOrder = i
        tabButton.Parent = tabButtons
        
        -- Apply rounded corners to the tab button
        self:ApplyRoundedCorners(tabButton, UDim.new(0, 6))
        
        -- Create content frame
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content_" .. i
        contentFrame.BackgroundTransparency = 1
        contentFrame.Position = UDim2.new(0, 0, 0, 0)
        contentFrame.Size = UDim2.new(1, 0, 1, 0)
        contentFrame.Visible = i == activeTab
        contentFrame.Parent = contentContainer
        
        -- Apply padding to the content frame
        self:ApplyPadding(contentFrame)
        
        -- Store the tab frame
        tabFrames[i] = {
            Button = tabButton,
            Content = contentFrame
        }
        
        -- Tab button click event
        tabButton.MouseButton1Click:Connect(function()
            -- Deactivate current tab
            tabFrames[activeTab].Button.BackgroundColor3 = self.CurrentTheme.Background
            tabFrames[activeTab].Button.TextColor3 = self.CurrentTheme.Text:Lerp(self.CurrentTheme.Background, 0.3)
            tabFrames[activeTab].Content.Visible = false
            
            -- Activate new tab
            activeTab = i
            tabButton.BackgroundColor3 = self.CurrentTheme.Primary
            tabButton.TextColor3 = self.CurrentTheme.Text
            contentFrame.Visible = true
            
            -- Call the tab's callback if it exists
            if tab.callback then
                tab.callback(i, tab.name)
            end
        end)
    end
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        TabButtons = tabButtons,
        ContentContainer = contentContainer,
        Tabs = tabFrames,
        ActiveTab = activeTab,
        Type = "TabContainer",
        SetActiveTab = function(self, index)
            if tabFrames[index] then
                -- Simulate a click on the tab button
                tabFrames[index].Button.MouseButton1Click:Fire()
            end
        end,
        GetActiveTab = function(self)
            return activeTab
        end,
        UpdateTheme = function(self, theme)
            frame.BackgroundColor3 = theme.Surface
            tabButtons.BackgroundColor3 = theme.Background
            
            for i, tabFrame in ipairs(tabFrames) do
                tabFrame.Button.BackgroundColor3 = i == activeTab and theme.Primary or theme.Background
                tabFrame.Button.TextColor3 = i == activeTab and theme.Text or theme.Text:Lerp(theme.Background, 0.3)
                tabFrame.Button.Font = theme.FontSemiBold
            end
        end
    }
    
    return self.Elements[name], contentContainer
end

-- Create a notification
function GuiFramework:CreateNotification(title, message, type, duration)
    -- Create a notification container if it doesn't exist
    if not self.NotificationContainer then
        self.NotificationContainer = Instance.new("Frame")
        self.NotificationContainer.Name = "NotificationContainer"
        self.NotificationContainer.BackgroundTransparency = 1
        self.NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
        self.NotificationContainer.Size = UDim2.new(0, 300, 1, -40)
        self.NotificationContainer.Parent = self.ScreenGui
        
        -- Create a list layout for the notifications
        local listLayout = Instance.new("UIListLayout")
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 10)
        listLayout.Parent = self.NotificationContainer
    end
    
    -- Determine the notification color based on type
    local color
    if type == "success" then
        color = self.CurrentTheme.Success
    elseif type == "warning" then
        color = self.CurrentTheme.Warning
    elseif type == "error" then
        color = self.CurrentTheme.Error
    else
        color = self.CurrentTheme.Primary
    end
    
    -- Create the notification frame
    local notification = Instance.new("Frame")
    notification.Name = "Notification_" .. os.time()
    notification.BackgroundColor3 = self.CurrentTheme.Surface
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 0, 0, 0)
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.Parent = self.NotificationContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(notification)
    
    -- Create a colored indicator
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.BackgroundColor3 = color
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.Size = UDim2.new(0, 5, 1, 0)
    indicator.Parent = notification
    
    -- Apply rounded corners to the left side of the indicator
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = indicator
    
    -- Create the title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -50, 0, 20)
    titleLabel.Font = self.CurrentTheme.FontBold
    titleLabel.TextColor3 = self.CurrentTheme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title or "Notification"
    titleLabel.Parent = notification
    
    -- Create the message label
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.BackgroundTransparency = 1
    messageLabel.Position = UDim2.new(0, 15, 0, 35)
    messageLabel.Size = UDim2.new(1, -30, 0, 35)
    messageLabel.Font = self.CurrentTheme.FontRegular
    messageLabel.TextColor3 = self.CurrentTheme.Text:Lerp(self.CurrentTheme.Surface, 0.2)
    messageLabel.TextSize = 14
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Text = message or ""
    messageLabel.Parent = notification
    
    -- Create a close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -25, 0, 10)
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Font = self.CurrentTheme.FontBold
    closeButton.TextColor3 = self.CurrentTheme.Text:Lerp(self.CurrentTheme.Surface, 0.2)
    closeButton.TextSize = 14
    closeButton.Text = "×"
    closeButton.Parent = notification
    
    -- Animate the notification in
    notification.Position = UDim2.new(1, 0, 0, 0)
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    local tween = self.TweenService:Create(notification, tweenInfo, {
        Position = UDim2.new(0, 0, 0, 0)
    })
    tween:Play()
    
    -- Close button click event
    closeButton.MouseButton1Click:Connect(function()
        -- Animate the notification out
        local tweenInfo = TweenInfo.new(
            0.3,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        )
        local tween = self.TweenService:Create(notification, tweenInfo, {
            Position = UDim2.new(1, 0, 0, 0)
        })
        tween:Play()
        
        -- Destroy the notification after the animation
        tween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    -- Auto-close the notification after the specified duration
    if duration ~= nil then
        delay(duration or 5, function()
            -- Check if the notification still exists
            if notification and notification.Parent then
                -- Animate the notification out
                local tweenInfo = TweenInfo.new(
                    0.3,
                    Enum.EasingStyle.Quad,
                    Enum.EasingDirection.In
                )
                local tween = self.TweenService:Create(notification, tweenInfo, {
                    Position = UDim2.new(1, 0, 0, 0)
                })
                tween:Play()
                
                -- Destroy the notification after the animation
                tween.Completed:Connect(function()
                    notification:Destroy()
                end)
            end
        end)
    end
    
    return notification
end

-- Create a modal dialog
function GuiFramework:CreateModal(title, content, buttons)
    -- Create a modal background
    local modalBackground = Instance.new("Frame")
    modalBackground.Name = "ModalBackground"
    modalBackground.BackgroundColor3 = Color3.new(0, 0, 0)
    modalBackground.BackgroundTransparency = 0.5
    modalBackground.Position = UDim2.new(0, 0, 0, 0)
    modalBackground.Size = UDim2.new(1, 0, 1, 0)
    modalBackground.ZIndex = 100
    modalBackground.Parent = self.ScreenGui
    
    -- Create the modal frame
    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.BackgroundColor3 = self.CurrentTheme.Surface
    modal.BorderSizePixel = 0
    modal.Position = UDim2.new(0.5, -200, 0.5, -150)
    modal.Size = UDim2.new(0, 400, 0, 300)
    modal.ZIndex = 101
    modal.Parent = modalBackground
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(modal)
    
    -- Create the title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = self.CurrentTheme.Primary
    titleBar.BorderSizePixel = 0
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.ZIndex = 102
    titleBar.Parent = modal
    
    -- Apply rounded corners to the top of the title bar
    local titleBarCorner = Instance.new("UICorner")
    titleBarCorner.CornerRadius = self.CurrentTheme.CornerRadius
    titleBarCorner.Parent = titleBar
    
    -- Create the title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Font = self.CurrentTheme.FontBold
    titleLabel.TextColor3 = self.CurrentTheme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title or "Modal Dialog"
    titleLabel.ZIndex = 103
    titleLabel.Parent = titleBar
    
    -- Create a close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundTransparency = 1
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Font = self.CurrentTheme.FontBold
    closeButton.TextColor3 = self.CurrentTheme.Text
    closeButton.TextSize = 20
    closeButton.Text = "×"
    closeButton.ZIndex = 103
    closeButton.Parent = titleBar
    
    -- Create the content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.BackgroundTransparency = 1
    contentContainer.Position = UDim2.new(0, 15, 0, 50)
    contentContainer.Size = UDim2.new(1, -30, 0, 190)
    contentContainer.ZIndex = 102
    contentContainer.Parent = modal
    
    -- Create the content based on type
    if type(content) == "string" then
        -- Create a text label for string content
        local contentLabel = Instance.new("TextLabel")
        contentLabel.Name = "ContentLabel"
        contentLabel.BackgroundTransparency = 1
        contentLabel.Position = UDim2.new(0, 0, 0, 0)
        contentLabel.Size = UDim2.new(1, 0, 1, 0)
        contentLabel.Font = self.CurrentTheme.FontRegular
        contentLabel.TextColor3 = self.CurrentTheme.Text
        contentLabel.TextSize = 14
        contentLabel.TextWrapped = true
        contentLabel.TextXAlignment = Enum.TextXAlignment.Left
        contentLabel.TextYAlignment = Enum.TextYAlignment.Top
        contentLabel.Text = content
        contentLabel.ZIndex = 102
        contentLabel.Parent = contentContainer
    elseif typeof(content) == "Instance" then
        -- Use the provided instance as content
        content.Position = UDim2.new(0, 0, 0, 0)
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Parent = contentContainer
    end
    
    -- Create the button container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "ButtonContainer"
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Position = UDim2.new(0, 15, 1, -60)
    buttonContainer.Size = UDim2.new(1, -30, 0, 40)
    buttonContainer.ZIndex = 102
    buttonContainer.Parent = modal
    
    -- Create a list layout for the buttons
    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Horizontal
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = buttonContainer
    
    -- Create the buttons
    if buttons then
        for i, buttonInfo in ipairs(buttons) do
            local button = Instance.new("TextButton")
            button.Name = "Button_" .. i
            button.BackgroundColor3 = buttonInfo.primary and self.CurrentTheme.Primary or self.CurrentTheme.Surface
            button.BorderSizePixel = 0
            button.Size = UDim2.new(0, 100, 0, 40)
            button.Font = self.CurrentTheme.FontSemiBold
            button.TextColor3 = buttonInfo.primary and self.CurrentTheme.Text or self.CurrentTheme.Text:Lerp(self.CurrentTheme.Surface, 0.2)
            button.TextSize = 14
            button.Text = buttonInfo.text or "Button"
            button.ZIndex = 103
            button.LayoutOrder = i
            button.Parent = buttonContainer
            
            -- Apply rounded corners
            self:ApplyRoundedCorners(button)
            
            -- Click event
            if buttonInfo.callback then
                button.MouseButton1Click:Connect(function()
                    buttonInfo.callback()
                    
                    -- Close the modal if closeOnClick is true or not specified
                    if buttonInfo.closeOnClick ~= false then
                        modalBackground:Destroy()
                    end
                end)
            else
                -- Default behavior is to close the modal
                button.MouseButton1Click:Connect(function()
                    modalBackground:Destroy()
                end)
            end
        end
    else
        -- Create a default OK button
        local okButton = Instance.new("TextButton")
        okButton.Name = "OkButton"
        okButton.BackgroundColor3 = self.CurrentTheme.Primary
        okButton.BorderSizePixel = 0
        okButton.Size = UDim2.new(0, 100, 0, 40)
        okButton.Font = self.CurrentTheme.FontSemiBold
        okButton.TextColor3 = self.CurrentTheme.Text
        okButton.TextSize = 14
        okButton.Text = "OK"
        okButton.ZIndex = 103
        okButton.Parent = buttonContainer
        
        -- Apply rounded corners
        self:ApplyRoundedCorners(okButton)
        
        -- Click event
        okButton.MouseButton1Click:Connect(function()
            modalBackground:Destroy()
        end)
    end
    
    -- Close button click event
    closeButton.MouseButton1Click:Connect(function()
        modalBackground:Destroy()
    end)
    
    -- Animate the modal in
    modal.Position = UDim2.new(0.5, -200, 0, -300)
    local tweenInfo = TweenInfo.new(
        0.5,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    local tween = self.TweenService:Create(modal, tweenInfo, {
        Position = UDim2.new(0.5, -200, 0.5, -150)
    })
    tween:Play()
    
    return modal, modalBackground
end

-- Create a tooltip
function GuiFramework:CreateTooltip(text, parent, position)
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.BackgroundColor3 = self.CurrentTheme.Background
    tooltip.BorderSizePixel = 0
    tooltip.Position = position or UDim2.new(0, 0, 0, 0)
    tooltip.Size = UDim2.new(0, 200, 0, 30)
    tooltip.Visible = false
    tooltip.ZIndex = 1000
    tooltip.Parent = parent or self.ScreenGui
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(tooltip)
    
    -- Create the text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Font = self.CurrentTheme.FontRegular
    textLabel.TextColor3 = self.CurrentTheme.Text
    textLabel.TextSize = 12
    textLabel.Text = text or "Tooltip"
    textLabel.ZIndex = 1001
    textLabel.Parent = tooltip
    
    -- Apply padding
    self:ApplyPadding(textLabel, UDim.new(0, 5))
    
    -- Adjust the tooltip size based on the text
    local textSize = game:GetService("TextService"):GetTextSize(
        textLabel.Text,
        textLabel.TextSize,
        textLabel.Font,
        Vector2.new(1000, 1000)
    )
    tooltip.Size = UDim2.new(0, textSize.X + 20, 0, textSize.Y + 10)
    
    -- Return the tooltip with show and hide functions
    return {
        Instance = tooltip,
        Show = function(self, x, y)
            tooltip.Position = UDim2.new(0, x, 0, y)
            tooltip.Visible = true
        end,
        Hide = function(self)
            tooltip.Visible = false
        end,
        SetText = function(self, newText)
            textLabel.Text = newText
            
            -- Adjust the tooltip size based on the new text
            local textSize = game:GetService("TextService"):GetTextSize(
                textLabel.Text,
                textLabel.TextSize,
                textLabel.Font,
                Vector2.new(1000, 1000)
            )
            tooltip.Size = UDim2.new(0, textSize.X + 20, 0, textSize.Y + 10)
        end,
        UpdateTheme = function(self, theme)
            tooltip.BackgroundColor3 = theme.Background
            textLabel.TextColor3 = theme.Text
            textLabel.Font = theme.FontRegular
        end
    }
end

-- Add tooltip to an element
function GuiFramework:AddTooltipToElement(element, text)
    local tooltip = self:CreateTooltip(text)
    
    -- Mouse enter event
    element.MouseEnter:Connect(function()
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        tooltip:Show(mouse.X + 5, mouse.Y + 5)
    end)
    
    -- Mouse move event
    element.MouseMoved:Connect(function(x, y)
        tooltip:Show(x + 5, y + 5)
    end)
    
    -- Mouse leave event
    element.MouseLeave:Connect(function()
        tooltip:Hide()
    end)
    
    return tooltip
end

-- Create a color picker
function GuiFramework:CreateColorPicker(name, parent, position, initialColor, onColorChanged)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.BackgroundColor3 = self.CurrentTheme.Surface
    frame.BorderSizePixel = 0
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.Size = UDim2.new(0, 200, 0, 40)
    frame.Parent = parent or self.MainContainer
    
    -- Apply rounded corners
    self:ApplyRoundedCorners(frame)
    
    -- Create the color display
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Name = "ColorDisplay"
    colorDisplay.BackgroundColor3 = initialColor or Color3.fromRGB(255, 0, 0)
    colorDisplay.BorderSizePixel = 0
    colorDisplay.Position = UDim2.new(0, 10, 0.5, -15)
    colorDisplay.Size = UDim2.new(0, 30, 0, 30)
    colorDisplay.Parent = frame
    
    -- Apply rounded corners to the color display
    self:ApplyRoundedCorners(colorDisplay, UDim.new(0, 4))
    
    -- Create the color value label
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Name = "ColorLabel"
    colorLabel.BackgroundTransparency = 1
    colorLabel.Position = UDim2.new(0, 50, 0, 0)
    colorLabel.Size = UDim2.new(1, -60, 1, 0)
    colorLabel.Font = self.CurrentTheme.FontRegular
    colorLabel.TextColor3 = self.CurrentTheme.Text
    colorLabel.TextSize = 14
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left
    colorLabel.Text = string.format("RGB(%d, %d, %d)", 
        math.floor(initialColor.R * 255 or 255), 
        math.floor(initialColor.G * 255 or 0), 
        math.floor(initialColor.B * 255 or 0))
    colorLabel.Parent = frame
    
    -- Create a button to handle clicks
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.BackgroundTransparency = 1
    button.Position = UDim2.new(0, 0, 0, 0)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    button.Parent = frame
    
    -- Create the color picker popup
    local popup = Instance.new("Frame")
    popup.Name = "ColorPickerPopup"
    popup.BackgroundColor3 = self.CurrentTheme.Surface
    popup.BorderSizePixel = 0
    popup.Position = UDim2.new(0, 0, 1, 10)
    popup.Size = UDim2.new(0, 200, 0, 220)
    popup.Visible = false
    popup.ZIndex = 10
    popup.Parent = frame
    
    -- Apply rounded corners to the popup
    self:ApplyRoundedCorners(popup)
    
    -- Create the color hue picker
    local huePicker = Instance.new("ImageLabel")
    huePicker.Name = "HuePicker"
    huePicker.BackgroundTransparency = 1
    huePicker.Position = UDim2.new(0, 10, 0, 10)
    huePicker.Size = UDim2.new(0, 180, 0, 20)
    huePicker.Image = "rbxassetid://3641079629" -- Hue gradient image
    huePicker.ZIndex = 11
    huePicker.Parent = popup
    
    -- Apply rounded corners to the hue picker
    self:ApplyRoundedCorners(huePicker, UDim.new(0, 4))
    
    -- Create the hue selector
    local hueSelector = Instance.new("Frame")
    hueSelector.Name = "HueSelector"
    hueSelector.BackgroundColor3 = Color3.new(1, 1, 1)
    hueSelector.BorderSizePixel = 0
    hueSelector.Position = UDim2.new(0, 0, 0, 0)
    hueSelector.Size = UDim2.new(0, 5, 1, 0)
    hueSelector.ZIndex = 12
    hueSelector.Parent = huePicker
    
    -- Create the color saturation/value picker
    local svPicker = Instance.new("ImageLabel")
    svPicker.Name = "SVPicker"
    svPicker.BackgroundColor3 = Color3.fromHSV(1, 1, 1) -- Red
    svPicker.BorderSizePixel = 0
    svPicker.Position = UDim2.new(0, 10, 0, 40)
    svPicker.Size = UDim2.new(0, 180, 0, 130)
    svPicker.Image = "rbxassetid://3641079629" -- Will be overlaid with gradients
    svPicker.ZIndex = 11
    svPicker.Parent = popup
    
    -- Apply rounded corners to the SV picker
    self:ApplyRoundedCorners(svPicker, UDim.new(0, 4))
    
    -- Create the SV selector
    local svSelector = Instance.new("Frame")
    svSelector.Name = "SVSelector"
    svSelector.BackgroundColor3 = Color3.new(1, 1, 1)
    svSelector.BorderSizePixel = 0
    svSelector.Position = UDim2.new(0, 0, 0, 0)
    svSelector.Size = UDim2.new(0, 10, 0, 10)
    svSelector.ZIndex = 12
    svSelector.Parent = svPicker
    
    -- Apply rounded corners to the SV selector (make it circular)
    self:ApplyRoundedCorners(svSelector, UDim.new(1, 0))
    
    -- Create RGB input fields
    local rInput = Instance.new("TextBox")
    rInput.Name = "RInput"
    rInput.BackgroundColor3 = self.CurrentTheme.Background
    rInput.BorderSizePixel = 0
    rInput.Position = UDim2.new(0, 10, 0, 180)
    rInput.Size = UDim2.new(0, 50, 0, 30)
    rInput.Font = self.CurrentTheme.FontRegular
    rInput.TextColor3 = self.CurrentTheme.Text
    rInput.TextSize = 14
    rInput.Text = tostring(math.floor(initialColor.R * 255 or 255))
    rInput.PlaceholderText = "R"
    rInput.ZIndex = 11
    rInput.Parent = popup
    
    -- Apply rounded corners to the R input
    self:ApplyRoundedCorners(rInput, UDim.new(0, 4))
    
    local gInput = Instance.new("TextBox")
    gInput.Name = "GInput"
    gInput.BackgroundColor3 = self.CurrentTheme.Background
    gInput.BorderSizePixel = 0
    gInput.Position = UDim2.new(0, 70, 0, 180)
    gInput.Size = UDim2.new(0, 50, 0, 30)
    gInput.Font = self.CurrentTheme.FontRegular
    gInput.TextColor3 = self.CurrentTheme.Text
    gInput.TextSize = 14
    gInput.Text = tostring(math.floor(initialColor.G * 255 or 0))
    gInput.PlaceholderText = "G"
    gInput.ZIndex = 11
    gInput.Parent = popup
    
    -- Apply rounded corners to the G input
    self:ApplyRoundedCorners(gInput, UDim.new(0, 4))
    
    local bInput = Instance.new("TextBox")
    bInput.Name = "BInput"
    bInput.BackgroundColor3 = self.CurrentTheme.Background
    bInput.BorderSizePixel = 0
    bInput.Position = UDim2.new(0, 130, 0, 180)
    bInput.Size = UDim2.new(0, 50, 0, 30)
    bInput.Font = self.CurrentTheme.FontRegular
    bInput.TextColor3 = self.CurrentTheme.Text
    bInput.TextSize = 14
    bInput.Text = tostring(math.floor(initialColor.B * 255 or 0))
    bInput.PlaceholderText = "B"
    bInput.ZIndex = 11
    bInput.Parent = popup
    
    -- Apply rounded corners to the B input
    self:ApplyRoundedCorners(bInput, UDim.new(0, 4))
    
    -- Track the current color
    local currentColor = initialColor or Color3.fromRGB(255, 0, 0)
    local currentH, currentS, currentV = Color3.toHSV(currentColor)
    
    -- Function to update the color
    local function updateColor(color)
        currentColor = color
        colorDisplay.BackgroundColor3 = color
        colorLabel.Text = string.format("RGB(%d, %d, %d)", 
            math.floor(color.R * 255), 
            math.floor(color.G * 255), 
            math.floor(color.B * 255))
        
        -- Update RGB inputs
        rInput.Text = tostring(math.floor(color.R * 255))
        gInput.Text = tostring(math.floor(color.G * 255))
        bInput.Text = tostring(math.floor(color.B * 255))
        
        -- Call the callback
        if onColorChanged then
            onColorChanged(color)
        end
    end
    
    -- Function to update from HSV
    local function updateFromHSV(h, s, v)
        currentH, currentS, currentV = h, s, v
        local color = Color3.fromHSV(h, s, v)
        updateColor(color)
        
        -- Update the SV picker background color
        svPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        
        -- Update the hue selector position
        hueSelector.Position = UDim2.new(h, -2.5, 0, 0)
        
        -- Update the SV selector position
        svSelector.Position = UDim2.new(s, -5, 1 - v, -5)
    end
    
    -- Function to update from RGB
    local function updateFromRGB(r, g, b)
        local color = Color3.fromRGB(r, g, b)
        currentH, currentS, currentV = Color3.toHSV(color)
        updateColor(color)
        
        -- Update the SV picker background color
        svPicker.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1)
        
        -- Update the hue selector position
        hueSelector.Position = UDim2.new(currentH, -2.5, 0, 0)
        
        -- Update the SV selector position
        svSelector.Position = UDim2.new(currentS, -5, 1 - currentV, -5)
    end
    
    -- Initialize with the current color
    updateFromHSV(currentH, currentS, currentV)
    
    -- Hue picker mouse events
    huePicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local hue = (input.Position.X - huePicker.AbsolutePosition.X) / huePicker.AbsoluteSize.X
            hue = math.clamp(hue, 0, 1)
            updateFromHSV(hue, currentS, currentV)
        end
    end)
    
    huePicker.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if input.UserInputState == Enum.UserInputState.Change then
                local hue = (input.Position.X - huePicker.AbsolutePosition.X) / huePicker.AbsoluteSize.X
                hue = math.clamp(hue, 0, 1)
                updateFromHSV(hue, currentS, currentV)
            end
        end
    end)
    
    -- SV picker mouse events
    svPicker.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local s = (input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X
            local v = 1 - (input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y
            s = math.clamp(s, 0, 1)
            v = math.clamp(v, 0, 1)
            updateFromHSV(currentH, s, v)
        end
    end)
    
    svPicker.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if input.UserInputState == Enum.UserInputState.Change then
                local s = (input.Position.X - svPicker.AbsolutePosition.X) / svPicker.AbsoluteSize.X
                local v = 1 - (input.Position.Y - svPicker.AbsolutePosition.Y) / svPicker.AbsoluteSize.Y
                s = math.clamp(s, 0, 1)
                v = math.clamp(v, 0, 1)
                updateFromHSV(currentH, s, v)
            end
        end
    end)
    
    -- RGB input events
    rInput.FocusLost:Connect(function(enterPressed)
        local r = tonumber(rInput.Text) or 0
        r = math.clamp(r, 0, 255) / 255
        updateFromRGB(r, currentColor.G, currentColor.B)
    end)
    
    gInput.FocusLost:Connect(function(enterPressed)
        local g = tonumber(gInput.Text) or 0
        g = math.clamp(g, 0, 255) / 255
        updateFromRGB(currentColor.R, g, currentColor.B)
    end)
    
    bInput.FocusLost:Connect(function(enterPressed)
        local b = tonumber(bInput.Text) or 0
        b = math.clamp(b, 0, 255) / 255
        updateFromRGB(currentColor.R, currentColor.G, b)
    end)
    
    -- Button click event to toggle popup
    button.MouseButton1Click:Connect(function()
        popup.Visible = not popup.Visible
    end)
    
    -- Store the element
    self.Elements[name] = {
        Instance = frame,
        ColorDisplay = colorDisplay,
        ColorLabel = colorLabel,
        Popup = popup,
        Type = "ColorPicker",
        Color = currentColor,
        SetColor = function(self, color)
            updateColor(color)
            currentH, currentS, currentV = Color3.toHSV(color)
            
            -- Update the SV picker background color
            svPicker.BackgroundColor3 = Color3.fromHSV(currentH, 1, 1)
            
            -- Update the hue selector position
            hueSelector.Position = UDim2.new(currentH, -2.5, 0, 0)
            
            -- Update the SV selector position
            svSelector.Position = UDim2.new(currentS, -5, 1 - currentV, -5)
            
            self.Color = color
        end,
        GetColor = function(self)
            return currentColor
        end,
        UpdateTheme = function(self, theme)
            frame.BackgroundColor3 = theme.Surface
            colorLabel.TextColor3 = theme.Text
            colorLabel.Font = theme.FontRegular
            popup.BackgroundColor3 = theme.Surface
            rInput.BackgroundColor3 = theme.Background
            rInput.TextColor3 = theme.Text
            rInput.Font = theme.FontRegular
            gInput.BackgroundColor3 = theme.Background
            gInput.TextColor3 = theme.Text
            gInput.Font = theme.FontRegular
            bInput.BackgroundColor3 = theme.Background
            bInput.TextColor3 = theme.Text
            bInput.Font = theme.FontRegular
        end
    }
    
    return self.Elements[name]
end

-- Return the GUI Framework
return GuiFramework
