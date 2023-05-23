-- Tentukan waktu yang dibutuhkan untuk dianggap AFK (dalam detik)
local afkTimeThreshold = 300 -- 5 menit

-- Dapatkan karakter pemain
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Catat waktu terakhir pemain bergerak
local lastActiveTime = tick()

-- Fungsi untuk memperbarui waktu terakhir aktif
local function updateLastActiveTime()
    lastActiveTime = tick()
end

-- Perbarui waktu terakhir aktif saat pemain bergerak
humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(updateLastActiveTime)
humanoid:GetPropertyChangedSignal("Jump"):Connect(updateLastActiveTime)

-- Perbarui waktu terakhir aktif saat pemain menembak
if character:FindFirstChild("Right Arm") then
    local tool = character["Right Arm"]:FindFirstChildWhichIsA("Tool")
    if tool then
        tool.Activated:Connect(updateLastActiveTime)
    end
end

-- Buat UI dengan nama pembuat
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UI"
ScreenGui.Enabled = true
ScreenGui.Parent = player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.5, -100, 0.5, -25)
Frame.BackgroundColor3 = Color3.new(0, 1, 0) -- Warna awal UI adalah hijau
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Created by Muhammad Syifaul Janah Multimedia"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.TextSize = 18
TextLabel.Parent = Frame

-- Fungsi untuk menyembunyikan atau menampilkan UI
local function toggleUI()
    ScreenGui.Enabled = not ScreenGui.Enabled
end

-- Fungsi untuk mengubah warna UI
local function changeUIColor()
    if Frame.BackgroundColor3 == Color3.new(0, 1, 0) then
        Frame.BackgroundColor3 = Color3.new(1, 0, 0) -- Mengubah warna menjadi merah
    else
        Frame.BackgroundColor3 = Color3.new(0, 1, 0) -- Mengubah warna menjadi hijau
    end
end

-- Fungsi untuk menangani input pemain
local function onKeyPress(input)
    if input.KeyCode == Enum.KeyCode.E then
        toggleUI()
    elseif input.KeyCode == Enum.KeyCode.B then
        changeUIColor()
    end
end

-- Menghubungkan fungsi onKeyPress dengan event UserInputService.InputBegan
game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

-- Fungsi untuk memindahkan UI
local function dragUI(input)
    local delta = input.Position - input.Position - input.Position
    Frame.Position = Frame.Position + UDim2.new(0, delta.X, 0, delta.Y)
end

-- Menghubungkan fungsi dragUI dengan event UserInputService.InputChanged
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and input:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and ScreenGui.Enabled then
        dragUI(input)
    end
end)

-- Periksa secara berulang waktu terakhir aktif untuk mendeteksi AFK
while true do
    wait(1) -- Periksa setiap 1 detik
    
    local currentTime = tick()
    local afkTime = currentTime - lastActiveTime
    
    if afkTime >= afkTimeThreshold then
        -- Pemain dianggap AFK, lakukan tindakan anti AFK di sini
        
        -- Contoh: Berjalan ke depan dan memutar karakter
        humanoid:MoveTo(character.PrimaryPart.Position + character.PrimaryPart.CFrame.LookVector * 5)
        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(45), 0))
        
        -- Catat waktu terakhir aktif kembali
        updateLastActiveTime()
    end
end
