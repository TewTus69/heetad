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
local RS, UIS, Rep, Players = game:GetService("RunService"), game:GetService("UserInputService"),
                              game:GetService("ReplicatedStorage"), game:GetService("Players")
local remotes = Rep:WaitForChild("RemoteFunctions")

-- 🪧 Notification
local function notify(msg)
	local n = Instance.new("TextLabel", game.CoreGui)
	n.Size = UDim2.new(0, 320, 0, 40)
	n.Position = UDim2.new(0.5, -160, 0.05, 0)
	n.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
	n.TextColor3 = Color3.new(1, 1, 1)
	n.Font = Enum.Font.GothamBold
	n.TextSize = 18
	n.Text = msg
	n.Visible = true
	Instance.new("UICorner", n)
	task.delay(3, function() n:Destroy() end)
end

-- 🌐 State
local macroData, isRecording, isPlaying = {}, false, false
local autoPlayAgain, autoStart = false, false
local currentMode = "dif_normal"
local lastRestart, restartCooldown = 0, 8

-- 🧠 Macro Hook
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

-- 🗂️ Main Tab
local main = Window:NewTab("Main"):NewSection("🎮 Macro")

main:NewButton("⏺️ Start Record", "บันทึกแมโคร", function()
	macroData, isRecording = {}, true
	notify("⏺️ เริ่มบันทึกแล้ว")
end)

main:NewButton("🛑 Stop Record", "หยุดบันทึก", function()
	isRecording = false
	notify("🛑 หยุดบันทึกแล้ว")
end)

main:NewButton("▶️ Play Macro", "เล่นซ้ำแมโคร", function()
	if #macroData == 0 then return notify("⚠️ ยังไม่มีข้อมูลแมโคร") end
	isPlaying = true
	notify("▶️ เล่นแมโคร...")
	coroutine.wrap(function()
		for _, act in ipairs(macroData) do
			task.wait(act.delay or 0.5)
			if act.type == "place" then remotes.PlaceUnit:InvokeServer(act.unit, act.data)
			elseif act.type == "upgrade" then remotes.UpgradeUnit:InvokeServer(act.unitId)
			elseif act.type == "sell" then remotes.SellUnit:InvokeServer(act.unitId)
			end
		end
		isPlaying = false
	end)()
end)

main:NewToggle("🔁 Auto Play Again", "รีสตาร์ทเมื่อจบเกม", function(state)
	autoPlayAgain = state
	notify("🔁 Auto Restart: " .. tostring(state))
end)

main:NewToggle("🧱 Auto Select Mode", "เลือกระดับอัตโนมัติ", function(state)
	autoStart = state
	notify("🧱 Auto Mode: " .. tostring(state))
end)

-- ⚙️ Settings Tab
Window:NewTab("Settings"):NewSection("🎯 Difficulty")
	:NewDropdown("Mode", "เลือกระดับ", {"dif_easy", "dif_normal", "dif_hard", "dif_insane"}, function(opt)
		currentMode = opt
		notify("🎯 โหมด: " .. opt)
	end)

-- 📌 About Tab
Window:NewTab("About"):NewSection("💬"):NewLabel("สร้างโดย: ไออ้วง x เค้าเอง 🩵")

-- 🔁 Loop 1 วิ ตรวจจับ Restart
task.spawn(function()
	while true do
		task.wait(1)

		if autoStart then
			pcall(function()
				remotes.PlaceDifficultyVote:InvokeServer(currentMode)
				notify("✅ เลือกโหมด: " .. currentMode)
				autoStart = false
			end)
		end

		if autoPlayAgain and tick() - lastRestart > restartCooldown then
			for _, ui in ipairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
				if ui:IsA("TextLabel") and ui.Text then
					local text = ui.Text:lower()
					if text:find("wave lost") or text:find("defeat") or text:find("overwhelmed") or text:find("timeout") then
						pcall(function()
							local args = {"NotificationOptionSelected", "7f8e8a30-8064-4a95-8a5b-8ffd38caa9a8", "Timedout"}
							Rep:WaitForChild("ReNotifyEvent"):FireServer(unpack(args))
							task.wait(0.3)
							remotes.RestartGame:InvokeServer()
							lastRestart = tick()
							notify("🔁 เริ่มรอบใหม่แล้ว!")
						end)
						break
					end
				end
			end
		end
	end
end)

-- ⌨️ RightShift Toggle
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Window:Toggle()
	end
end)
