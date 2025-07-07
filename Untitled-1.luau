-- 🌸 AiOuang UI v1 - Sidebar + Draggable + Minimize

-- ล้างของเก่า
pcall(function() game.CoreGui:FindFirstChild("AiUI"):Destroy() end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AiUI"
gui.ResetOnSpawn = false

-- 🌟 Main Window
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

-- 🟥 Sidebar (Menu)
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 120, 1, 0)
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
content.Position = UDim2.new(0, 120, 0, 0)
content.Size = UDim2.new(1, -120, 1, 0)
content.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
content.BorderSizePixel = 0
Instance.new("UICorner", content)

-- 🟨 Minimize Button
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(90, 0, 90)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
Instance.new("UICorner", minimizeBtn)

-- 🟩 Icon When Minimized
local iconBtn = Instance.new("TextButton", gui)
iconBtn.Size = UDim2.new(0, 60, 0, 30)
iconBtn.Position = UDim2.new(1, -70, 1, -40)
iconBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
iconBtn.Text = "🔧"
iconBtn.TextColor3 = Color3.new(1,1,1)
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 22
iconBtn.Visible = false
Instance.new("UICorner", iconBtn)

-- 🧠 Logic: Minimize
minimizeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	iconBtn.Visible = true
end)

iconBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	iconBtn.Visible = false
end)

-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
-- ใส่ลิงก์จริงแทน ... ด้านล่างนี้
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
