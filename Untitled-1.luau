-- 🌿 Macro UI + Auto Play Again for Tower Defense (Full Version)

pcall(function() game.CoreGui:FindFirstChild("MacroUI"):Destroy() end)

local UIS = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local RS = game:GetService("RunService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "MacroUI"

local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 380, 0, 220)
win.Position = UDim2.new(0.5, -190, 0.5, -110)
win.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
win.BorderSizePixel = 0
Instance.new("UICorner", win)

local title = Instance.new("TextLabel", win)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Mode: Basic"
title.TextXAlignment = Enum.TextXAlignment.Left

title.Position = UDim2.new(0, 10, 0, 0)

local modes = {"Easy", "Normal", "Hard", "Insane"}
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

local macroData = {}
local isRecording = false
local isAuto = false

local function autoPlayAgain()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextButton") and obj.Text:lower():find("play again") then
            firesignal(obj.MouseButton1Click)
            break
        end
    end
end

local function playbackMacro()
    for _, action in ipairs(macroData) do
        task.wait(action.delay)
        local args = action.args
        if args and typeof(args.Position) == "Vector3" then
            -- 模拟การวางยูนิต
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate() -- ปล่อยยูนิต
            end
        end
    end
end

local btns = {
    {icon="✔", text="Auto Play", func=function()
        isAuto = not isAuto
    end},
    {icon="▶️", text="Start Macro", func=function()
        macroData = {}
    end},
    {icon="⏺️", text="Record", func=function()
        isRecording = not isRecording
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

-- Drag window
win.Active = true; win.Draggable = true

-- Auto loop
RS.RenderStepped:Connect(function()
    if isAuto then autoPlayAgain() end
    if isRecording then
        table.insert(macroData, {
            delay = 0.2,
            args = {
                Position = game.Players.LocalPlayer:GetMouse().Hit.p
            }
        })
        task.wait(0.2)
    end
end)


-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
