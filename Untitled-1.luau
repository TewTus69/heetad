-- 💥 ลบ GUI ซ้ำซ้อน
pcall(function()
	for _, gui in ipairs(gethui():GetChildren()) do
		if gui:IsA("ScreenGui") and gui:FindFirstChild("MainFrame") then
			gui:Destroy()
		end
	end
end)

-- 🔱 โหลด Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🌟 Macro Controller", "Midnight")

-- 🔧 ตัวแปรหลัก
local RS = game:GetService("RunService")
local Rep = game:GetService("ReplicatedStorage")
local remotes = Rep:WaitForChild("RemoteFunctions")

local macroData = {}
local isRecording = false
local isPlaying = false
local autoPlayAgain = false
local autoStart = false
local currentMode = "Normal"

-- 📁 แท็บ Main
local MainTab = Window:NewTab("Main")
local MacroSection = MainTab:NewSection("🎮 Macro Control")

MacroSection:NewToggle("⏺️ Record", "บันทึกแมโคร", function(state)
	isRecording = state
end)

MacroSection:NewToggle("▶️ Play Macro", "เล่นแมโครบันทึกไว้", function(state)
	isPlaying = state
	if state then
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
		end)()
	end
end)

MacroSection:NewToggle("🔁 Auto Play Again", "เล่นใหม่อัตโนมัติ", function(state)
	autoPlayAgain = state
end)

MacroSection:NewToggle("🧱 Auto Start Unit", "วางยูนิตอัตโนมัติเมื่อเริ่มใหม่", function(state)
	autoStart = state
end)

-- ⚙️ Settings
local SettingsTab = Window:NewTab("Settings")
local s = SettingsTab:NewSection("⚙️ Difficulty")
s:NewDropdown("Select Mode", "เลือกระดับ", {"Easy", "Normal", "Hard", "Insane"}, function(opt)
	currentMode = opt
end)

-- 📌 About
local info = Window:NewTab("About"):NewSection("📌 Info")
info:NewLabel("สร้างโดยไออ้วงและเค้าเอง ❤️")

-- 🧠 Hook Remote (Record จากการวาง)
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

-- Hook อัปเกรด
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

-- Hook ขาย
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

-- 🌐 ระบบ Auto
RS.RenderStepped:Connect(function()
	-- 🎯 โหวตโหมดเมื่อเริ่มเกมใหม่
	if autoStart then
		local success, _ = pcall(function()
			remotes.PlaceDifficultyVote:InvokeServer("dif_" .. currentMode:lower())
		end)
		if success then autoStart = false end
	end

	-- 🔁 เล่นใหม่เมื่อจบเกม
	if autoPlayAgain then
		for _, obj in ipairs(game:GetDescendants()) do
			if obj:IsA("TextButton") and obj.Text:lower():find("play again") then
				pcall(function() firesignal(obj.MouseButton1Click) end)
			end
		end
	end
end)

-- 🎛️ ปุ่มลัดซ่อน UI
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		Window:Toggle()
	end
end)
