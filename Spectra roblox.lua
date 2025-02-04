-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Cheat Variables
local CheatEnabled = true
local ESP_Enabled = false
local Aimbot_Enabled = false
local Aimbot_Strength = 5
local BunnyHop_Enabled = false
local AntiAim_Enabled = false
local SpinSpeed = 10  -- Speed of the Anti-Aim Spin
local ESP_Color = Color3.fromRGB(255, 0, 0) -- Default Red

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Spectra Toggle Button
local SpectraButton = Instance.new("TextButton")
SpectraButton.Size = UDim2.new(0, 100, 0, 40)
SpectraButton.Position = UDim2.new(0, 10, 0.5, -20)
SpectraButton.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
SpectraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpectraButton.Text = "Spectra"
SpectraButton.Font = Enum.Font.SourceSansBold
SpectraButton.TextSize = 18
SpectraButton.Parent = ScreenGui

-- Main UI
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
MainFrame.BorderSizePixel = 2
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
Title.Text = "Spectra Cheat Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Function to Add Buttons
function createButton(text, pos, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.Position = UDim2.new(0, 5, 0, pos)
    Button.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = text
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.Parent = MainFrame
    Button.MouseButton1Click:Connect(callback)
end

-- Create Slider for Aimbot Strength
function createSlider(minValue, maxValue, defaultValue, text, position, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0, 300, 0, 50)
    SliderFrame.Position = UDim2.new(0, 5, 0, position)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    SliderFrame.Parent = MainFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Text = text
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextSize = 16
    SliderLabel.Parent = SliderFrame

    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(1, 0, 0, 10)
    Slider.Position = UDim2.new(0, 0, 0, 20)
    Slider.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    Slider.Text = ""
    Slider.Parent = SliderFrame

    local Handle = Instance.new("Frame")
    Handle.Size = UDim2.new(0, 50, 0, 10)
    Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handle.Parent = Slider

    Handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local newPos = math.clamp(input.Position.X - Slider.AbsolutePosition.X, 0, Slider.AbsoluteSize.X)
            Handle.Position = UDim2.new(0, newPos, 0, 0)
            local percentage = newPos / Slider.AbsoluteSize.X
            local value = minValue + (percentage * (maxValue - minValue))
            callback(value)
        end
    end)

    callback(defaultValue) -- Set initial value
end

-- Toggle Cheat
createButton("Toggle Cheat", 50, function()
    CheatEnabled = not CheatEnabled
end)

-- ESP Toggle
createButton("Toggle ESP", 90, function()
    ESP_Enabled = not ESP_Enabled
end)

-- Aimbot Toggle
createButton("Toggle Aimbot", 130, function()
    Aimbot_Enabled = not Aimbot_Enabled
end)

-- Anti-Aim Toggle
createButton("Toggle Anti-Aim", 170, function()
    AntiAim_Enabled = not AntiAim_Enabled
end)

-- ESP Color Picker
local ColorPicker = Instance.new("TextButton")
ColorPicker.Size = UDim2.new(1, -10, 0, 30)
ColorPicker.Position = UDim2.new(0, 5, 0, 250)
ColorPicker.BackgroundColor3 = ESP_Color
ColorPicker.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorPicker.Text = "Pick ESP Color"
ColorPicker.Font = Enum.Font.SourceSansBold
ColorPicker.TextSize = 16
ColorPicker.Parent = MainFrame
ColorPicker.MouseButton1Click:Connect(function()
    ESP_Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    ColorPicker.BackgroundColor3 = ESP_Color
end)

-- Spectra Button Toggles UI
SpectraButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Insert Key Toggles UI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Aimbot Strength Slider
createSlider(0, 100, 5, "Aimbot Strength", 250, function(value)
    Aimbot_Strength = value
end)

-- Spin Speed Slider
createSlider(1, 50, 10, "Anti-Aim Spin Speed", 300, function(value)
    SpinSpeed = value
end)

-- ESP Function
RunService.RenderStepped:Connect(function()
    if ESP_Enabled and CheatEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local RootPart = player.Character.HumanoidRootPart
                local vector, onScreen = Camera:WorldToViewportPoint(RootPart.Position)
                if onScreen then
                    local ESPBox = Drawing.new("Square")
                    ESPBox.Size = Vector2.new(50, 50)
                    ESPBox.Position = Vector2.new(vector.X - 25, vector.Y - 25)
                    ESPBox.Color = ESP_Color
                    ESPBox.Visible = true
                    ESPBox.Filled = false
                    ESPBox.Thickness = 2

                    RunService.RenderStepped:Wait()
                    ESPBox:Remove()
                end
            end
        end
    end
end)

-- Aimbot Function
RunService.RenderStepped:Connect(function()
    if Aimbot_Enabled and CheatEnabled then
        local closestPlayer = nil
        local shortestDistance = math.huge
        local mouseLocation = UserInputService:GetMouseLocation()

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local RootPart = player.Character.HumanoidRootPart
                local Humanoid = player.Character.Humanoid
                if Humanoid.Health > 0 then  -- Only target alive players
                    local screenPos, onScreen = Camera:WorldToViewportPoint(RootPart.Position)
                    if onScreen then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mouseLocation).Magnitude
                        if distance < shortestDistance then
                            closestPlayer = RootPart
                            shortestDistance = distance
                        end
                    end
                end
            end
        end

        if closestPlayer then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, closestPlayer.Position), Aimbot_Strength / 100)
        end
    end
end)

-- BunnyHop
RunService.RenderStepped:Connect(function()
    if BunnyHop_Enabled and CheatEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
            LocalPlayer.Character.Humanoid.Jump = true
        end
    end
end)

-- Anti-Aim (Spin)
RunService.RenderStepped:Connect(function()
    if AntiAim_Enabled and CheatEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
    end
end)
