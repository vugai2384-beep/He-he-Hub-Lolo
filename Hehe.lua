local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===========================================================================
-- HỆ THỐNG NHẠC NỀN (KHÔNG CÓ SFX CLICK) 🎵
-- ===========================================================================
local MY_SOUND_ID = "rbxassetid://111063699178716" 

local bgMusic = nil
local isMusicPlaying = true

-- Hàm quản lý nhạc nền
local function playBackgroundMusic()
    if bgMusic then bgMusic:Destroy() end
    
    bgMusic = Instance.new("Sound")
    bgMusic.SoundId = MY_SOUND_ID
    bgMusic.Volume = 0.4 -- Âm lượng vừa phải mượt mà
    bgMusic.Looped = false -- Chạy 1 lần duy nhất theo yêu cầu
    bgMusic.Parent = workspace
    bgMusic:Play()
    
    -- Tự động đổi trạng thái nút nếu nhạc chạy hết bài
    bgMusic.Ended:Connect(function()
        isMusicPlaying = false
        local btn = gui and gui:FindFirstChild("MainMenu") and gui.MainMenu:FindFirstChild("InfoFrame") and gui.MainMenu.InfoFrame:FindFirstChild("BtnToggleMusic")
        if btn then
            btn.Text = "🎵 Bật Nhạc Nền"
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
    end)
end

local function stopBackgroundMusic()
    if bgMusic then
        bgMusic:Stop()
        bgMusic:Destroy()
        bgMusic = nil
    end
    isMusicPlaying = false
end

-- Tiền tải (Preload) âm thanh
pcall(function()
    ContentProvider:PreloadAsync({ MY_SOUND_ID })
end)

-- Tự động bật nhạc nền ngay khi execute
playBackgroundMusic()

-- ===========================================================================
-- KHỞI TẠO SCREEN GUI CHÍNH
-- ===========================================================================
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
MainMenu.Visible = false -- KHÔNG tự động mở GUI khi mới load script
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
-- 4. PHÂN HỆ 1: TAB INFO
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

-- NÚT BẬT/TẮT NHẠC NỀN
local BtnToggleMusic = Instance.new("TextButton")
BtnToggleMusic.Name = "BtnToggleMusic"
BtnToggleMusic.Size = UDim2.new(0, 160, 0, 35)
BtnToggleMusic.Position = UDim2.new(0, 0, 0, 100)
BtnToggleMusic.BackgroundColor3 = Color3.fromRGB(255, 165, 2)
BtnToggleMusic.BackgroundTransparency = 0.3
BtnToggleMusic.Font = Enum.Font.SourceSansBold
BtnToggleMusic.Text = "🎵 Tắt Nhạc Nền"
BtnToggleMusic.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggleMusic.TextSize = 12
BtnToggleMusic.Parent = InfoFrame

local BtnToggleMusicCorner = Instance.new("UICorner")
BtnToggleMusicCorner.CornerRadius = UDim.new(0, 6)
BtnToggleMusicCorner.Parent = BtnToggleMusic

local BtnToggleMusicStroke = Instance.new("UIStroke")
BtnToggleMusicStroke.Color = Color3.fromRGB(255, 215, 0)
BtnToggleMusicStroke.Thickness = 1
BtnToggleMusicStroke.Parent = BtnToggleMusic

BtnToggleMusic.MouseButton1Click:Connect(function()
    isMusicPlaying = not isMusicPlaying
    if isMusicPlaying then
        playBackgroundMusic()
        BtnToggleMusic.Text = "🎵 Tắt Nhạc Nền"
        BtnToggleMusic.BackgroundColor3 = Color3.fromRGB(255, 165, 2)
    else
        stopBackgroundMusic()
        BtnToggleMusic.Text = "🎵 Bật Nhạc Nền"
        BtnToggleMusic.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- THÊM DÒNG: CHƯA CẬP NHẬT NHẠC KHÁC
local MusicStatusLabel = Instance.new("TextLabel")
MusicStatusLabel.Size = UDim2.new(1, 0, 0, 20)
MusicStatusLabel.Position = UDim2.new(0, 0, 0, 145)
MusicStatusLabel.BackgroundTransparency = 1
MusicStatusLabel.Font = Enum.Font.SourceSansItalic
MusicStatusLabel.Text = "🎧 Danh sách nhạc khác: Chưa cập nhật"
MusicStatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
MusicStatusLabel.TextSize = 10
MusicStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
MusicStatusLabel.Parent = InfoFrame
addTextStroke(MusicStatusLabel)

local hue = 0
RunService.RenderStepped:Connect(function(deltaTime)
    hue = (hue + deltaTime * 0.1) % 1
    local rainbowColor = Color3.fromHSV(hue, 0.9, 1)
    TiktokLabel.TextColor3 = rainbowColor
    RobloxLabel.TextColor3 = rainbowColor
end)

---------------------------------------------------------------------------
-- 5. PHÂN HỆ 2: TAB FE
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
-- 6. PHÂN HỆ 3: TAB TỔNG HỢP (DANH SÁCH SCRIPT) 📦
---------------------------------------------------------------------------
local TongHopFrame = Instance.new("Frame")
TongHopFrame.Name = "TongHopFrame"
TongHopFrame.Size = UDim2.new(0, 170, 0, 280)
TongHopFrame.Position = UDim2.new(0, 138, 0, 20)
TongHopFrame.BackgroundTransparency = 1
TongHopFrame.Visible = false
TongHopFrame.Parent = MainMenu

local TongHopTitle = Instance.new("TextLabel")
TongHopTitle.Size = UDim2.new(1, 0, 0, 25)
TongHopTitle.BackgroundTransparency = 1
TongHopTitle.Font = Enum.Font.SourceSansBold
TongHopTitle.Text = "📦 TỔNG HỢP SCRIPT 📦"
TongHopTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
TongHopTitle.TextSize = 13
TongHopTitle.TextXAlignment = Enum.TextXAlignment.Left
TongHopTitle.Parent = TongHopFrame
addTextStroke(TongHopTitle)

-- Bảng cuộn chứa danh sách Script khác (Kéo dài hết mức do không có ô speed)
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 0, 230)
ScrollFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 240)
ScrollFrame.Parent = TongHopFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 8)
ScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ScrollLayout.Parent = ScrollFrame

local function createScriptButton(name, url, order, isLoadstring)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextSize = 11
    btn.LayoutOrder = order
    btn.Parent = ScrollFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 170, 255)
    stroke.Thickness = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if isLoadstring then
                loadstring(game:HttpGet(url))()
            else
                url()
            end
        end)
    end)
    return btn
end

-- 1. Script Bay (Fly) viết trực tiếp
local function runFly()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    local flying = true
    local speed = 50
    local bv = Instance.new("BodyVelocity")
    local bg = Instance.new("BodyGyro")
    
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.new(0, 0.1, 0)
    bv.Parent = hrp
    
    bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    
    task.spawn(function()
        while flying and character and hrp and humanoid.Health > 0 do
            task.wait()
            local direction = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.LookVector.Unit:Cross(Vector3.new(0,1,0)) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.LookVector.Unit:Cross(Vector3.new(0,1,0)) end
            
            bv.Velocity = direction * speed
            bg.CFrame = workspace.CurrentCamera.CFrame
        end
        bv:Destroy()
        bg:Destroy()
    end)
end

-- Thêm các nút script vào danh sách cuộn của Tab Tổng hợp
createScriptButton("🚀 Script Fly (Bay)", runFly, 1, false)
createScriptButton("🔍 Dex Explorer (Xem Core)", "https://raw.githubusercontent.com/infyyd/obfuscator/main/asfshgfhfhffgh", 2, true)
createScriptButton("🕵️ SimpleSpy (Theo dõi Remote)", "https://raw.githubusercontent.com/7YSe7en/SimpleSpyV3/main/SimpleSpyV3.lua", 3, true)
createScriptButton("🌀 Reanimate Animation", "https://raw.githubusercontent.com/MyWorldServer/Reanimate/master/Reanimate.lua", 4, true)

---------------------------------------------------------------------------
-- 7. KHỞI TẠO CÁC NÚT BẤM MENU TRÁI (BỎ NÚT CÀI ĐẶT)
---------------------------------------------------------------------------
local function createMenuText(text, order, isTitle)
    local label = Instance.new("TextButton")
    label.Size = UDim2.new(0.92, 0, 0, isTitle and 18 or 28) -- Tăng nhẹ kích thước nút lên 28 cho cân đối menu
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.Text = text
    label.TextColor3 = isTitle and Color3.fromRGB(255, 234, 167) or Color3.fromRGB(255, 255, 255)
    label.TextSize = isTitle and 12 or 11
    label.LayoutOrder = order
    
    if not isTitle then
        label.TextXAlignment = Enum.TextXAlignment.Left
        local btnPadding = Instance.new("UIPadding")
        btnPadding.PaddingLeft = UDim.new(0, 4)
        btnPadding.Parent = label
        
        label.MouseEnter:Connect(function()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 165, 2)}):Play()
        end)
        label.MouseLeave:Connect(function()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
    end
    
    label.Parent = GlassBox
    return label
end

createMenuText("👽 Người Ngoài", 1, true)
createMenuText("Hành Tinh", 2, true)
createMenuText("━━━━━━", 3, true)

local BtnInfo = createMenuText("ℹ️ Info", 4, false)
local BtnFE = createMenuText("🛠️ FE", 5, false)
local BtnTongHop = createMenuText("📦 Tổng hợp", 6, false)
local BtnDong = createMenuText("❌ Đóng", 7, false)

BtnDong.TextColor3 = Color3.fromRGB(255, 107, 107)
BtnDong.MouseLeave:Connect(function() BtnDong.TextColor3 = Color3.fromRGB(255, 107, 107) end)

---------------------------------------------------------------------------
-- 8. LOGIC CHUYỂN TAB VÀ BẬT/TẮT MENU
---------------------------------------------------------------------------
local function hideAllTabs()
    InfoFrame.Visible = false
    FeFrame.Visible = false
    TongHopFrame.Visible = false
end

BtnInfo.MouseButton1Click:Connect(function()
    hideAllTabs()
    InfoFrame.Visible = true
end)

BtnFE.MouseButton1Click:Connect(function()
    hideAllTabs()
    FeFrame.Visible = true
end)

BtnTongHop.MouseButton1Click:Connect(function()
    hideAllTabs()
    TongHopFrame.Visible = true
end)

Circle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local initialPos = Circle.Position
        task.wait(0.12)
        if Circle.Position == initialPos then
            MainMenu.Visible = not MainMenu.Visible
        end
    end
end)

BtnDong.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
end)
