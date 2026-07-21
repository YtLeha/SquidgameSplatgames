--[[
    Script: Squid Game Ultimate v2.1
    Author: FairsHub
    All features with toggle buttons ON/OFF
]]

local FairsHub = {}

-- ===== ВСЕ НАСТРОЙКИ =====
FairsHub.settings = {
    -- Основные
    godMode = true,
    speedBoost = true,
    antiAfk = true,
    espPlayers = true,
    noclip = false,
    flyMode = false,
    
    -- Игры
    autoRedLight = true,
    autoJumpRope = true,
    autoPenthatlon = true,
    autoTugOfWar = true,
    autoMarbles = true,
    autoMingle = true,
    autoRebel = true,
    autoSquidGame = true,
    auto100Blocks = true,
    
    -- Боевые
    killAura = false,
    killAuraRange = 20,
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
local noclipEnabled = false
local flying = false
local bodyVelocity = nil

print("🔥 FairsHub Ultimate v2.1 Loaded!")

-- ===== СОЗДАНИЕ GUI =====
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FairsHubUltimate"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(0, 310, 0, 520)
    frame.Position = UDim2.new(0.5, -155, 0.5, -260)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 30, 30)
    frame.Active = true
    frame.Draggable = true
    frame.CanvasSize = UDim2.new(0, 0, 0, 900)
    frame.ScrollBarThickness = 8
    frame.Parent = screenGui

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "⚔️ FairsHub | Ultimate v2.1"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, 0, 0, 20)
    sub.Position = UDim2.new(0, 0, 0, 40)
    sub.Text = "All Games | Kill Aura | Noclip | Fly Mode"
    sub.TextColor3 = Color3.fromRGB(150, 150, 200)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.Parent = frame

    local btnY = 70
    local buttons = {}

    -- Функция создания кнопки-переключателя
    local function createToggle(name, defaultColor)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.88, 0, 0, 32)
        btn.Position = UDim2.new(0.06, 0, 0, btnY)
        btn.BackgroundColor3 = defaultColor or Color3.fromRGB(40, 40, 60)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        btn.Text = name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF")
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = frame
        btnY = btnY + 37
        
        -- Клик для переключения
        btn.MouseButton1Click:Connect(function()
            FairsHub.settings[name] = not FairsHub.settings[name]
            btn.Text = name .. ": " .. (FairsHub.settings[name] and "✅ ON" or "❌ OFF")
            btn.BackgroundColor3 = FairsHub.settings[name] and Color3.fromRGB(30, 80, 30) or Color3.fromRGB(80, 30, 30)
            
            -- Специальные действия при переключении
            if name == "noclip" then toggleNoclip() end
            if name == "flyMode" and not FairsHub.settings.flyMode then
                if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
                flying = false
            end
        end)
        
        -- Устанавливаем цвет при создании
        btn.BackgroundColor3 = FairsHub.settings[name] and Color3.fromRGB(30, 80, 30) or Color3.fromRGB(80, 30, 30)
        table.insert(buttons, btn)
        return btn
    end

    -- Функция создания секции
    local function addSection(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 25)
        lbl.Position = UDim2.new(0, 0, 0, btnY)
        lbl.Text = " ═══ " .. text .. " ═══ "
        lbl.TextColor3 = Color3.fromRGB(255, 200, 50)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.Parent = frame
        btnY = btnY + 30
    end

    -- ===== СОЗДАНИЕ ВСЕХ КНОПОК =====
    
    addSection("⚡ MAIN")
    createToggle("godMode")
    createToggle("speedBoost")
    createToggle("antiAfk")
    createToggle("espPlayers")

    addSection("🎮 AUTO GAMES")
    createToggle("autoRedLight")
    createToggle("autoJumpRope")
    createToggle("autoPenthatlon")
    createToggle("autoTugOfWar")
    createToggle("autoMarbles")
    createToggle("autoMingle")
    createToggle("autoRebel")
    createToggle("autoSquidGame")
    createToggle("auto100Blocks")

    addSection("💀 COMBAT")
    createToggle("killAura")
    createToggle("noclip")
    createToggle("flyMode")

    addSection("🛠 CONTROLS")
    
    -- Кнопка Hide
    local hideBtn = Instance.new("TextButton")
    hideBtn.Size = UDim2.new(0.4, 0, 0, 32)
    hideBtn.Position = UDim2.new(0.06, 0, 0, btnY)
    hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    hideBtn.BorderSizePixel = 1
    hideBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
    hideBtn.Text = "➖ Hide GUI"
    hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    hideBtn.Font = Enum.Font.Gotham
    hideBtn.TextSize = 13
    hideBtn.Parent = frame
    hideBtn.MouseButton1Click:Connect(function()
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

    -- Кнопка Close
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.4, 0, 0, 32)
    closeBtn.Position = UDim2.new(0.54, 0, 0, btnY)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.BorderSizePixel = 1
    closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "✕ Close GUI"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.TextSize = 13
    closeBtn.Parent = frame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        print("⛔ GUI closed. Scripts still running!")
    end)

    btnY = btnY + 40

    -- Кредиты
    local credit = Instance.new("TextLabel")
    credit.Size = UDim2.new(1, 0, 0, 20)
    credit.Position = UDim2.new(0, 0, 0, btnY)
    credit.Text = "© FairsHub 2026 | discord.gg/fairshub"
    credit.TextColor3 = Color3.fromRGB(100, 100, 150)
    credit.BackgroundTransparency = 1
    credit.Font = Enum.Font.Gotham
    credit.TextSize = 11
    credit.Parent = frame

    frame.CanvasSize = UDim2.new(0, 0, 0, btnY + 30)
    return screenGui
end

-- ===== ВСЕ ФУНКЦИИ =====

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

-- ESP
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

-- RED LIGHT
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

-- JUMP ROPE
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

-- PENTHATLON
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

-- TUG OF WAR
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

-- MARBLES
local function autoMarbles()
    spawn(function()
        while FairsHub.settings.autoMarbles do
            task.wait(0.1)
            pcall(function()
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild("ThrowMarble")
                if remote then remote:FireServer() end
            end)
        end
    end)
end

-- MINGLE
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

-- REBEL
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

-- SQUID GAME
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

-- 100 BLOCKS
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

-- KILL AURA
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

-- NOCLIP
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

-- FLY MODE
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
                if bodyVelocity then bodyVelocity:Destroy(); bodyVelocity = nil end
            end
        end
    end)
end

-- ===== ПЕРЕЗАГРУЗКА ПЕРСОНАЖА =====
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    print("🔄 Character respawned!")
end)

-- ===== ЗАПУСК =====
local function init()
    createGUI()
    godMode()
    speedBoost()
    antiAfk()
    espPlayers()
    autoRedLight()
    autoJumpRope()
    autoPenthatlon()
    autoTugOfWar()
    autoMarbles()
    autoMingle()
    autoRebel()
    autoSquidGame()
    auto100Blocks()
    killAura()
    flyMode()
    toggleNoclip()
    
    print("🔥 FairsHub Ultimate v2.1 LOADED!")
    print("🎮 Все функции с кнопками ON/OFF!")
    print("📱 Нажми F для Fly Mode")
    print("💀 Kill Aura радиус: " .. FairsHub.settings.killAuraRange)
    print("🔗 Discord: discord.gg/fairshub")
end

init()
