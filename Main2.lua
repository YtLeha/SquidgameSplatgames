--[[
    Script: Squid Game Ultimate
    Author: FairsHub
    Version: 2.0
    Game: Squid Game (Splat Games)
    Executor: Delta X / Mobile Supported
    Features: ALL GAMES + Kill Aura + Noclip + 100 Blocks Top
]]

local FairsHub = {}

-- ===== НАСТРОЙКИ =====
FairsHub.settings = {
    -- Базовые
    godMode = true,
    speedBoost = true,
    antiAfk = true,
    espPlayers = true,
    noclip = false,
    flyMode = false,
    
    -- Авто-прохождение игр
    autoRedLight = true,        -- Красный свет / Зелёный свет
    autoJumpRope = true,        -- Прыжки через скакалку
    autoPenthatlon = true,      -- Пятиборье
    autoTugOfWar = true,        -- Перетягивание каната
    autoMarbles = true,         -- Шарики
    autoMingle = true,          -- Mingle
    autoRebel = true,           -- Rebel
    autoSquidGame = true,       -- Squid Game
    auto100Blocks = true,       -- 100 Blocks Top
    
    -- Боевые
    killAura = false,           -- Аура убийства
    killAuraRange = 20,         -- Радиус ауры
}

-- ===== ПЕРЕМЕННЫЕ =====
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInput = game:GetService("UserInputService")
local virtualInput = game:GetService("VirtualInputManager")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local guiVisible = true

print("🔥 FairsHub Ultimate Squid Game Script Loaded!")

-- ===== СОЗДАНИЕ GUI =====
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FairsHubUltimate"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(0, 300, 0, 500)
    frame.Position = UDim2.new(0.5, -150, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    frame.Active = true
    frame.Draggable = true
    frame.CanvasSize = UDim2.new(0, 0, 0, 800)
    frame.ScrollBarThickness = 8
    frame.Parent = screenGui

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "⚔️ FairsHub | Ultimate"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 40)
    sub.Text = "All Games + Kill Aura + Noclip"
    sub.TextColor3 = Color3.fromRGB(150, 150, 200)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 13
    sub.Parent = frame

    -- Кнопки управления
    local btnY = 70
    local function addButton(text, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 30)
        btn.Position = UDim2.new(0.05, 0, 0, btnY)
        btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 60)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = frame
        btn.MouseButton1Click:Connect(callback)
        btnY = btnY + 35
        return btn
    end

    -- Секции
    local function addSection(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 25)
        lbl.Position = UDim2.new(0, 0, 0, btnY)
        lbl.Text = "--- " .. text .. " ---"
        lbl.TextColor3 = Color3.fromRGB(255, 200, 50)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.Parent = frame
        btnY = btnY + 28
    end

    addSection("⚡ MAIN")
    for name in pairs(FairsHub.settings) do
        if name:find("auto") or name == "godMode" or name == "speedBoost" or name == "antiAfk" or name == "espPlayers" then
            local btn = addButton(name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF"), 
                FairsHub.settings[name] and Color3.fromRGB(40, 60, 40) or Color3.fromRGB(60, 40, 40),
                function()
                    FairsHub.settings[name] = not FairsHub.settings[name]
                    btn.Text = name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF")
                    btn.BackgroundColor3 = FairsHub.settings[name] and Color3.fromRGB(40, 60, 40) or Color3.fromRGB(60, 40, 40)
                end
            )
        end
    end

    addSection("🎮 GAME MODES")
    local gameModes = {"autoRedLight", "autoJumpRope", "autoPenthatlon", "autoTugOfWar", 
                       "autoMarbles", "autoMingle", "autoRebel", "autoSquidGame", "auto100Blocks"}
    for _, name in ipairs(gameModes) do
        local btn = addButton(name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF"),
            FairsHub.settings[name] and Color3.fromRGB(40, 60, 40) or Color3.fromRGB(60, 40, 40),
            function()
                FairsHub.settings[name] = not FairsHub.settings[name]
                btn.Text = name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF")
                btn.BackgroundColor3 = FairsHub.settings[name] and Color3.fromRGB(40, 60, 40) or Color3.fromRGB(60, 40, 40)
            end
        )
    end

    addSection("💀 COMBAT")
    for name in pairs(FairsHub.settings) do
        if name == "killAura" or name == "noclip" or name == "flyMode" then
            local btn = addButton(name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF"),
                FairsHub.settings[name] and Color3.fromRGB(40, 40, 60) or Color3.fromRGB(60, 40, 40),
                function()
                    FairsHub.settings[name] = not FairsHub.settings[name]
                    btn.Text = name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF")
                    btn.BackgroundColor3 = FairsHub.settings[name] and Color3.fromRGB(40, 60, 40) or Color3.fromRGB(60, 40, 40)
                    if name == "noclip" then toggleNoclip() end
                end
            )
        end
    end

    -- Hide/Close
    local hideBtn = addButton("➖ Hide GUI", Color3.fromRGB(50, 50, 80), function()
        guiVisible = not guiVisible
        frame.Visible = guiVisible
        if not guiVisible then
            local showBtn = Instance.new("TextButton")
            showBtn.Name = "ShowButton"
            showBtn.Size = UDim2.new(0, 60, 0, 30)
            showBtn.Position = UDim2.new(0, 10, 0.9, 0)
            showBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            showBtn.Text = "🔽 Show"
            showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            showBtn.Font = Enum.Font.Gotham
            showBtn.TextSize = 12
            showBtn.Parent = screenGui
            showBtn.MouseButton1Click:Connect(function()
                guiVisible = true
                frame.Visible = true
                showBtn:Destroy()
            end)
        end
    end)

    local closeBtn = addButton("✕ Close GUI", Color3.fromRGB(200, 30, 30), function()
        screenGui:Destroy()
        print("⛔ GUI closed. Scripts still running!")
    end)

    frame.CanvasSize = UDim2.new(0, 0, 0, btnY + 20)
    return screenGui
end

-- ===== ФУНКЦИИ ИГР =====

-- 1. Red Light Green Light
local function autoRedLight()
    spawn(function()
        while FairsHub.settings.autoRedLight do
            task.wait(0.01)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:find("Light") then
                        if obj.BrickColor == BrickColor.Red() then
                            humanoid.WalkSpeed = 0
                        elseif obj.BrickColor == BrickColor.Green() then
                            humanoid.WalkSpeed = 50
                        end
                    end
                end
            end)
        end
    end)
end

-- 2. Jump Rope (авто-прыжки)
local function autoJumpRope()
    spawn(function()
        while FairsHub.settings.autoJumpRope do
            task.wait(0.1)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:find("Rope") then
                        if (obj.Position - character.PrimaryPart.Position).Magnitude < 10 then
                            humanoid.Jump = true
                            task.wait(0.2)
                        end
                    end
                end
            end)
        end
    end)
end

-- 3. Penthatlon (авто-клик)
local function autoPenthatlon()
    spawn(function()
        while FairsHub.settings.autoPenthatlon do
            task.wait(0.01)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ClickDetector") or obj.Name:find("Button") then
                        obj:Click()
                    end
                end
            end)
        end
    end)
end

-- 4. Tug of War (авто-тяга)
local function autoTugOfWar()
    spawn(function()
        while FairsHub.settings.autoTugOfWar do
            task.wait(0.01)
            pcall(function()
                virtualInput:SendKeyEvent(true, "E", false, game)
                task.wait(0.05)
                virtualInput:SendKeyEvent(false, "E", false, game)
            end)
        end
    end)
end

-- 5. Marbles (авто-бросок)
local function autoMarbles()
    spawn(function()
        while FairsHub.settings.autoMarbles do
            task.wait(0.1)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Tool") and obj.Name:find("Marble") then
                        game:GetService("ReplicatedStorage"):FindFirstChild("ThrowMarble"):FireServer()
                    end
                end
            end)
        end
    end)
end

-- 6. Mingle (авто-поиск комнат)
local function autoMingle()
    spawn(function()
        while FairsHub.settings.autoMingle do
            task.wait(1)
            pcall(function()
                local nearest = nil
                local minDist = math.huge
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:find("Room") then
                        local dist = (obj.Position - character.PrimaryPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = obj
                        end
                    end
                end
                if nearest then
                    local mouse = player:GetMouse()
                    mouse.MoveTo(nearest.Position + Vector3.new(0, 3, 0))
                end
            end)
        end
    end)
end

-- 7. Rebel (авто-атака)
local function autoRebel()
    spawn(function()
        while FairsHub.settings.autoRebel do
            task.wait(0.1)
            pcall(function()
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p ~= player then
                        local char = p.Character
                        if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                            local mouse = player:GetMouse()
                            mouse.MoveTo(char.PrimaryPart.Position)
                            virtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            task.wait(0.05)
                            virtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end
            end)
        end
    end)
end

-- 8. Squid Game (авто-бой)
local function autoSquidGame()
    spawn(function()
        while FairsHub.settings.autoSquidGame do
            task.wait(0.1)
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:find("Finish") then
                        local mouse = player:GetMouse()
                        mouse.MoveTo(obj.Position + Vector3.new(0, 3, 0))
                        humanoid.WalkSpeed = 80
                    end
                end
            end)
        end
    end)
end

-- 9. 100 Blocks Top (авто-подъём)
local function auto100Blocks()
    spawn(function()
        while FairsHub.settings.auto100Blocks do
            task.wait(0.1)
            pcall(function()
                local highest = nil
                local maxY = -math.huge
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:find("Block") then
                        if obj.Position.Y > maxY then
                            maxY = obj.Position.Y
                            highest = obj
                        end
                    end
                end
                if highest then
                    local mouse = player:GetMouse()
                    mouse.MoveTo(highest.Position + Vector3.new(0, 5, 0))
                    humanoid.Jump = true
                end
            end)
        end
    end)
end

-- ===== БОЕВЫЕ ФУНКЦИИ =====

-- Kill Aura
local function killAura()
    spawn(function()
        while FairsHub.settings.killAura do
            task.wait(0.1)
            pcall(function()
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p ~= player then
                        local char = p.Character
                        if char and char:FindFirstChild("Humanoid") then
                            local dist = (char.PrimaryPart.Position - character.PrimaryPart.Position).Magnitude
                            if dist < FairsHub.settings.killAuraRange then
                                char.Humanoid.Health = 0
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Noclip (вкл/выкл)
local noclipEnabled = false
local function toggleNoclip()
    noclipEnabled = FairsHub.settings.noclip
    if noclipEnabled then
        runService.Stepped:Connect(function()
            if noclipEnabled and character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Fly Mode
local flying = false
local bodyVelocity = nil
local function flyMode()
    userInput.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F and FairsHub.settings.flyMode then
            flying = not flying
            if flying then
                bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.Parent = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                
                runService.Heartbeat:Connect(function()
                    if flying and bodyVelocity then
                        local moveDir = Vector3.new(0, 0, 0)
                        if userInput:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
                        if userInput:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
                        if userInput:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
                        if userInput:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
                        if userInput:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                        bodyVelocity.Velocity = moveDir * 100
                    end
                end)
            else
                if bodyVelocity then bodyVelocity:Destroy() end
            end
        end
    end)
end

-- ===== БАЗОВЫЕ ФУНКЦИИ =====

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

-- Speed Boost
local function speedBoost()
    runService.Heartbeat:Connect(function()
        if FairsHub.settings.speedBoost then
            pcall(function() humanoid.WalkSpeed = 50; humanoid.JumpPower = 80 end)
        else
            pcall(function() humanoid.WalkSpeed = 16; humanoid.JumpPower = 50 end)
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
                                hl.Parent = char.Head
                            end
                        end
                    end)
                end
            end
        end
    end)
end

-- ===== ЗАПУСК =====
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    print("🔄 Character respawned!")
end)

local function init()
    createGUI()
    godMode()
    speedBoost()
    antiAfk()
    espPlayers()
    
    -- Запускаем все авто-игры
    autoRedLight()
    autoJumpRope()
    autoPenthatlon()
    autoTugOfWar()
    autoMarbles()
    autoMingle()
    autoRebel()
    autoSquidGame()
    auto100Blocks()
    
    -- Боевые
    killAura()
    flyMode()
    toggleNoclip()
    
    print("🔥 FairsHub Ultimate Script LOADED!")
    print("🎮 Все режимы автоматизированы!")
    print("💀 Kill Aura, Noclip, Fly Mode активны!")
    print("📱 Нажми F для Fly Mode")
    print("🔗 Discord: https://discord.gg/CMvjHtd8d")
end

-- Запуск
init()
