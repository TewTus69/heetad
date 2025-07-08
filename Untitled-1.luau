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
local function notify(msg)
	local notification = Instance.new("TextLabel")
	notification.Parent = game:GetService("CoreGui")
	notification.Size = UDim2.new(0, 320, 0, 40)
	notification.Position = UDim2.new(0.5, -160, 0.05, 0)
	notification.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
	notification.TextColor3 = Color3.new(1, 1, 1)
	notification.Font = Enum.Font.GothamBold
	notification.TextSize = 18
	notification.Text = msg
	notification.Visible = true
	Instance.new("UICorner", notification)
	task.delay(3, function()
		notification:Destroy()
	end)
end

-- 🧠 State
local macroData, isRecording, isPlaying = {}, false, false
local autoPlayAgain, autoStart = false, false
local currentMode = "Normal"
local lastRestart, restartCooldown = 0, 8

-- 🎮 Macro Recording Hooks
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

-- 🗂️ Main Tab
local mainSec = Window:NewTab("Main"):NewSection("🎮 Macro")

mainSec:NewButton("⏺️ Start Record", "เริ่มบันทึกแมโคร", function()
	macroData = {}
	isRecording = true
	notify("⏺️ กำลังบันทึก")
end)

mainSec:NewButton("🛑 Stop Record", "หยุดบันทึก", function()
	isRecording = false
	notify("🛑 หยุดบันทึกแล้ว")
end)

mainSec:NewButton("▶️ Play Macro", "เล่นแมโคร", function()
	if #macroData == 0 then return notify("⚠️ ยังไม่มีข้อมูลแมโคร") end
	isPlaying = true
	notify("▶️ เริ่มเล่นแมโคร")
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

		-- 🔁 เริ่ม loop ทุกวินาที
		coroutine.wrap(function()
			while autoPlayAgain do
				-- ตรงนี้คือ logic ที่จะให้เช็คทุก 1 วิ
				print("[LOOP] ตรวจทุก 1 วิ...")
				wait(1)
			end
		end)()
	end
end)

mainSec:NewToggle("🧱 Auto Select Mode", "เลือกโหมดอัตโนมัติ", function(state)
	autoStart = state
	notify("🧱 Auto Select Mode: " .. tostring(state))
end)

-- ⚙️ Settings Tab
Window:NewTab("Settings"):NewSection("🎯 Difficulty")
	:NewDropdown("Mode", "เลือกระดับเกม", {"dif_easy", "dif_normal", "dif_hard", "dif_insane"}, function(opt) 
		currentMode = opt
		notify("🎯 ตั้งค่าโหมด: " .. opt)

		local success, err = pcall(function()
			game:GetService("ReplicatedStorage")
				:WaitForChild("RemoteFunctions")
				:WaitForChild("PlaceDifficultyVote")
				:InvokeServer(opt)
		end)

		if success then
			notify("✅ เลือกโหมดสำเร็จ: " .. opt)
		else
			notify("⚠️ เลือกโหมดล้มเหลว: " .. tostring(err))
		end
	end)

-- 📌 About Tab
Window:NewTab("About"):NewSection("📌 Created by"):NewLabel("ไออ้วง x เค้าเอง 🩵")

-- 🔁 Auto Handler (Play Again + Vote)
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
		for _, ui in ipairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
			if ui:IsA("TextLabel") and ui.Text and ui.Text:lower():match("overwhelmed|timeout|defeat|wave lost") then
				pcall(function()
					local re = Rep:FindFirstChild("ReNotifyEvent")
					if re then
						re:FireServer("NotificationOptionSelected", nil, "Timedout")
					end
					task.wait(0.4)
					remotes.RestartGame:InvokeServer()
					lastRestart = tick()
					notify("🔁 เริ่มรอบใหม่อัตโนมัติแล้ว!")
				end)
				break
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
