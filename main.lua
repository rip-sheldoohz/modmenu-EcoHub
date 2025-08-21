local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Serviços necessários
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Variáveis do jogador
local player = Players.LocalPlayer
local humanoid
local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

-- Função para pegar humanoid atual do player
local function getHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("Humanoid")
end

humanoid = getHumanoid()

-- Criação da Janela
local Window = Rayfield:CreateWindow({
   Name = "Eco Hub By rip_sheldoohz",
   Icon = 0,
   LoadingTitle = "Eco Hub",
   LoadingSubtitle = "by rip_sheldoohz",
   ShowText = "Eco Hub",
   Theme = "Default",

   ToggleUIKeybind = Enum.KeyCode.K,
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

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

-- ============================================================================
-- ABA BROOKHAVEN RP
-- ============================================================================

local BrookhavenRPTab = Window:CreateTab("Brookhaven 🏡 RP")

BrookhavenRPTab:CreateParagraph({
    Title = "Script Brookhaven 🏡 RP",
    Content = "Use os botões abaixo para ativar as funções do Brookhaven"
})

-- ============================================================================
-- SISTEMA FLY
-- ============================================================================

local humanoidRootPart
local flyAtivo = false
local flySpeed = 100 -- mais forte por padrão
local bodyVelocity
local bodyGyro
local moveDir = Vector3.new(0,0,0)

-- Atualizar HumanoidRootPart quando personagem spawna
player.CharacterAdded:Connect(function(char)
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)
if player.Character then
    humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
end

-- Detecta entrada de teclas
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not flyAtivo then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.W then moveDir = moveDir + Vector3.new(0,0,1) end -- frente
        if input.KeyCode == Enum.KeyCode.S then moveDir = moveDir + Vector3.new(0,0,-1) end -- trás
        if input.KeyCode == Enum.KeyCode.A then moveDir = moveDir + Vector3.new(-1,0,0) end -- esquerda
        if input.KeyCode == Enum.KeyCode.D then moveDir = moveDir + Vector3.new(1,0,0) end -- direita
        if input.KeyCode == Enum.KeyCode.Space then moveDir = moveDir + Vector3.new(0,1,0) end -- cima
        if input.KeyCode == Enum.KeyCode.LeftControl then moveDir = moveDir + Vector3.new(0,-1,0) end -- baixo
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

-- Função para ativar/desativar fly
local function ativarFly(Value)
    flyAtivo = Value
    local char = player.Character
    if not char or not humanoidRootPart then return end

    if flyAtivo then
        print("Fly ativado - Voando com tudo (carro/carrinho incluso) 🚀")

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9) -- muito mais forte
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

-- Atualiza movimento do Fly
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

-- Toggle Fly no menu
BrookhavenRPTab:CreateToggle({
    Name = "Ativar Fly",
    CurrentValue = false,
    Flag = "ToggleFly",
    Callback = ativarFly
})

-- Slider de velocidade
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

-- ============================================================================
-- SISTEMA NOCLIP
-- ============================================================================

local noclipAtivo = false
local noclipConnection = nil

-- Função para aplicar noclip em todas as partes do personagem
local function aplicarNoclip()
    local character = player.Character
    if not character then return end
    
    -- Aplica noclip em todas as BaseParts do personagem
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Também aplica em acessórios e outras partes que podem ser adicionadas
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end
end

-- Função para remover noclip de todas as partes do personagem
local function removerNoclip()
    local character = player.Character
    if not character then return end
    
    -- Remove noclip de todas as BaseParts do personagem
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            -- HumanoidRootPart sempre deve ter CanCollide = false para evitar bugs
            if part.Name == "HumanoidRootPart" then
                part.CanCollide = false
            else
                part.CanCollide = true
            end
        end
    end
    
    -- Também remove de acessórios e outras partes
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

-- Toggle Noclip
BrookhavenRPTab:CreateToggle({
    Name = "Ativar Noclip",
    CurrentValue = false,
    Flag = "ToggleNoclip",
    Callback = function(Value)
        noclipAtivo = Value
        
        if Value then
            print("Noclip ativado - Você pode atravessar paredes!")
            
            -- Criar conexão para manter noclip ativo
            if noclipConnection then
                noclipConnection:Disconnect()
            end
            
            noclipConnection = RunService.Stepped:Connect(function()
                aplicarNoclip()
            end)
            
        else
            print("Noclip desativado - Colisão normal restaurada")
            
            -- Desconectar e remover noclip
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            
            removerNoclip()
        end
        
        -- Aplicar imediatamente
        if noclipAtivo then
            aplicarNoclip()
        else
            removerNoclip()
        end
    end,
})

-- Função para aplicar noclip em novos acessórios/partes adicionadas
local function onChildAdded(child)
    if noclipAtivo and child:IsA("BasePart") then
        child.CanCollide = false
    elseif noclipAtivo and child:IsA("Accessory") then
        -- Aguardar Handle carregar se for um acessório
        local handle = child:WaitForChild("Handle", 5)
        if handle then
            handle.CanCollide = false
        end
    end
end

-- Garantir que noclip seja aplicado quando personagem respawna
player.CharacterAdded:Connect(function(character)
    -- Aguardar personagem carregar completamente
    character:WaitForChild("HumanoidRootPart")
    wait(1) -- Pequena pausa para garantir que tudo carregou
    
    if noclipAtivo then
        print("Reaplicando noclip após respawn")
        aplicarNoclip()
    end
    
    -- Conectar eventos para novas partes adicionadas
    character.ChildAdded:Connect(onChildAdded)
    character.DescendantAdded:Connect(function(descendant)
        if noclipAtivo and descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end)
end)

-- Se já há um personagem, conectar os eventos
if player.Character then
    player.Character.ChildAdded:Connect(onChildAdded)
    player.Character.DescendantAdded:Connect(function(descendant)
        if noclipAtivo and descendant:IsA("BasePart") then
            descendant.CanCollide = false
        end
    end)
end

-- ============================================================================
-- SISTEMA DE SUPER PULO
-- ============================================================================

local superPuloAtivo = false
local jumpPowerOriginal = 50 -- padrão Roblox
local jumpPowerAtual = 150 -- valor inicial do super pulo

-- Função para ativar/desativar Super Pulo
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

-- Atualiza humanoid ao respawn para manter Super Pulo
player.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    if superPuloAtivo and humanoid then
        humanoid.JumpPower = jumpPowerAtual
    end
end)

-- Toggle no Rayfield
BrookhavenRPTab:CreateToggle({
    Name = "Ativar Super Pulo",
    CurrentValue = false,
    Flag = "ToggleSuperPulo",
    Callback = atualizarSuperPulo
})

-- Slider para ajustar a altura do pulo
BrookhavenRPTab:CreateSlider({
   Name = "Altura do Pulo",
   Range = {100, 1000}, -- mínimo 100, máximo 1000
   Increment = 10,
   Suffix = "u/s",
   CurrentValue = 150, -- valor inicial
   Flag = "SliderJumpPower",
   Callback = function(Value)
       jumpPowerAtual = Value
       local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
       if superPuloAtivo and humanoid then
           humanoid.JumpPower = jumpPowerAtual
       end
   end,
})

-- ============================================================================
-- SISTEMA DE VELOCIDADE
-- ============================================================================

local velocidadeAtiva = false
local velocidadeEscolhida = 16
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Função para obter humanoid de forma segura
local function getHumanoidSafe()
    local character = player.Character
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- Função para aplicar velocidade quando personagem respawna
local function aplicarVelocidadeNoRespawn()
    wait(0.5) -- Aguarda um pouco para garantir que o personagem carregou
    local currentHumanoid = getHumanoidSafe()
    if currentHumanoid and velocidadeAtiva then
        currentHumanoid.WalkSpeed = velocidadeEscolhida
        print("Velocidade aplicada após respawn: " .. velocidadeEscolhida)
    end
end

-- Conectar evento de respawn do personagem
player.CharacterAdded:Connect(aplicarVelocidadeNoRespawn)

-- Toggle Velocidade
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

-- Slider Velocidade
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

-- ============================================================================
-- SISTEMA DE ESP
-- ============================================================================

BrookhavenRPTab:CreateParagraph({
    Title = "ESP Otimizado - Brookhaven 🏡 RP",
    Content = "ESP otimizado com linhas conectoras e sem lag.\nVisualize jogadores e cofres de forma suave e eficiente."
})

-- Configurações ESP
local espAtivoPlayers = false
local espAtivoCofres = false
local corPlayer = Color3.fromRGB(0, 255, 0)
local corCofre = Color3.fromRGB(255, 255, 0)
local camera = workspace.CurrentCamera

-- Tabelas de ESP
local playerHighlights = {}
local cofreHighlights = {}
local playerConnections = {}
local updateTimer = 0
local cofreUpdateTimer = 0

-- Função ESP Arsenal para JOGADORES (otimizada)
local function createPlayerArsenalESP(targetPlayer)
    if not targetPlayer.Character or playerHighlights[targetPlayer] then return end
    
    local character = targetPlayer.Character
    local espObjects = {}
    
    -- Highlight Arsenal para jogador
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
    
    -- Billboard simplificado
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
        
        -- Atualização de distância otimizada
        spawn(function()
            while billboard.Parent and player.Character and targetPlayer.Character do
                local hrp1 = player.Character:FindFirstChild("HumanoidRootPart")
                local hrp2 = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp1 and hrp2 then
                    local dist = math.floor((hrp1.Position - hrp2.Position).Magnitude)
                    distLabel.Text = dist .. "m"
                    distLabel.TextColor3 = corPlayer
                end
                wait(0.5) -- Atualiza a cada 0.5 segundos
            end
        end)
    end
    
    -- Tracer otimizado
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
                wait(0.1) -- Reduz frequência do tracer
            end
            if tracer then tracer:Remove() end
        end)
    end)
    
    playerHighlights[targetPlayer] = espObjects
end

-- Função ESP Arsenal para COFRES (super otimizada)
local function createCofreArsenalESP(cofre)
    if cofreHighlights[cofre] then return end
    
    local espObjects = {}
    
    -- Highlight para cofre
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
    
    -- Billboard simplificado
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
    
    -- Tracer para cofre (mais otimizado)
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
                wait(0.15) -- Menos frequente
            end
            if tracer then tracer:Remove() end
        end)
    end)
    
    -- Atualizar distância (menos frequente)
    spawn(function()
        while billboard.Parent and player.Character do
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and cofre.Parent then
                local dist = math.floor((hrp.Position - cofre.Position).Magnitude)
                distLabel.Text = dist .. "m"
                distLabel.TextColor3 = corCofre
            end
            wait(0.7) -- Atualiza menos frequentemente
        end
    end)
    
    cofreHighlights[cofre] = espObjects
end

-- Aplicar ESP jogadores (otimizado)
local function applyPlayerESP()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            createPlayerArsenalESP(targetPlayer)
        end
    end
end

-- Aplicar ESP cofres (super otimizado)
local function applyCofreESP()
    local found = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if found >= 20 then break end -- Limite para evitar lag
        if obj:IsA("BasePart") and obj.Name and 
           (obj.Name:lower():find("cofre") or obj.Name:lower():find("safe") or obj.Name:lower():find("chest")) then
            createCofreArsenalESP(obj)
            found = found + 1
        end
    end
end

-- Remover ESP jogadores
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

-- Remover ESP cofres
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

-- Loop principal super otimizado
spawn(function()
    while true do
        local currentTime = tick()
        
        -- Atualizar jogadores a cada 2 segundos
        if espAtivoPlayers and (currentTime - updateTimer) > 2 then
            applyPlayerESP()
            updateTimer = currentTime
        end
        
        -- Atualizar cofres a cada 5 segundos
        if espAtivoCofres and (currentTime - cofreUpdateTimer) > 5 then
            applyCofreESP()
            cofreUpdateTimer = currentTime
        end
        
        wait(1) -- Loop principal roda a cada 1 segundo
    end
end)

-- Interface Rayfield limpa
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

-- Notificação
Rayfield:Notify({
    Title = "ESP Otimizado Carregado",
    Content = "Sistema ESP sem lag ativado!",
    Duration = 3
})

-- ============================================================================
-- SISTEMA DE ANTI-BAN
-- ============================================================================
BrookhavenRPTab:CreateParagraph({
    Title = "Anti-Ban - Brookhaven 🏡 RP",
    Content = "Ative o sistema Anti-Ban para proteger seu personagem de kicks, barreiras suspeitas e quedas.\nUse o botão abaixo para ligar ou desligar a proteção e fique seguro enquanto joga."
})


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local antiBanAtivo = false
local destroyedParts = {}
local lastSafePos = nil
local debounceRestore = false
local characterProtected = false
local antiKickEnabled = false
local characterConnection = nil

-- Configurações de palavras-chave suspeitas
local banTriggerWords = { "ban", "kick", "barrier", "block", "anti", "exploit" }

-- Proteção kick via metatable hook
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

-- Remove barreiras suspeitas
local function removeBarrierParts()
    pcall(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj and obj.Parent and obj:IsA("BasePart") and not destroyedParts[obj] then
                local lname = obj.Name:lower()
                for _, word in ipairs(banTriggerWords) do
                    if lname:find(word) then
                        destroyedParts[obj] = true
                        pcall(function()
                            obj:Destroy()
                        end)
                        warn("[Anti-Ban]: Removido objeto bloqueador: " .. obj.Name)
                        break
                    end
                end
            end
        end
    end)
end

-- Protege o personagem contra remoção de partes
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

-- Restaura personagem se morrer ou cair
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

-- Monitora posição segura
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

-- Atualiza posição segura continuamente
local safePositionLoop = nil
local barrierRemovalLoop = nil

-- Função para iniciar loops
local function startLoops()
    -- Loop de posição segura
    if safePositionLoop then
        task.cancel(safePositionLoop)
    end
    
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

    -- Loop para remover barreiras
    if barrierRemovalLoop then
        task.cancel(barrierRemovalLoop)
    end
    
    barrierRemovalLoop = task.spawn(function()
        while antiBanAtivo do
            task.wait(2)
            if antiBanAtivo then
                removeBarrierParts()
            end
        end
    end)
end

-- Função para parar loops
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

-- Toggle do Anti-Ban
BrookhavenRPTab:CreateToggle({
    Name = "Ativar Anti-Ban",
    CurrentValue = false,
    Flag = "ToggleAntiBan",
    Callback = function(Value)
        pcall(function()
            antiBanAtivo = Value

            if Value then
                -- Ativa proteções
                hookKick()
                
                -- Desconecta conexão anterior se existir
                if characterConnection then
                    characterConnection:Disconnect()
                end
                
                -- Se o personagem já existir, protege
                if LocalPlayer.Character then
                    onCharacterAdded(LocalPlayer.Character)
                end

                -- Conecta evento de personagem adicionado
                characterConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                    onCharacterAdded(char)
                end)
                
                -- Inicia loops de monitoramento
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
                -- Desativa proteções
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

-- ============================================================================
-- SISTEMA DE OTIMIZAÇÃO LEVE (mantém nomes/GUI)
-- ============================================================================
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local function aplicarOtimizacaoLeve()
    -- Configurações gráficas
    local settings = UserSettings():GetService("UserGameSettings")
    settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    settings.MasterVolume = 0.2

    -- Iluminação simples
    Lighting.Technology = Enum.Technology.Compatibility
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    -- Remove apenas efeitos pesados do Lighting
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("SunRaysEffect") then
            effect:Destroy()
        end
    end

    -- Otimiza objetos no mapa
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- Material leve, mas mantém aparência básica
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Trail") then
            obj.Enabled = false -- só desativa em vez de destruir
        end
        -- IMPORTANTE: NÃO remove Decal/Texture porque isso apaga nomes e detalhes
        -- NÃO desativa SurfaceGui / BillboardGui porque isso apaga HUD e nomes
    end

    -- Otimiza áudio
    SoundService.AmbientReverb = Enum.ReverbType.NoReverb
    SoundService.DopplerScale = 0
    SoundService.RolloffScale = 0.5
end

-- UI direto no BrookhavenRPTab
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
