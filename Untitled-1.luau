-- 🌸 Wave Play Record UI (By AiOuang)

-- ล้าง GUI เก่า
pcall(function() game.CoreGui:FindFirstChild("WaveUI"):Destroy() end)

-- UI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "WaveUI"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 300, 0, 160)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.Name = "MainFrame"

local startButton = Instance.new("TextButton", mainFrame)
startButton.Size = UDim2.new(0, 260, 0, 40)
startButton.Position = UDim2.new(0, 20, 0, 20)
startButton.Text = "▶️ Start Game"
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 20
startButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.BorderSizePixel = 0
Instance.new("UICorner", startButton)

local recordLabel = Instance.new("TextLabel", mainFrame)
recordLabel.Size = UDim2.new(0, 260, 0, 60)
recordLabel.Position = UDim2.new(0, 20, 0, 80)
recordLabel.Text = "📝 Last Record: None"
recordLabel.Font = Enum.Font.Gotham
recordLabel.TextSize = 18
recordLabel.TextWrapped = true
recordLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
recordLabel.BackgroundTransparency = 1

-- ฟังก์ชันบันทึก
local function saveRecord(wave)
    local result = "📝 Last Record: 🌊 Waves: " .. wave .. " | 🕒 " .. os.date("%d/%m/%Y %H:%M:%S")
    recordLabel.Text = result
    _G.LastWave = result
end

-- ปุ่มกดเริ่มเล่น (สุ่ม Wave)
startButton.MouseButton1Click:Connect(function()
    local wave = math.random(10, 30)
    saveRecord(wave)
end)

-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
-- ใส่ลิงก์จริงแทน ... ด้านล่างนี้
loadstring(game:HttpGet("https://raw.githubusercontent.com/hee/script/main/actual.lua"))()
