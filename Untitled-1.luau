-- 🌿 AiOuang UI v3 - Drag+Minimize+Animation

pcall(function() game.CoreGui:FindFirstChild("AiUI"):Destroy() end)

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AiUI"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame)

-- 🟪 DragBar (ลาก + หัวข้อ)
local dragBar = Instance.new("Frame", mainFrame)
dragBar.Size = UDim2.new(1, 0, 0, 30)
dragBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
dragBar.Name = "DragBar"
dragBar.ZIndex = 2

local title = Instance.new("TextLabel", dragBar)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "🌿 AiOuang UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

-- ✅ Custom Drag Script
local dragging, dragStart, startPos

dragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- 🟥 Sidebar
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.Size = UDim2.new(0, 120, 1, -30)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar)

local menuList = {"Dashboard", "Macro", "Units", "Settings"}
for i, name in ipairs(menuList) do
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, (i - 1) * 35 + 10)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = name
	Instance.new("UICorner", btn)
end

-- 🟦 Content Area
local content = Instance.new("Frame", mainFrame)
content.Position = UDim2.new(0, 120, 0, 30)
content.Size = UDim2.new(1, -120, 1, -30)
content.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Instance.new("UICorner", content)

-- 🟨 Minimize Button
local minimizeBtn = Instance.new("TextButton", dragBar)
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -35, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 90)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.ZIndex = 4
Instance.new("UICorner", minimizeBtn)

-- 🟩 Icon เมื่อย่อ
local iconBtn = Instance.new("TextButton", gui)
iconBtn.Size = UDim2.new(0, 60, 0, 30)
iconBtn.Position = UDim2.new(1, -70, 1, -40)
iconBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
iconBtn.Text = "🔧"
iconBtn.TextColor3 = Color3.new(1, 1, 1)
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 22
iconBtn.Visible = false
iconBtn.Active = true
iconBtn.Draggable = true
Instance.new("UICorner", iconBtn)

-- 🧠 Animation Logic
local function fadeOut(frame)
	TweenService:Create(frame, TweenInfo.new(0.3), {
		Size = UDim2.new(0, 0, 0, 0)
	}):Play()
	wait(0.3)
	frame.Visible = false
end

local function fadeIn(frame)
	frame.Visible = true
	frame.Size = UDim2.new(0, 500, 0, 300)
end


minimizeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(mainFrame, TweenInfo.new(0.2), {
		Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + 30),
		Size = UDim2.new(0, 500, 0, 0)
	}):Play()
	wait(0.2)
	mainFrame.Visible = false
	iconBtn.Visible = true
end)

iconBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	mainFrame.Size = UDim2.new(0, 500, 0, 0)
	mainFrame.Position = UDim2.new(0.5, -250, 0.5, -120)
	TweenService:Create(mainFrame, TweenInfo.new(0.2), {
		Size = UDim2.new(0, 500, 0, 300)
	}):Play()
	iconBtn.Visible = false
end)

-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
