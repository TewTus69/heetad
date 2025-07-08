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
local events = Rep:FindFirstChildOfClass("Folder") or Rep

-- 🧠 State
local macroData, isRecording, isPlaying = {}, false, false
local autoPlayAgain, autoStart = false, false
local currentMode, lastRestart, restartCooldown = "Normal", 0, 8

-- 🪧 Notification
local notification = Instance.new("TextLabel")
notification.Parent = game:GetService("CoreGui")
notification.Size = UDim2.new(0, 320, 0, 40)
notification.Position = UDim2.new(0.5, -160, 0.05, 0)
notification.BackgroundColor3 = Color3.fromRGB(30, 60, 90)
notification.TextColor3 = Color3.new(1, 1, 1)
notification.Font = Enum.Font.GothamBold
notification.TextSize = 18
notification.Visible = false
Instance.new("UICorner", notification)

local function notify(msg)
	notification.Text = msg
	notification.Visible = true
	task.delay(3, function() notification.Visible = false end)
end

-- 🧾 Log UI
local logFrame = Instance.new("ScrollingFrame")
logFrame.Name = "SpyLog"
logFrame.Parent = game:GetService("CoreGui")
logFrame.Position = UDim2.new(0, 10, 0.5, -150)
logFrame.Size = UDim2.new(0, 400, 0, 300)
logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
logFrame.BorderSizePixel = 0
logFrame.CanvasSize = UDim2.new(0, 0, 5, 0)
logFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
logFrame.ScrollBarThickness = 6
Instance.new("UICorner", logFrame)

local function log(text)
	local line = Instance.new("TextLabel")
	line.Size = UDim2.new(1, -10, 0, 20)
	line.BackgroundTransparency = 1
	line.Text = text
	line.Font = Enum.Font.Code
	line.TextSize = 14
	line.TextColor3 = Color3.fromRGB(0, 255, 0)
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.Parent = logFrame
end

-- 🕵️ Hook Remotes
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	if method == "FireServer" or method == "InvokeServer" then
		local success, result = pcall(function() return self.Name end)
		if success and typeof(args) == "table" then
			local argStrs = {}
			for _, v in ipairs(args) do
				table.insert(argStrs, typeof(v) == "string" and '"'..v..'"' or tostring(v))
			end
			log(string.format("[%s] %s(%s)", method, self.Name, table.concat(argStrs, ", ")))
		end
	end
	return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 🗂️ UI Tabs
local main = Window:NewTab("Main"):NewSection("🎮 Macro")

main:NewButton("⏺️ Start Record", "เริ่มบันทึก", function()
	macroData, isRecording = {}, true
	notify("⏺️ เริ่มบันทึกแล้ว")
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
	notify("🔁 Auto Play Again: " .. tostring(state))
end)

main:NewToggle("🧱 Auto Select Mode", "โหวตโหมดอัตโนมัติ", function(state)
	autoStart = state
	notify("🧱 Auto Mode: " .. tostring(state))
end)

Window:NewTab("Settings"):NewSection("🎯 Difficulty")
	:NewDropdown("Mode", "เลือกระดับ", {"dif_easy", "dif_normal", "dif_hard", "dif_insane"}, function(opt)
		currentMode = opt
		notify("🎯 ตั้งค่าโหมด: " .. opt)
		pcall(function()
			remotes.PlaceDifficultyVote:InvokeServer(opt)
		end)
	end)

Window:NewTab("About"):NewSection("👩‍💻 Created by"):NewLabel("ไออ้วง x เค้าเอง 🐬")

-- 🎮 Hook Macro Record
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

-- 🔁 Loop Auto Vote + Auto Restart
task.spawn(function()
	while true do
		task.wait(1)

		if autoStart then
			pcall(function()
				remotes.PlaceDifficultyVote:InvokeServer(currentMode)
				notify("✅ โหวตโหมด: " .. currentMode)
				autoStart = false
			end)
		end

		if autoPlayAgain and tick() - lastRestart > restartCooldown then
			for _, ui in ipairs(Players.LocalPlayer.PlayerGui:GetDescendants()) do
				if ui:IsA("TextLabel") and ui.Text:lower():find("defeat") then
					pcall(function()
						Rep:WaitForChild("ReNotifyEvent"):FireServer("NotificationOptionSelected", "any", "Timedout")
						task.wait(0.4)
						remotes.RestartGame:InvokeServer()
						lastRestart = tick()
						notify("🔁 เริ่มรอบใหม่แล้ว!")
					end)
					break
				end
			end
		end
	end
end)

-- ⌨️ RightShift toggle UI
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Window:Toggle()
	end
end)
