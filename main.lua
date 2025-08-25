-- Carrega o Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Jogador local
local player = Players.LocalPlayer
local humanoid
local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Função para obter o Humanoid com segurança
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

-- Inicializa o humanoid
humanoid = getHumanoid()

-- Criação da janela principal do Mod Menu
local Window = Rayfield:CreateWindow({
    Name = "modmenu - EcoHub",
    Icon = 0,
    LoadingTitle = "Eco Hub",
    LoadingSubtitle = "by rip_sheldoohz",
    ShowText = "Eco Hub",
    Theme = "Default",

    ToggleUIKeybind = Enum.KeyCode.K,
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,

    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EcoHub",
        FileName = "EcoHubConfig"
    },

    Discord = {
        Enabled = true,
        Invite = "abygGhvRCG",
        RememberJoins = true
    },

    KeySystem = true,
    KeySettings = {
        Title = "Eco Hub - Key System",
        Subtitle = "Proteção com Key",
        Note = "Digite sua Key para acessar o painel",
        FileName = "EcoHubKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"EcoHub"}
    }
})

local MainMenuTab = Window:CreateTab("Main Eco Hub", 4483362458)

MainMenuTab:CreateParagraph({
    Title = "Boas-Vindas | Mod Menu Eco Hub",
    Content = "Você está no painel principal do Eco Hub, um mod menu completo com diversos scripts atualizados e ferramentas avançadas para desenvolvedores. Criado e mantido por rip_sheldoohz. Use os botões acima para explorar as funções disponíveis."
})

MainMenuTab:CreateParagraph({
    Title = "Mod Menu Eco Hub Atualizado",
    Content = "Esta é a versão mais recente do Eco Hub, com todos os scripts e ferramentas atualizados. Desenvolvido por rip_sheldoohz. Nenhum conteúdo será exibido abaixo."
})


local BrookhavenRPTab = Window:CreateTab("Brookhaven 🏡 RP", 4483362458)
BrookhavenRPTab:CreateParagraph({
    Title = "Script Brookhaven 🏡 RP",
    Content = "Use os botões abaixo para ativar as funções do Brookhaven"
})

local humanoidRootPart
local flyAtivo = false
local flySpeed = 100
local bodyVelocity
local bodyGyro
local moveDir = Vector3.new(0,0,0)

player.CharacterAdded:Connect(function(char)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)
if player.Character then
    humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not flyAtivo then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir + Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir + Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir + Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir + Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = moveDir + Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDir = moveDir + Vector3.new(0,-1,0) end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not flyAtivo then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir - Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir - Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir - Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir - Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = moveDir - Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDir = moveDir - Vector3.new(0,-1,0) end
    end
end)

local function ativarFly(Value)
    flyAtivo = Value
    local char = player.Character
    if not char or not humanoidRootPart then return end

    if flyAtivo then
        print("Fly ativado - Voando com tudo (carro/carrinho incluso) 🚀")

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = humanoidRootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
    else
        print("Fly desativado")

        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        moveDir = Vector3.new(0,0,0)
    end
end

RunService.RenderStepped:Connect(function()
    if flyAtivo and humanoidRootPart and bodyVelocity and bodyGyro then
        local cam = workspace.CurrentCamera
        local direction = (cam.CFrame.LookVector * moveDir.Z + cam.CFrame.RightVector * moveDir.X + Vector3.new(0, moveDir.Y, 0))

        if direction.Magnitude > 0 then
            direction = direction.Unit
        else
            direction = Vector3.new(0,0,0)
        end

        bodyVelocity.Velocity = direction * flySpeed
        bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + cam.CFrame.LookVector)
    end
end)

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Fly",
    CurrentValue = false,
    Flag = "ToggleFly",
    Callback = ativarFly
})

BrookhavenRPTab:CreateSlider({
    Name = "Velocidade do Fly",
    Range = {10, 500},
    Increment = 10,
    Suffix = " u/s",
    CurrentValue = 100,
    Flag = "SliderFlySpeed",
    Callback = function(Value)
        flySpeed = Value
        print("Velocidade do fly ajustada para: " .. Value)
    end,
})

local noclipAtivo = false
local noclipConnection = nil

local function aplicarNoclip()
    local character = player.Character
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end

local function removerNoclip()
    local character = player.Character
    if not character then return end
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            if part.Name == "HumanoidRootPart" then
                part.CanCollide = false
            else
                part.CanCollide = true
            end
        end
    end
    
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant.Name == "HumanoidRootPart" then
                descendant.CanCollide = false
            else
                descendant.CanCollide = true
            end
        end
    end
end

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Noclip",
    CurrentValue = false,
    Flag = "ToggleNoclip",
    Callback = function(Value)
        noclipAtivo = Value
        
        if Value then
            print("Noclip ativado - Você pode atravessar paredes!")
            
            if noclipConnection then
                noclipConnection:Disconnect()
            end
            
            noclipConnection = RunService.Stepped:Connect(function()
                aplicarNoclip()
            end)
            
        else
            print("Noclip desativado - Colisão normal restaurada")
            
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            removerNoclip()
        end
        
        if noclipAtivo then
            aplicarNoclip()
        else
            removerNoclip()
        end
    end,
})

local function onChildAdded(child)
    if noclipAtivo and child:IsA("BasePart") then
        child.CanCollide = false
    elseif noclipAtivo and child:IsA("Accessory") then
        local handle = child:WaitForChild("Handle", 5)
        if handle then
            handle.CanCollide = false
        end
    end
end

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(1)
    
    if noclipAtivo then
        print("Reaplicando noclip após respawn")
        aplicarNoclip()
    end
    
    character.ChildAdded:Connect(onChildAdded)
    character.DescendantAdded:Connect(function(descendant)
        if noclipAtivo and descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end)
end)

if player.Character then
    player.Character.ChildAdded:Connect(onChildAdded)
    player.Character.DescendantAdded:Connect(function(descendant)
        if noclipAtivo and descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end)
end

local superPuloAtivo = false
local jumpPowerOriginal = 50
local jumpPowerAtual = 150

local function atualizarSuperPulo(Value)
    superPuloAtivo = Value
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if superPuloAtivo then
            humanoid.JumpPower = jumpPowerAtual
        else
            humanoid.JumpPower = jumpPowerOriginal
        end
    end
end

player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    if superPuloAtivo and humanoid then
        humanoid.JumpPower = jumpPowerAtual
    end
end)

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Super Pulo",
    CurrentValue = false,
    Flag = "ToggleSuperPulo",
    Callback = atualizarSuperPulo
})

BrookhavenRPTab:CreateSlider({
   Name = "Altura do Pulo",
   Range = {100, 1000},
   Increment = 10,
   Suffix = "u/s",
   CurrentValue = 150,
   Flag = "SliderJumpPower",
   Callback = function(Value)
       jumpPowerAtual = Value
       local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
       if superPuloAtivo and humanoid then
           humanoid.JumpPower = jumpPowerAtual
       end
   end,
})

local velocidadeAtiva = false
local velocidadeEscolhida = 16
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function getHumanoidSafe()
    local character = player.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function aplicarVelocidadeNoRespawn()
    wait(0.5)
    local currentHumanoid = getHumanoidSafe()
    if currentHumanoid and velocidadeAtiva then
        currentHumanoid.WalkSpeed = velocidadeEscolhida
        print("Velocidade aplicada após respawn: " .. velocidadeEscolhida)
    end
end

player.CharacterAdded:Connect(aplicarVelocidadeNoRespawn)

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Velocidade",
    CurrentValue = false,
    Flag = "ToggleVelocidade",
    Callback = function(Value)
        pcall(function()
            velocidadeAtiva = Value
            local currentHumanoid = getHumanoidSafe()
            
            if currentHumanoid then
                if Value then
                    currentHumanoid.WalkSpeed = velocidadeEscolhida
                    print("Velocidade ativada: " .. velocidadeEscolhida)
                else
                    currentHumanoid.WalkSpeed = 16
                    print("Velocidade desativada (16)")
                end
            else
                warn("Humanoid não encontrado para alterar velocidade.")
            end
        end)
    end,
})

BrookhavenRPTab:CreateSlider({
    Name = "Velocidade do Jogador",
    Range = {16, 1000},
    Increment = 1,
    Suffix = " u/s",
    CurrentValue = 16,
    Flag = "SliderVelocidade",
    Callback = function(Value)
        pcall(function()
            velocidadeEscolhida = Value
            local currentHumanoid = getHumanoidSafe()
            
            if velocidadeAtiva and currentHumanoid then
                currentHumanoid.WalkSpeed = Value
                print("Velocidade ajustada para: " .. Value)
            end
        end)
    end,
})

BrookhavenRPTab:CreateParagraph({
    Title = "ESP Otimizado - Brookhaven 🏡 RP",
    Content = "ESP otimizado com linhas conectoras e sem lag.\nVisualize jogadores e cofres de forma suave e eficiente."
})

local espAtivoPlayers = false
local espAtivoCofres = false
local corPlayer = Color3.fromRGB(0, 255, 0)
local corCofre = Color3.fromRGB(255, 255, 0)
local camera = workspace.CurrentCamera

local playerHighlights = {}
local cofreHighlights = {}
local playerConnections = {}
local updateTimer = 0
local cofreUpdateTimer = 0

local function createPlayerArsenalESP(targetPlayer)
    if not targetPlayer.Character or playerHighlights[targetPlayer] then return end
    
    local character = targetPlayer.Character
    local espObjects = {}
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerArsenalESP"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.3
    highlight.FillColor = corPlayer
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = character
    table.insert(espObjects, highlight)
    
    local head = character:FindFirstChild("Head")
    if head then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlayerInfo"
        billboard.Size = UDim2.new(0, 120, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 12
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.SourceSansBold
        nameLabel.Parent = billboard
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Size = UDim2.new(1, 0, 0.4, 0)
        distLabel.Position = UDim2.new(0, 0, 0.6, 0)
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = corPlayer
        distLabel.TextSize = 10
        distLabel.TextStrokeTransparency = 0
        distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distLabel.Font = Enum.Font.SourceSans
        distLabel.Text = "0m"
        distLabel.Parent = billboard
        
        table.insert(espObjects, billboard)
        
        spawn(function()
            while billboard.Parent and player.Character and targetPlayer.Character do
                local hrp1 = player.Character:FindFirstChild("HumanoidRootPart")
                local hrp2 = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp1 and hrp2 then
                    local dist = math.floor((hrp1.Position - hrp2.Position).Magnitude)
                    distLabel.Text = dist .. "m"
                    distLabel.TextColor3 = corPlayer
                end
                wait(0.5)
            end
        end)
    end
    
    pcall(function()
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = corPlayer
        tracer.Thickness = 1
        tracer.Transparency = 0.9
        
        table.insert(espObjects, tracer)
        
        spawn(function()
            while espAtivoPlayers and character.Parent and tracer do
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        tracer.Color = corPlayer
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                end
                wait(0.1)
            end
            if tracer then tracer:Remove() end
        end)
    end)
    
    playerHighlights[targetPlayer] = espObjects
end

local function createCofreArsenalESP(cofre)
    if cofreHighlights[cofre] then return end
    
    local espObjects = {}
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "CofreESP"
    highlight.Adornee = cofre
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0.2
    highlight.FillColor = corCofre
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = cofre
    table.insert(espObjects, highlight)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CofreInfo"
    billboard.Adornee = cofre
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 1, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = game.CoreGui
    
    local cofreLabel = Instance.new("TextLabel")
    cofreLabel.Size = UDim2.new(1, 0, 0.5, 0)
    cofreLabel.BackgroundTransparency = 1
    cofreLabel.Text = "COFRE"
    cofreLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    cofreLabel.TextSize = 10
    cofreLabel.TextStrokeTransparency = 0
    cofreLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    cofreLabel.Font = Enum.Font.SourceSansBold
    cofreLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = corCofre
    distLabel.TextSize = 9
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Font = Enum.Font.SourceSans
    distLabel.Text = "0m"
    distLabel.Parent = billboard
    
    table.insert(espObjects, billboard)
    
    pcall(function()
        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = corCofre
        tracer.Thickness = 1
        tracer.Transparency = 0.9
        
        table.insert(espObjects, tracer)
        
        spawn(function()
            while espAtivoCofres and cofre.Parent and tracer do
                local screenPos, onScreen = camera:WorldToViewportPoint(cofre.Position)
                if onScreen then
                    tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                    tracer.Color = corCofre
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
                wait(0.15)
            end
            if tracer then tracer:Remove() end
        end)
    end)
    
    spawn(function()
        while billboard.Parent and player.Character do
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and cofre.Parent then
                local dist = math.floor((hrp.Position - cofre.Position).Magnitude)
                distLabel.Text = dist .. "m"
                distLabel.TextColor3 = corCofre
            end
            wait(0.7)
        end
    end)
    
    cofreHighlights[cofre] = espObjects
end

local function applyPlayerESP()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            createPlayerArsenalESP(targetPlayer)
        end
    end
end

local function applyCofreESP()
    local found = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if found >= 20 then break end
        if obj:IsA("BasePart") and obj.Name and 
           (obj.Name:lower():find("cofre") or obj.Name:lower():find("safe") or obj.Name:lower():find("chest")) then
            createCofreArsenalESP(obj)
            found = found + 1
        end
    end
end

local function removePlayerESP()
    for targetPlayer, espObjs in pairs(playerHighlights) do
        for _, obj in pairs(espObjs) do
            if obj and obj.Destroy then
                obj:Destroy()
            elseif obj and obj.Remove then
                obj:Remove()
            end
        end
    end
    playerHighlights = {}
end

local function removeCofreESP()
    for cofre, espObjs in pairs(cofreHighlights) do
        for _, obj in pairs(espObjs) do
            if obj and obj.Destroy then
                obj:Destroy()
            elseif obj and obj.Remove then
                obj:Remove()
            end
        end
    end
    cofreHighlights = {}
end

spawn(function()
    while true do
        local currentTime = tick()
        
        if espAtivoPlayers and (currentTime - updateTimer) > 2 then
            applyPlayerESP()
            updateTimer = currentTime
        end
        
        if espAtivoCofres and (currentTime - cofreUpdateTimer) > 5 then
            applyCofreESP()
            cofreUpdateTimer = currentTime
        end
        
        wait(1)
    end
end)

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Esp Players",
    CurrentValue = false,
    Flag = "ToggleArsenalPlayers",
    Callback = function(Value)
        espAtivoPlayers = Value
        if Value then
            applyPlayerESP()
        else
            removePlayerESP()
        end
    end
})

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Esp Cofres",
    CurrentValue = false,
    Flag = "ToggleArsenalCofres",
    Callback = function(Value)
        espAtivoCofres = Value
        if Value then
            applyCofreESP()
        else
            removeCofreESP()
        end
    end
})

BrookhavenRPTab:CreateColorPicker({
    Name = "Cor ESP Jogadores",
    Color = corPlayer,
    Flag = "ColorPlayer",
    Callback = function(Value)
        corPlayer = Value
    end
})

BrookhavenRPTab:CreateColorPicker({
    Name = "Cor ESP Cofres",
    Color = corCofre,
    Flag = "ColorCofre",
    Callback = function(Value)
        corCofre = Value
    end
})

Rayfield:Notify({
    Title = "ESP Otimizado Carregado",
    Content = "Sistema ESP sem lag ativado!",
    Duration = 3
})

BrookhavenRPTab:CreateParagraph({
    Title = "Anti-Ban - Brookhaven 🏡 RP",
    Content = "Ative o sistema Anti-Ban para proteger seu personagem de kicks, barreiras suspeitas e quedas.\nUse o botão abaixo para ligar ou desligar a proteção e fique seguro enquanto joga."
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local antiBanAtivo = false
local destroyedParts = {}
local lastSafePos = nil
local debounceRestore = false
local characterProtected = false
local antiKickEnabled = false
local characterConnection = nil

local banTriggerWords = { "ban", "kick", "barrier", "block", "anti", "exploit" }

local function hookKick()
    if antiKickEnabled then return end
    antiKickEnabled = true

    local success = pcall(function()
        if getrawmetatable and newcclosure then
            local mt = getrawmetatable(game)
            if mt then
                setreadonly(mt, false)

                local oldNamecall = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod and getnamecallmethod() or ""
                    if method == "Kick" or tostring(self):lower():find("kick") then
                        warn("[Anti-Ban]: Kick bloqueado.")
                        return nil
                    end
                    return oldNamecall(self, ...)
                end)

                setreadonly(mt, true)
            end
        end
    end)

    if not success then
        warn("[Anti-Ban]: Não foi possível ativar proteção contra Kick.")
    end
end

local function removeBarrierParts()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj and obj.Parent and obj:IsA("BasePart") and not destroyedParts[obj] then
                local lname = obj.Name:lower()
                for _, word in ipairs(banTriggerWords) do
                    if lname:find(word) then
                        destroyedParts[obj] = true
                        pcall(function() obj:Destroy() end)
                        warn("[Anti-Ban]: Removido objeto bloqueador: " .. obj.Name)
                        break
                    end
                end
            end
        end
    end)
end

local function protectCharacter(character)
    if not character or characterProtected then return end
    characterProtected = true

    pcall(function()
        character.DescendantRemoving:Connect(function(part)
            if part and part:IsDescendantOf(character) then
                warn("[Anti-Ban]: Parte do personagem removida: " .. part.Name .. ". Recarregando personagem...")
                task.wait(0.1)
                pcall(function()
                    LocalPlayer:LoadCharacter()
                end)
            end
        end)
    end)
end

local function restoreCharacter()
    if debounceRestore then return end
    debounceRestore = true
    warn("[Anti-Ban]: Morte ou queda detectada. Restaurando em 3 segundos...")

    task.spawn(function()
        task.wait(3)
        pcall(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if lastSafePos then
                    char.HumanoidRootPart.CFrame = CFrame.new(lastSafePos) + Vector3.new(0, 5, 0)
                end
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health <= 0 then
                    humanoid.Health = humanoid.MaxHealth
                end
            else
                LocalPlayer:LoadCharacter()
            end
        end)
        task.wait(2)
        debounceRestore = false
    end)
end

local function onCharacterAdded(character)
    if not character then return end

    pcall(function()
        characterProtected = false
        protectCharacter(character)

        local hrp = character:WaitForChild("HumanoidRootPart", 10)
        if hrp and lastSafePos then
            task.wait(0.5)
            hrp.CFrame = CFrame.new(lastSafePos) + Vector3.new(0, 5, 0)
            warn("[Anti-Ban]: Teleportado para última posição segura.")
        end
    end)
end

local safePositionLoop = nil
local barrierRemovalLoop = nil

local function startLoops()
    if safePositionLoop then task.cancel(safePositionLoop) end

    safePositionLoop = task.spawn(function()
        while antiBanAtivo do
            task.wait(1)
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                    local humanoid = char.Humanoid
                    local root = char.HumanoidRootPart

                    if humanoid.Health > 0 and root.Position.Y > -100 then
                        lastSafePos = root.Position
                    elseif humanoid.Health <= 0 or root.Position.Y < -50 then
                        restoreCharacter()
                    end
                end
            end)
        end
    end)

    if barrierRemovalLoop then task.cancel(barrierRemovalLoop) end

    barrierRemovalLoop = task.spawn(function()
        while antiBanAtivo do
            task.wait(2)
            if antiBanAtivo then
                removeBarrierParts()
            end
        end
    end)
end

local function stopLoops()
    if safePositionLoop then
        task.cancel(safePositionLoop)
        safePositionLoop = nil
    end
    if barrierRemovalLoop then
        task.cancel(barrierRemovalLoop)
        barrierRemovalLoop = nil
    end
end

BrookhavenRPTab:CreateToggle({
    Name = "Ativar Anti-Ban",
    CurrentValue = false,
    Flag = "ToggleAntiBan",
    Callback = function(Value)
        pcall(function()
            antiBanAtivo = Value

            if Value then
                hookKick()

                if characterConnection then
                    characterConnection:Disconnect()
                end

                if LocalPlayer.Character then
                    onCharacterAdded(LocalPlayer.Character)
                end

                characterConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                    onCharacterAdded(char)
                end)

                startLoops()

                if Rayfield then
                    Rayfield:Notify({
                        Title = "Anti-Ban Ativado",
                        Content = "Proteção contra kick e barreiras ativada!",
                        Duration = 3,
                        Image = 4483362458
                    })
                end

                print("[Anti-Ban]: Sistema ativado com sucesso!")
            else
                stopLoops()

                if characterConnection then
                    characterConnection:Disconnect()
                    characterConnection = nil
                end

                if Rayfield then
                    Rayfield:Notify({
                        Title = "Anti-Ban Desativado",
                        Content = "Proteção desativada.",
                        Duration = 3,
                        Image = 4483362458
                    })
                end

                print("[Anti-Ban]: Sistema desativado.")
            end
        end)
    end
})

local function aplicarOtimizacaoLeve()
    local settings = UserSettings():GetService("UserGameSettings")
    settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    settings.MasterVolume = 0.2

    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("SunRaysEffect") then
            effect:Destroy()
        end
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end

    SoundService.AmbientReverb = Enum.ReverbType.NoReverb
    SoundService.DopplerScale = 0
    SoundService.RolloffScale = 0.5
end

BrookhavenRPTab:CreateButton({
    Name = "Ativar Otimização",
    Callback = function()
        aplicarOtimizacaoLeve()
        if Rayfield then
            Rayfield:Notify({
                Title = "Otimização Aplicada",
                Content = "FPS aumentado, efeitos pesados desativados. HUD e nomes mantidos!",
                Duration = 3,
                Image = 4483362458
            })
        end
    end
})

local IniciacaoPTab = Window:CreateTab("Iniciação de Combate", 4483362458)
IniciacaoPTab:CreateParagraph({
    Title = "Script de Iniciação de Combate",
    Content = "Combater Inimigos\nby rip_sheldoohz"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local velocidadeAtiva = false
local velocidadeAtual = 16

local function getHumanoid()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid")
end

IniciacaoPTab:CreateToggle({
    Name = "Ativar Velocidade",
    CurrentValue = false,
    Flag = "ToggleVelocidade",
    Callback = function(Value)
        velocidadeAtiva = Value
        local humanoid = getHumanoid()
        humanoid.WalkSpeed = Value and velocidadeAtual or 16
    end,
})

IniciacaoPTab:CreateSlider({
    Name = "Velocidade",
    Range = {16, 1000},
    Increment = 1,
    Suffix = "WalkSpeed",
    CurrentValue = 16,
    Flag = "SliderVelocidade",
    Callback = function(Value)
        velocidadeAtual = Value
        if velocidadeAtiva then
            local humanoid = getHumanoid()
            humanoid.WalkSpeed = velocidadeAtual
        end
    end,
})

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoClickAtivo = false
local clicksPorSegundo = 10

local clickConnection
local tempoUltimoClick = 0

local function temEspadaEquipada()
    local character = player.Character
    if not character then return false end

    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name:lower():find("sword") then
        return true
    end
    return false
end

IniciacaoPTab:CreateToggle({
    Name = "Ativar Auto Click",
    CurrentValue = false,
    Flag = "ToggleAutoClick",
    Callback = function(Value)
        autoClickAtivo = Value

        if autoClickAtivo then
            if clickConnection then
                clickConnection:Disconnect()
                clickConnection = nil
            end

            tempoUltimoClick = 0

            clickConnection = RunService.Heartbeat:Connect(function(dt)
                if autoClickAtivo then
                    tempoUltimoClick = tempoUltimoClick + dt
                    local intervalo = 1 / clicksPorSegundo

                    if tempoUltimoClick >= intervalo then
                        if UserInputService:GetMouseLocation() and temEspadaEquipada() then
                            spawn(function()
                                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                                local eventoClick = ReplicatedStorage:FindFirstChild("ClickEvent")
                                if eventoClick and eventoClick:IsA("RemoteEvent") then
                                    eventoClick:FireServer()
                                else
                                    print("Evento ClickEvent não encontrado!")
                                end
                            end)
                        end
                        tempoUltimoClick = 0
                    end
                end
            end)
        else
            if clickConnection then
                clickConnection:Disconnect()
                clickConnection = nil
            end
        end
    end,
})

IniciacaoPTab:CreateSlider({
    Name = "Clicks por Segundo",
    Range = {10, 1000},
    Increment = 1,
    Suffix = "CPS",
    CurrentValue = 10,
    Flag = "SliderAutoClickCPS",
    Callback = function(Value)
        clicksPorSegundo = Value
    end,
})

local HighwayRacingtab = Window:CreateTab("Highway Racing", 4483362458)

local ESP = {
    enabled = false,
    color = Color3.fromRGB(255, 0, 0),
    highlights = {},
    connections = {}
}

function ESP:createESP(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if self.highlights[targetPlayer] then self.highlights[targetPlayer]:Destroy() end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = targetPlayer.Character
    highlight.FillColor = self.color
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = targetPlayer.Character
    
    self.highlights[targetPlayer] = highlight
end

function ESP:removeESP(targetPlayer)
    if self.highlights[targetPlayer] then
        self.highlights[targetPlayer]:Destroy()
        self.highlights[targetPlayer] = nil
    end
end

function ESP:monitorPlayer(targetPlayer)
    local function onCharacterAdded(char)
        char:WaitForChild("HumanoidRootPart", 5)
        self:createESP(targetPlayer)
    end
    
    if targetPlayer.Character then
        onCharacterAdded(targetPlayer.Character)
    end
    
    local charConn = targetPlayer.CharacterAdded:Connect(onCharacterAdded)
    table.insert(self.connections, charConn)
end

function ESP:clearAll()
    for _, conn in ipairs(self.connections) do
        conn:Disconnect()
    end
    table.clear(self.connections)
    
    for _, esp in pairs(self.highlights) do
        esp:Destroy()
    end
    table.clear(self.highlights)
end

function ESP:updateColor(color)
    self.color = color
    for _, esp in pairs(self.highlights) do
        esp.FillColor = self.color
    end
end

function ESP:toggle(enabled)
    self.enabled = enabled
    if enabled then
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= LocalPlayer then
                self:monitorPlayer(targetPlayer)
            end
        end
        
        local addConn = Players.PlayerAdded:Connect(function(targetPlayer)
            if targetPlayer ~= LocalPlayer then
                self:monitorPlayer(targetPlayer)
            end
        end)
        table.insert(self.connections, addConn)
        
        local removeConn = Players.PlayerRemoving:Connect(function(targetPlayer)
            self:removeESP(targetPlayer)
        end)
        table.insert(self.connections, removeConn)
    else
        self:clearAll()
    end
end

-- Interface ESP
HighwayRacingtab:CreateParagraph({
    Title = "Ativação ESP",
    Content = "Ative para visualizar jogadores ou objetos através de paredes."
})

HighwayRacingtab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "AtivarESP",
    Callback = function(Value)
        ESP:toggle(Value)
    end,
})

HighwayRacingtab:CreateColorPicker({
    Name = "Mudar Cor ESP",
    Color = ESP.color,
    Flag = "CorESP",
    Callback = function(Value)
        ESP:updateColor(Value)
    end,
})

local Speed = {
    enabled = false,
    speed = 200,
    connection = nil,
    currentVehicle = nil,
    currentSeat = nil
}

function Speed:getVehicleInfo()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not character then return nil, nil end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return nil, nil end
    
    local seat = humanoid.SeatPart
    if seat and seat:IsA("VehicleSeat") then
        local vehicle = seat.Parent
        self.currentSeat = seat
        self.currentVehicle = vehicle
        return vehicle, seat
    end
    
    self.currentSeat = nil
    self.currentVehicle = nil
    return nil, nil
end

function Speed:applySpeed()
    if not self.currentSeat or not self.currentSeat:IsDescendantOf(workspace) then
        return false
    end
    
    local lookDirection = self.currentSeat.CFrame.LookVector
    lookDirection = Vector3.new(lookDirection.X, 0, lookDirection.Z).Unit
    
    local newVelocity = lookDirection * self.speed
    newVelocity = Vector3.new(newVelocity.X, self.currentSeat.Velocity.Y, newVelocity.Z)
    
    self.currentSeat.Velocity = newVelocity
    return true
end

function Speed:start()
    local vehicle, seat = self:getVehicleInfo()
    if not vehicle or not seat then
        warn("Você precisa estar sentado em um veículo para usar a velocidade automática.")
        return false
    end
    
    print("Sistema de velocidade automática ativado!")
    
    if self.connection then self.connection:Disconnect() end
    
    self.connection = RunService.Heartbeat:Connect(function()
        local success = self:applySpeed()
        if not success then
            self:stop()
            self.enabled = false
        end
    end)
    
    return true
end

function Speed:stop()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
        print("Sistema de velocidade automática desativado!")
    end
end

function Speed:toggle(value)
    self.enabled = value
    
    if self.enabled then
        local success = self:start()
        if not success then
            self.enabled = false
        end
    else
        self:stop()
    end
end

HighwayRacingtab:CreateParagraph({
    Title = "Ativação de Velocidade do Carro",
    Content = "Ative para aumentar a velocidade do carro durante a corrida."
})

HighwayRacingtab:CreateToggle({
    Name = "Velocidade Automática",
    CurrentValue = false,
    Flag = "AutoSpeedToggle",
    Callback = function(Value)
        Speed:toggle(Value)
    end,
})

HighwayRacingtab:CreateSlider({
    Name = "Velocidade do Carro",
    Range = {50, 1000},
    Increment = 25,
    Suffix = " km/h",
    CurrentValue = 200,
    Flag = "AutoSpeedValue",
    Callback = function(Value)
        Speed.speed = Value
        print("Velocidade ajustada para:", Speed.speed)
    end,
})

HighwayRacingtab:CreateButton({
    Name = "Parar Emergência",
    Callback = function()
        Speed.enabled = false
        Speed:stop()
        if Speed.currentSeat then
            Speed.currentSeat.Velocity = Vector3.new(0, 0, 0)
        end
        print("Parada de emergência ativada!")
    end,
})

local Fly = {
    enabled = false,
    speed = 200,
    connection = nil,
    inputConnection1 = nil,
    inputConnection2 = nil,
    currentSeat = nil,
    moveVector = Vector3.new(0, 0, 0),
    keysPressed = {
        W = false, A = false, S = false, D = false,
        Space = false, LeftControl = false
    }
}

function Fly:getVehicleSeat()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return nil end
    
    local seat = humanoid.SeatPart
    if seat and seat:IsA("VehicleSeat") then
        self.currentSeat = seat
        return seat
    end
    
    self.currentSeat = nil
    return nil
end

function Fly:updateMoveVector()
    local direction = Vector3.new(0, 0, 0)
    
    if self.keysPressed.W then direction = direction + Vector3.new(0, 0, 1) end
    if self.keysPressed.S then direction = direction + Vector3.new(0, 0, -1) end
    if self.keysPressed.A then direction = direction + Vector3.new(-1, 0, 0) end
    if self.keysPressed.D then direction = direction + Vector3.new(1, 0, 0) end
    if self.keysPressed.Space then direction = direction + Vector3.new(0, 1, 0) end
    if self.keysPressed.LeftControl then direction = direction + Vector3.new(0, -1, 0) end
    
    self.moveVector = direction
end

function Fly:onKeyPressed(input, gameProcessed)
    if gameProcessed or not self.enabled then return end
    
    local keyCode = input.KeyCode
    if keyCode == Enum.KeyCode.W then self.keysPressed.W = true
    elseif keyCode == Enum.KeyCode.A then self.keysPressed.A = true
    elseif keyCode == Enum.KeyCode.S then self.keysPressed.S = true
    elseif keyCode == Enum.KeyCode.D then self.keysPressed.D = true
    elseif keyCode == Enum.KeyCode.Space then self.keysPressed.Space = true
    elseif keyCode == Enum.KeyCode.LeftControl then self.keysPressed.LeftControl = true
    end
    
    self:updateMoveVector()
end

function Fly:onKeyReleased(input, gameProcessed)
    if gameProcessed or not self.enabled then return end
    
    local keyCode = input.KeyCode
    if keyCode == Enum.KeyCode.W then self.keysPressed.W = false
    elseif keyCode == Enum.KeyCode.A then self.keysPressed.A = false
    elseif keyCode == Enum.KeyCode.S then self.keysPressed.S = false
    elseif keyCode == Enum.KeyCode.D then self.keysPressed.D = false
    elseif keyCode == Enum.KeyCode.Space then self.keysPressed.Space = false
    elseif keyCode == Enum.KeyCode.LeftControl then self.keysPressed.LeftControl = false
    end
    
    self:updateMoveVector()
end

function Fly:start()
    local seat = self:getVehicleSeat()
    if not seat then
        warn("Entre em um veículo antes de ativar o voo!")
        return false
    end
    
    print("Voo ativado! Use WASD + Espaco/Ctrl para controlar")
    
    if self.connection then self.connection:Disconnect() end
    if self.inputConnection1 then self.inputConnection1:Disconnect() end
    if self.inputConnection2 then self.inputConnection2:Disconnect() end
    
    self.inputConnection1 = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        self:onKeyPressed(input, gameProcessed)
    end)
    
    self.inputConnection2 = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        self:onKeyReleased(input, gameProcessed)
    end)
    
    self.connection = RunService.Heartbeat:Connect(function()
        if self.currentSeat and self.currentSeat.Parent and self.currentSeat:IsDescendantOf(workspace) then
            local carCFrame = self.currentSeat.CFrame
            
            if self.moveVector.Magnitude > 0 then
                local moveDirection = Vector3.new(0, 0, 0)
                
                if self.moveVector.X ~= 0 then
                    moveDirection = moveDirection + (carCFrame.RightVector * self.moveVector.X)
                end
                if self.moveVector.Y ~= 0 then
                    moveDirection = moveDirection + (Vector3.new(0, 1, 0) * self.moveVector.Y)
                end
                if self.moveVector.Z ~= 0 then
                    moveDirection = moveDirection + (carCFrame.LookVector * self.moveVector.Z)
                end
                
                self.currentSeat.Velocity = moveDirection.Unit * self.speed
                self.currentSeat.AssemblyLinearVelocity = moveDirection.Unit * self.speed
            else
                self.currentSeat.Velocity = Vector3.new(0, 0, 0)
                self.currentSeat.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
            
            self.currentSeat.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        else
            self:stop()
            self.enabled = false
        end
    end)
    
    return true
end

function Fly:stop()
    print("🛑 Voo desativado!")
    
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    
    if self.inputConnection1 then
        self.inputConnection1:Disconnect()
        self.inputConnection1 = nil
    end
    
    if self.inputConnection2 then
        self.inputConnection2:Disconnect()
        self.inputConnection2 = nil
    end
    
    if self.currentSeat and self.currentSeat:IsDescendantOf(workspace) then
        self.currentSeat.Velocity = Vector3.new(0, 0, 0)
        if self.currentSeat.AssemblyLinearVelocity then
            self.currentSeat.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        if self.currentSeat.AssemblyAngularVelocity then
            self.currentSeat.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
    
    for key in pairs(self.keysPressed) do
        self.keysPressed[key] = false
    end
    self.moveVector = Vector3.new(0, 0, 0)
end

function Fly:toggle(value)
    self.enabled = value
    
    if self.enabled then
        local success = self:start()
        if not success then
            self.enabled = false
        end
    else
        self:stop()
    end
end

HighwayRacingtab:CreateParagraph({
    Title = "Ativação de Voo", 
    Content = "Use WASD + Espaço/Ctrl para controlar o voo do veículo."
})

HighwayRacingtab:CreateToggle({
    Name = "Ativar Voo",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        Fly:toggle(Value)
    end,
})

HighwayRacingtab:CreateSlider({
    Name = "Velocidade Voo",
    Range = {50, 500},
    Increment = 10,
    Suffix = "",
    CurrentValue = 200,
    Flag = "FlySpeed",
    Callback = function(Value)
        Fly.speed = Value
    end,
})

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T then
        local circle = AutoTeleport:findNextPinkCircle()
        if circle then
            AutoTeleport:teleportToCircle(circle)
            print("⚡ Teleporte de emergência executado!")
        end
    elseif input.KeyCode == Enum.KeyCode.X then
        AutoTeleport:toggle(false)
        warn("🚨 Sistema Auto Teleporte PARADO via tecla de emergência!")
    end
end)

-- ==================== MONITORAMENTO DE VEÍCULOS ====================
local function setupVehicleMonitoring()
    LocalPlayer.CharacterAdded:Connect(function()
        Speed.enabled = false
        Speed:stop()
        Fly.enabled = false
        Fly:stop()
    end)
    
    RunService.Heartbeat:Connect(function()
        if Speed.enabled then
            local vehicle, seat = Speed:getVehicleInfo()
            if not vehicle or not seat then
                Speed.enabled = false
                Speed:stop()
            end
        end
        
        if Fly.enabled then
            local seat = Fly:getVehicleSeat()
            if not seat then
                Fly.enabled = false
                Fly:stop()
            end
        end
    end)
end

local humanoidRootPart
local flyAtivo = false
local flySpeed = 100
local bodyVelocity
local bodyGyro
local moveDir = Vector3.new(0,0,0)

player.CharacterAdded:Connect(function(char)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)
if player.Character then
    humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not flyAtivo then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir + Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir + Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir + Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir + Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = moveDir + Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDir = moveDir + Vector3.new(0,-1,0) end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not flyAtivo then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir - Vector3.new(0,0,1) end
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir - Vector3.new(0,0,-1) end
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir - Vector3.new(-1,0,0) end
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir - Vector3.new(1,0,0) end
        if input.KeyCode == Enum.KeyCode.Space then moveDir = moveDir - Vector3.new(0,1,0) end
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDir = moveDir - Vector3.new(0,-1,0) end
    end
end)

local function ativarFly(Value)
    flyAtivo = Value
    local char = player.Character
    if not char or not humanoidRootPart then return end

    if flyAtivo then
        print("Fly ativado - Voando com tudo (carro/carrinho incluso) 🚀")

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = humanoidRootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
    else
        print("Fly desativado")

        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        moveDir = Vector3.new(0,0,0)
    end
end

RunService.RenderStepped:Connect(function()
    if flyAtivo and humanoidRootPart and bodyVelocity and bodyGyro then
        local cam = workspace.CurrentCamera
        local direction = (cam.CFrame.LookVector * moveDir.Z + cam.CFrame.RightVector * moveDir.X + Vector3.new(0, moveDir.Y, 0))

        if direction.Magnitude > 0 then
            direction = direction.Unit
        else
            direction = Vector3.new(0,0,0)
        end

        bodyVelocity.Velocity = direction * flySpeed
        bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position, humanoidRootPart.Position + cam.CFrame.LookVector)
    end
end)

HighwayRacingtab:CreateToggle({
    Name = "Ativar Fly",
    CurrentValue = false,
    Flag = "ToggleFly",
    Callback = ativarFly
})

HighwayRacingtab:CreateSlider({
    Name = "Velocidade do Fly",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " u/s",
    CurrentValue = 100,
    Flag = "SliderFlySpeed",
    Callback = function(Value)
        flySpeed = Value
        print("Velocidade do fly ajustada para: " .. Value)
    end,
})

setupVehicleMonitoring()
