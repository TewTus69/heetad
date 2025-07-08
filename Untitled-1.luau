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

-- ⚙️ Service
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Rep = game:GetService("ReplicatedStorage")
local remotes = Rep:WaitForChild("RemoteFunctions")
local Players = game:GetService("Players")

-- 🪧 Notification UI
local notification = Instance.new("TextLabel", game:GetService("CoreGui"))
notification.Size = UDim2.new(0, 320, 0, 40)
notification.Position = UDim2.new(0.5, -160, 0.05, 0)
notification.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
notification.TextColor3 = Color3.new(1, 1, 1)
notification.Font = Enum.Font.GothamBold
notification.TextSize = 18
notification.Visible = false
Instance.new("UICorner", notification)

local function notify(text)
	notification.Text = text
	notification.Visible = true
	task.delay(3, function() notification.Visible = false end)
end

-- 🌟 ตัวแปร
local macroData, isRecording, isPlaying = {}, false, false
local autoPlayAgain, autoStart = false, false
local currentMode = "normal"
local lastRestart, restartCooldown = 0, 8

-- 🧠 Hook Macro
local function hookRemote(name, handler)
	local old = remotes[name].InvokeServer
	remotes[name].InvokeServer = function(_, ...)
		if isRecording then handler(...) end
		return old(remotes[name], ...)
	end
end

hookRemote("PlaceUnit", function(unit, data)
	table.insert(macroData, {type = "place", unit = unit, data = data, delay = 0.3})
end)
hookRemote("UpgradeUnit", function(unitId)
	table.insert(macroData, {type = "upgrade", unitId = unitId, delay = 0.25})
end)
hookRemote("SellUnit", function(unitId)
	table.insert(macroData, {type = "sell", unitId = unitId, delay = 0.25})
end)

-- 📂 Main Tab
local main = Window:NewTab("Main"):NewSection("🎮 Macro")

main:NewButton("⏺️ Start Record", "เริ่มบันทึก", function()
	macroData, isRecording = {}, true
	notify("⏺️ กำลังบันทึก...")
end)

main:NewButton("🛑 Stop Record", "หยุดบันทึก", function()
	isRecording = false
	notify("🛑 หยุดบันทึกแล้ว")
end)

main:NewButton("▶️ Play Macro", "เล่นแมโคร", function()
	if #macroData == 0 then return notify("⚠️ ยังไม่มีข้อมูลแมโคร") end
	isPlaying = true
	notify("▶️ เริ่มเล่นแมโคร")
	coroutine.wrap(function()
		for _, a in ipairs(macroData) do
			task.wait(a.delay or 0.5)
			if a.type == "place" then remotes.PlaceUnit:InvokeServer(a.unit, a.data)
			elseif a.type == "upgrade" then remotes.UpgradeUnit:InvokeServer(a.unitId)
			elseif a.type == "sell" then remotes.SellUnit:InvokeServer(a.unitId)
			end
		end
		isPlaying = false
	end)()
end)

main:NewToggle("🔁 Auto Play Again", "รีสตาร์ทเมื่อจบเกม", function(state)
	autoPlayAgain = state
	notify("🔁 Auto Restart: " .. tostring(state))
	if state then
		pcall(function()
			remotes.RestartGame:InvokeServer()
			lastRestart = tick()
		end)
	end
end)

main:NewToggle("🧱 Auto Select Mode", "โหวตโหมดอัตโนมัติ", function(state)
	autoStart = state
	notify("🧱 Auto Mode: " .. tostring(state))
end)

-- ⚙️ Settings
Window:NewTab("Settings"):NewSection("🎯 Difficulty")
	:NewDropdown("Mode", "เลือกระดับ", {"dif_easy", "dif_normal", "dif_hard", "dif_insane"}, function(opt)
		currentMode = opt:sub(5)
		notify("🎯 ตั้งค่าโหมด: " .. opt)

		pcall(function()
			remotes.PlaceDifficultyVote:InvokeServer(opt)
		end)
	end)

-- 📌 Info
Window:NewTab("About"):NewSection("👩‍💻 Created by"):NewLabel("ไออ้วง x เค้าเอง 🐬")

-- 🔁 Auto Function
RS.RenderStepped:Connect(function()
	if autoStart then
		local ok = pcall(function()
			remotes.PlaceDifficultyVote:InvokeServer("dif_" .. currentMode:lower())
		end)
		if ok then
			notify("✅ โหวตโหมด: " .. currentMode)
			autoStart = false
		end
	end

	if autoPlayAgain and tick() - lastRestart > restartCooldown then
		local guiFound = false

		for _, ui in ipairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
			if ui:IsA("TextLabel") and ui.Text then
				local text = ui.Text:lower()
				if text:find("overwhelmed") or text:find("timeout") or text:find("defeat") or text:find("wave lost") then
					guiFound = true
					break
				end
			end
		end

		if guiFound then
			local reNotify = Rep:FindFirstChild("ReNotifyEvent")
			if reNotify then
				pcall(function()
					reNotify:FireServer("NotificationOptionSelected", nil, "Timedout")
				end)
			end

			wait(0.5)

			local success, err = pcall(function()
				remotes.RestartGame:InvokeServer()
			end)

			if success then
				lastRestart = tick()
				notify("🔁 เริ่มรอบใหม่อัตโนมัติแล้ว!")
			else
				notify("⚠️ รีสตาร์ทล้มเหลว: " .. tostring(err))
			end
		end
	end
end)

-- ⌨️ Toggle UI
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Window:Toggle()
	end
end)
