-- 💥 ลบ GUI ซ้ำซ้อน
pcall(function()
	for _, gui in ipairs(game:GetService("CoreGui"):GetChildren()) do
		if gui:IsA("ScreenGui") and gui:FindFirstChild("MainFrame") then
			gui:Destroy()
		end
	end
end)

-- 🔱 โหลด Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌊 Macro Controller", "Ocean")

-- ⚙️ บริการที่ใช้
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Rep = game:GetService("ReplicatedStorage")
local remotes = Rep:WaitForChild("RemoteFunctions")

-- 🪧 Notification แบบเรียบหรู
local notification = Instance.new("TextLabel")
notification.Parent = game:GetService("CoreGui")
notification.Size = UDim2.new(0, 300, 0, 40)
notification.Position = UDim2.new(0.5, -150, 0.05, 0)
notification.BackgroundColor3 = Color3.fromRGB(20, 60, 80)
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.Font = Enum.Font.GothamBold
notification.TextSize = 18
notification.Text = ""
notification.Visible = false
Instance.new("UICorner", notification)

local function notify(msg)
	notification.Text = msg
	notification.Visible = true
	task.delay(3, function()
		notification.Visible = false
	end)
end

-- 🔧 ตัวแปรหลัก
local macroData = {}
local isRecording = false
local isPlaying = false
local autoPlayAgain = false
local autoStart = false
local currentMode = "Normal"
local lastRestart = 0
local restartCooldown = 10

-- 📁 แท็บ Main
local mainTab = Window:NewTab("Main")
local section = mainTab:NewSection("🎮 Macro Control")

section:NewButton("⏺️ Start Record", "เริ่มบันทึกแมโคร", function()
	macroData = {}
	isRecording = true
	notify("⏺️ เริ่มบันทึกแล้ว")
end)

section:NewButton("🛑 Stop Record", "หยุดบันทึก", function()
	isRecording = false
	notify("🛑 หยุดบันทึกแล้ว")
end)

section:NewButton("▶️ Play Macro", "เล่นข้อมูลที่บันทึก", function()
	if #macroData == 0 then return notify("⚠️ ยังไม่มีข้อมูลแมโคร") end
	isPlaying = true
	notify("▶️ เริ่มเล่นแมโคร")
	coroutine.wrap(function()
		for _, act in ipairs(macroData) do
			task.wait(act.delay or 0.5)
			if act.type == "place" then
				remotes.PlaceUnit:InvokeServer(act.unit, act.data)
			elseif act.type == "upgrade" then
				remotes.UpgradeUnit:InvokeServer(act.unitId)
			elseif act.type == "sell" then
				remotes.SellUnit:InvokeServer(act.unitId)
			end
		end
		isPlaying = false
	end)()
end)

section:NewToggle("🔁 Auto Play Again", "รีสตาร์ทเกมอัตโนมัติ", function(state)
	autoPlayAgain = state
	notify("🔁 Auto Play Again: " .. tostring(state))
end)

section:NewToggle("🧱 Auto Select Mode", "เลือกระดับเกมอัตโนมัติ", function(state)
	autoStart = state
	notify("🧱 Auto Mode: " .. tostring(state))
end)

-- ⚙️ แท็บ Settings
local settingsTab = Window:NewTab("Settings")
settingsTab:NewSection("⚙️ Difficulty")
	:NewDropdown("Mode", "เลือกระดับ", {"Easy", "Normal", "Hard", "Insane"}, function(opt)
		currentMode = opt
		notify("⚙️ ตั้งค่าโหมด: " .. opt)
	end)

-- 📌 แท็บ About
Window:NewTab("About"):NewSection("✦ Info")
	:NewLabel("สร้างโดยไออ้วงและเค้าเอง 💙")

-- 🎮 Hook Remote สำหรับบันทึก
local oldPlace = remotes.PlaceUnit.InvokeServer
remotes.PlaceUnit.InvokeServer = function(_, unit, data)
	if isRecording then
		table.insert(macroData, {
			type = "place",
			unit = unit,
			data = data,
			delay = 0.3
		})
	end
	return oldPlace(remotes.PlaceUnit, unit, data)
end

local oldUpgrade = remotes.UpgradeUnit.InvokeServer
remotes.UpgradeUnit.InvokeServer = function(_, unitId)
	if isRecording then
		table.insert(macroData, {
			type = "upgrade",
			unitId = unitId,
			delay = 0.2
		})
	end
	return oldUpgrade(remotes.UpgradeUnit, unitId)
end

local oldSell = remotes.SellUnit.InvokeServer
remotes.SellUnit.InvokeServer = function(_, unitId)
	if isRecording then
		table.insert(macroData, {
			type = "sell",
			unitId = unitId,
			delay = 0.2
		})
	end
	return oldSell(remotes.SellUnit, unitId)
end

-- 🕹️ RenderStep ตรวจจับโหมดและเล่นซ้ำ
RS.RenderStepped:Connect(function()
	if autoStart then
		local ok = pcall(function()
			remotes.PlaceDifficultyVote:InvokeServer("dif_" .. currentMode:lower())
		end)
		if ok then
			notify("✅ โหวตโหมด " .. currentMode)
			autoStart = false
		end
	end

	if autoPlayAgain and tick() - lastRestart > restartCooldown then
		local success, err = pcall(function()
			remotes.RestartGame:InvokeServer()
		end)
		if success then
			lastRestart = tick()
			notify("🔁 รีสตาร์ทเกมสำเร็จ!")
		else
			notify("⚠️ รีสตาร์ทล้มเหลว: " .. tostring(err))
		end
	end
end)

-- ⌨️ ซ่อน/แสดง UI
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Window:Toggle()
	end
end)
