-- 🌿 Macro UI + Auto Play Again for Tower Defense

pcall(function() game.CoreGui:FindFirstChild("MacroUI"):Destroy() end)

local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")

-- GUI สร้าง
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MacroUI"

local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 380, 0, 200)
win.Position = UDim2.new(0.5, -190, 0.5, -100)
win.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
win.BorderSizePixel = 0
local corner = Instance.new("UICorner", win)

-- Title / Mode Selector
local title = Instance.new("TextLabel", win)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Mode: Basic"
title.TextXAlignment = Enum.TextXAlignment.Left

-- Dropdown
local modes = {"Easy","Normal","Hard","Insane"}
local currentMode = modes[1]
local dropdown = Instance.new("TextButton", win)
dropdown.Size = UDim2.new(0, 120, 0, 24)
dropdown.Position = UDim2.new(0, 10, 0, 34)
dropdown.BackgroundColor3 = Color3.fromRGB(45,45,55)
dropdown.Font = Enum.Font.Gotham
dropdown.TextSize = 14
dropdown.TextColor3 = Color3.new(1,1,1)
dropdown.Text = currentMode
Instance.new("UICorner", dropdown)

local listOpen = false
local listFrame = Instance.new("Frame", win)
listFrame.Position = UDim2.new(0,10,0,60)
listFrame.Size = UDim2.new(0,120,0,0)
listFrame.BackgroundColor3 = Color3.fromRGB(45,45,55)
Instance.new("UICorner", listFrame)

dropdown.MouseButton1Click:Connect(function()
    listOpen = not listOpen
    listFrame:TweenSize(UDim2.new(0,120,0,listOpen and #modes*24 or 0),"Out","Quad",0.2,true)
end)

for i, m in ipairs(modes) do
    local btn = Instance.new("TextButton", listFrame)
    btn.Size = UDim2.new(1,0,0,24)
    btn.Position = UDim2.new(0,0,0,(i-1)*24)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,50)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = m
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        currentMode = m
        dropdown.Text = m
        title.Text = "Mode: " .. m
        listOpen = false
        listFrame:TweenSize(UDim2.new(0,120,0,0),"Out","Quad",0.2,true)
    end)
end

-- ฟังก์ชัน Placeholder
local isAuto = false
local macroData = {}
local isRecording = false

local function autoPlayAgain()
    print("✅ Auto Play Again triggered")
    -- TODO: ใช้ fireclickdetector หรือ firesignal
end

local function playbackMacro()
    print("🔁 Playback Macro:", macroData)
    -- TODO: วางและอัปเกรตตาม macroData
end

-- ปุ่ม UI
local btns = {
    {icon="✔", text="Auto Play", func=function()
        isAuto = not isAuto
        print("Auto Play = ", isAuto)
    end},
    {icon="▶️", text="Start Macro", func=function()
        macroData = {} print("Macro cleared, ready to record")
    end},
    {icon="⏺️", text="Record", func=function()
        isRecording = not isRecording
        print("Recording = ", isRecording)
    end},
    {icon="🔁", text="Playback", func=playbackMacro},
}

for i, info in ipairs(btns) do
    local b = Instance.new("TextButton", win)
    b.Size = UDim2.new(0, 160, 0, 28)
    b.Position = UDim2.new(0,10,0,80+(i-1)*34)
    b.BackgroundColor3 = Color3.fromRGB(50,50,60)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.TextColor3 = Color3.new(1,1,1)
    b.Text = info.icon.." "..info.text
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(info.func)
end

-- ปุ่มย่อ/ลาก ได้ง่าย
local dragging, dragStart, winPos
win.Active = true; win.Draggable = true

win.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=input.Position; winPos=win.Position
        input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
        local delta = input.Position-dragStart
        win.Position = UDim2.new(winPos.X.Scale, winPos.X.Offset+delta.X, winPos.Y.Scale, winPos.Y.Offset+delta.Y)
    end
end)

-- 🧠 ตัวอย่างเรียก Auto Play และ Recording ตามเงื่อนไข
game:GetService("RunService").RenderStepped:Connect(function()
    if isAuto then autoPlayAgain() end
    if isRecording then
        -- เก็บ macroData เช่น {time=os.clock(), action="place", pos=CFrame.new(...)}
    end
end)


-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
