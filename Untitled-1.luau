-- ✅ Destroy existing UI if present
pcall(function() game.CoreGui:FindFirstChild("MacroUI"):Destroy() end)

-- ⚙️ Services
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 📦 Kavo UI Framework (from GitHub)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Macro Controller", "Midnight")

-- 🌐 Tabs and Sections
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Macro Controls")

-- 📌 Variables
local modes = {"Easy", "Normal", "Hard", "Insane"}
local currentMode = modes[1]
local macroData, isRecording, isAuto = {}, false, false
local lastTime = tick()

-- 🎮 Mode Dropdown
MainSection:NewDropdown("Select Mode", "Choose macro difficulty", modes, function(v)
    currentMode = v
end)

-- 🔄 Auto Play Again
MainSection:NewToggle("Auto Play Again", "Automatically presses 'Play Again'", function(t)
    isAuto = t
end)

-- ⏺️ Record Macro
MainSection:NewToggle("Record Macro", "Start/Stop recording mouse macro", function(t)
    isRecording = t
    lastTime = tick()
end)

-- 🔄 Start New Macro
MainSection:NewButton("Start New Macro", "Clear current recorded macro", function()
    macroData = {}
end)

-- ▶️ Play Macro
MainSection:NewButton("Play Macro", "Playback recorded macro", function()
    coroutine.wrap(function()
        for _, action in ipairs(macroData) do
            task.wait(action.delay)
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end)()
end)

-- 🔁 Function Definitions
local function autoPlayAgain()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Text:lower():find("play again") then
            firesignal(obj.MouseButton1Click)
            break
        end
    end
end

local function recordMacro()
    local now = tick()
    table.insert(macroData, {
        delay = now - lastTime,
        pos = LP:GetMouse().Hit.Position
    })
    lastTime = now
end

-- 🕒 Main Update Loop
RS.RenderStepped:Connect(function()
    if isAuto then autoPlayAgain() end
    if isRecording then recordMacro() end
end)

-- 🌐 External Script Loader
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
