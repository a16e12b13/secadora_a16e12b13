local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer

local function createHairDryer()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()
    
    -- Eliminar secadora anterior si existe
    for _, item in pairs(backpack:GetChildren()) do
        if item.Name == "SecadoraDePelo" then
            item:Destroy()
        end
    end
    for _, item in pairs(character:GetChildren()) do
        if item.Name == "SecadoraDePelo" then
            item:Destroy()
        end
    end

    -- Crear el Tool
    local tool = Instance.new("Tool")
    tool.Name = "SecadoraDePelo"
    tool.RequiresHandle = true
    tool.CanBeDropped = false
    tool.ToolTip = "Secadora Rosa Pastel 💨"

    -- Handle (mango)
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.35, 1.1, 0.35)
    handle.Color = Color3.fromRGB(255, 182, 193) -- Rosa pastel
    handle.Material = Enum.Material.SmoothPlastic
    handle.Parent = tool

    -- Cabezal de la secadora
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(0.85, 0.65, 0.65)
    head.Color = Color3.fromRGB(255, 200, 220) -- Rosa pastel más claro
    head.Material = Enum.Material.SmoothPlastic
    head.CanCollide = false
    head.Parent = tool

    local weld = Instance.new("Weld")
    weld.Part0 = handle
    weld.Part1 = head
    weld.C0 = CFrame.new(0, 0.85, 0)
    weld.Parent = handle

    -- Detalle extra (boquilla)
    local nozzle = Instance.new("Part")
    nozzle.Name = "Nozzle"
    nozzle.Size = Vector3.new(0.4, 0.35, 0.4)
    nozzle.Color = Color3.fromRGB(255, 160, 180)
    nozzle.Material = Enum.Material.SmoothPlastic
    nozzle.CanCollide = false
    nozzle.Parent = tool

    local weld2 = Instance.new("Weld")
    weld2.Part0 = head
    weld2.Part1 = nozzle
    weld2.C0 = CFrame.new(0, 0, -0.45)
    weld2.Parent = head

    tool.Parent = backpack

    -- Lógica de uso
    local canUse = true
    local cooldown = 1.7

    tool.Activated:Connect(function()
        if not canUse then return end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if not root or not humanoid or humanoid.Health <= 0 then return end
        
        canUse = false

        -- Impulso hacia arriba
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "SecadoraBoost"
        bodyVelocity.Velocity = Vector3.new(0, 68, 0)
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Parent = root
        
        Debris:AddItem(bodyVelocity, 0.9)

        -- Partículas de aire
        local attachment = Instance.new("Attachment")
        attachment.Parent = root
        
        local particles = Instance.new("ParticleEmitter")
        particles.Texture = "rbxassetid://241650934"
        particles.Rate = 110
        particles.Lifetime = NumberRange.new(0.35, 0.65)
        particles.Speed = NumberRange.new(12, 20)
        particles.SpreadAngle = Vector2.new(45, 45)
        particles.Color = ColorSequence.new(Color3.fromRGB(255, 220, 230))
        particles.Parent = attachment
        
        Debris:AddItem(attachment, 1.1)

        -- Sonido de secadora
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://9113826695" -- Sonido de aire/soplado
        sound.Volume = 0.75
        sound.PlaybackSpeed = 1.05
        sound.Parent = root
        sound:Play()
        Debris:AddItem(sound, 2.5)

        task.wait(cooldown)
        canUse = true
    end)

    print("✅ Secadora Rosa Pastel lista!")
end

-- Crear al ejecutar
createHairDryer()

-- Recrear al respawnear
player.CharacterAdded:Connect(function()
    task.wait(1.2)
    createHairDryer()
end)
