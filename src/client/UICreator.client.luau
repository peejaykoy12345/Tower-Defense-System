--[[local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TowerToolbar"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 110)
mainFrame.Position = UDim2.new(0.5, -325, 1, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)
layout.Parent = mainFrame

local towers = {
	{ Name = "Null", Price = 0 },
	{ Name = "Null", Price = 0 },
	{ Name = "Null", Price = 0 },
	{ Name = "Null", Price = 0 },
	{ Name = "Null", Price = 0 }
}

for i = 1, 5 do
	local slotFrame = Instance.new("Frame")
	slotFrame.Name = tostring(i)
	slotFrame.Size = UDim2.new(0, 120, 0, 85)
	slotFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	slotFrame.BorderSizePixel = 0
	slotFrame.Parent = mainFrame
	
	local slotCorner = Instance.new("UICorner")
	slotCorner.CornerRadius = UDim.new(0, 8)
	slotCorner.Parent = slotFrame
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 1, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.Parent = slotFrame
	
	local numberLabel = Instance.new("TextLabel")
	numberLabel.Name = "SlotNumber"
	numberLabel.Size = UDim2.new(1, 0, 0.3, 0)
	numberLabel.BackgroundTransparency = 1
	numberLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	numberLabel.TextScaled = true
	numberLabel.Font = Enum.Font.GothamBold
	numberLabel.Text = tostring(i)
	numberLabel.Parent = button
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "TowerName"
	nameLabel.Size = UDim2.new(1, 0, 0.35, 0)
	nameLabel.Position = UDim2.new(0, 0, 0.3, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = towers[i].Name
	nameLabel.Parent = button
	
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Name = "TowerPrice"
	priceLabel.Size = UDim2.new(1, 0, 0.35, 0)
	priceLabel.Position = UDim2.new(0, 0, 0.65, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	priceLabel.TextScaled = true
	priceLabel.Font = Enum.Font.Gotham
	priceLabel.Text = "$" .. towers[i].Price
	priceLabel.Parent = button
	
	button.MouseButton1Click:Connect(function()
		print("Selected tower slot:", i)
	end)
end]]