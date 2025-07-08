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

-- ⚙️ Services
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Rep = game:GetService("ReplicatedStorage")
local remotes = Rep:WaitForChild("RemoteFunctions")

-- 🪧 Notification
local notification = Instance.new("TextLabel")
notification.Parent = game:GetService("CoreGui")
notification.Size = UDim2.new(0, 320, 0, 40)
notification.Position = UDim2.new(0.5, -160, 0.05, 0)
notification.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.Font = Enum.Font.GothamBold
notification.TextSize = 18
notification.Text = ""
notification.Visible = false
Instance.new("UICorner", notification)

local function notify(msg)
	notification.Text = msg
	notification.Visible = true
	task.delay(3, function() notification.Visible = false end)
end

-- 🧠 State
local macroData = {}
local isRecording = false
local isPlaying = false
local autoPlayAgain = false
local autoStart = false
local currentMode = "Normal"
local lastRestart = 0
local restartCooldown = 8

-- 🗂️ Tab: Main
local mainTab = Window:NewTab("Main")
local mainSec = mainTab:NewSection("🎮 Macro")

mainSec:NewButton("⏺️ Start Record", "บันทึกการวาง/อัพ/ขายยูนิต", function()
	macroData = {}
	isRecording = true
	notify("⏺️ เริ่มบันทึกแล้ว")
end)

mainSec:NewButton("🛑 Stop Record", "หยุดบันทึกแมโคร", function()
	isRecording = false
	notify("🛑 หยุดบันทึกแล้ว")
end)

mainSec:NewButton("▶️ Play Macro", "เล่นซ้ำแมโคร", function()
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

mainSec:NewToggle("🔁 Auto Play Again", "รีสตาร์ทเมื่อจบเกม", function(state)
	autoPlayAgain = state
	notify("🔁 Auto Play Again: " .. tostring(state))

	if state then
		-- เรียก Restart ทันทีเมื่อเปิด toggle
		local success, err = pcall(function()
			game:GetService("ReplicatedStorage")
				:WaitForChild("RemoteFunctions")
				:WaitForChild("RestartGame")
				:InvokeServer()
		end)

		if success then
			notify("🔁 รีสตาร์ทเกมทันทีเรียบร้อย!")
		else
			notify("⚠️ รีสตาร์ททันทีล้มเหลว: " .. tostring(err))
		end
	end
end)

mainSec:NewToggle("🧱 Auto Select Mode", "เลือกระดับอัตโนมัติ", function(state)
	autoStart = state
	notify("🧱 Auto Select Mode: " .. tostring(state))
end)

-- ⚙️ Tab: Settings
Window:NewTab("Settings"):NewSection("🎯 Difficulty")
	:NewDropdown("Mode", "เลือกระดับเกม", {"Easy", "Normal", "Hard", "Insane"}, function(opt)
		currentMode = opt
		notify("🎯 ตั้งค่าโหมด: " .. opt)
	end)

-- 📌 About
Window:NewTab("About"):NewSection("📌 Created by"):NewLabel("ไออ้วง x เค้าเอง 🩵")

-- 🎮 Hook Recording
local function hookRemote(name, handler)
	local old = remotes[name].InvokeServer
	remotes[name].InvokeServer = function(_, ...)
		if isRecording then handler(...) end
		return old(remotes[name], ...)
	end
end

hookRemote("PlaceUnit", function(unit, data)
	table.insert(macroData, { type = "place", unit = unit, data = data, delay = 0.3 })
end)

hookRemote("UpgradeUnit", function(unitId)
	table.insert(macroData, { type = "upgrade", unitId = unitId, delay = 0.25 })
end)

hookRemote("SellUnit", function(unitId)
	table.insert(macroData, { type = "sell", unitId = unitId, delay = 0.25 })
end)

-- 🔁 Auto Restart Handler
RS.RenderStepped:Connect(function()
	-- 🧱 Auto Select Mode
	if autoStart then
		local modeArg = { "dif_" .. currentMode:lower() }
		local ok, err = pcall(function()
			remotes.PlaceDifficultyVote:InvokeServer(unpack(modeArg))
		end)
		if ok then
			notify("✅ โหวตโหมด: " .. currentMode)
			autoStart = false
		else
			notify("⚠️ โหวตโหมดล้มเหลว: " .. tostring(err))
		end
	end

	-- 🔁 Auto Play Again
	if autoPlayAgain and tick() - lastRestart > restartCooldown then
		local found = false
		for _, ui in ipairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
			if ui:IsA("TextLabel") and ui.Text then
				local text = ui.Text:lower()
				if text:find("wave lost") or text:find("defeat") or text:find("overwhelmed") then
					found = true
					break
				end
			elseif ui:IsA("TextButton") and ui.Text:lower():find("play again") then
				found = true
				break
			end
		end

		if found then
			local reNotify = Rep:FindFirstChild("ReNotifyEvent")
			if reNotify then
				pcall(function()
					reNotify:FireServer("NotificationOptionSelected", nil, "Timedout")
				end)
			end

			task.wait(0.3)

			local ok, err = pcall(function()
				remotes.RestartGame:InvokeServer()
			end)

			if ok then
				lastRestart = tick()
				notify("🔁 เริ่มรอบใหม่แล้ว!")
			else
				notify("⚠️ รีสตาร์ทล้มเหลว: " .. tostring(err))
			end
		end
	end
end)

-- ⌨️ ซ่อน/แสดง UI ด้วย RightShift
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Window:Toggle()
	end
end)
