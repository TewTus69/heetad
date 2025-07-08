-- 💥 ลบ Kavo UI ที่ค้าง
pcall(function()
    for _, gui in ipairs(gethui():GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("MainFrame") then
            gui:Destroy()
        end
    end
end)

-- 🔱 โหลด Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌟 Macro Controller", "Midnight")

-- 🧠 ตัวแปรเก็บสถานะ
local isRecording = false
local isAutoPlayAgain = false
local macroData = {}
local lastTime = tick()
local currentMode = "Easy"

-- 🧠 ฟังก์ชันบันทึกการใช้งาน
local function recordMacro()
    local now = tick()
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    table.insert(macroData, {
        delay = now - lastTime,
        pos = mouse.Hit and mouse.Hit.Position
    })
    lastTime = now
end

-- 🧠 ฟังก์ชันเล่นซ้ำ
local function playMacro()
    coroutine.wrap(function()
        for _, step in ipairs(macroData) do
            task.wait(step.delay)
            local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end)()
end

-- 🧠 ฟังก์ชัน Play Again
local function autoPlayAgain()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Text:lower():find("play again") then
            firesignal(obj.MouseButton1Click)
            break
        end
    end
end

-- 📁 แท็บ Main
local MainTab = Window:NewTab("Main")
local MacroSection = MainTab:NewSection("🎮 Macro Controls")

MacroSection:NewButton("▶️ Start Macro", "ล้างและเริ่มบันทึกใหม่", function()
    macroData = {}
    lastTime = tick()
end)

MacroSection:NewButton("🔁 Play Macro", "เล่นซ้ำทั้งหมด", function()
    playMacro()
end)

MacroSection:NewToggle("⏺️ Record", "เปิด/ปิดการบันทึก", function(state)
    isRecording = state
    lastTime = tick()
end)

MacroSection:NewToggle("🔂 Auto Play Again", "กดปุ่ม play again อัตโนมัติ", function(state)
    isAutoPlayAgain = state
end)

-- ⚙️ แท็บ Settings
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("⚙️ Configuration")

SettingsSection:NewDropdown("Select Mode", "เลือกโหมด", {"Easy", "Normal", "Hard", "Insane"}, function(selected)
    currentMode = selected
end)

-- ℹ️ แท็บ About
local InfoTab = Window:NewTab("About")
local InfoSection = InfoTab:NewSection("📌 Info")
InfoSection:NewLabel("สร้างโดยไออ้วง + เค้าเอง 💖")

-- 🔐 Toggle UI visibility
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        local main = gethui():FindFirstChild("MainFrame", true)
        if main then
            main.Visible = not main.Visible
        end
    end
end)

-- 🔁 ทำงานวนระหว่างเล่น
game:GetService("RunService").RenderStepped:Connect(function()
    if isRecording then recordMacro() end
    if isAutoPlayAgain then autoPlayAgain() end
end)
