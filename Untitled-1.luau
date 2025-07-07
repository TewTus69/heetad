-- 🌟 Tower Defense Auto Script UI - Minimal with Macro + Wave Select

-- 💥 Destroy previous UI if exists
pcall(function()
    game.CoreGui:FindFirstChild("TowerAutoUI"):Destroy()
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- 📦 GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TowerAutoUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 240)
frame.Position = UDim2.new(0, 20, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

-- 🧾 Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🌿 Tower Macro"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0, 10, 0, 0)

-- 🔽 Select Mode Dropdown (Dummy)
local modeDropdown = Instance.new("TextButton", frame)
modeDropdown.Size = UDim2.new(1, -20, 0, 30)
modeDropdown.Position = UDim2.new(0, 10, 0, 40)
modeDropdown.Text = "Select Mode: Easy"
modeDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
modeDropdown.TextColor3 = Color3.new(1, 1, 1)
modeDropdown.Font = Enum.Font.Gotham
modeDropdown.TextSize = 14
Instance.new("UICorner", modeDropdown)

-- 🔁 Toggle Auto Play Again
local autoPlay = Instance.new("TextButton", frame)
autoPlay.Size = UDim2.new(1, -20, 0, 30)
autoPlay.Position = UDim2.new(0, 10, 0, 80)
autoPlay.BackgroundColor3 = Color3.fromRGB(45, 55, 65)
autoPlay.TextColor3 = Color3.new(1,1,1)
autoPlay.Font = Enum.Font.Gotham
autoPlay.TextSize = 14
autoPlay.Text = "[✔] Auto Play Again"
Instance.new("UICorner", autoPlay)

-- 📹 Macro Buttons
local recordBtn = Instance.new("TextButton", frame)
recordBtn.Size = UDim2.new(1, -20, 0, 30)
recordBtn.Position = UDim2.new(0, 10, 0, 120)
recordBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
recordBtn.Text = "⏺️ Record"
recordBtn.TextColor3 = Color3.new(1, 1, 1)
recordBtn.Font = Enum.Font.Gotham
recordBtn.TextSize = 14
Instance.new("UICorner", recordBtn)

local playBtn = Instance.new("TextButton", frame)
playBtn.Size = UDim2.new(1, -20, 0, 30)
playBtn.Position = UDim2.new(0, 10, 0, 160)
playBtn.BackgroundColor3 = Color3.fromRGB(30, 60, 30)
playBtn.Text = "▶️ Start Macro"
playBtn.TextColor3 = Color3.new(1, 1, 1)
playBtn.Font = Enum.Font.Gotham
playBtn.TextSize = 14
Instance.new("UICorner", playBtn)

local playbackBtn = Instance.new("TextButton", frame)
playbackBtn.Size = UDim2.new(1, -20, 0, 30)
playbackBtn.Position = UDim2.new(0, 10, 0, 200)
playbackBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
playbackBtn.Text = "🔁 Playback Macro"
playbackBtn.TextColor3 = Color3.new(1, 1, 1)
playbackBtn.Font = Enum.Font.Gotham
playbackBtn.TextSize = 14
Instance.new("UICorner", playbackBtn)

-- 💬 Function Hooks (Stub only)
local isRecording = false
recordBtn.MouseButton1Click:Connect(function()
    isRecording = not isRecording
    recordBtn.Text = isRecording and "⏹️ Stop Recording" or "⏺️ Record"
    print("[Macro] Recording:", isRecording)
end)

playBtn.MouseButton1Click:Connect(function()
    print("[Macro] Playing...")
end)

playbackBtn.MouseButton1Click:Connect(function()
    print("[Macro] Playback Loaded")
end)

autoPlay.MouseButton1Click:Connect(function()
    print("[AutoPlayAgain] Toggled")
end)

modeDropdown.MouseButton1Click:Connect(function()
    print("[SelectMode] Open Dropdown (not implemented)")
end)


-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
