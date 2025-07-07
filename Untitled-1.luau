pcall(function() game.CoreGui:FindFirstChild("MacroUI"):Destroy() end)

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MacroUI"
gui.ResetOnSpawn = false

local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 400, 0, 300)
win.Position = UDim2.new(0.5, -200, 0.5, -150)
win.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
Instance.new("UICorner", win)

local title = Instance.new("TextLabel", win)
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Macro Controller"

local modes = {"Easy", "Normal", "Hard", "Insane"}
local currentMode = modes[1]

local dropdown = Instance.new("TextButton")
dropdown.Parent = win
dropdown.Size = UDim2.new(0, 140, 0, 26)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
dropdown.Text = "Mode: "..currentMode
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
Instance.new("UICorner", dropdown)

local listFrame = Instance.new("Frame")
listFrame.Parent = gui -- ต้องอยู่ใน ScreenGui เพื่อไม่ถูกตัดโดยหน้าต่าง
listFrame.Position = dropdown.AbsolutePosition + Vector2.new(0, dropdown.AbsoluteSize.Y)
listFrame.Size = UDim2.new(0, 140, 0, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
listFrame.ClipsDescendants = true
Instance.new("UICorner", listFrame)

-- อัปเดตตำแหน่งตามการลากหน้าต่าง
win:GetPropertyChangedSignal("Position"):Connect(function()
    listFrame.Position = dropdown.AbsolutePosition + Vector2.new(0, dropdown.AbsoluteSize.Y)
end)

-- เพิ่มตัวเลือก
local listOpen = false
dropdown.MouseButton1Click:Connect(function()
    listOpen = not listOpen
    listFrame:TweenSize(UDim2.new(0, 140, 0, listOpen and #modes * 24 or 0), "Out", "Quad", 0.2, true)
end)

for i, m in ipairs(modes) do
    local opt = Instance.new("TextButton", listFrame)
    opt.Size = UDim2.new(1, 0, 0, 24)
    opt.Position = UDim2.new(0, 0, 0, (i - 1) * 24)
    opt.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    opt.Text = m
    opt.Font = Enum.Font.Gotham
    opt.TextSize = 14
    opt.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", opt)
    opt.MouseButton1Click:Connect(function()
        currentMode = m
        dropdown.Text = "Mode: "..m
        listOpen = false
        listFrame:TweenSize(UDim2.new(0, 140, 0, 0), "Out", "Quad", 0.2, true)
    end)
end

local macroData, isRecording, isAuto = {}, false, false
local lastTime = tick()

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

local function playbackMacro()
    coroutine.wrap(function()
        for _, action in ipairs(macroData) do
            task.wait(action.delay)
            local tool = LP.Character and LP.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end)()
end

local function createToggle(name, y, callback, status)
    local toggle = Instance.new("TextButton", win)
    toggle.Size = UDim2.new(0, 180, 0, 28)
    toggle.Position = UDim2.new(0, 10, 0, y)
    toggle.BackgroundColor3 = Color3.fromRGB(55,55,65)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Text = name..": OFF"
    Instance.new("UICorner", toggle)
    toggle.MouseButton1Click:Connect(function()
        status = not status
        toggle.Text = name..": "..(status and "ON" or "OFF")
        callback(status)
    end)
end

local function createButton(name, y, callback)
    local b = Instance.new("TextButton", win)
    b.Size = UDim2.new(0, 180, 0, 28)
    b.Position = UDim2.new(0, 210, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(55,55,65)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = name
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

createToggle("Auto Play Again", 110, function(state) isAuto = state end, isAuto)
createToggle("Record Macro", 150, function(state) isRecording = state; lastTime = tick() end, isRecording)
createButton("Start New Macro", 110, function() macroData = {} end)
createButton("Play Macro", 150, playbackMacro)

RS.RenderStepped:Connect(function()
    if isAuto then autoPlayAgain() end
    if isRecording then recordMacro() end
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
