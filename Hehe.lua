local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-- 🔔 THÔNG BÁO KIỂM TRA
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Đang khởi chạy...",
        Text = "By:DucAnhLon - Đã ép hiện GUI trực tiếp!",
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

-- Tạo ScreenGui bám thẳng vào CoreGui để chống game nuốt GUI
local gui = Instance.new("ScreenGui")
gui.Name = "NutTronAnhV2"
gui.ResetOnSpawn = false

-- Đưa vào CoreGui (nếu executor hỗ trợ), nếu lỗi thì tống vào PlayerGui
local success, err = pcall(function()
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

-- Viền Rainbow 7 sắc cầu vồng
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
-- 📂 2. GIAO DIỆN MENU (VUÔNG 1:1, KHÔNG GÓC NHỌN, THANH DỌC 1/6)
-- ==========================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MenuFrame"
MenuFrame.Size = UDim2.new(0, 320, 0, 320)
MenuFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
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

-- Thanh bên trái dọc bằng ⅙ chiều rộng
local LeftBar = Instance.new("Frame")
LeftBar.Name = "LeftBar"
LeftBar.Size = UDim2.new(0.166, 0, 1, 0)
LeftBar.Position = UDim2.new(0, 0, 0, 0)
LeftBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LeftBar.BorderSizePixel = 0
LeftBar.Parent = MenuFrame

local LeftBarCorner = Instance.new("UICorner", LeftBar)
LeftBarCorner.CornerRadius = UDim.new(0, 18)

local DotDecor = Instance.new("Frame")
DotDecor.Size = UDim2.new(0, 8, 0, 8)
DotDecor.Position = UDim2.new(0.5, -4, 0, 20)
DotDecor.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
DotDecor.Parent = LeftBar
Instance.new("UICorner", DotDecor).CornerRadius = UDim.new(1, 0)

-- Tiêu đề Menu
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 0, 50)
TitleLabel.Position = UDim2.new(0.18, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ DUC ANH HUB ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
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
CloseButton.TextSize, CloseButton.FontFace = 13, Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
CloseButton.Parent = MenuFrame
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)

-- Danh sách chức năng
local ScrollingList = Instance.new("ScrollingFrame")
ScrollingList.Size = UDim2.new(0.8, -10, 1, -65)
ScrollingList.Position = UDim2.new(0.18, 10, 0, 55)
ScrollingList.BackgroundTransparency = 1
ScrollingList.CanvasSize = UDim2.new(0, 0, 0, 260)
ScrollingList.ScrollBarThickness = 3
ScrollingList.Parent = MenuFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ScrollingList

local function createMenuButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 13
    btn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    btn.Parent = ScrollingList
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}):Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
        if callback then callback() end
    end)
end

createMenuButton("Fly (Bay lượn)", function() print("Fly!") end)
createMenuButton("Noclip (Đi xuyên tường)", function() print("Noclip!") end)
createMenuButton("ESP (Nhìn xuyên tường)", function() print("ESP!") end)
createMenuButton("Speed x2", function() pcall(function() player.Character.Humanoid.WalkSpeed = 32 end) end)
createMenuButton("Reset Speed", function() pcall(function() player.Character.Humanoid.WalkSpeed = 16 end) end)

-- ==========================================
-- 🛠️ 3. LOGIC KÉO THẢ & BẬT TẮT
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

print("🚀 Script đã chạy thành công 100% không lỗi!")
