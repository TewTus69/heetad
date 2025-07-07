-- 🌸 AiOuang UI v1 - Sidebar + Draggable + Minimize

pcall(function() game.CoreGui:FindFirstChild("AiUI"):Destroy() end)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AiUI"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame)

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 120, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar)

local menuList = {"Dashboard", "Macro", "Units", "Settings"}
for i, name in ipairs(menuList) do
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (i - 1) * 35 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = name
    Instance.new("UICorner", btn)
end

local
