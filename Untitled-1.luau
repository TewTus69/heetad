-- 💥 เคลียร์ GUI ซ้อน
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

-- 📁 ตัวแปรหลัก
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Mouse = game.Players.LocalPlayer:GetMouse()
local RS = game:GetService("RunService")

local macro = {}
local recording = false
local playing = false
local autoPlayAgain = false
local lastTime = tick()

-- 🎬 ระบบ Record
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and recording then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            table.insert(macro, {
                time = tick() - lastTime,
                type = "key",
                key = input.KeyCode.Name
            })
            lastTime = tick()
        end
    end
end)

Mouse.Button1Down:Connect(function()
    if recording then
        table.insert(macro, {
            time = tick() - lastTime,
            type = "click",
            position = Mouse.Hit.Position
        })
        lastTime = tick()
    end
end)

-- 🔁 ระบบ Playback
local function playMacro()
    if playing or #macro == 0 then return end
    playing = true

    coroutine.wrap(function()
        for _, action in ipairs(macro) do
            task.wait(action.time)
            if action.type == "key" then
                VIM:SendKeyEvent(true, Enum.KeyCode[action.key], false, game)
                VIM:SendKeyEvent(false, Enum.KeyCode[action.key], false, game)
            elseif action.type == "click" and action.position then
                VIM:SendMouseButtonEvent(action.position.X, action.position.Y, 0, true, game, 0)
                VIM:SendMouseButtonEvent(action.position.X, action.position.Y, 0, false, game, 0)
            end
        end
        playing = false
    end)()
end

-- ▶️ Auto Play Again
local function tryPlayAgain()
    for _, d in pairs(game:GetDescendants()) do
        if d:IsA("TextButton") and d.Text:lower():find("play again") then
            firesignal(d.MouseButton1Click)
            break
        end
    end
end

-- 📌 UI Setup
local MainTab = Window:NewTab("Main")
local MacroSection = MainTab:NewSection("🎮 Macro Controls")

MacroSection:NewButton("▶️ Start Macro", "เริ่มใหม่", function()
    macro = {}
    lastTime = tick()
end)

MacroSection:NewButton("🔁 Play Macro", "เล่นซ้ำ", function()
    playMacro()
end)

MacroSection:NewToggle("⏺️ Record", "บันทึก", function(state)
    recording = state
    lastTime = tick()
end)

MacroSection:NewToggle("🔂 Auto Play Again", "คลิกปุ่มให้", function(state)
    autoPlayAgain = state
end)

-- ⚙️ Settings
local SettingsTab = Window:NewTab("Settings")
SettingsSection:NewDropdown("Select Mode", "เลือกโหมด", {"Easy", "Normal", "Hard", "Insane"}, function(selected)
    currentMode = selected

    -- ลูปหาปุ่มโดยดูจากชื่อ
    for _, btn in ipairs(game:GetDescendants()) do
        if btn:IsA("ImageButton") and btn.Name:lower():find(selected:lower()) then
            firesignal(btn.MouseButton1Click)
            print("✔️ คลิกโหมด:", selected)
            return
        end
    end

    -- fallback: เผื่อมีปุ่มชื่อไม่ตรง แต่มี TextLabel ข้างใน
    for _, btn in ipairs(game:GetDescendants()) do
        if btn:IsA("ImageButton") then
            local label = btn:FindFirstChildWhichIsA("TextLabel", true)
            if label and label.Text:lower():find(selected:lower()) then
                firesignal(btn.MouseButton1Click)
                print("✔️ คลิกโหมดผ่าน label:", selected)
                return
            end
        end
    end

    warn("❌ ไม่พบปุ่มที่ตรงกับโหมด:", selected)
end)

-- ℹ️ About
local AboutTab = Window:NewTab("About")
local Info = AboutTab:NewSection("📌 Info")
Info:NewLabel("Macro by ไออ้วง & เค้า 💖")

-- 🎯 Hotkey Toggle UI
local shown = true
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        local gui = gethui():FindFirstChild("MainFrame", true)
        if gui then gui.Visible = not gui.Visible end
    end
end)

-- 🔁 วนตลอดระหว่างเล่น
RS.RenderStepped:Connect(function()
    if autoPlayAgain then tryPlayAgain() end
end)
