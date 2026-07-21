--[[
    Script: Squid Game Script
    Author: FairsHub
    Version: 1.1
    Game: Squid Game (Splat Games)
    Executor: Delta X / Mobile Supported
]]

local FairsHub = {}

-- Settings (Toggle On/Off)
FairsHub.settings = {
    godMode = true,
    autoClick = true,
    autoBridge = true,
    autoDalgona = true,
    speedBoost = true,
    antiAfk = true,
    espPlayers = true,
    flyMode = false
}

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInput = game:GetService("UserInputService")
local virtualInput = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local guiVisible = true

print("✅ FairsHub Squid Game Script Loaded!")

-- Create GUI for Mobile
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FairsHubGUI"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 280, 0, 450)
    frame.Position = UDim2.new(0.5, -140, 0.5, -225)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Text = "⚔️ FairsHub | Squid Game"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame

    -- Subtitle
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 35)
    sub.Text = "by FairsHub | Mobile Optimized"
    sub.TextColor3 = Color3.fromRGB(150, 150, 200)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.Parent = frame

    -- ===== КНОПКИ УПРАВЛЕНИЯ =====
    
    -- Кнопка СВЕРНУТЬ (Hide)
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0, 60, 0, 25)
    hideBtn.Position = UDim2.new(0.65, 0, 0, 5)
    hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    hideBtn.Text = "➖ Hide"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.Font = Enum.Font.Gotham
    hideBtn.TextSize = 12
    hideBtn.BorderSizePixel = 1
    hideBtn.BorderColor3 = Color3.fromRGB(100, 100, 150)
    hideBtn.Parent = frame

    -- Кнопка ЗАКРЫТЬ (Close)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 60, 0, 25)
    closeBtn.Position = UDim2.new(0.85, 0, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.Text = "✕ Close"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 12
    closeBtn.BorderSizePixel = 1
    closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Parent = frame

    -- Toggle Buttons
    local yPos = 65
    for name, value in pairs(FairsHub.settings) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 32)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        btn.Text = name .. ": " .. (value and "✅ ON" or "❌ OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = frame
        
        btn.MouseButton1Click:Connect(function()
            FairsHub.settings[name] = not FairsHub.settings[name]
            btn.Text = name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF")
        end)
        
        yPos = yPos + 38
    end

    -- Credits
    local credit = Instance.new("TextLabel")
    credit.Size = UDim2.new(1, 0, 0, 20)
    credit.Position = UDim2.new(0, 0, 0, yPos + 5)
    credit.Text = "© FairsHub 2026 | discord.gg/fairshub"
    credit.TextColor3 = Color3.fromRGB(100, 100, 150)
    credit.BackgroundTransparency = 1
    credit.Font = Enum.Font.Gotham
    credit.TextSize = 11
    credit.Parent = frame

    -- ===== ФУНКЦИИ КНОПОК =====
    
    -- Кнопка Hide (сворачивает)
    hideBtn.MouseButton1Click:Connect(function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
        if guiVisible then
            hideBtn.Text = "➖ Hide"
        else
            hideBtn.Text = "➕ Show"
            -- Создаём маленькую кнопку для показа
            local showBtn = Instance.new("TextButton")
            showBtn.Name = "ShowButton"
            showBtn.Size = UDim2.new(0, 50, 0, 30)
            showBtn.Position = UDim2.new(0, 10, 0.9, 0)
            showBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            showBtn.Text = "🔽 Show"
            showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            showBtn.Font = Enum.Font.Gotham
            showBtn.TextSize = 12
            showBtn.BorderSizePixel = 2
            showBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
            showBtn.Parent = screenGui
            
            showBtn.MouseButton1Click:Connect(function()
                guiVisible = true
                frame.Visible = true
                hideBtn.Text = "➖ Hide"
                showBtn:Destroy()
            end)
        end
    end)

    -- Кнопка Close (удаляет GUI)
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        print("⛔ GUI закрыт. Скрипты продолжают работать!")
        print("🔄 Перезапусти скрипт для восстановления GUI")
    end)

    return screenGui
end

-- God Mode
local function godMode()
    runService.Heartbeat:Connect(function()
        if FairsHub.settings.godMode then
            pcall(function()
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
                humanoid.BreakJointsOnDeath = false
            end)
        end
    end)
end

-- Auto Click
local function autoClick()
    userInput.InputBegan:Connect(function(input)
        if FairsHub.settings.autoClick then
            if input.UserInputType == Enum.UserInputType.Touch or 
               input.UserInputType == Enum.UserInputType.MouseButton1 then
                for i = 1, 8 do
                    virtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                    task.wait(0.001)
                    virtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                end
            end
        end
    end)
end

-- Auto Bridge
local function autoBridge()
    spawn(function()
        while FairsHub.settings.autoBridge do
            task.wait(0.1)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name:find("Glass") then
                    pcall(function()
                        if obj.BrickColor == BrickColor.Green() or 
                           obj.BrickColor == BrickColor.new("Bright green") then
                            local pos = obj.Position
                            local mouse = player:GetMouse()
                            if mouse then
                                mouse.MoveTo(pos + Vector3.new(0, 3, 0))
                            end
                        end
                    end)
                end
            end
        end
    end)
end

-- Auto Dalgona
local function autoDalgona()
    spawn(function()
        while FairsHub.settings.autoDalgona do
            task.wait(0.01)
            local viewport = camera.ViewportSize
            virtualInput:SendTouchEvent(viewport.X / 2, viewport.Y / 2, 0, true, game, 0)
            task.wait(0.001)
            virtualInput:SendTouchEvent(viewport.X / 2, viewport.Y / 2, 0, false, game, 0)
        end
    end)
end

-- Speed Boost
local function speedBoost()
    runService.Heartbeat:Connect(function()
        if FairsHub.settings.speedBoost then
            pcall(function()
                humanoid.WalkSpeed = 50
                humanoid.JumpPower = 80
            end)
        else
            pcall(function()
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end)
        end
    end)
end

-- Anti AFK
local function antiAfk()
    spawn(function()
        while FairsHub.settings.antiAfk do
            task.wait(55)
            virtualInput:SendKeyEvent(true, "W", false, game)
            task.wait(0.2)
            virtualInput:SendKeyEvent(false, "W", false, game)
            virtualInput:SendKeyEvent(true, "A", false, game)
            task.wait(0.1)
            virtualInput:SendKeyEvent(false, "A", false, game)
        end
    end)
end

-- ESP Players
local function espPlayers()
    spawn(function()
        while FairsHub.settings.espPlayers do
            task.wait(1)
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= player then
                    pcall(function()
                        local char = p.Character
                        if char and char:FindFirstChild("Head") then
                            local hl = char.Head:FindFirstChild("FairsHub_ESP")
                            if not hl then
                                hl = Instance.new("Highlight")
                                hl.Name = "FairsHub_ESP"
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                                hl.FillTransparency = 0.4
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.OutlineTransparency = 0.2
                                hl.Parent = char.Head
                            end
                        end
                    end)
                end
            end
        end
    end)
end

-- Fly Mode
local function flyMode()
    local flying = false
    local bodyVelocity = nil
    
    userInput.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F and FairsHub.settings.flyMode then
            flying = not flying
            if flying then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = humanoid.Parent:FindFirstChild("Torso") or 
                                       humanoid.Parent:FindFirstChild("UpperTorso")
                
                runService.Heartbeat:Connect(function()
                    if flying and bodyVelocity then
                        local moveDirection = Vector3.new(0, 0, 0)
                        if userInput:IsKeyDown(Enum.KeyCode.W) then
                            moveDirection = moveDirection + camera.CFrame.LookVector
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.S) then
                            moveDirection = moveDirection - camera.CFrame.LookVector
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.A) then
                            moveDirection = moveDirection - camera.CFrame.RightVector
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.D) then
                            moveDirection = moveDirection + camera.CFrame.RightVector
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.Space) then
                            moveDirection = moveDirection + Vector3.new(0, 1, 0)
                        end
                        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                            moveDirection = moveDirection - Vector3.new(0, 1, 0)
                        end
                        bodyVelocity.Velocity = moveDirection * 100
                    end
                end)
            else
                if bodyVelocity then
                    bodyVelocity:Destroy()
                    bodyVelocity = nil
                end
            end
        end
    end)
end

-- Character respawn handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    print("🔄 Character respawned, functions re-enabled")
end)

-- Initialize everything
local function init()
    local gui = createGUI()
    godMode()
    autoClick()
    autoBridge()
    autoDalgona()
    speedBoost()
    antiAfk()
    espPlayers()
    flyMode()
    
    print("🔥 FairsHub Squid Game Script is running!")
    print("📱 Press F to toggle Fly Mode (if enabled)")
    print("🎮 Join https://discord.gg/CMvjHtd8d for more scripts")
    print("🔄 GUI buttons: Hide (➖) and Close (✕)")
end

-- Start the script
init()
