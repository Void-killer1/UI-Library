-- Anti-Duplication (Çift Çalışmayı Önleme)
if getgenv().DeccalUI_Instance then
    pcall(function() getgenv().DeccalUI_Instance:Destroy() end)
end

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Kütüphane Ana Tablosu
local DeccalLibrary = {}
local Theme = {
    Background = Color3.fromRGB(11, 11, 11),
    Panel = Color3.fromRGB(26, 26, 26),
    Accent = Color3.fromRGB(255, 65, 65), -- İsteğe bağlı değişebilir
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 150),
    Outline = Color3.fromRGB(40, 40, 40),
    TransparentBlack = Color3.fromRGB(0, 0, 0)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Deccal_AvantGarde_UI_" .. tostring(math.random(1000, 9999))
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Güvenlik: CoreGui destekleniyorsa oraya, yoksa PlayerGui'ye at.
local success, err = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
end

getgenv().DeccalUI_Instance = ScreenGui

-- Yardımcı Fonksiyonlar (Animasyon ve Sürükleme)
local function CreateTween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(topbar, object)
    local dragging = false
    local dragInput, mousePos, framePos

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            object.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function DeccalLibrary:CreateWindow(titleText)
    local Window = {}
    
    -- Mobil Buton (Kapalıyken Gözüken Sürüklenebilir Logo)
    local MobileButton = Instance.new("ImageButton")
    MobileButton.Name = "MobileToggle"
    MobileButton.Parent = ScreenGui
    MobileButton.BackgroundColor3 = Theme.TransparentBlack
    MobileButton.BackgroundTransparency = 0.5
    MobileButton.Position = UDim2.new(0.5, -25, 0, 20)
    MobileButton.Size = UDim2.new(0, 50, 0, 50)
    MobileButton.Image = "rbxassetid://89883430109659"
    MobileButton.Visible = false
    MobileButton.ClipsDescendants = true
    
    local MobileCorner = Instance.new("UICorner")
    MobileCorner.CornerRadius = UDim.new(1, 0)
    MobileCorner.Parent = MobileButton
    
    local MobileStroke = Instance.new("UIStroke")
    MobileStroke.Color = Theme.Accent
    MobileStroke.Thickness = 1.5
    MobileStroke.Parent = MobileButton

    MakeDraggable(MobileButton, MobileButton)

    -- Ana Çerçeve
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Outline
    MainStroke.Parent = MainFrame

    -- Üst Bar (Top Bar)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Theme.Background
    TopBar.BackgroundTransparency = 0.2
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    
    local TopBarDivider = Instance.new("Frame")
    TopBarDivider.Name = "Divider"
    TopBarDivider.Parent = TopBar
    TopBarDivider.BackgroundColor3 = Theme.Outline
    TopBarDivider.BorderSizePixel = 0
    TopBarDivider.Position = UDim2.new(0, 0, 1, -1)
    TopBarDivider.Size = UDim2.new(1, 0, 0, 1)

    MakeDraggable(TopBar, MainFrame)

    -- Logo (Top Bar)
    local Logo = Instance.new("ImageLabel")
    Logo.Parent = TopBar
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0, 5)
    Logo.Size = UDim2.new(0, 30, 0, 30)
    Logo.Image = "rbxassetid://89883430109659"

    -- Başlık
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = titleText or "Deccal UI"
    Title.TextColor3 = Theme.Text
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Kapatma / Küçültme Butonu
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.TextDark
    CloseBtn.TextSize = 16

    CloseBtn.MouseEnter:Connect(function() CreateTween(CloseBtn, {TextColor3 = Theme.Accent}) end)
    CloseBtn.MouseLeave:Connect(function() CreateTween(CloseBtn, {TextColor3 = Theme.TextDark}) end)

    CloseBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 600, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        MainFrame.Visible = false
        MobileButton.Visible = true
        MobileButton.Size = UDim2.new(0, 0, 0, 0)
        CreateTween(MobileButton, {Size = UDim2.new(0, 50, 0, 50)}, 0.3)
    end)

    MobileButton.MouseButton1Click:Connect(function()
        CreateTween(MobileButton, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.wait(0.2)
        MobileButton.Visible = false
        MainFrame.Visible = true
        CreateTween(MainFrame, {Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0}, 0.3)
    end)

    -- Yan Menü (Sidebar)
    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.Active = true
    Sidebar.BackgroundTransparency = 1
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 150, 1, -40)
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.ScrollBarThickness = 2
    Sidebar.ScrollBarImageColor3 = Theme.Accent
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = Sidebar
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 5)

    -- İçerik Konteyneri
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)

    local Tabs = {}
    local firstTab = true

    function Window:CreateTab(tabName)
        local Tab = {}
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = Sidebar
        TabBtn.BackgroundColor3 = Theme.Panel
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = "  " .. tabName
        TabBtn.TextColor3 = Theme.TextDark
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left

        local TabIndicator = Instance.new("Frame")
        TabIndicator.Parent = TabBtn
        TabIndicator.BackgroundColor3 = Theme.Accent
        TabIndicator.BorderSizePixel = 0
        TabIndicator.Size = UDim2.new(0, 2, 1, 0)
        TabIndicator.Visible = false

        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = ContentContainer
        TabContent.Active = true
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 2
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.Visible = firstTab

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingTop = UDim.new(0, 10)

        if firstTab then
            TabBtn.TextColor3 = Theme.Text
            TabIndicator.Visible = true
            firstTab = false
        end

        table.insert(Tabs, {Btn = TabBtn, Content = TabContent, Indicator = TabIndicator})

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Content.Visible = false
                t.Indicator.Visible = false
                CreateTween(t.Btn, {TextColor3 = Theme.TextDark, BackgroundTransparency = 1}, 0.2)
            end
            TabContent.Visible = true
            TabIndicator.Visible = true
            CreateTween(TabBtn, {TextColor3 = Theme.Text, BackgroundTransparency = 0.8}, 0.2)
        end)

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        -- Elements Modülleri
        function Tab:CreateButton(text, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Parent = TabContent
            ButtonFrame.BackgroundColor3 = Theme.Panel
            ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = ButtonFrame
            
            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Color = Theme.Outline
            BtnStroke.Parent = ButtonFrame

            local Btn = Instance.new("TextButton")
            Btn.Parent = ButtonFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = text
            Btn.TextColor3 = Theme.Text
            Btn.TextSize = 13

            Btn.MouseEnter:Connect(function() CreateTween(BtnStroke, {Color = Theme.Accent}, 0.2) end)
            Btn.MouseLeave:Connect(function() CreateTween(BtnStroke, {Color = Theme.Outline}, 0.2) end)
            
            Btn.MouseButton1Click:Connect(function()
                -- Ripple Effect (Micro-interaction)
                local ripple = Instance.new("Frame")
                ripple.Parent = ButtonFrame
                ripple.BackgroundColor3 = Theme.Accent
                ripple.BackgroundTransparency = 0.6
                ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                local rc = Instance.new("UICorner")
                rc.CornerRadius = UDim.new(1, 0)
                rc.Parent = ripple
                
                CreateTween(ripple, {Size = UDim2.new(1, 50, 1, 50), BackgroundTransparency = 1}, 0.4)
                task.delay(0.4, function() ripple:Destroy() end)
                
                pcall(callback)
            end)
        end

        function Tab:CreateToggle(text, default, callback)
            local toggled = default or false
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundColor3 = Theme.Panel
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            
            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 6)
            TglCorner.Parent = ToggleFrame

            local TglLabel = Instance.new("TextLabel")
            TglLabel.Parent = ToggleFrame
            TglLabel.BackgroundTransparency = 1
            TglLabel.Position = UDim2.new(0, 10, 0, 0)
            TglLabel.Size = UDim2.new(1, -60, 1, 0)
            TglLabel.Font = Enum.Font.Gotham
            TglLabel.Text = text
            TglLabel.TextColor3 = Theme.TextDark
            TglLabel.TextSize = 13
            TglLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBG = Instance.new("Frame")
            SwitchBG.Parent = ToggleFrame
            SwitchBG.BackgroundColor3 = toggled and Theme.Accent or Theme.Outline
            SwitchBG.Position = UDim2.new(1, -45, 0.5, -10)
            SwitchBG.Size = UDim2.new(0, 35, 0, 20)
            
            local SwCorner = Instance.new("UICorner")
            SwCorner.CornerRadius = UDim.new(1, 0)
            SwCorner.Parent = SwitchBG

            local SwitchCircle = Instance.new("Frame")
            SwitchCircle.Parent = SwitchBG
            SwitchCircle.BackgroundColor3 = Theme.Text
            SwitchCircle.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            SwitchCircle.Size = UDim2.new(0, 16, 0, 16)
            
            local CircCorner = Instance.new("UICorner")
            CircCorner.CornerRadius = UDim.new(1, 0)
            CircCorner.Parent = SwitchCircle

            local Btn = Instance.new("TextButton")
            Btn.Parent = ToggleFrame
            Btn.BackgroundTransparency = 1
            Btn.Size = UDim2.new(1, 0, 1, 0)
            Btn.Text = ""

            Btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    CreateTween(SwitchBG, {BackgroundColor3 = Theme.Accent}, 0.2)
                    CreateTween(SwitchCircle, {Position = UDim2.new(1, -18, 0.5, -8)}, 0.2)
                    CreateTween(TglLabel, {TextColor3 = Theme.Text}, 0.2)
                else
                    CreateTween(SwitchBG, {BackgroundColor3 = Theme.Outline}, 0.2)
                    CreateTween(SwitchCircle, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
                    CreateTween(TglLabel, {TextColor3 = Theme.TextDark}, 0.2)
                end
                pcall(callback, toggled)
            end)
            
            if toggled then pcall(callback, toggled) CreateTween(TglLabel, {TextColor3 = Theme.Text}, 0) end
        end

        function Tab:CreateSlider(text, min, max, default, callback)
            local value = default or min
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabContent
            SliderFrame.BackgroundColor3 = Theme.Panel
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            
            local SlCorner = Instance.new("UICorner")
            SlCorner.CornerRadius = UDim.new(0, 6)
            SlCorner.Parent = SliderFrame

            local SlLabel = Instance.new("TextLabel")
            SlLabel.Parent = SliderFrame
            SlLabel.BackgroundTransparency = 1
            SlLabel.Position = UDim2.new(0, 10, 0, 5)
            SlLabel.Size = UDim2.new(1, -20, 0, 20)
            SlLabel.Font = Enum.Font.Gotham
            SlLabel.Text = text
            SlLabel.TextColor3 = Theme.Text
            SlLabel.TextSize = 13
            SlLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SlValue = Instance.new("TextLabel")
            SlValue.Parent = SliderFrame
            SlValue.BackgroundTransparency = 1
            SlValue.Position = UDim2.new(0, 10, 0, 5)
            SlValue.Size = UDim2.new(1, -20, 0, 20)
            SlValue.Font = Enum.Font.Gotham
            SlValue.Text = tostring(value)
            SlValue.TextColor3 = Theme.Accent
            SlValue.TextSize = 13
            SlValue.TextXAlignment = Enum.TextXAlignment.Right

            local TrackBG = Instance.new("Frame")
            TrackBG.Parent = SliderFrame
            TrackBG.BackgroundColor3 = Theme.Outline
            TrackBG.Position = UDim2.new(0, 10, 0, 30)
            TrackBG.Size = UDim2.new(1, -20, 0, 6)
            Instance.new("UICorner", TrackBG).CornerRadius = UDim.new(1, 0)

            local TrackFill = Instance.new("Frame")
            TrackFill.Parent = TrackBG
            TrackFill.BackgroundColor3 = Theme.Accent
            TrackFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            Instance.new("UICorner", TrackFill).CornerRadius = UDim.new(1, 0)

            local Btn = Instance.new("TextButton")
            Btn.Parent = TrackBG
            Btn.BackgroundTransparency = 1
            Btn.Position = UDim2.new(0, -10, 0, -10)
            Btn.Size = UDim2.new(1, 20, 1, 20)
            Btn.Text = ""

            local dragging = false
            Btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local relativePos = mousePos - TrackBG.AbsolutePosition.X
                    local percent = math.clamp(relativePos / TrackBG.AbsoluteSize.X, 0, 1)
                    
                    value = math.floor(min + ((max - min) * percent))
                    SlValue.Text = tostring(value)
                    CreateTween(TrackFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.1)
                    pcall(callback, value)
                end
            end)
        end

        return Tab
    end

    return Window
end

-- ÖRNEK KULLANIM (Kütüphane iskeleti hazır, özellikler entegre edildi)
local MainWindow = DeccalLibrary:CreateWindow("Deccal Avant-Garde")
local MainTab = MainWindow:CreateTab("Genel Ayarlar")
local VisualTab = MainWindow:CreateTab("Görsel (Visuals)")
local ExploitsTab = MainWindow:CreateTab("Gelişmiş")

MainTab:CreateToggle("Aimbot Aktif", false, function(state)
    print("Aimbot: " .. tostring(state))
end)

MainTab:CreateSlider("Görüş Alanı (FOV)", 0, 120, 90, function(val)
    print("FOV Değeri: " .. tostring(val))
end)

MainTab:CreateButton("Konsolu Temizle", function()
    print("Konsol temizlendi.")
end)

VisualTab:CreateToggle("ESP Aktif", true, function(state)
    print("ESP durumu: " .. tostring(state))
end)

ExploitsTab:CreateButton("Panik Butonu (Sil)", function()
    if getgenv().DeccalUI_Instance then
        getgenv().DeccalUI_Instance:Destroy()
    end
end)
