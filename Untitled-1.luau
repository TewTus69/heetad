-- ✅ Destroy existing UI if present
pcall(function() game.CoreGui:FindFirstChild("MacroUI"):Destroy() end)

-- 🔹 โหลด Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 🔹 สร้างหน้าต่างหลัก
local Window = Library.CreateLib("🌟 Macro Controller", "Midnight") -- ธีม Midnight

-- 🔹 แท็บหลัก
local MainTab = Window:NewTab("Main")

-- 🔹 เซกชัน Macro
local MacroSection = MainTab:NewSection("🎮 Macro Controls")
MacroSection:NewButton("▶️ Start Macro", "เริ่มแมโครใหม่", function() end)
MacroSection:NewButton("🔁 Play Macro", "เล่นแมโครบันทึกไว้", function() end)
MacroSection:NewToggle("⏺️ Record", "เปิด/ปิดการบันทึก", function(state) end)
MacroSection:NewToggle("🔂 Auto Play Again", "เล่นใหม่อัตโนมัติ", function(state) end)

-- 🔹 แท็บตั้งค่า
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("🛠️ Configuration")

SettingsSection:NewDropdown("Select Mode", "เลือกโหมดที่ต้องการ", {"Easy", "Normal", "Hard", "Insane"}, function(current)
    print("Mode Selected:", current)
end)

SettingsSection:NewLabel("เลือกโหมดก่อนเริ่มแมโคร")

-- 🔹 แท็บอื่นๆ
local InfoTab = Window:NewTab("About")
local InfoSection = InfoTab:NewSection("ℹ️ ข้อมูล")
InfoSection:NewLabel("สร้างโดยไออ้วงและเค้าเอง ❤️")


-- 🌐 External Script Loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()

