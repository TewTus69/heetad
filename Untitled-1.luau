--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoGUI_TDS"

-- Auto Skip Toggle
local toggleSkip = Instance.new("TextButton", gui)
toggleSkip.Size = UDim2.new(0, 160, 0, 40)
toggleSkip.Position = UDim2.new(0, 20, 0.5, -170)
toggleSkip.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleSkip.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleSkip.Font = Enum.Font.SourceSansBold
toggleSkip.TextSize = 18
toggleSkip.Text = "Auto Skip [OFF]"
toggleSkip.BorderSizePixel = 0

-- Auto Upgrade Toggle
local toggleUpgrade = Instance.new("TextButton", gui)
toggleUpgrade.Size = UDim2.new(0, 160, 0, 40)
toggleUpgrade.Position = UDim2.new(0, 20, 0.5, -120)
toggleUpgrade.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleUpgrade.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleUpgrade.Font = Enum.Font.SourceSansBold
toggleUpgrade.TextSize = 18
toggleUpgrade.Text = "Auto Upgrade [OFF]"
toggleUpgrade.BorderSizePixel = 0

-- Upgrade Input
local upgradeInput = Instance.new("TextBox", gui)
upgradeInput.Size = UDim2.new(0, 160, 0, 30)
upgradeInput.Position = UDim2.new(0, 20, 0.5, -80)
upgradeInput.PlaceholderText = "Skins, e.g. Crypto, PNG"
upgradeInput.Text = ""
upgradeInput.Visible = false
upgradeInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
upgradeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeInput.ClearTextOnFocus = false

-- Auto CTA Toggle
local toggleCTA = Instance.new("TextButton", gui)
toggleCTA.Size = UDim2.new(0, 160, 0, 40)
toggleCTA.Position = UDim2.new(0, 20, 0.5, -30)
toggleCTA.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleCTA.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleCTA.Font = Enum.Font.SourceSansBold
toggleCTA.TextSize = 18
toggleCTA.Text = "Auto CTA [OFF]"
toggleCTA.BorderSizePixel = 0

-- CTA Skin Input
local ctaInput = Instance.new("TextBox", gui)
ctaInput.Size = UDim2.new(0, 160, 0, 30)
ctaInput.Position = UDim2.new(0, 20, 0.5, 10)
ctaInput.PlaceholderText = "CTA Skin Name"
ctaInput.Text = ""
ctaInput.Visible = false
ctaInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ctaInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ctaInput.ClearTextOnFocus = false

-- State
local autoSkip = false
local upgrading = false
local autoCTA = false
local upgradeSkins = {}
local ctaSkin = ""
local upgradeCounts = {}

-- Special Skins Table
local specialSkins = {
    ["default"] = true, ["arcade"] = true, ["crypto"] = true,
    ["tycoon"] = true, ["png"] = true, ["cozy camp"] = true,
    ["ducky"] = true, ["pirate"] = true
}

-- Utilities
local function parseInput(text)
    local t = {}
    for skin in text:gmatch("[^,]+") do
        skin = skin:match("^%s*(.-)%s*$") -- Trim whitespace
        if skin ~= "" then table.insert(t, skin) end
    end
    return t
end

local function getLevelFromGui()
    for _, obj in pairs(game.CoreGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextBox") then
            if obj.Name == "levelText" then
                local level = tonumber(obj.Text:match("Level:%s*(%d+)"))
                if level then return level end
            end
        end
    end
    return nil
end

local function fireStreaming(towerName)
    local args = {"Streaming", "SelectTower", "Farm", towerName}
    pcall(function()
        ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end)
end

local function upgradeTower(tower)
    fireStreaming(tower.Name)
    local args = {
        "Troops", "Upgrade", "Set", {
            ["Troop"] = tower,
            ["Path"] = 1
        }
    }
    pcall(function()
        ReplicatedStorage:WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
    end)
    task.wait(0.3)
    local level = getLevelFromGui()
    if level then
        upgradeCounts[tower] = level
    end
end

-- GUI Events
toggleSkip.MouseButton1Click:Connect(function()
    autoSkip = not autoSkip
    toggleSkip.Text = autoSkip and "Auto Skip [ON]" or "Auto Skip [OFF]"
    toggleSkip.BackgroundColor3 = autoSkip and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(50, 50, 50)
end)

toggleUpgrade.MouseButton1Click:Connect(function()
    upgrading = not upgrading
    toggleUpgrade.Text = upgrading and "Auto Upgrade [ON]" or "Auto Upgrade [OFF]"
    toggleUpgrade.BackgroundColor3 = upgrading and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50)
    upgradeInput.Visible = upgrading
    if upgrading then upgradeSkins = parseInput(upgradeInput.Text) end
end)

upgradeInput.FocusLost:Connect(function()
    if upgrading then
        upgradeSkins = parseInput(upgradeInput.Text)
    end
end)

toggleCTA.MouseButton1Click:Connect(function()
    autoCTA = not autoCTA
    toggleCTA.Text = autoCTA and "Auto CTA [ON]" or "Auto CTA [OFF]"
    toggleCTA.BackgroundColor3 = autoCTA and Color3.fromRGB(170, 0, 0) or Color3.fromRGB(50, 50, 50)
    ctaInput.Visible = autoCTA
end)

ctaInput.FocusLost:Connect(function()
    ctaSkin = ctaInput.Text
end)

-- Auto Skip Loop
task.spawn(function()
    while true do
        if autoSkip then
            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteFunction"):InvokeServer("Voting", "Skip")
            end)
        end
        task.wait(0.01)
    end
end)

-- Auto Upgrade Loop
task.spawn(function()
    while true do
        task.wait(1)
        if upgrading and #upgradeSkins > 0 then
            local towersFolder = Workspace:FindFirstChild("Towers")
            if towersFolder then
                for _, skin in ipairs(upgradeSkins) do
                    local matching = {}
                    for _, tower in ipairs(towersFolder:GetChildren()) do
                        if tower.Name == skin then
                            table.insert(matching, tower)
                        end
                    end

                    if specialSkins[skin:lower()] then
                        local upgraded3 = 0
                        for _, t in ipairs(matching) do
                            if (upgradeCounts[t] or 0) >= 3 then upgraded3 += 1 end
                        end
                        if upgraded3 < 8 then
                            for _, t in ipairs(matching) do
                                if (upgradeCounts[t] or 0) < 3 then upgradeTower(t) end
                            end
                        else
                            for _, t in ipairs(matching) do
                                if (upgradeCounts[t] or 0) < 5 then
                                    upgradeTower(t)
                                    break
                                end
                            end
                        end
                    else
                        for _, t in ipairs(matching) do
                            upgradeTower(t)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto CTA Loop (10s Cooldown)
task.spawn(function()
    while true do
        if autoCTA and ctaSkin ~= "" then
            local towers = Workspace:FindFirstChild("Towers")
            if towers then
                for _, t in ipairs(towers:GetChildren()) do
                    if t.Name == ctaSkin then
                        local args = {
                            "Troops", "Abilities", "Activate",
                            {["Troop"] = t, ["Name"] = "Call Of Arms", ["Data"] = {}}
                        }
                        pcall(function()
                            ReplicatedStorage:WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
                        end)
                        task.wait(10) -- cooldown reduced to 10s
                    end
                end
            end
        else
            task.wait(1)
        end
    end
end)


-- ✅ โหลดสคริปต์หลักต่อท้าย (ถ้ามี)
loadstring(game:HttpGet("https://raw.githubusercontent.com/TewTus69/heetad/main/Untitled-1.luau"))()
