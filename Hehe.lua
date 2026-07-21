local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- 🔔 THÔNG BÁO KIỂM TRA
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "DUC ANH HUB V1",
        Text = "Update đầu tiên!!!!!!",
        Duration = 5
    })
end)

-- Xóa GUI cũ nếu chạy đè
pcall(function()
    if CoreGui:FindFirstChild("NutTronAnhV2") then
        CoreGui.NutTronAnhV2:Destroy()
    end
    if player.PlayerGui:FindFirstChild("NutTronAnhV2") then
        player.PlayerGui.NutTronAnhV2:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NutTronAnhV2"
gui.ResetOnSpawn = false

local success = pcall(function()
    gui.Parent = CoreGui
end)
if not success then
    gui.Parent = player:WaitForChild("PlayerGui")
end

-- ==========================================
-- 🟢 1. NÚT TRÒN DI ĐỘNG (BỆ PHÕNG)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 50, 0, 50)
MainFrame.Position = UDim2.new(0.1, 0, 0.5, -25)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Parent = gui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(1, 0)

local ActionButton = Instance.new("ImageButton")
ActionButton.Name = "ActionButton"
ActionButton.Size = UDim2.new(0.85, 0, 0.85, 0)
ActionButton.Position = UDim2.new(0.075, 0, 0.075, 0)
ActionButton.BackgroundTransparency = 1
ActionButton.Image = "rbxassetid://130940118"
ActionButton.Active = true
ActionButton.Parent = MainFrame

Instance.new("UICorner", ActionButton).CornerRadius = UDim.new(1, 0)

local FrameStroke = Instance.new("UIStroke", MainFrame)
FrameStroke.Thickness = 3
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local connection
connection = RunService.RenderStepped:Connect(function()
    if not MainFrame or not MainFrame.Parent then
        if connection then connection:Disconnect() end
        return
    end
    local hue = (os.clock() % 4) / 4
    FrameStroke.Color = Color3.fromHSV(hue, 1, 1)
end)

-- ==========================================
-- 📂 2. GIAO DIỆN MENU & HỆ THỐNG TAB
-- ==========================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 340, 0, 320)
MenuFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
MenuFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MenuFrame.BackgroundTransparency = 0.1
MenuFrame.Visible = false
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Parent = gui

Instance.new("UICorner", MenuFrame).CornerRadius = UDim.new(0, 18)

local MenuStroke = Instance.new("UIStroke", MenuFrame)
MenuStroke.Thickness = 2
MenuStroke.Color = Color3.fromRGB(70, 130, 255)

-- Thanh bên trái (LeftBar)
local LeftBar = Instance.new("Frame")
LeftBar.Name = "LeftBar"
LeftBar.Size = UDim2.new(0.22, 0, 1, 0)
LeftBar.Position = UDim2.new(0, 0, 0, 0)
LeftBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LeftBar.BorderSizePixel = 0
LeftBar.Parent = MenuFrame

local LeftBarCorner = Instance.new("UICorner", LeftBar)
LeftBarCorner.CornerRadius = UDim.new(0, 18)

local UIListLayoutTab = Instance.new("UIListLayout")
UIListLayoutTab.Padding = UDim.new(0, 10)
UIListLayoutTab.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayoutTab.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayoutTab.Parent = LeftBar

-- Tiêu đề Menu
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.75, 0, 0, 50)
TitleLabel.Position = UDim2.new(0.24, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ DUC ANH HUB ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
TitleLabel.Parent = MenuFrame

-- Nút tắt Menu (Dấu X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -36, 0, 11)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 13
CloseButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
CloseButton.Parent = MenuFrame
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

-- Khung chứa Container Tab
local ContainerHolder = Instance.new("Folder")
ContainerHolder.Parent = MenuFrame

local function createTabContainer()
    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.new(0.75, -10, 1, -65)
    sf.Position = UDim2.new(0.24, 10, 0, 55)
    sf.BackgroundTransparency = 1
    sf.CanvasSize = UDim2.new(0, 0, 0, 320)
    sf.ScrollBarThickness = 3
    sf.Visible = false
    sf.Parent = ContainerHolder

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = sf
    return sf
end

local Tab1Container = createTabContainer() -- Tab 1: Info
local Tab2Container = createTabContainer() -- Tab 2: Slap Tower
Tab1Container.Visible = true

local function createTabButton(name, targetContainer)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    btn.Parent = LeftBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        Tab1Container.Visible = false
        Tab2Container.Visible = false
        targetContainer.Visible = true
    end)
end

createTabButton("Info", Tab1Container)
createTabButton("Slap Tower", Tab2Container)

-- ==========================================
-- 📄 NỘI DUNG TAB 1: INFO (RAINBOW TEXT)
-- ==========================================
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 220)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Script Việt Nam Này Lấy Cảm Hứng Từ Slap Tower và nên có vài chức năng vật vì đây là bản v1 Tôi sẽ update nhiều hơn\n\nTiktok:Yuya_Lwo"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextSize = 13
InfoLabel.TextWrapped = true
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
InfoLabel.Parent = Tab1Container

local infoConnection
infoConnection = RunService.RenderStepped:Connect(function()
    if not InfoLabel or not InfoLabel.Parent then
        if infoConnection then infoConnection:Disconnect() end
        return
    end
    local hue = (os.clock() % 4) / 4
    InfoLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- ==========================================
-- 🛠️ NỘI DUNG TAB 2: SLAP TOWER (CHỨC NĂNG)
-- ==========================================
local function createMenuButton(name, parentContainer, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    btn.Parent = parentContainer
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    local activeState = false
    btn.MouseButton1Click:Connect(function()
        activeState = not activeState
        local targetColor = activeState and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(35, 35, 42)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = targetColor}):Play()
        if callback then callback(activeState, btn) end
    end)
    return btn
end

-- 0. Anti Slap
createMenuButton("Anti Slap", Tab2Container, function(state)
    if state then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/amdzy088/Immune-slap-tower-/refs/heads/main/Immune%20slap%20tower%20work"))()
        end)
    end
end)

-- 1. Highlights
local espConnection
createMenuButton("Highlights (Sáng người chơi)", Tab2Container, function(state)
    if state then
        espConnection = RunService.RenderStepped:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    if not p.Character:FindFirstChild("DucAnhHighlight") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "DucAnhHighlight"
                        hl.Adornee = p.Character
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.FillTransparency = 0.5
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.OutlineTransparency = 0
                        hl.Parent = p.Character
                    end
                end
            end
        end)
    else
        if espConnection then espConnection:Disconnect() end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("DucAnhHighlight") then
                p.Character.DucAnhHighlight:Destroy()
            end
        end
    end
end)

-- 2. Float
local floatPart = nil
createMenuButton("Float (Đi trên không)", Tab2Container, function(state)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if state then
        if not floatPart then
            floatPart = Instance.new("Part")
            floatPart.Name = "FloatPlatform"
            floatPart.Size = Vector3.new(5, 1, 5)
            floatPart.Transparency = 1
            floatPart.Anchored = true
            floatPart.Parent = workspace
        end
        
        RunService.RenderStepped:Connect(function()
            if state and floatPart and hrp then
                floatPart.CFrame = hrp.CFrame - Vector3.new(0, 3.5, 0)
            end
        end)
    else
        if floatPart then
            floatPart:Destroy()
            floatPart = nil
        end
    end
end)

-- 3. Noclip
local noclipConnection
createMenuButton("Noclip (Đi xuyên tường)", Tab2Container, function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() end
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- 4. Speed x2
createMenuButton("Speed x2", Tab2Container, function(state)
    pcall(function()
        player.Character.Humanoid.WalkSpeed = state and 32 or 16
    end)
end)

-- ==========================================
-- 🛠️ 3. LOGIC KÉO THẢ & BẬT TẮT NÚT TRÒN
-- ==========================================
local dragging = false
local dragInput, dragStart, startPos
local isMoved = false

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        isMoved = false
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
            isMoved = true
        end
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

ActionButton.MouseButton1Click:Connect(function()
    if isMoved then return end
    
    TweenService:Create(MainFrame, TweenInfo.new(0.1), {Size = UDim2.new(0, 45, 0, 45)}):Play()
    task.wait(0.1)
    TweenService:Create(MainFrame, TweenInfo.new(0.1), {Size = UDim2.new(0, 50, 0, 50)}):Play()
    
    MenuFrame.Visible = not MenuFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
end)

print("🚀 Đã sửa thành Anti Slap chuẩn chỉ!")
