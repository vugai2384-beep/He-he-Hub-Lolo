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
-- TAB UNIVERSA
local Tab3 = Instance.new("ScrollingFrame", gui)
Tab3.Size = UDim2.new(0.5, 0, 0.5, 0) -- Chỉnh size vừa phải
Tab3.Position = UDim2.new(0.2, 0, 0.2, 0) -- Đặt ở giữa màn hình
Tab3.Visible = false 
Tab3.Name = "Universa"
Tab3.BackgroundTransparency = 0.5
Tab3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local UIList = Instance.new("UIListLayout", Tab3)
UIList.Padding = UDim.new(0, 5)

local function createBtn(name, callback)
    local btn = Instance.new("TextButton", Tab3)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(callback)
end

createBtn("Noclip", function() print("Noclip") end)
createBtn("Float", function() print("Float") end)
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
    -- HEHE HUB - FLOAT & UTILS
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- [1] TẠO GUI (Tối giản)
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 180, 0, 220); Main.Position = UDim2.new(0.5, -90, 0.5, -110)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local UIList = Instance.new("UIListLayout", Main); UIList.Padding = UDim.new(0, 5); UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(name, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); btn.Text = name; btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn); btn.MouseButton1Click:Connect(function() callback(btn) end)
end

-- [2] CÁC LOGIC CHỨC NĂNG
local noclip = false
RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, v in pairs(player.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- Float Logic (Tạo Platform dưới chân)
local floating = false
local platform
RunService.RenderStepped:Connect(function()
    if floating and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        if not platform then
            platform = Instance.new("Part", workspace)
            platform.Size = Vector3.new(4, 0.5, 4); platform.Transparency = 1; platform.Anchored = true
        end
        platform.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
    elseif platform then
        platform:Destroy(); platform = nil
    end
end)

-- [3] GÁN NÚT BẤM
createBtn("Noclip: OFF", function(btn) noclip = not noclip; btn.Text = noclip and "Noclip: ON" or "Noclip: OFF" end)
createBtn("Float: OFF", function(btn) floating = not floating; btn.Text = floating and "Float: ON" or "Float: OFF" end)
createBtn("Inf Jump: ON", function() UserInputService.JumpRequest:Connect(function() player.Character.Humanoid:ChangeState("Jumping") end) end)
createBtn("Highlights", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and not p.Character:FindFirstChild("Highlight") then
            local h = Instance.new("Highlight", p.Character); h.FillColor = Color3.fromRGB(0, 255, 0)
        end
    end
end)
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
TiktokLabel.Position = UDim2.new(0, 0, 0, 25)
TiktokLabel.BackgroundTransparency = 1
TiktokLabel.Font = Enum.Font.SourceSansBold
TiktokLabel.Text = "🎵 TikTok: Yuya_lwo"
TiktokLabel.TextSize = 14
TiktokLabel.TextXAlignment = Enum.TextXAlignment.Left
TiktokLabel.Parent = InfoFrame
addTextStroke(TiktokLabel)

local RobloxLabel = Instance.new("TextLabel")
RobloxLabel.Size = UDim2.new(1, 0, 0, 25)
RobloxLabel.Position = UDim2.new(0, 0, 0, 50)
RobloxLabel.BackgroundTransparency = 1
RobloxLabel.Font = Enum.Font.SourceSansBold
RobloxLabel.Text = "🎮 Roblox: vyyeuchi2"
RobloxLabel.TextSize = 14
RobloxLabel.TextXAlignment = Enum.TextXAlignment.Left
RobloxLabel.Parent = InfoFrame
addTextStroke(RobloxLabel)

-- ==================== HỆ THỐNG PHÁT NHẠC ĐA BÀI ====================
local TRUC_XINH_ID = "rbxassetid://119165216580381"

-- Sửa lại hàm playMusic để dùng đúng biến global MY_SOUND_ID
local function playMusic(soundId)
    if bgMusic then bgMusic:Destroy() end
    
    bgMusic = Instance.new("Sound")
    bgMusic.SoundId = soundId
    bgMusic.Volume = 0.4
    bgMusic.Looped = false
    bgMusic.Parent = workspace
    bgMusic:Play()
    
    currentMusicId = soundId
    isMusicPlaying = true
end

-- NÚT BÀI NHẠC 1
local BtnToggleMusic1 = Instance.new("TextButton")
BtnToggleMusic1.Name = "BtnToggleMusic1"
BtnToggleMusic1.Size = UDim2.new(0, 160, 0, 30)
BtnToggleMusic1.Position = UDim2.new(0, 0, 0, 85)
BtnToggleMusic1.BackgroundColor3 = Color3.fromRGB(255, 165, 2)
BtnToggleMusic1.BackgroundTransparency = 0.3
BtnToggleMusic1.Font = Enum.Font.SourceSansBold
BtnToggleMusic1.Text = "🎵 Tắt Nhạc Nền 1"
BtnToggleMusic1.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggleMusic1.TextSize = 11
BtnToggleMusic1.Parent = InfoFrame

local Btn1Corner = Instance.new("UICorner")
Btn1Corner.CornerRadius = UDim.new(0, 6)
Btn1Corner.Parent = BtnToggleMusic1
local Btn1Stroke = Instance.new("UIStroke")
Btn1Stroke.Color = Color3.fromRGB(255, 215, 0)
Btn1Stroke.Thickness = 1
Btn1Stroke.Parent = BtnToggleMusic1

-- NÚT BÀI TRÚC XINH
local BtnToggleMusic2 = Instance.new("TextButton")
BtnToggleMusic2.Name = "BtnToggleMusic2"
BtnToggleMusic2.Size = UDim2.new(0, 160, 0, 30)
BtnToggleMusic2.Position = UDim2.new(0, 0, 0, 120)
BtnToggleMusic2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
BtnToggleMusic2.BackgroundTransparency = 0.3
BtnToggleMusic2.Font = Enum.Font.SourceSansBold
BtnToggleMusic2.Text = "🎋 Bật Trúc Xinh"
BtnToggleMusic2.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnToggleMusic2.TextSize = 11
BtnToggleMusic2.Parent = InfoFrame

local Btn2Corner = Instance.new("UICorner")
Btn2Corner.CornerRadius = UDim.new(0, 6)
Btn2Corner.Parent = BtnToggleMusic2
local Btn2Stroke = Instance.new("UIStroke")
Btn2Stroke.Color = Color3.fromRGB(255, 215, 0)
Btn2Stroke.Thickness = 1
Btn2Stroke.Parent = BtnToggleMusic2

BtnToggleMusic1.MouseButton1Click:Connect(function()
    if currentMusicId == MY_SOUND_ID then
        stopBackgroundMusic()
        currentMusicId = nil
        BtnToggleMusic1.Text = "🎵 Bật Nhạc Nền 1"
        BtnToggleMusic1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        playMusic(MY_SOUND_ID)
        BtnToggleMusic1.Text = "🎵 Tắt Nhạc Nền 1"
        BtnToggleMusic1.BackgroundColor3 = Color3.fromRGB(255, 165, 2)
        BtnToggleMusic2.Text = "🎋 Bật Trúc Xinh"
        BtnToggleMusic2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)
BtnToggleMusic2.MouseButton1Click:Connect(function()
    if currentMusicId == TRUC_XINH_ID then
        stopBackgroundMusic()
        currentMusicId = nil
        BtnToggleMusic2.Text = "🎋 Bật Trúc Xinh"
        BtnToggleMusic2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        playMusic(TRUC_XINH_ID)
        BtnToggleMusic2.Text = "🎋 Tắt Trúc Xinh"
        BtnToggleMusic2.BackgroundColor3 = Color3.fromRGB(255, 165, 2)
        BtnToggleMusic1.Text = "🎵 Bật Nhạc Nền 1"
        BtnToggleMusic1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "HeheHub"

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, 180, 0, 110) -- Làm bé lại nè
Main.Position = UDim2.new(0.5, -90, 0.5, -55)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

-- Cho phép di chuyển (Draggable)
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) dragging = false end)

local Info = Instance.new("TextLabel", Main)
Info.Size = UDim2.new(1, 0, 1, 0)
Info.BackgroundTransparency = 1
Info.Text = "HEHE HUB 🗿\nNhạc Việt Remix"
Info.TextColor3 = Color3.fromRGB(255, 255, 255)
Info.Font = Enum.Font.SourceSansBold
Info.TextSize = 14

local btn = Instance.new("TextButton", Main)
btn.Size = UDim2.new(0.7, 0, 0.3, 0)
btn.Position = UDim2.new(0.15, 0, 0.6, 0)
btn.Text = "▶ BẬT"
btn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Instance.new("UICorner", btn)

local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://82627558368623" 

btn.MouseButton1Click:Connect(function()
    if sound.IsPlaying then
        sound:Stop()
        btn.Text = "▶ BẬT"
    else
        sound:Play()
        btn.Text = "⏸ DỪNG"
    end
end)
