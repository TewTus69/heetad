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

-- 📁 สร้างแท็บ Main
local MainTab = Window:NewTab("Main")
local MacroSection = MainTab:NewSection("🎮 Macro Controls")
MacroSection:NewButton("▶️ Start Macro", "เริ่มแมโครบันทึกไว้", function() end)
MacroSection:NewButton("🔁 Play Macro", "เล่นแมโครบันทึกไว้", function() end)
MacroSection:NewToggle("⏺️ Record", "", function(state) end)
MacroSection:NewToggle("🔂 Auto Play Again", "", function(state) end)

-- ⚙️ สร้างแท็บ Settings
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("⚙️ Configuration")
SettingsSection:NewDropdown("Mode", "", {"Easy", "Normal", "Hard", "Insane"}, function(selected) end)

-- ℹ️ แท็บ About
local InfoTab = Window:NewTab("About")
local InfoSection = InfoTab:NewSection("📌 Info")
InfoSection:NewLabel("Created by AiOuang + Team")

-- ✦ รวม logic จาก Untitled-1 ที่เหลือ
-- (คัดเฉพาะ logic ฟังก์ชัน ไม่ใช่ GUI creation)

-- 🔐 เปิด/ปิด UI ด้วย hotkey
local UIS = game:GetService("UserInputService")
local shown = true
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        shown = not shown
        Window:Toggle() -- ถ้ามี method toggle ใน library
    end
end)
