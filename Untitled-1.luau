-- 🚀 Ready-to-use GUI by AI Helper

pcall(function() game.CoreGui:FindFirstChild("QuickUI"):Destroy() end)

local Tween = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "QuickUI"

local win = Instance.new("Frame", gui)
win.Name = "Window"
win.Size = UDim2.new(0, 480, 0, 280)
win.Position = UDim2.new(0.5, -240, 0.5, -140)
win.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
win.BorderSizePixel = 0
local corner = Instance.new("UICorner", win)

-- title bar (ลาก)
local bar = Instance.new("Frame", win)
bar.Name = "TitleBar"
bar.Size = UDim2.new(1, 0, 0, 28)
bar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)

local title = Instance.new("TextLabel", bar)
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 8, 0, 0)
title.Text = "🌿 Quick UI"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local btnMin = Instance.new("TextButton", bar)
btnMin.Size = UDim2.new(0, 28, 1, 0)
btnMin.Position = UDim2.new(1, -56, 0, 0)
btnMin.Text = "-"
btnMin.Font = Enum.Font.GothamBold
btnMin.TextSize = 18
btnMin.TextColor3 = Color3.new(1, 1, 1)
btnMin.BackgroundColor3 = Color3.fromRGB(90, 0, 90)
Instance.new("UICorner", btnMin)

local btnClose = Instance.new("TextButton", bar)
btnClose.Size = UDim2.new(0, 28, 1, 0)
btnClose.Position = UDim2.new(1, -28, 0, 0)
btnClose.Text = "×"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 18
btnClose.TextColor3 = Color3.new(1, 1, 1)
btnClose.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Instance.new("UICorner", btnClose)

local dragData = {dragging = false}

bar.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		dragData.dragging = true
		dragData.start = inp.Position
		dragData.winPos = win.Position
	end
end)

bar.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		dragData.dragging = false
	end
end)

UIS.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseMovement and dragData.dragging then
		local delta = inp.Position - dragData.start
		win.Position = UDim2.new(dragData.winPos.X.Scale, dragData.winPos.X.Offset + delta.X,
			dragData.winPos.Y.Scale, dragData.winPos.Y.Offset + delta.Y)
	end
end)

-- Side menu
local side = Instance.new("Frame", win)
side.Size = UDim2.new(0, 120, 1, -28)
side.Position = UDim2.new(0, 0, 0, 28)
side.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Instance.new("UICorner", side)

local pages = {"Home","Macro","Units","Settings"}
for i, n in ipairs(pages) do
	local b = Instance.new("TextButton", side)
	b.Size = UDim2.new(1, -16, 0, 32)
	b.Position = UDim2.new(0, 8, 0, (i-1)*40 + 8)
	b.Text = n
	b.Font = Enum.Font.Gotham
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(45,45,55)
	Instance.new("UICorner", b)
end

-- Content placeholder
local cont = Instance.new("Frame", win)
cont.Size = UDim2.new(1, -120, 1, -28)
cont.Position = UDim2.new(0, 120, 0, 28)
cont.BackgroundColor3 = Color3.fromRGB(45,45,55)
Instance.new("UICorner", cont)

-- Button events
btnMin.MouseButton1Click:Connect(function()
	local tween = Tween:Create(win, TweenInfo.new(0.2), {Size = UDim2.new(0,480,0,28)})
	tween:Play()
	tween.Completed:Wait()
	cont.Visible = false
	btnMin.Visible = false
	btnClose.Visible = false
end)

btnClose.MouseButton1Click:Connect(function()
	win:Destroy()
end)

-- icon to restore (ลากได้)
local ico = Instance.new("TextButton", gui)
ico.Size = UDim2.new(0, 64, 0, 32)
ico.Position = UDim2.new(0, 20, 1, -60)
ico.Text = "🔧"
ico.Font = Enum.Font.GothamBold
ico.TextSize = 22
ico.TextColor3 = Color3.new(1,1,1)
ico.BackgroundColor3 = Color3.fromRGB(60,60,70)
ico.Visible = false
ico.Active = true
ico.Draggable = true
Instance.new("UICorner", ico)

ico.MouseButton1Click:Connect(function()
	cont.Visible = true
	btnMin.Visible = true
	btnClose.Visible = true
	win.Size = UDim2.new(0,480,0,280)
end)

-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
