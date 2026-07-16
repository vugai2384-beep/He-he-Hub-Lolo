local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui chính
local gui = Instance.new("ScreenGui")
gui.Name = "NguoiNgoaiHanhTinh"
gui.ResetOnSpawn = false
gui.Parent = playerGui

---------------------------------------------------------------------------
-- 1. NÚT TRÒN BẬT/TẮT MENU (Kéo thả được)
---------------------------------------------------------------------------
local Circle = Instance.new("ImageButton")
Circle.Name = "ToggleButton"
Circle.Size = UDim2.new(0, 50, 0, 50)
Circle.Position = UDim2.new(0.1, 0, 0.5, -25)
Circle.BackgroundTransparency = 1
Circle.Active = true
Circle.ZIndex = 10
Circle.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=89114452344960&width=420&height=420&format=png"
Circle.Parent = gui

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = Circle

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(255, 215, 0)
CircleStroke.Thickness = 1.5
CircleStroke.Parent = Circle

local function makeDraggable(frame)
    local dragging, dragStart, startPos, dragInput
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            dragInput = input
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input == dragInput then dragging = false end
    end)
end

makeDraggable(Circle)

---------------------------------------------------------------------------
-- 2. MENU CHÍNH HÌNH VUÔNG
---------------------------------------------------------------------------
local MainMenu = Instance.new("ImageLabel")
MainMenu.Name = "MainMenu"
MainMenu.Size = UDim2.new(0, 320, 0, 320)
MainMenu.Position = UDim2.new(0.5, -160, 0.5, -160)
MainMenu.BackgroundTransparency = 1
MainMenu.Active = true
MainMenu.Visible = false
MainMenu.ScaleType = Enum.ScaleType.Crop
MainMenu.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=130678370021345&width=420&height=420&format=png"
MainMenu.Parent = gui

makeDraggable(MainMenu)

local MenuUIStroke = Instance.new("UIStroke")
MenuUIStroke.Color = Color3.fromRGB(255, 215, 0)
MenuUIStroke.Thickness = 2.5
MenuUIStroke.Parent = MainMenu

local MenuCorner = Instance.new("UICorner")
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MainMenu

---------------------------------------------------------------------------
-- 3. HỘP KÍNH BÊN TRÁI
---------------------------------------------------------------------------
local GlassBox = Instance.new("Frame")
GlassBox.Name = "GlassBox"
GlassBox.Size = UDim2.new(0, 115, 0, 290)
GlassBox.Position = UDim2.new(0, 12, 0, 15)
GlassBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GlassBox.BackgroundTransparency = 0.93
GlassBox.Parent = MainMenu

local GlassCorner = Instance.new("UICorner")
GlassCorner.CornerRadius = UDim.new(0, 10)
GlassCorner.Parent = GlassBox

local GlassStroke = Instance.new("UIStroke")
GlassStroke.Color = Color3.fromRGB(255, 215, 0)
GlassStroke.Thickness = 1
GlassStroke.Transparency = 0.6
GlassStroke.Parent = GlassBox

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = GlassBox
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.Parent = GlassBox

local function addTextStroke(label)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2
    stroke.Parent = label
end

---------------------------------------------------------------------------
-- 4. TAB 1: INFO
---------------------------------------------------------------------------
local InfoFrame = Instance.new("Frame")
InfoFrame.Name = "InfoFrame"
InfoFrame.Size = UDim2.new(0, 170, 0, 240)
InfoFrame.Position = UDim2.new(0, 138, 0, 20)
InfoFrame.BackgroundTransparency = 1
InfoFrame.Visible = false
InfoFrame.Parent = MainMenu

local InfoTitle = Instance.new("TextLabel")
InfoTitle.Size = UDim2.new(1, 0, 0, 25)
InfoTitle.BackgroundTransparency = 1
InfoTitle.Font = Enum.Font.SourceSansBold
InfoTitle.Text = "✨ THÔNG TIN TÀI KHOẢN ✨"
InfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoTitle.TextSize = 13
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.Parent = InfoFrame
addTextStroke(InfoTitle)

local TiktokLabel = Instance.new("TextLabel")
TiktokLabel.Size = UDim2.new(1, 0, 0, 25)
TiktokLabel.Position = UDim2.new(0, 0, 0, 30)
TiktokLabel.BackgroundTransparency = 1
TiktokLabel.Font = Enum.Font.SourceSansBold
TiktokLabel.Text = "🎵 TikTok: Yuya_lwo"
TiktokLabel.TextSize = 14
TiktokLabel.TextXAlignment = Enum.TextXAlignment.Left
TiktokLabel.Parent = InfoFrame
addTextStroke(TiktokLabel)

local RobloxLabel = Instance.new("TextLabel")
RobloxLabel.Size = UDim2.new(1, 0, 0, 25)
RobloxLabel.Position = UDim2.new(0, 0, 0, 60)
RobloxLabel.BackgroundTransparency = 1
RobloxLabel.Font = Enum.Font.SourceSansBold
RobloxLabel.Text = "🎮 Roblox: vyyeuchi2"
RobloxLabel.TextSize = 14
RobloxLabel.TextXAlignment = Enum.TextXAlignment.Left
RobloxLabel.Parent = InfoFrame
addTextStroke(RobloxLabel)

local hue = 0
RunService.RenderStepped:Connect(function(deltaTime)
    hue = (hue + deltaTime * 0.1) % 1
    local rainbowColor = Color3.fromHSV(hue, 0.9, 1)
    TiktokLabel.TextColor3 = rainbowColor
    RobloxLabel.TextColor3 = rainbowColor
end)

---------------------------------------------------------------------------
-- 5. TAB 2: FE
---------------------------------------------------------------------------
local FeFrame = Instance.new("Frame")
FeFrame.Name = "FeFrame"
FeFrame.Size = UDim2.new(0, 170, 0, 240)
FeFrame.Position = UDim2.new(0, 138, 0, 20)
FeFrame.BackgroundTransparency = 1
FeFrame.Visible = false
FeFrame.Parent = MainMenu

local FeTitle = Instance.new("TextLabel")
FeTitle.Size = UDim2.new(1, 0, 0, 25)
FeTitle.BackgroundTransparency = 1
FeTitle.Font = Enum.Font.SourceSansBold
FeTitle.Text = "🔥 TÍNH NĂNG FE 🔥"
FeTitle.TextColor3 = Color3.fromRGB(255, 85, 85)
FeTitle.TextSize = 13
FeTitle.TextXAlignment = Enum.TextXAlignment.Left
FeTitle.Parent = FeFrame
addTextStroke(FeTitle)

local BtnIY = Instance.new("TextButton")
BtnIY.Name = "BtnIY"
BtnIY.Size = UDim2.new(0, 160, 0, 35)
BtnIY.Position = UDim2.new(0, 0, 0, 35)
BtnIY.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnIY.BackgroundTransparency = 0.3
BtnIY.Font = Enum.Font.SourceSansBold
BtnIY.Text = "⚡ Chạy Infinite Yield"
BtnIY.TextColor3 = Color3.fromRGB(255, 215, 0)
BtnIY.TextSize = 13
BtnIY.Parent = FeFrame

local BtnIYCorner = Instance.new("UICorner")
BtnIYCorner.CornerRadius = UDim.new(0, 6)
BtnIYCorner.Parent = BtnIY

local BtnIYStroke = Instance.new("UIStroke")
BtnIYStroke.Color = Color3.fromRGB(255, 215, 0)
BtnIYStroke.Thickness = 1
BtnIYStroke.Parent = BtnIY

BtnIY.MouseButton1Click:Connect(function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)
end)

local BtnJerkOthers = Instance.new("TextButton")
BtnJerkOthers.Name = "BtnJerkOthers"
BtnJerkOthers.Size = UDim2.new(0, 160, 0, 35)
BtnJerkOthers.Position = UDim2.new(0, 0, 0, 80)
BtnJerkOthers.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnJerkOthers.BackgroundTransparency = 0.3
BtnJerkOthers.Font = Enum.Font.SourceSansBold
BtnJerkOthers.Text = "🗿 Sóc lọ Mọi Người Ghi Jerk"
BtnJerkOthers.TextColor3 = Color3.fromRGB(255, 100, 200)
BtnJerkOthers.TextSize = 11
BtnJerkOthers.Parent = FeFrame

local BtnJerkOthersCorner = Instance.new("UICorner")
BtnJerkOthersCorner.CornerRadius = UDim.new(0, 6)
BtnJerkOthersCorner.Parent = BtnJerkOthers

local BtnJerkOthersStroke = Instance.new("UIStroke")
BtnJerkOthersStroke.Color = Color3.fromRGB(255, 100, 200)
BtnJerkOthersStroke.Thickness = 1
BtnJerkOthersStroke.Parent = BtnJerkOthers

local JerkingEveryone = false
local jerkConnection = nil
local jerkSpeed = 35    
local jerkAmount = 0.5  

BtnJerkOthers.MouseButton1Click:Connect(function()
    JerkingEveryone = not JerkingEveryone
    
    if JerkingEveryone then
        BtnJerkOthers.BackgroundColor3 = Color3.fromRGB(255, 100, 200)
        BtnJerkOthers.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        jerkConnection = RunService.Heartbeat:Connect(function()
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local char = otherPlayer.Character
                    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                    if torso then
                        local shoulder = torso:FindFirstChild("Right Shoulder") or torso:FindFirstChild("RightShoulder")
                        if shoulder and shoulder:IsA("Motor6D") then
                            local offset = math.sin(tick() * jerkSpeed) * jerkAmount
                            shoulder.Transform = CFrame.new(offset, 0, 0) * CFrame.Angles(0, 0, 0)
                        end
                    end
                end
            end
        end)
    else
        if jerkConnection then
            jerkConnection:Disconnect()
            jerkConnection = nil
        end
        BtnJerkOthers.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        BtnJerkOthers.TextColor3 = Color3.fromRGB(255, 100, 200)
        
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer.Character then
                local char = otherPlayer.Character
                local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                if torso then
                    local shoulder = torso:FindFirstChild("Right Shoulder") or torso:FindFirstChild("RightShoulder")
                    if shoulder and shoulder:IsA("Motor6D") then
                        shoulder.Transform = CFrame.new(0, 0, 0)
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------------------------
-- 6. TAB 3: TỔNG HỢP (SLIDER SPEED, SLIDER JUMP, FLOAT, NOCLIP, INF JUMP, ESP)
---------------------------------------------------------------------------
local TongHopFrame = Instance.new("Frame")
TongHopFrame.Name = "TongHopFrame"
TongHopFrame.Size = UDim2.new(0, 170, 0, 280)
TongHopFrame.Position = UDim2.new(0, 138, 0, 15)
TongHopFrame.BackgroundTransparency = 1
TongHopFrame.Visible = false
TongHopFrame.Parent = MainMenu

local TongHopTitle = Instance.new("TextLabel")
TongHopTitle.Size = UDim2.new(1, 0, 0, 18)
TongHopTitle.BackgroundTransparency = 1
TongHopTitle.Font = Enum.Font.SourceSansBold
TongHopTitle.Text = "📦 TAB TỔNG HỢP 📦"
TongHopTitle.TextColor3 = Color3.fromRGB(0, 255, 127)
TongHopTitle.TextSize = 13
TongHopTitle.TextXAlignment = Enum.TextXAlignment.Left
TongHopTitle.Parent = TongHopFrame
addTextStroke(TongHopTitle)

-- [1] THANH KÉO TỐC ĐỘ (SLIDER SPEED 1 - 1000)
local SpeedSliderFrame = Instance.new("Frame")
SpeedSliderFrame.Name = "SpeedSliderFrame"
SpeedSliderFrame.Size = UDim2.new(0, 160, 0, 32)
SpeedSliderFrame.Position = UDim2.new(0, 0, 0, 22)
SpeedSliderFrame.BackgroundTransparency = 1
SpeedSliderFrame.Parent = TongHopFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 12)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Font = Enum.Font.SourceSansBold
SpeedLabel.Text = "Tốc độ: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 10
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = SpeedSliderFrame
addTextStroke(SpeedLabel)

local SpeedBar = Instance.new("Frame")
SpeedBar.Size = UDim2.new(1, 0, 0, 4)
SpeedBar.Position = UDim2.new(0, 0, 0, 18)
SpeedBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedBar.BorderSizePixel = 0
SpeedBar.Parent = SpeedSliderFrame

local SpeedBarCorner = Instance.new("UICorner")
SpeedBarCorner.CornerRadius = UDim.new(1, 0)
SpeedBarCorner.Parent = SpeedBar

local SpeedFill = Instance.new("Frame")
SpeedFill.Size = UDim2.new(0.016, 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(0, 191, 255)
SpeedFill.BorderSizePixel = 0
SpeedFill.Parent = SpeedBar

local SpeedFillCorner = Instance.new("UICorner")
SpeedFillCorner.CornerRadius = UDim.new(1, 0)
SpeedFillCorner.Parent = SpeedFill

local SpeedBtn = Instance.new("ImageButton")
SpeedBtn.Size = UDim2.new(0, 10, 0, 10)
SpeedBtn.Position = UDim2.new(0.016, -5, 0.5, -5)
SpeedBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedBtn.Parent = SpeedBar

local SpeedBtnCorner = Instance.new("UICorner")
SpeedBtnCorner.CornerRadius = UDim.new(1, 0)
SpeedBtnCorner.Parent = SpeedBtn

local currentSpeed = 16
local isSpeedSliding = false

local function updateSpeedSlider(input)
    local barWidth = SpeedBar.AbsoluteSize.X
    local relativeX = math.clamp(input.Position.X - SpeedBar.AbsolutePosition.X, 0, barWidth)
    local percentage = relativeX / barWidth
    currentSpeed = math.floor(1 + (percentage * 999))
    SpeedLabel.Text = "Tốc độ: " .. tostring(currentSpeed)
    
    SpeedFill.Size = UDim2.new(percentage, 0, 1, 0)
    SpeedBtn.Position = UDim2.new(percentage, -5, 0.5, -5)
end

SpeedBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSpeedSliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSpeedSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSpeedSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSpeedSlider(input)
    end
end)

-- [2] THANH KÉO SỨC NHẢY (SLIDER JUMP POWER 1 - 1000)
local JumpSliderFrame = Instance.new("Frame")
JumpSliderFrame.Name = "JumpSliderFrame"
JumpSliderFrame.Size = UDim2.new(0, 160, 0, 32)
JumpSliderFrame.Position = UDim2.new(0, 0, 0, 58)
JumpSliderFrame.BackgroundTransparency = 1
JumpSliderFrame.Parent = TongHopFrame

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(1, 0, 0, 12)
JumpLabel.BackgroundTransparency = 1
JumpLabel.Font = Enum.Font.SourceSansBold
JumpLabel.Text = "Sức nhảy: 50"
JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpLabel.TextSize = 10
JumpLabel.TextXAlignment = Enum.TextXAlignment.Left
JumpLabel.Parent = JumpSliderFrame
addTextStroke(JumpLabel)

local JumpBar = Instance.new("Frame")
JumpBar.Size = UDim2.new(1, 0, 0, 4)
JumpBar.Position = UDim2.new(0, 0, 0, 18)
JumpBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
JumpBar.BorderSizePixel = 0
JumpBar.Parent = JumpSliderFrame

local JumpBarCorner = Instance.new("UICorner")
JumpBarCorner.CornerRadius = UDim.new(1, 0)
JumpBarCorner.Parent = JumpBar

local JumpFill = Instance.new("Frame")
JumpFill.Size = UDim2.new(0.05, 0, 1, 0)
JumpFill.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
JumpFill.BorderSizePixel = 0
JumpFill.Parent = JumpBar

local JumpFillCorner = Instance.new("UICorner")
JumpFillCorner.CornerRadius = UDim.new(1, 0)
JumpFillCorner.Parent = JumpFill

local JumpBtn = Instance.new("ImageButton")
JumpBtn.Size = UDim2.new(0, 10, 0, 10)
JumpBtn.Position = UDim2.new(0.05, -5, 0.5, -5)
JumpBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
JumpBtn.Parent = JumpBar

local JumpBtnCorner = Instance.new("UICorner")
JumpBtnCorner.CornerRadius = UDim.new(1, 0)
JumpBtnCorner.Parent = JumpBtn

local currentJump = 50
local isJumpSliding = false

local function updateJumpSlider(input)
    local barWidth = JumpBar.AbsoluteSize.X
    local relativeX = math.clamp(input.Position.X - JumpBar.AbsolutePosition.X, 0, barWidth)
    local percentage = relativeX / barWidth
    currentJump = math.floor(1 + (percentage * 999))
    JumpLabel.Text = "Sức nhảy: " .. tostring(currentJump)
    
    JumpFill.Size = UDim2.new(percentage, 0, 1, 0)
    JumpBtn.Position = UDim2.new(percentage, -5, 0.5, -5)
end

JumpBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isJumpSliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isJumpSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isJumpSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateJumpSlider(input)
    end
end)

-- Vòng lặp khóa Tốc độ & Sức nhảy liên tục
task.spawn(function()
    while true do
        pcall(function()
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                hum.WalkSpeed = currentSpeed
                hum.UseJumpPower = true
                hum.JumpPower = currentJump
            end
        end)
        task.wait(0.1)
    end
end)

-- Hàm tạo nút hành động trong Tab Tổng hợp
local function createHackButton(name, text, posY, color, onClick)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 160, 0, 26)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = color
    btn.TextSize = 10
    btn.Parent = TongHopFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        onClick(btn)
    end)
    return btn
end

-- 1. Nút Float (Đi Trên Không)
local FloatActive = false
local floatPart = nil
createHackButton("BtnFloat", "🎈 Đi Trên Không (Float)", 96, Color3.fromRGB(0, 255, 255), function(btn)
    FloatActive = not FloatActive
    if FloatActive then
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        
        task.spawn(function()
            while FloatActive do
                pcall(function()
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        if not floatPart or not floatPart.Parent then
                            floatPart = Instance.new("Part")
                            floatPart.Name = "FloatPlatform"
                            floatPart.Size = Vector3.new(6, 0.5, 6)
                            floatPart.Transparency = 1
                       
