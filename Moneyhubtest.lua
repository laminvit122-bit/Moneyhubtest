if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

local TEXTURE_ID = "rbxassetid://9343433823"
local CROSS_TEXTURE_ID = "rbxassetid://87983057610468"
local NOTIFY_FRAME_ID = ""

local MODULES_ICON = "rbxassetid://82633060732202"
local SETTINGS_ICON = "rbxassetid://138028255370142"
local MAIN_ICON = "rbxassetid://14502433595"
local VISUALS_ICON = "rbxassetid://11322089611"
local TELEPORT_ICON = "rbxassetid://6723742952"
local LANGUAGE_ICON = "rbxassetid://84460102482950"
local CONFIGS_ICON = "rbxassetid://90837140373377"
local GEAR_ICON = "rbxassetid://6953984741"

local SAVE_ICON = "rbxassetid://11768914234"
local IMPORT_ICON = "rbxassetid://6953990743"
local DELETE_ICON = "rbxassetid://11768918600"

local SAFE_COORDS = Vector3.new(-200.7, 675.7, 357.3)

if playerGui:FindFirstChild("MoneyHubGui") then
    playerGui.MoneyHubGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoneyHubGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    elseif gethui then
        screenGui.Parent = gethui()
    else
        screenGui.Parent = playerGui
    end
end)
if not screenGui.Parent then screenGui.Parent = playerGui end

local function playEnableSound()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://139421450430380"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        task.delay(2, function()
            sound:Destroy()
        end)
    end)
end

-- КРАСНОЕ НЕОНОВОЕ УВЕДОМЛЕНИЕ ПРИ ОТСУТСТВИИ СПОСОБНОСТИ
local activeErrorNotification = nil

local function showAbilityErrorNotification(onCompleted)
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://109149869070031"
        sound.Volume = 1
        sound.Parent = SoundService
        sound:Play()
        task.delay(2, function() sound:Destroy() end)
    end)

    if activeErrorNotification and activeErrorNotification.Parent then
        activeErrorNotification:Destroy()
        activeErrorNotification = nil
    end

    local width = 320
    local height = 64

    local errContainer = Instance.new("Frame")
    errContainer.Size = UDim2.new(0, width, 0, height)
    errContainer.Position = UDim2.new(0.5, -width / 2, 1, 80)
    errContainer.BackgroundTransparency = 1
    errContainer.ZIndex = 800
    errContainer.Parent = screenGui
    activeErrorNotification = errContainer

    local errBg = Instance.new("Frame")
    errBg.Size = UDim2.new(1, 0, 1, 0)
    errBg.BackgroundColor3 = Color3.fromRGB(22, 6, 8)
    errBg.BackgroundTransparency = 0.08
    errBg.BorderSizePixel = 0
    errBg.ClipsDescendants = true
    errBg.ZIndex = 801
    errBg.Parent = errContainer

    local errCorner = Instance.new("UICorner")
    errCorner.CornerRadius = UDim.new(0, 8)
    errCorner.Parent = errBg

    local errGradient = Instance.new("UIGradient")
    errGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(165, 16, 24)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(36, 6, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 12, 20))
    })
    errGradient.Rotation = 25
    errGradient.Parent = errBg

    local diagSheen = Instance.new("Frame")
    diagSheen.Size = UDim2.new(0.45, 0, 2.2, 0)
    diagSheen.Position = UDim2.new(0.22, 0, -0.6, 0)
    diagSheen.Rotation = 28
    diagSheen.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
    diagSheen.BackgroundTransparency = 0.86
    diagSheen.BorderSizePixel = 0
    diagSheen.ZIndex = 802
    diagSheen.Parent = errBg

    if NOTIFY_FRAME_ID ~= "" then
        local frameArt = Instance.new("ImageLabel")
        frameArt.Size = UDim2.new(1, 0, 1, 0)
        frameArt.BackgroundTransparency = 1
        frameArt.Image = NOTIFY_FRAME_ID
        frameArt.ScaleType = Enum.ScaleType.Stretch
        frameArt.ZIndex = 803
        frameArt.Parent = errBg
    else
        local borderStroke = Instance.new("UIStroke")
        borderStroke.Color = Color3.fromRGB(255, 38, 52)
        borderStroke.Thickness = 1.8
        borderStroke.Transparency = 0.15
        borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        borderStroke.Parent = errBg
    end

    local iconHolder = Instance.new("Frame")
    iconHolder.Size = UDim2.new(0, 44, 0, 44)
    iconHolder.Position = UDim2.new(1, -54, 0.5, -22)
    iconHolder.BackgroundTransparency = 1
    iconHolder.ClipsDescendants = true
    iconHolder.ZIndex = 804
    iconHolder.Parent = errBg

    local errIcon = Instance.new("ImageLabel")
    errIcon.Size = UDim2.new(0, 34, 0, 34)
    errIcon.Position = UDim2.new(0.5, -17, 0.5, -17)
    errIcon.BackgroundTransparency = 1
    errIcon.Image = CROSS_TEXTURE_ID
    errIcon.ImageColor3 = Color3.fromRGB(255, 60, 75)
    errIcon.ScaleType = Enum.ScaleType.Fit
    errIcon.ZIndex = 805
    errIcon.Parent = iconHolder

    local errLbl = Instance.new("TextLabel")
    errLbl.Size = UDim2.new(1, -82, 1, 0)
    errLbl.Position = UDim2.new(0, 20, 0, 0)
    errLbl.BackgroundTransparency = 1
    errLbl.Font = Enum.Font.GothamBold
    errLbl.Text = "Выберите способность"
    errLbl.TextColor3 = Color3.fromRGB(255, 245, 245)
    errLbl.TextSize = 12
    errLbl.TextXAlignment = Enum.TextXAlignment.Left
    errLbl.TextTruncate = Enum.TextTruncate.AtEnd
    errLbl.ZIndex = 805
    errLbl.Parent = errBg

    TweenService:Create(errContainer, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -width / 2, 1, -92)
    }):Play()

    task.delay(2.8, function()
        if errContainer and errContainer.Parent then
            local tw = TweenService:Create(errContainer, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -width / 2, 1, 80)
            })
            tw:Play()
            tw.Completed:Connect(function()
                if activeErrorNotification == errContainer then
                    activeErrorNotification = nil
                end
                errContainer:Destroy()
                if onCompleted then onCompleted() end
            end)
        end
    end)
end

-- СТАНДАРТНЫЕ УВЕДОМЛЕНИЯ (ТЁПЛЫЙ ОРАНЖЕВО-КОРИЧНЕВЫЙ СТИЛЬ)
local notificationsContainer = Instance.new("Frame")
notificationsContainer.Name = "NotificationsContainer"
notificationsContainer.Size = UDim2.new(0, 240, 1, 0)
notificationsContainer.Position = UDim2.new(1, -250, 0, 0)
notificationsContainer.BackgroundTransparency = 1
notificationsContainer.ZIndex = 500
notificationsContainer.Parent = screenGui

local activeNotifications = 0

local function showNotification(title, stateText)
    activeNotifications = activeNotifications + 1
    local yPos = -(activeNotifications * 55)

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(1, 0, 0, 45)
    notifFrame.Position = UDim2.new(1, 50, 1, yPos - 10)
    notifFrame.BackgroundColor3 = Color3.fromRGB(45, 26, 13)
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.BorderSizePixel = 0
    notifFrame.ZIndex = 501
    notifFrame.Parent = notificationsContainer

    local nCorner = Instance.new("UICorner") nCorner.CornerRadius = UDim.new(0, 8) nCorner.Parent = notifFrame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -15, 0, 22)
    titleLbl.Position = UDim2.new(0, 10, 0, 4)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.Text = title .. ": " .. stateText
    titleLbl.TextColor3 = Color3.fromRGB(255, 200, 120)
    titleLbl.TextSize = 11
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 502
    titleLbl.Parent = notifFrame

    local lineBg = Instance.new("Frame")
    lineBg.Size = UDim2.new(1, -20, 0, 3)
    lineBg.Position = UDim2.new(0, 10, 1, -8)
    lineBg.BackgroundColor3 = Color3.fromRGB(60, 35, 18)
    lineBg.BorderSizePixel = 0
    lineBg.ZIndex = 502
    lineBg.Parent = notifFrame
    local lbCorner = Instance.new("UICorner") lbCorner.CornerRadius = UDim.new(1, 0) lbCorner.Parent = lineBg

    local lineFill = Instance.new("Frame")
    lineFill.Size = UDim2.new(1, 0, 1, 0)
    lineFill.Position = UDim2.new(0, 0, 0, 0)
    lineFill.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    lineFill.BorderSizePixel = 0
    lineFill.ZIndex = 503
    lineFill.Parent = lineBg
    local lfCorner = Instance.new("UICorner") lfCorner.CornerRadius = UDim.new(1, 0) lfCorner.Parent = lineFill

    TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 1, yPos - 10)}):Play()
    TweenService:Create(lineFill, TweenInfo.new(3.0, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()

    task.delay(3.0, function()
        TweenService:Create(notifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 50, 1, yPos - 10), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        notifFrame:Destroy()
        activeNotifications = math.max(0, activeNotifications - 1)
    end)
end

-- ГЛАВНОЕ ОКНО (ИСХОДНЫЙ КОРИЧНЕВО-ОРАНЖЕВЫЙ ЦВЕТ)
local targetPosition = UDim2.new(0.5, -320, 0.5, -205)
local hiddenPosition = UDim2.new(0.5, -320, 0.5, 380)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 640, 0, 410)
mainFrame.Position = hiddenPosition
mainFrame.BackgroundColor3 = Color3.fromRGB(38, 24, 12)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner") mainCorner.CornerRadius = UDim.new(0, 14) mainCorner.Parent = mainFrame

local effectsContainer = Instance.new("Frame")
effectsContainer.Name = "EffectsContainer"
effectsContainer.Size = UDim2.new(1, 0, 1, 0)
effectsContainer.BackgroundTransparency = 1
effectsContainer.ZIndex = 1
effectsContainer.Parent = mainFrame

local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, 0, 1, 0)
contentContainer.BackgroundTransparency = 1
contentContainer.ZIndex = 2
contentContainer.Parent = mainFrame

-- Боковая панель
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 160, 1, -20)
sidebar.Position = UDim2.new(0, 10, 0, 10)
sidebar.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = contentContainer

local sidebarCorner = Instance.new("UICorner") sidebarCorner.CornerRadius = UDim.new(0, 10) sidebarCorner.Parent = sidebar

local logoTexture = Instance.new("ImageLabel") logoTexture.Size = UDim2.new(0, 20, 0, 20) logoTexture.Position = UDim2.new(0, 10, 0, 17) logoTexture.BackgroundTransparency = 1 logoTexture.Image = TEXTURE_ID logoTexture.ZIndex = 3 logoTexture.Parent = sidebar
local logoLabel = Instance.new("TextLabel") logoLabel.Size = UDim2.new(1, -38, 0, 20) logoLabel.Position = UDim2.new(0, 34, 0, 10) logoLabel.BackgroundTransparency = 1 logoLabel.Font = Enum.Font.GothamBold logoLabel.Text = "MONEYHUB" logoLabel.TextColor3 = Color3.fromRGB(255, 195, 80) logoLabel.TextSize = 14 logoLabel.TextXAlignment = Enum.TextXAlignment.Left logoLabel.ZIndex = 3 logoLabel.Parent = sidebar

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "VersionLabel"
versionLabel.Size = UDim2.new(1, -38, 0, 16)
versionLabel.Position = UDim2.new(0, 34, 0, 28)
versionLabel.BackgroundTransparency = 1
versionLabel.Font = Enum.Font.GothamBold
versionLabel.Text = "v0.1"
versionLabel.TextColor3 = Color3.fromRGB(180, 130, 80)
versionLabel.TextSize = 10
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.ZIndex = 3
versionLabel.Parent = sidebar

-- СЕКЦИЯ MODULES (Main + Visuals + Teleport)
local modulesIconImg = Instance.new("ImageLabel") modulesIconImg.Size = UDim2.new(0, 14, 0, 14) modulesIconImg.Position = UDim2.new(0, 12, 0, 55) modulesIconImg.BackgroundTransparency = 1 modulesIconImg.Image = MODULES_ICON modulesIconImg.ZIndex = 3 modulesIconImg.Parent = sidebar
local modulesHeader = Instance.new("TextLabel") modulesHeader.Size = UDim2.new(0, 100, 0, 20) modulesHeader.Position = UDim2.new(0, 32, 0, 52) modulesHeader.BackgroundTransparency = 1 modulesHeader.Font = Enum.Font.GothamBold modulesHeader.Text = "Modules" modulesHeader.TextColor3 = Color3.fromRGB(210, 150, 90) modulesHeader.TextSize = 11 modulesHeader.TextXAlignment = Enum.TextXAlignment.Left modulesHeader.ZIndex = 3 modulesHeader.Parent = sidebar

local mainTabBtn = Instance.new("TextButton")
mainTabBtn.Size = UDim2.new(1, -20, 0, 26)
mainTabBtn.Position = UDim2.new(0, 10, 0, 75)
mainTabBtn.BackgroundColor3 = Color3.fromRGB(85, 50, 22)
mainTabBtn.BackgroundTransparency = 0.2
mainTabBtn.Text = "             Main"
mainTabBtn.TextColor3 = Color3.fromRGB(255, 225, 180)
mainTabBtn.TextSize = 11
mainTabBtn.Font = Enum.Font.GothamMedium
mainTabBtn.TextXAlignment = Enum.TextXAlignment.Left
mainTabBtn.ZIndex = 3
mainTabBtn.Parent = sidebar

local mainTabCorner = Instance.new("UICorner") mainTabCorner.CornerRadius = UDim.new(0, 6) mainTabCorner.Parent = mainTabBtn
local mainIconImg = Instance.new("ImageLabel") mainIconImg.Size = UDim2.new(0, 14, 0, 14) mainIconImg.Position = UDim2.new(0, 12, 0, 6) mainIconImg.BackgroundTransparency = 1 mainIconImg.Image = MAIN_ICON mainIconImg.ZIndex = 4 mainIconImg.Parent = mainTabBtn

local visualsTabBtn = Instance.new("TextButton")
visualsTabBtn.Size = UDim2.new(1, -20, 0, 26)
visualsTabBtn.Position = UDim2.new(0, 10, 0, 105)
visualsTabBtn.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
visualsTabBtn.BackgroundTransparency = 0.5
visualsTabBtn.Text = "             Visuals"
visualsTabBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
visualsTabBtn.TextSize = 11
visualsTabBtn.Font = Enum.Font.GothamMedium
visualsTabBtn.TextXAlignment = Enum.TextXAlignment.Left
visualsTabBtn.ZIndex = 3
visualsTabBtn.Parent = sidebar

local visualsTabCorner = Instance.new("UICorner") visualsTabCorner.CornerRadius = UDim.new(0, 6) visualsTabCorner.Parent = visualsTabBtn
local visualsIconImg = Instance.new("ImageLabel") visualsIconImg.Size = UDim2.new(0, 14, 0, 14) visualsIconImg.Position = UDim2.new(0, 12, 0, 6) visualsIconImg.BackgroundTransparency = 1 visualsIconImg.Image = VISUALS_ICON visualsIconImg.ZIndex = 4 visualsIconImg.Parent = visualsTabBtn

local teleportTabBtn = Instance.new("TextButton")
teleportTabBtn.Size = UDim2.new(1, -20, 0, 26)
teleportTabBtn.Position = UDim2.new(0, 10, 0, 135)
teleportTabBtn.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
teleportTabBtn.BackgroundTransparency = 0.5
teleportTabBtn.Text = "             Teleport"
teleportTabBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
teleportTabBtn.TextSize = 11
teleportTabBtn.Font = Enum.Font.GothamMedium
teleportTabBtn.TextXAlignment = Enum.TextXAlignment.Left
teleportTabBtn.ZIndex = 3
teleportTabBtn.Parent = sidebar

local teleportTabCorner = Instance.new("UICorner") teleportTabCorner.CornerRadius = UDim.new(0, 6) teleportTabCorner.Parent = teleportTabBtn
local teleportIconImg = Instance.new("ImageLabel") teleportIconImg.Size = UDim2.new(0, 14, 0, 14) teleportIconImg.Position = UDim2.new(0, 12, 0, 6) teleportIconImg.BackgroundTransparency = 1 teleportIconImg.Image = TELEPORT_ICON teleportIconImg.ZIndex = 4 teleportIconImg.Parent = teleportTabBtn

-- СЕКЦИЯ SETTINGS (Language + Configs) — выровнено по левому краю
local settingsIconImg = Instance.new("ImageLabel") settingsIconImg.Size = UDim2.new(0, 14, 0, 14) settingsIconImg.Position = UDim2.new(0, 12, 0, 174) settingsIconImg.BackgroundTransparency = 1 settingsIconImg.Image = SETTINGS_ICON settingsIconImg.ZIndex = 3 settingsIconImg.Parent = sidebar
local settingsHeader = Instance.new("TextLabel") settingsHeader.Size = UDim2.new(0, 100, 0, 20) settingsHeader.Position = UDim2.new(0, 32, 0, 171) settingsHeader.BackgroundTransparency = 1 settingsHeader.Font = Enum.Font.GothamBold settingsHeader.Text = "Settings" settingsHeader.TextColor3 = Color3.fromRGB(210, 150, 90) settingsHeader.TextSize = 11 settingsHeader.TextXAlignment = Enum.TextXAlignment.Left settingsHeader.ZIndex = 3 settingsHeader.Parent = sidebar

local languageTabBtn = Instance.new("TextButton")
languageTabBtn.Size = UDim2.new(1, -20, 0, 26)
languageTabBtn.Position = UDim2.new(0, 10, 0, 195)
languageTabBtn.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
languageTabBtn.BackgroundTransparency = 0.5
languageTabBtn.Text = "             Language"
languageTabBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
languageTabBtn.TextSize = 11
languageTabBtn.Font = Enum.Font.GothamMedium
languageTabBtn.TextXAlignment = Enum.TextXAlignment.Left
languageTabBtn.ZIndex = 3
languageTabBtn.Parent = sidebar

local languageTabCorner = Instance.new("UICorner") languageTabCorner.CornerRadius = UDim.new(0, 6) languageTabCorner.Parent = languageTabBtn
local languageIconImg = Instance.new("ImageLabel") languageIconImg.Size = UDim2.new(0, 14, 0, 14) languageIconImg.Position = UDim2.new(0, 12, 0, 6) languageIconImg.BackgroundTransparency = 1 languageIconImg.Image = LANGUAGE_ICON languageIconImg.ZIndex = 4 languageIconImg.Parent = languageTabBtn

local configTabBtn = Instance.new("TextButton")
configTabBtn.Size = UDim2.new(1, -20, 0, 26)
configTabBtn.Position = UDim2.new(0, 10, 0, 225)
configTabBtn.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
configTabBtn.BackgroundTransparency = 0.5
configTabBtn.Text = "             Configs"
configTabBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
configTabBtn.TextSize = 11
configTabBtn.Font = Enum.Font.GothamMedium
configTabBtn.TextXAlignment = Enum.TextXAlignment.Left
configTabBtn.ZIndex = 3
configTabBtn.Parent = sidebar

local configTabCorner = Instance.new("UICorner") configTabCorner.CornerRadius = UDim.new(0, 6) configTabCorner.Parent = configTabBtn
local configIconImg = Instance.new("ImageLabel") configIconImg.Size = UDim2.new(0, 14, 0, 14) configIconImg.Position = UDim2.new(0, 12, 0, 6) configIconImg.BackgroundTransparency = 1 configIconImg.Image = CONFIGS_ICON configIconImg.ZIndex = 4 configIconImg.Parent = configTabBtn

-- Верхняя панель
local topBarArea = Instance.new("Frame")
topBarArea.Name = "TopBarArea"
topBarArea.Size = UDim2.new(1, -190, 0, 45)
topBarArea.Position = UDim2.new(0, 175, 0, 10)
topBarArea.BackgroundTransparency = 1
topBarArea.ZIndex = 2
topBarArea.Parent = contentContainer

local searchBar = Instance.new("Frame")
searchBar.Size = UDim2.new(0, 190, 0, 30)
searchBar.Position = UDim2.new(0, 0, 0, 5)
searchBar.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
searchBar.BackgroundTransparency = 0.3
searchBar.ZIndex = 2
searchBar.Parent = topBarArea

local searchCorner = Instance.new("UICorner") searchCorner.CornerRadius = UDim.new(0, 8) searchCorner.Parent = searchBar
local searchIcon = Instance.new("TextLabel") searchIcon.Size = UDim2.new(0, 25, 1, 0) searchIcon.Position = UDim2.new(0, 8, 0, 0) searchIcon.BackgroundTransparency = 1 searchIcon.Text = "🔍" searchIcon.TextColor3 = Color3.fromRGB(200, 140, 70) searchIcon.TextSize = 12 searchIcon.ZIndex = 3 searchIcon.Parent = searchBar

local searchInput = Instance.new("TextBox")
searchInput.Size = UDim2.new(1, -35, 1, 0)
searchInput.Position = UDim2.new(0, 30, 0, 0)
searchInput.BackgroundTransparency = 1
searchInput.PlaceholderText = "Поиск..."
searchInput.PlaceholderColor3 = Color3.fromRGB(170, 120, 70)
searchInput.Text = ""
searchInput.TextColor3 = Color3.fromRGB(250, 220, 170)
searchInput.TextSize = 12
searchInput.Font = Enum.Font.Gotham
searchInput.ZIndex = 3
searchInput.Parent = searchBar

local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(0, 140, 0, 30)
profileFrame.Position = UDim2.new(1, -210, 0, 5)
profileFrame.BackgroundTransparency = 1
profileFrame.ZIndex = 5
profileFrame.Parent = topBarArea

local profileName = Instance.new("TextLabel")
profileName.Size = UDim2.new(1, -35, 1, 0)
profileName.Position = UDim2.new(0, 0, 0, 0)
profileName.BackgroundTransparency = 1
profileName.Font = Enum.Font.GothamBold
profileName.Text = player.DisplayName
profileName.TextColor3 = Color3.fromRGB(250, 220, 170)
profileName.TextSize = 11
profileName.TextXAlignment = Enum.TextXAlignment.Right
profileName.ZIndex = 6
profileName.Parent = profileFrame

local profileAvatar = Instance.new("ImageLabel")
profileAvatar.Size = UDim2.new(0, 24, 0, 24)
profileAvatar.Position = UDim2.new(1, -26, 0, 3)
profileAvatar.BackgroundColor3 = Color3.fromRGB(60, 35, 18)
profileAvatar.BorderSizePixel = 0
profileAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
profileAvatar.ZIndex = 6
profileAvatar.Parent = profileFrame

local avatarCorner = Instance.new("UICorner") avatarCorner.CornerRadius = UDim.new(1, 0) avatarCorner.Parent = profileAvatar

local minBtn = Instance.new("TextButton")
minBtn.Name = "MinimizeButton"
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -65, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(65, 38, 20)
minBtn.BackgroundTransparency = 0.3
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(230, 190, 140)
minBtn.TextSize = 14
minBtn.Font = Enum.Font.GothamBold
minBtn.ZIndex = 10
minBtn.Parent = topBarArea

local minCorner = Instance.new("UICorner") minCorner.CornerRadius = UDim.new(0, 6) minCorner.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -35, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(85, 35, 20)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(255, 150, 120)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 10
closeBtn.Parent = topBarArea

local closeCorner = Instance.new("UICorner") closeCorner.CornerRadius = UDim.new(0, 6) closeCorner.Parent = closeBtn

local sectionTitle = Instance.new("TextLabel")
sectionTitle.Size = UDim2.new(1, -190, 0, 20)
sectionTitle.Position = UDim2.new(0, 175, 0, 52)
sectionTitle.BackgroundTransparency = 1
sectionTitle.Font = Enum.Font.GothamBold
sectionTitle.Text = "Modules / Main"
sectionTitle.TextColor3 = Color3.fromRGB(190, 135, 75)
sectionTitle.TextSize = 12
sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
sectionTitle.ZIndex = 2
sectionTitle.Parent = contentContainer

-- Страницы
local mainPage = Instance.new("ScrollingFrame")
mainPage.Name = "MainPage"
mainPage.Size = UDim2.new(1, -190, 1, -90)
mainPage.Position = UDim2.new(0, 175, 0, 78)
mainPage.BackgroundTransparency = 1
mainPage.CanvasSize = UDim2.new(0, 0, 0, 0)
mainPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
mainPage.ScrollBarThickness = 4
mainPage.Visible = true
mainPage.ZIndex = 2
mainPage.Parent = contentContainer

local mainLayout = Instance.new("UIListLayout")
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Padding = UDim.new(0, 10)
mainLayout.Parent = mainPage

local mainPadding = Instance.new("UIPadding")
mainPadding.PaddingBottom = UDim.new(0, 30)
mainPadding.PaddingRight = UDim.new(0, 5)
mainPadding.Parent = mainPage

local visualsPage = Instance.new("ScrollingFrame")
visualsPage.Name = "VisualsPage"
visualsPage.Size = UDim2.new(1, -190, 1, -90)
visualsPage.Position = UDim2.new(0, 175, 0, 78)
visualsPage.BackgroundTransparency = 1
visualsPage.CanvasSize = UDim2.new(0, 0, 0, 0)
visualsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
visualsPage.ScrollBarThickness = 4
visualsPage.Visible = false
visualsPage.ZIndex = 2
visualsPage.Parent = contentContainer

local visualsLayout = Instance.new("UIListLayout")
visualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
visualsLayout.Padding = UDim.new(0, 10)
visualsLayout.Parent = visualsPage

local visualsPadding = Instance.new("UIPadding")
visualsPadding.PaddingBottom = UDim.new(0, 30)
visualsPadding.PaddingRight = UDim.new(0, 5)
visualsPadding.Parent = visualsPage

local teleportPage = Instance.new("ScrollingFrame")
teleportPage.Name = "TeleportPage"
teleportPage.Size = UDim2.new(1, -190, 1, -90)
teleportPage.Position = UDim2.new(0, 175, 0, 78)
teleportPage.BackgroundTransparency = 1
teleportPage.CanvasSize = UDim2.new(0, 0, 0, 0)
teleportPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
teleportPage.ScrollBarThickness = 4
teleportPage.Visible = false
teleportPage.ZIndex = 2
teleportPage.Parent = contentContainer

local languagePage = Instance.new("ScrollingFrame")
languagePage.Name = "LanguagePage"
languagePage.Size = UDim2.new(1, -190, 1, -90)
languagePage.Position = UDim2.new(0, 175, 0, 78)
languagePage.BackgroundTransparency = 1
languagePage.CanvasSize = UDim2.new(0, 0, 0, 300)
languagePage.ScrollBarThickness = 3
languagePage.Visible = false
languagePage.ZIndex = 2
languagePage.Parent = contentContainer

local configPage = Instance.new("ScrollingFrame")
configPage.Name = "ConfigPage"
configPage.Size = UDim2.new(1, -190, 1, -90)
configPage.Position = UDim2.new(0, 175, 0, 78)
configPage.BackgroundTransparency = 1
configPage.CanvasSize = UDim2.new(0, 0, 0, 300)
configPage.ScrollBarThickness = 3
configPage.Visible = false
configPage.ZIndex = 2
configPage.Parent = contentContainer

local refreshTeleportList

local function switchTab(tabName)
    mainPage.Visible = (tabName == "Main")
    visualsPage.Visible = (tabName == "Visuals")
    teleportPage.Visible = (tabName == "Teleport")
    languagePage.Visible = (tabName == "Language")
    configPage.Visible = (tabName == "Configs")

    if tabName == "Main" then
        sectionTitle.Text = "Modules / Main"
    elseif tabName == "Visuals" then
        sectionTitle.Text = "Modules / Visuals"
    elseif tabName == "Teleport" then
        sectionTitle.Text = "Modules / Teleport"
        if refreshTeleportList then refreshTeleportList() end
    elseif tabName == "Language" then
        sectionTitle.Text = "Settings / Language"
    elseif tabName == "Configs" then
        sectionTitle.Text = "Settings / Configs"
    end

    mainTabBtn.BackgroundColor3 = (tabName == "Main") and Color3.fromRGB(85, 50, 22) or Color3.fromRGB(54, 34, 18)
    mainTabBtn.TextColor3 = (tabName == "Main") and Color3.fromRGB(255, 225, 180) or Color3.fromRGB(200, 160, 120)

    visualsTabBtn.BackgroundColor3 = (tabName == "Visuals") and Color3.fromRGB(85, 50, 22) or Color3.fromRGB(54, 34, 18)
    visualsTabBtn.TextColor3 = (tabName == "Visuals") and Color3.fromRGB(255, 225, 180) or Color3.fromRGB(200, 160, 120)

    teleportTabBtn.BackgroundColor3 = (tabName == "Teleport") and Color3.fromRGB(85, 50, 22) or Color3.fromRGB(54, 34, 18)
    teleportTabBtn.TextColor3 = (tabName == "Teleport") and Color3.fromRGB(255, 225, 180) or Color3.fromRGB(200, 160, 120)

    languageTabBtn.BackgroundColor3 = (tabName == "Language") and Color3.fromRGB(85, 50, 22) or Color3.fromRGB(54, 34, 18)
    languageTabBtn.TextColor3 = (tabName == "Language") and Color3.fromRGB(255, 225, 180) or Color3.fromRGB(200, 160, 120)

    configTabBtn.BackgroundColor3 = (tabName == "Configs") and Color3.fromRGB(85, 50, 22) or Color3.fromRGB(54, 34, 18)
    configTabBtn.TextColor3 = (tabName == "Configs") and Color3.fromRGB(255, 225, 180) or Color3.fromRGB(200, 160, 120)
end

mainTabBtn.MouseButton1Click:Connect(function() switchTab("Main") end)
visualsTabBtn.MouseButton1Click:Connect(function() switchTab("Visuals") end)
teleportTabBtn.MouseButton1Click:Connect(function() switchTab("Teleport") end)
languageTabBtn.MouseButton1Click:Connect(function() switchTab("Language") end)
configTabBtn.MouseButton1Click:Connect(function() switchTab("Configs") end)

local autoFarmEnabled = false
local autoFarmLockTarget = true
local autoFarmLowHpFinisher = true
local autoFarmSafeZoneOnHit = true
local selectedStyle = ""

local aimAssistEnabled = false
local aimTargetPart = "Torso"
local aimSmoothness = 0.2

local speedHackEnabled = false
local walkSpeedValue = 32

local fakeDashEnabled = false
local fakeDashKey = Enum.KeyCode.Q
local fakeDashMobileBtnEnabled = false
local isDashing = false

local fullbrightEnabled = false
local scriptVisualsEnabled = false
local worldVisualsEnabled = false
local auraEnabled = false
local selectedAuraMode = "Noob"
local angelWingsEnabled = false

local currentParticleType = "🌸"
local worldParticleType = "🌸"
local worldSpeedMultiplier = 1.0
local currentLanguage = "RU"

local originalAmbient = Lighting.Ambient
local originalOutdoorAmbient = Lighting.OutdoorAmbient

local setAutoFarmUIState = nil
local setAimAssistUIState = nil
local setSpeedHackUIState = nil
local setFakeDashUIState = nil
local setFullbrightUIState = nil
local setScriptVisualsUIState = nil
local setWorldVisualsUIState = nil
local setAuraUIState = nil
local setAngelWingsUIState = nil

local updateAimButtonsVisual = nil
local setAimSliderValue = nil
local setSpeedSliderValue = nil
local refreshAuraPreviewVisual = nil

-- ПРИНЯТИЕ СПОСОБНОСТИ MARTIAL ARTIST В ИГРЕ
local function equipMartialArtistInGame()
    pcall(function()
        local charData = playerGui:FindFirstChild("CharacterData")
        if not charData then return end

        local firedAny = false

        local function triggerButton(btn)
            if not btn or not btn.Parent then return end
            local center = btn.AbsolutePosition + (btn.AbsoluteSize * 0.5)
            if firesignal then
                pcall(function() firesignal(btn.MouseEnter) end)
                pcall(function() firesignal(btn.MouseButton1Down) end)
                pcall(function() firesignal(btn.MouseButton1Up) end)
                pcall(function() firesignal(btn.MouseButton1Click) end)
                pcall(function() firesignal(btn.Activated) end)
            end
            pcall(function()
                VirtualInputManager:SendMouseMoveEvent(center.X, center.Y, game)
                task.wait(0.02)
                VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, true, game, 1)
                task.wait(0.03)
                VirtualInputManager:SendMouseButtonEvent(center.X, center.Y, 0, false, game, 1)
            end)
            pcall(function() btn:Activate() end)
            firedAny = true
        end

        for _, desc in ipairs(charData:GetDescendants()) do
            local nLower = desc.Name:lower()
            local txtLower = (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Text:lower() or ""
            if nLower:find("martial") or txtLower:find("martial artist") then
                if desc:IsA("GuiButton") then
                    triggerButton(desc)
                elseif desc.Parent and desc.Parent:IsA("GuiButton") then
                    triggerButton(desc.Parent)
                else
                    for _, sub in ipairs(desc:GetDescendants()) do
                        if sub:IsA("GuiButton") then
                            triggerButton(sub)
                        end
                    end
                end
            end
        end

        if not firedAny then
            for _, desc in ipairs(charData:GetDescendants()) do
                if desc:IsA("GuiButton") then
                    local t = (desc:IsA("TextButton") and desc.Text:lower()) or ""
                    local n = desc.Name:lower()
                    if t:find("equip") or t:find("select") or n:find("equip") or n:find("select") then
                        triggerButton(desc)
                    end
                end
            end
        end
    end)
end

local translatableCards = {}
local function updateAllTranslations()
    for _, item in ipairs(translatableCards) do
        item.lbl.Text = (currentLanguage == "RU") and item.ru or item.en
    end
end

local cardOrderIndex = 0

local function createModuleCard(parent, title, descRu, descEn, callbackToggle, hasSettings, customSettingsBuilder, customExpandedHeight)
    cardOrderIndex = cardOrderIndex + 1
    local expandedH = customExpandedHeight or 210

    local card = Instance.new("Frame")
    card.Name = "ModuleCard"
    card.Size = UDim2.new(0, 215, 0, 70)
    card.BackgroundColor3 = Color3.fromRGB(58, 36, 20)
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.LayoutOrder = cardOrderIndex
    card.Parent = parent

    local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 10) corner.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Name = "TitleLabel"
    tLbl.Size = UDim2.new(0, 110, 0, 20)
    tLbl.Position = UDim2.new(0, 12, 0, 10)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = Enum.Font.GothamBold
    tLbl.Text = title
    tLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    tLbl.TextSize = 13
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.ZIndex = 3
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(1, -20, 0, 28)
    dLbl.Position = UDim2.new(0, 12, 0, 36)
    dLbl.BackgroundTransparency = 1
    dLbl.Font = Enum.Font.Gotham
    dLbl.Text = (currentLanguage == "RU") and descRu or descEn
    dLbl.TextColor3 = Color3.fromRGB(180, 130, 80)
    dLbl.TextSize = 10
    dLbl.TextWrapped = true
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.ZIndex = 3
    dLbl.Parent = card

    table.insert(translatableCards, {lbl = dLbl, ru = descRu, en = descEn})

    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0, 34, 0, 18)
    toggleFrame.Position = UDim2.new(1, -42, 0, 11)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(40, 24, 15)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ZIndex = 3
    toggleFrame.Parent = card

    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(1, 0) tCorner.Parent = toggleFrame
    local toggleDot = Instance.new("Frame") toggleDot.Size = UDim2.new(0, 14, 0, 14) toggleDot.Position = UDim2.new(0, 2, 0, 2) toggleDot.BackgroundColor3 = Color3.fromRGB(150, 115, 80) toggleDot.BorderSizePixel = 0 toggleDot.ZIndex = 4 toggleDot.Parent = toggleFrame
    local dCorner = Instance.new("UICorner") dCorner.CornerRadius = UDim.new(1, 0) dCorner.Parent = toggleDot

    local clickBtn = Instance.new("TextButton") clickBtn.Size = UDim2.new(1, 0, 1, 0) clickBtn.BackgroundTransparency = 1 clickBtn.Text = "" clickBtn.ZIndex = 5 clickBtn.Parent = card

    local isEnabled = false
    local settingsPanelRef = nil

    local function setVisualState(val, noNotify)
        if title == "AutoFarm" and val and selectedStyle == "" then
            showAbilityErrorNotification(function()
                if settingsPanelRef and not settingsPanelRef.Visible then
                    settingsPanelRef.Visible = true
                    TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 215, 0, expandedH)}):Play()
                end
            end)
            return
        end

        isEnabled = val
        if isEnabled then
            if title == "AutoFarm" and selectedStyle == "MartialArtist" then
                task.spawn(function()
                    equipMartialArtistInGame()
                    task.wait(0.25)
                    equipMartialArtistInGame()
                end)
            end
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 120, 0)}):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -16, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            playEnableSound()
        else
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 24, 15)}):Play()
            TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(150, 115, 80)}):Play()
        end
        if callbackToggle then callbackToggle(isEnabled) end
        if not noNotify then
            local statusStr = isEnabled and "Включено" or "Выключено"
            showNotification(title, statusStr)
        end
    end

    clickBtn.MouseButton1Click:Connect(function()
        setVisualState(not isEnabled, false)
    end)

    if hasSettings then
        local settingsBtn = Instance.new("ImageButton")
        settingsBtn.Size = UDim2.new(0, 16, 0, 16)
        settingsBtn.Position = UDim2.new(1, -64, 0, 12)
        settingsBtn.BackgroundTransparency = 1
        settingsBtn.Image = GEAR_ICON
        settingsBtn.ZIndex = 5
        settingsBtn.Parent = card

        local settingsPanel = Instance.new("Frame")
        settingsPanel.Size = UDim2.new(1, -20, 0, expandedH - 72)
        settingsPanel.Position = UDim2.new(0, 10, 0, 68)
        settingsPanel.BackgroundTransparency = 1
        settingsPanel.Visible = false
        settingsPanel.ZIndex = 10
        settingsPanel.Parent = card
        settingsPanelRef = settingsPanel

        if customSettingsBuilder then
            customSettingsBuilder(settingsPanel, card)
        end

        settingsBtn.MouseButton1Click:Connect(function()
            local isOpen = not settingsPanel.Visible
            settingsPanel.Visible = isOpen
            local targetH = isOpen and expandedH or 70
            TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 215, 0, targetH)}):Play()
        end)
    end

    return card, setVisualState
end

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local query = searchInput.Text:lower()
    for _, page in ipairs({mainPage, visualsPage}) do
        for _, card in ipairs(page:GetChildren()) do
            if card:IsA("Frame") and card.Name == "ModuleCard" then
                local titleLbl = card:FindFirstChild("TitleLabel")
                if titleLbl then
                    local match = titleLbl.Text:lower():find(query)
                    card.Visible = (match ~= nil)
                end
            end
        end
    end
end)

-- 1. AutoFarm
local setAutoFarmUIFunc
_, setAutoFarmUIFunc = createModuleCard(mainPage, "AutoFarm", "Обычные удары, способности и ульта", "Обычные удары, способности и ульта", function(state)
    autoFarmEnabled = state
end, true, function(panel)
    local styleLbl = Instance.new("TextLabel")
    styleLbl.Size = UDim2.new(1, 0, 0, 16)
    styleLbl.Position = UDim2.new(0, 0, 0, 0)
    styleLbl.BackgroundTransparency = 1
    styleLbl.Font = Enum.Font.GothamBold
    styleLbl.Text = "Выберите способность:"
    styleLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    styleLbl.TextSize = 10
    styleLbl.TextXAlignment = Enum.TextXAlignment.Left
    styleLbl.ZIndex = 11
    styleLbl.Parent = panel

    local martialBtn = Instance.new("TextButton")
    martialBtn.Size = UDim2.new(1, 0, 0, 25)
    martialBtn.Position = UDim2.new(0, 0, 0, 17)
    martialBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
    martialBtn.Text = ""
    martialBtn.ZIndex = 11
    martialBtn.Parent = panel
    local mbC = Instance.new("UICorner") mbC.CornerRadius = UDim.new(0, 6) mbC.Parent = martialBtn

    local martialIcon = Instance.new("ImageLabel")
    martialIcon.Size = UDim2.new(0, 16, 0, 16)
    martialIcon.Position = UDim2.new(0, 6, 0.5, -8)
    martialIcon.BackgroundTransparency = 1
    martialIcon.Image = "rbxassetid://79240866082046"
    martialIcon.ZIndex = 12
    martialIcon.Parent = martialBtn

    local martialTextLbl = Instance.new("TextLabel")
    martialTextLbl.Size = UDim2.new(1, -30, 1, 0)
    martialTextLbl.Position = UDim2.new(0, 28, 0, 0)
    martialTextLbl.BackgroundTransparency = 1
    martialTextLbl.Text = "Martial Artist"
    martialTextLbl.TextColor3 = Color3.fromRGB(200, 160, 120)
    martialTextLbl.TextSize = 10
    martialTextLbl.Font = Enum.Font.GothamBold
    martialTextLbl.TextXAlignment = Enum.TextXAlignment.Left
    martialTextLbl.ZIndex = 12
    martialTextLbl.Parent = martialBtn

    martialBtn.MouseButton1Click:Connect(function()
        if selectedStyle == "MartialArtist" then
            selectedStyle = ""
            martialBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            martialTextLbl.TextColor3 = Color3.fromRGB(200, 160, 120)
            showNotification("AutoFarm", "Способность сброшена")
        else
            selectedStyle = "MartialArtist"
            martialBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            martialTextLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            equipMartialArtistInGame()
            showNotification("AutoFarm", "Выбрано: Martial Artist")
        end
    end)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.Position = UDim2.new(0, 0, 0, 46)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "Настройки AutoFarm:"
    lbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11
    lbl.Parent = panel

    local lockBtn = Instance.new("TextButton")
    lockBtn.Size = UDim2.new(1, 0, 0, 22)
    lockBtn.Position = UDim2.new(0, 0, 0, 64)
    lockBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    lockBtn.Text = "Фиксация цели: ON"
    lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockBtn.TextSize = 10
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.ZIndex = 11
    lockBtn.Parent = panel
    local lbC = Instance.new("UICorner") lbC.CornerRadius = UDim.new(0, 6) lbC.Parent = lockBtn

    lockBtn.MouseButton1Click:Connect(function()
        autoFarmLockTarget = not autoFarmLockTarget
        if autoFarmLockTarget then
            lockBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            lockBtn.Text = "Фиксация цели: ON"
        else
            lockBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            lockBtn.Text = "Фиксация цели: OFF"
        end
    end)

    local lowHpBtn = Instance.new("TextButton")
    lowHpBtn.Size = UDim2.new(1, 0, 0, 22)
    lowHpBtn.Position = UDim2.new(0, 0, 0, 90)
    lowHpBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    lowHpBtn.Text = "Добивать шотных (<35 HP): ON"
    lowHpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    lowHpBtn.TextSize = 10
    lowHpBtn.Font = Enum.Font.GothamBold
    lowHpBtn.ZIndex = 11
    lowHpBtn.Parent = panel
    local lhpC = Instance.new("UICorner") lhpC.CornerRadius = UDim.new(0, 6) lhpC.Parent = lowHpBtn

    lowHpBtn.MouseButton1Click:Connect(function()
        autoFarmLowHpFinisher = not autoFarmLowHpFinisher
        if autoFarmLowHpFinisher then
            lowHpBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            lowHpBtn.Text = "Добивать шотных (<35 HP): ON"
        else
            lowHpBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            lowHpBtn.Text = "Добивать шотных (<35 HP): OFF"
        end
    end)

    local safeZoneBtn = Instance.new("TextButton")
    safeZoneBtn.Size = UDim2.new(1, 0, 0, 22)
    safeZoneBtn.Position = UDim2.new(0, 0, 0, 116)
    safeZoneBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    safeZoneBtn.Text = "Безопасная зона при ударе: ON"
    safeZoneBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    safeZoneBtn.TextSize = 9.5
    safeZoneBtn.Font = Enum.Font.GothamBold
    safeZoneBtn.ZIndex = 11
    safeZoneBtn.Parent = panel
    local szC = Instance.new("UICorner") szC.CornerRadius = UDim.new(0, 6) szC.Parent = safeZoneBtn

    safeZoneBtn.MouseButton1Click:Connect(function()
        autoFarmSafeZoneOnHit = not autoFarmSafeZoneOnHit
        if autoFarmSafeZoneOnHit then
            safeZoneBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            safeZoneBtn.Text = "Безопасная зона при ударе: ON"
        else
            safeZoneBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            safeZoneBtn.Text = "Безопасная зона при ударе: OFF"
        end
    end)
end, 236)
setAutoFarmUIState = setAutoFarmUIFunc

-- 2. Aim Assist
local setAimUIFunc
_, setAimUIFunc = createModuleCard(mainPage, "Aim Assist", "Автонаведение на цель", "Автонаведение на цель", function(state)
    aimAssistEnabled = state
end, true, function(panel)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "Целься в:"
    lbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11
    lbl.Parent = panel

    local torsoBtn = Instance.new("TextButton")
    torsoBtn.Size = UDim2.new(0, 85, 0, 22)
    torsoBtn.Position = UDim2.new(0, 0, 0, 20)
    torsoBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    torsoBtn.Text = "Туловище"
    torsoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    torsoBtn.TextSize = 10
    torsoBtn.Font = Enum.Font.GothamBold
    torsoBtn.ZIndex = 11
    torsoBtn.Parent = panel
    local tbC = Instance.new("UICorner") tbC.CornerRadius = UDim.new(0, 6) tbC.Parent = torsoBtn

    local headBtn = Instance.new("TextButton")
    headBtn.Size = UDim2.new(0, 85, 0, 22)
    headBtn.Position = UDim2.new(0, 95, 0, 20)
    headBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
    headBtn.Text = "Голова"
    headBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
    headBtn.TextSize = 10
    headBtn.Font = Enum.Font.GothamBold
    headBtn.ZIndex = 11
    headBtn.Parent = panel
    local hbC = Instance.new("UICorner") hbC.CornerRadius = UDim.new(0, 6) hbC.Parent = headBtn

    updateAimButtonsVisual = function(partName)
        if partName == "Torso" then
            torsoBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            torsoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            headBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            headBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
        else
            headBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            headBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            torsoBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            torsoBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
        end
    end

    torsoBtn.MouseButton1Click:Connect(function() aimTargetPart = "Torso" updateAimButtonsVisual("Torso") end)
    headBtn.MouseButton1Click:Connect(function() aimTargetPart = "Head" updateAimButtonsVisual("Head") end)

    local sliderLbl = Instance.new("TextLabel")
    sliderLbl.Size = UDim2.new(1, 0, 0, 16)
    sliderLbl.Position = UDim2.new(0, 0, 0, 48)
    sliderLbl.BackgroundTransparency = 1
    sliderLbl.Font = Enum.Font.GothamBold
    sliderLbl.Text = "Плавность:"
    sliderLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    sliderLbl.TextSize = 9
    sliderLbl.TextXAlignment = Enum.TextXAlignment.Left
    sliderLbl.ZIndex = 11
    sliderLbl.Parent = panel

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 180, 0, 6)
    sliderBg.Position = UDim2.new(0, 5, 0, 72)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 24, 15)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 11
    sliderBg.Parent = panel
    local sBgCorner = Instance.new("UICorner") sBgCorner.CornerRadius = UDim.new(1, 0) sBgCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 12
    sliderFill.Parent = sliderBg
    local sFillCorner = Instance.new("UICorner") sFillCorner.CornerRadius = UDim.new(1, 0) sFillCorner.Parent = sliderFill

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 20, 1, 20)
    sliderBtn.Position = UDim2.new(0, -10, 0, -10)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 14
    sliderBtn.Parent = sliderBg

    local draggingSlider = false
    setAimSliderValue = function(val)
        local pos = math.clamp((0.8 - val) / (0.8 - 0.05), 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        aimSmoothness = val
    end

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        aimSmoothness = 0.8 - (pos * 0.75)
    end

    sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSlider = false end end)
    UserInputService.InputChanged:Connect(function(input) if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)

    setAimSliderValue(aimSmoothness)
end)
setAimAssistUIState = setAimUIFunc

-- 3. SpeedHack
local setSpeedUIFunc
_, setSpeedUIFunc = createModuleCard(mainPage, "SpeedHack", "Увеличение скорости бега", "Увеличение скорости бега", function(state)
    speedHackEnabled = state
end, true, function(panel)
    local sliderLbl = Instance.new("TextLabel")
    sliderLbl.Size = UDim2.new(1, 0, 0, 16)
    sliderLbl.Position = UDim2.new(0, 0, 0, 10)
    sliderLbl.BackgroundTransparency = 1
    sliderLbl.Font = Enum.Font.GothamBold
    sliderLbl.Text = "Скорость (16 - 150):"
    sliderLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    sliderLbl.TextSize = 10
    sliderLbl.TextXAlignment = Enum.TextXAlignment.Left
    sliderLbl.ZIndex = 11
    sliderLbl.Parent = panel

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 180, 0, 6)
    sliderBg.Position = UDim2.new(0, 5, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 24, 15)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 11
    sliderBg.Parent = panel
    local sBgCorner = Instance.new("UICorner") sBgCorner.CornerRadius = UDim.new(1, 0) sBgCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.2, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 12
    sliderFill.Parent = sliderBg
    local sFillCorner = Instance.new("UICorner") sFillCorner.CornerRadius = UDim.new(1, 0) sFillCorner.Parent = sliderFill

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 20, 1, 20)
    sliderBtn.Position = UDim2.new(0, -10, 0, -10)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 14
    sliderBtn.Parent = sliderBg

    local draggingSpeed = false
    setSpeedSliderValue = function(val)
        local pos = math.clamp((val - 16) / (150 - 16), 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        walkSpeedValue = val
    end

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        walkSpeedValue = math.floor(16 + (pos * (150 - 16)))
    end

    sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSpeed = false end end)
    UserInputService.InputChanged:Connect(function(input) if draggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)

    setSpeedSliderValue(walkSpeedValue)
end)
setSpeedHackUIState = setSpeedUIFunc

local function enableDragging(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.InputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local mobileDashBtn = Instance.new("Frame")
mobileDashBtn.Name = "MobileDashBtn"
mobileDashBtn.Size = UDim2.new(0, 60, 0, 60)
mobileDashBtn.Position = UDim2.new(0.8, 0, 0.6, 0)
mobileDashBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
mobileDashBtn.BackgroundTransparency = 0.2
mobileDashBtn.Visible = false
mobileDashBtn.ZIndex = 200
mobileDashBtn.Parent = screenGui

local mdCorner = Instance.new("UICorner") mdCorner.CornerRadius = UDim.new(1, 0) mdCorner.Parent = mobileDashBtn
local mdLbl = Instance.new("TextLabel") mdLbl.Size = UDim2.new(1, 0, 1, 0) mdLbl.BackgroundTransparency = 1 mdLbl.Font = Enum.Font.GothamBold mdLbl.Text = "DASH" mdLbl.TextColor3 = Color3.fromRGB(255, 255, 255) mdLbl.TextSize = 13 mdLbl.ZIndex = 201 mdLbl.Parent = mobileDashBtn
local mdClick = Instance.new("TextButton") mdClick.Size = UDim2.new(1, 0, 1, 0) mdClick.BackgroundTransparency = 1 mdClick.Text = "" mdClick.ZIndex = 202 mdClick.Parent = mobileDashBtn

local performFakeDash
mdClick.MouseButton1Click:Connect(function()
    if fakeDashEnabled and performFakeDash then
        performFakeDash()
    end
end)

-- 4. Fake Dash
local setDashUIFunc
_, setDashUIFunc = createModuleCard(mainPage, "Fake Dash", "Анимация и перемещение рывка без урона", "Анимация и перемещение рывка без урона", function(state)
    fakeDashEnabled = state
    if not fakeDashEnabled then
        mobileDashBtn.Visible = false
    else
        mobileDashBtn.Visible = fakeDashMobileBtnEnabled
    end
end, true, function(panel)
    local keyLbl = Instance.new("TextLabel")
    keyLbl.Size = UDim2.new(1, 0, 0, 16)
    keyLbl.Position = UDim2.new(0, 0, 0, 2)
    keyLbl.BackgroundTransparency = 1
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.Text = "Клавиша рывка (ПК):"
    keyLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    keyLbl.TextSize = 10
    keyLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyLbl.ZIndex = 11
    keyLbl.Parent = panel

    local keyBtn = Instance.new("TextButton")
    keyBtn.Size = UDim2.new(0, 90, 0, 22)
    keyBtn.Position = UDim2.new(0, 0, 0, 20)
    keyBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
    keyBtn.Text = "[" .. fakeDashKey.Name .. "]"
    keyBtn.TextColor3 = Color3.fromRGB(255, 180, 90)
    keyBtn.TextSize = 10
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.ZIndex = 11
    keyBtn.Parent = panel
    local kbC = Instance.new("UICorner") kbC.CornerRadius = UDim.new(0, 6) kbC.Parent = keyBtn

    local listeningForKey = false
    keyBtn.MouseButton1Click:Connect(function()
        listeningForKey = true
        keyBtn.Text = "[Жми...]"
        keyBtn.TextColor3 = Color3.fromRGB(255, 120, 0)
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
            listeningForKey = false
            fakeDashKey = input.KeyCode
            keyBtn.Text = "[" .. fakeDashKey.Name .. "]"
            keyBtn.TextColor3 = Color3.fromRGB(255, 180, 90)
        end
    end)

    local mobBtnToggle = Instance.new("TextButton")
    mobBtnToggle.Size = UDim2.new(0, 180, 0, 26)
    mobBtnToggle.Position = UDim2.new(0, 0, 0, 48)
    mobBtnToggle.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
    mobBtnToggle.Text = "Кнопка (телефон): OFF"
    mobBtnToggle.TextColor3 = Color3.fromRGB(200, 160, 120)
    mobBtnToggle.TextSize = 9
    mobBtnToggle.Font = Enum.Font.GothamBold
    mobBtnToggle.ZIndex = 11
    mobBtnToggle.Parent = panel
    local mbtC = Instance.new("UICorner") mbtC.CornerRadius = UDim.new(0, 6) mbtC.Parent = mobBtnToggle

    mobBtnToggle.MouseButton1Click:Connect(function()
        fakeDashMobileBtnEnabled = not fakeDashMobileBtnEnabled
        if fakeDashMobileBtnEnabled then
            mobBtnToggle.Text = "Кнопка (телефон): ON"
            mobBtnToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            mobBtnToggle.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
            if fakeDashEnabled then mobileDashBtn.Visible = true end
        else
            mobBtnToggle.Text = "Кнопка (телефон): OFF"
            mobBtnToggle.TextColor3 = Color3.fromRGB(200, 160, 120)
            mobBtnToggle.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            mobileDashBtn.Visible = false
        end
    end)
end)
setFakeDashUIState = setDashUIFunc

performFakeDash = function()
    local char = player.Character
    if not char or isDashing then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end

    isDashing = true

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        local dashAnim = Instance.new("Animation")
        dashAnim.AnimationId = "rbxassetid://10479335381"
        local track = animator:LoadAnimation(dashAnim)
        track.Priority = Enum.AnimationPriority.Action
        track:Play()
    end

    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude == 0 then
        moveDir = root.CFrame.LookVector
    end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
    bodyVelocity.Velocity = moveDir * 65
    bodyVelocity.Parent = root

    task.wait(0.25)
    bodyVelocity:Destroy()
    isDashing = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if fakeDashEnabled and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == fakeDashKey then
        performFakeDash()
    end
end)

-- Visuals
createModuleCard(visualsPage, "Fullbright", "Максимально светлое освещение карты", "Максимально светлое освещение карты", function(state)
    fullbrightEnabled = state
    if fullbrightEnabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.Ambient = originalAmbient
        Lighting.OutdoorAmbient = originalOutdoorAmbient
    end
end, false)

local setScriptVisualsUIFunc
_, setScriptVisualsUIFunc = createModuleCard(visualsPage, "Script Visuals", "Падающие стикеры в меню", "Падающие стикеры в меню", function(state)
    scriptVisualsEnabled = state
end, true, function(panel)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "Выберите стиль меню:"
    lbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11
    lbl.Parent = panel

    local btn1 = Instance.new("TextButton") btn1.Size = UDim2.new(0, 32, 0, 24) btn1.Position = UDim2.new(0, 0, 0, 22) btn1.BackgroundColor3 = Color3.fromRGB(255, 120, 0) btn1.Text = "🌸" btn1.TextColor3 = Color3.fromRGB(255, 255, 255) btn1.TextSize = 12 btn1.Font = Enum.Font.GothamBold btn1.ZIndex = 11 btn1.Parent = panel local c1 = Instance.new("UICorner") c1.CornerRadius = UDim.new(0, 6) c1.Parent = btn1
    local btn2 = Instance.new("TextButton") btn2.Size = UDim2.new(0, 32, 0, 24) btn2.Position = UDim2.new(0, 36, 0, 22) btn2.BackgroundColor3 = Color3.fromRGB(50, 28, 14) btn2.Text = "❤️" btn2.TextColor3 = Color3.fromRGB(200, 160, 120) btn2.TextSize = 12 btn2.Font = Enum.Font.GothamBold btn2.ZIndex = 11 btn2.Parent = panel local c2 = Instance.new("UICorner") c2.CornerRadius = UDim.new(0, 6) c2.Parent = btn2
    local btn3 = Instance.new("TextButton") btn3.Size = UDim2.new(0, 32, 0, 24) btn3.Position = UDim2.new(0, 72, 0, 22) btn3.BackgroundColor3 = Color3.fromRGB(50, 28, 14) btn3.Text = "⭐" btn3.TextColor3 = Color3.fromRGB(200, 160, 120) btn3.TextSize = 12 btn3.Font = Enum.Font.GothamBold btn3.ZIndex = 11 btn3.Parent = panel local c3 = Instance.new("UICorner") c3.CornerRadius = UDim.new(0, 6) c3.Parent = btn3
    local btn4 = Instance.new("TextButton") btn4.Size = UDim2.new(0, 38, 0, 24) btn4.Position = UDim2.new(0, 108, 0, 22) btn4.BackgroundColor3 = Color3.fromRGB(50, 28, 14) btn4.Text = "🍃" btn4.TextColor3 = Color3.fromRGB(200, 160, 120) btn4.TextSize = 12 btn4.Font = Enum.Font.GothamBold btn4.ZIndex = 11 btn4.Parent = panel local c4 = Instance.new("UICorner") c4.CornerRadius = UDim.new(0, 6) c4.Parent = btn4
    local btn5 = Instance.new("TextButton") btn5.Size = UDim2.new(0, 38, 0, 24) btn5.Position = UDim2.new(0, 150, 0, 22) btn5.BackgroundColor3 = Color3.fromRGB(50, 28, 14) btn5.Text = "❄️" btn5.TextColor3 = Color3.fromRGB(200, 160, 120) btn5.TextSize = 12 btn5.Font = Enum.Font.GothamBold btn5.ZIndex = 11 btn5.Parent = panel local c5 = Instance.new("UICorner") c5.CornerRadius = UDim.new(0, 6) c5.Parent = btn5

    local function updateParticleButtons(pType)
        currentParticleType = pType
        local buttons = { {btn1, "🌸"}, {btn2, "❤️"}, {btn3, "⭐"}, {btn4, "🍃"}, {btn5, "❄️"} }
        for _, pair in ipairs(buttons) do
            local active = (pair[2] == pType)
            pair[1].BackgroundColor3 = active and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(50, 28, 14)
            pair[1].TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 160, 120)
        end
    end

    btn1.MouseButton1Click:Connect(function() updateParticleButtons("🌸") end)
    btn2.MouseButton1Click:Connect(function() updateParticleButtons("❤️") end)
    btn3.MouseButton1Click:Connect(function() updateParticleButtons("⭐") end)
    btn4.MouseButton1Click:Connect(function() updateParticleButtons("🍃") end)
    btn5.MouseButton1Click:Connect(function() updateParticleButtons("❄️") end)
end)
setScriptVisualsUIState = setScriptVisualsUIFunc

local setWorldVisualsUIFunc
_, setWorldVisualsUIFunc = createModuleCard(visualsPage, "World Visual", "Стикеры падают вокруг вас в мире", "Стикеры падают вокруг вас в мире", function(state)
    worldVisualsEnabled = state
end, true, function(panel)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "Выберите стиль мира:"
    lbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11
    lbl.Parent = panel

    local wbtn1 = Instance.new("TextButton") wbtn1.Size = UDim2.new(0, 32, 0, 22) wbtn1.Position = UDim2.new(0, 0, 0, 20) wbtn1.BackgroundColor3 = Color3.fromRGB(255, 120, 0) wbtn1.Text = "🌸" wbtn1.TextColor3 = Color3.fromRGB(255, 255, 255) wbtn1.TextSize = 11 wbtn1.Font = Enum.Font.GothamBold wbtn1.ZIndex = 11 wbtn1.Parent = panel local wc1 = Instance.new("UICorner") wc1.CornerRadius = UDim.new(0, 6) wc1.Parent = wbtn1
    local wbtn2 = Instance.new("TextButton") wbtn2.Size = UDim2.new(0, 32, 0, 22) wbtn2.Position = UDim2.new(0, 36, 0, 20) wbtn2.BackgroundColor3 = Color3.fromRGB(50, 28, 14) wbtn2.Text = "❤️" wbtn2.TextColor3 = Color3.fromRGB(200, 160, 120) wbtn2.TextSize = 11 wbtn2.Font = Enum.Font.GothamBold wbtn2.ZIndex = 11 wbtn2.Parent = panel local wc2 = Instance.new("UICorner") wc2.CornerRadius = UDim.new(0, 6) wc2.Parent = wbtn2
    local wbtn3 = Instance.new("TextButton") wbtn3.Size = UDim2.new(0, 32, 0, 22) wbtn3.Position = UDim2.new(0, 72, 0, 20) wbtn3.BackgroundColor3 = Color3.fromRGB(50, 28, 14) wbtn3.Text = "⭐" wbtn3.TextColor3 = Color3.fromRGB(200, 160, 120) wbtn3.TextSize = 11 wbtn3.Font = Enum.Font.GothamBold wbtn3.ZIndex = 11 wbtn3.Parent = panel local wc3 = Instance.new("UICorner") wc3.CornerRadius = UDim.new(0, 6) wc3.Parent = wbtn3
    local wbtn4 = Instance.new("TextButton") wbtn4.Size = UDim2.new(0, 38, 0, 22) wbtn4.Position = UDim2.new(0, 108, 0, 20) wbtn4.BackgroundColor3 = Color3.fromRGB(50, 28, 14) wbtn4.Text = "🍃" wbtn4.TextColor3 = Color3.fromRGB(200, 160, 120) wbtn4.TextSize = 11 wbtn4.Font = Enum.Font.GothamBold wbtn4.ZIndex = 11 wbtn4.Parent = panel local wc4 = Instance.new("UICorner") wc4.CornerRadius = UDim.new(0, 6) wc4.Parent = wbtn4
    local wbtn5 = Instance.new("TextButton") wbtn5.Size = UDim2.new(0, 38, 0, 22) wbtn5.Position = UDim2.new(0, 150, 0, 20) wbtn5.BackgroundColor3 = Color3.fromRGB(50, 28, 14) wbtn5.Text = "❄️" wbtn5.TextColor3 = Color3.fromRGB(200, 160, 120) wbtn5.TextSize = 11 wbtn5.Font = Enum.Font.GothamBold wbtn5.ZIndex = 11 wbtn5.Parent = panel local wc5 = Instance.new("UICorner") wc5.CornerRadius = UDim.new(0, 6) wc5.Parent = wbtn5

    local function updateWorldParticleButtons(pType)
        worldParticleType = pType
        local buttons = { {wbtn1, "🌸"}, {wbtn2, "❤️"}, {wbtn3, "⭐"}, {wbtn4, "🍃"}, {wbtn5, "❄️"} }
        for _, pair in ipairs(buttons) do
            local active = (pair[2] == pType)
            pair[1].BackgroundColor3 = active and Color3.fromRGB(255, 120, 0) or Color3.fromRGB(50, 28, 14)
            pair[1].TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 160, 120)
        end
    end

    wbtn1.MouseButton1Click:Connect(function() updateWorldParticleButtons("🌸") end)
    wbtn2.MouseButton1Click:Connect(function() updateWorldParticleButtons("❤️") end)
    wbtn3.MouseButton1Click:Connect(function() updateWorldParticleButtons("⭐") end)
    wbtn4.MouseButton1Click:Connect(function() updateWorldParticleButtons("🍃") end)
    wbtn5.MouseButton1Click:Connect(function() updateWorldParticleButtons("❄️") end)

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1, 0, 0, 16)
    speedLbl.Position = UDim2.new(0, 0, 0, 48)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Font = Enum.Font.GothamBold
    speedLbl.Text = "Скорость падения:"
    speedLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
    speedLbl.TextSize = 9
    speedLbl.TextXAlignment = Enum.TextXAlignment.Left
    speedLbl.ZIndex = 11
    speedLbl.Parent = panel

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0, 180, 0, 6)
    sliderBg.Position = UDim2.new(0, 5, 0, 70)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 24, 15)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 11
    sliderBg.Parent = panel
    local sBgCorner = Instance.new("UICorner") sBgCorner.CornerRadius = UDim.new(1, 0) sBgCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 12
    sliderFill.Parent = sliderBg
    local sFillCorner = Instance.new("UICorner") sFillCorner.CornerRadius = UDim.new(1, 0) sFillCorner.Parent = sliderFill

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 20, 1, 20)
    sliderBtn.Position = UDim2.new(0, -10, 0, -10)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 14
    sliderBtn.Parent = sliderBg

    local draggingWorldSpeed = false
    local function updateWorldSpeedSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        worldSpeedMultiplier = 0.3 + (pos * 2.2)
    end

    sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingWorldSpeed = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingWorldSpeed = false end end)
    UserInputService.InputChanged:Connect(function(input) if draggingWorldSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateWorldSpeedSlider(input) end end)
end)
setWorldVisualsUIState = setWorldVisualsUIFunc

-- СИСТЕМА АУР И ПРЕДПРОСМОТРА (СКРИПТ ОТ CHATGPT)
local activeAuraConnection = nil
local activeAuraFolder = nil

local previewAuraFolder = nil
local previewConnection = nil
local previewCharModel = nil
local previewWorld = nil
local previewCamera = nil

local function disconnect(connection)
    if connection then
        connection:Disconnect()
    end
end

local function removeActiveAura()
    disconnect(activeAuraConnection)
    activeAuraConnection = nil

    if activeAuraFolder then
        activeAuraFolder:Destroy()
        activeAuraFolder = nil
    end

    local char = player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, name in ipairs({
        "AuraAttachment",
        "FlameCoreAttachment",
        "FlameTonguesAttachment",
        "EnergySmokeAttachment",
        "PurpleFlameLight"
    }) do
        local object = root:FindFirstChild(name)
        if object then
            object:Destroy()
        end
    end
end

local function buildRealAura(char, root, mode)
    local folder = Instance.new("Folder")
    folder.Name = mode == "Fire" and "FirePurpleAura" or "NoobPsyAura"
    folder.Parent = Workspace

    local pulse = 0
    local light
    local highlight
    local emitter

    if mode == "Fire" then
        local coreAtt = Instance.new("Attachment")
        coreAtt.Name = "FlameCoreAttachment"
        coreAtt.Position = Vector3.new(0, -0.5, 0)
        coreAtt.Parent = root

        local tonguesAtt = Instance.new("Attachment")
        tonguesAtt.Name = "FlameTonguesAttachment"
        tonguesAtt.Position = Vector3.new(0, -1.2, 0)
        tonguesAtt.Parent = root

        local smokeAtt = Instance.new("Attachment")
        smokeAtt.Name = "EnergySmokeAttachment"
        smokeAtt.Position = Vector3.new(0, 0.2, 0)
        smokeAtt.Parent = root

        local core = Instance.new("ParticleEmitter")
        core.Name = "CoreFlame"
        core.Texture = "rbxasset://textures/particles/fire_main.dds"
        core.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 140, 255)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(155, 45, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(88, 12, 185))
        })
        core.LightEmission = 1
        core.Rate = 65
        core.Lifetime = NumberRange.new(0.45, 0.85)
        core.Speed = NumberRange.new(3.5, 6.5)
        core.SpreadAngle = Vector2.new(28, 28)
        core.Acceleration = Vector3.new(0, 12, 0)
        core.RotSpeed = NumberRange.new(-90, 90)
        core.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.3),
            NumberSequenceKeypoint.new(0.4, 2.2),
            NumberSequenceKeypoint.new(1, 0.1)
        })
        core.Parent = coreAtt

        local outer = Instance.new("ParticleEmitter")
        outer.Name = "OuterFlame"
        outer.Texture = "rbxasset://textures/particles/fire_main.dds"
        outer.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(115, 20, 210)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(68, 8, 145)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 3, 68))
        })
        outer.LightEmission = 0.8
        outer.Rate = 55
        outer.Lifetime = NumberRange.new(0.6, 1.1)
        outer.Speed = NumberRange.new(2.5, 5.2)
        outer.SpreadAngle = Vector2.new(45, 45)
        outer.Acceleration = Vector3.new(0, 9.5, 0)
        outer.RotSpeed = NumberRange.new(-110, 110)
        outer.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.8),
            NumberSequenceKeypoint.new(0.5, 2.9),
            NumberSequenceKeypoint.new(1, 0.2)
        })
        outer.Parent = tonguesAtt

        local smoke = Instance.new("ParticleEmitter")
        smoke.Name = "EnergySmoke"
        smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
        smoke.Color = ColorSequence.new(
            Color3.fromRGB(92, 24, 168),
            Color3.fromRGB(18, 4, 38)
        )
        smoke.Rate = 28
        smoke.Lifetime = NumberRange.new(0.8, 1.4)
        smoke.Speed = NumberRange.new(1.8, 3.8)
        smoke.SpreadAngle = Vector2.new(55, 55)
        smoke.Acceleration = Vector3.new(0, 7, 0)
        smoke.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.4),
            NumberSequenceKeypoint.new(0.6, 2.7),
            NumberSequenceKeypoint.new(1, 3.4)
        })
        smoke.Parent = smokeAtt

        light = Instance.new("PointLight")
        light.Name = "PurpleFlameLight"
        light.Color = Color3.fromRGB(155, 55, 255)
        light.Brightness = 4
        light.Range = 14
        light.Parent = root

        highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(130, 35, 245)
        highlight.OutlineColor = Color3.fromRGB(195, 110, 255)
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0.15
        highlight.Parent = folder

    else
        local attachment = Instance.new("Attachment")
        attachment.Name = "AuraAttachment"
        attachment.Parent = root

        emitter = Instance.new("ParticleEmitter")
        emitter.Name = "NoobAuraParticles"
        emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"

        emitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 50, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(65, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
        })

        emitter.LightEmission = 1
        emitter.LightInfluence = 0
        emitter.Rate = 110
        emitter.Lifetime = NumberRange.new(0.5, 1.2)
        emitter.Speed = NumberRange.new(2, 5)
        emitter.SpreadAngle = Vector2.new(180, 180)
        emitter.RotSpeed = NumberRange.new(-180, 180)

        emitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.5, 0.95),
            NumberSequenceKeypoint.new(1, 0)
        })

        emitter.Parent = attachment

        highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(125, 50, 255)
        highlight.OutlineColor = Color3.fromRGB(65, 160, 255)
        highlight.FillTransparency = 0.68
        highlight.OutlineTransparency = 0.1
        highlight.Parent = folder
    end

    local connection = RunService.RenderStepped:Connect(function(dt)
        if not char.Parent or not root.Parent then
            return
        end

        pulse += dt * 3

        local wave = (math.sin(pulse) + 1) * 0.5

        if light then
            light.Brightness = 3.2 + wave * 1.8
        end

        if highlight then
            highlight.FillTransparency = 0.8 - wave * 0.15
            highlight.OutlineTransparency = 0.35 - wave * 0.2
        end

        if emitter then
            emitter.Rate = 80 + wave * 70
        end
    end)

    return folder, connection
end

local function applyActiveAura(char)
    removeActiveAura()

    if not auraEnabled or not char then
        return
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    activeAuraFolder, activeAuraConnection =
        buildRealAura(char, root, selectedAuraMode)
end

local function createNeonPart(parent, name, color, size)
    local part = Instance.new("Part")

    part.Name = name
    part.Shape = Enum.PartType.Ball
    part.Size = size
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Transparency = 0.12

    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false

    part.Parent = parent

    return part
end

local function clearPreviewAura()
    disconnect(previewConnection)
    previewConnection = nil

    if previewAuraFolder then
        previewAuraFolder:Destroy()
        previewAuraFolder = nil
    end
end

local function buildPreviewAura()
    clearPreviewAura()

    if not previewCharModel or not previewWorld then
        return
    end

    local root = previewCharModel:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end

    local folder = Instance.new("Folder")
    folder.Name = "PreviewAuraEffects"
    folder.Parent = previewWorld

    previewAuraFolder = folder

    local objects = {}
    local time = 0

    if selectedAuraMode == "Noob" then

        local colors = {
            Color3.fromRGB(125, 50, 255),
            Color3.fromRGB(65, 160, 255),
            Color3.fromRGB(200, 100, 255),
            Color3.fromRGB(170, 100, 255)
        }

        for i = 1, 16 do
            local angle = (i / 16) * math.pi * 2

            local part = createNeonPart(
                folder,
                "NoobParticle_" .. i,
                colors[(i % #colors) + 1],
                Vector3.new(0.17, 0.17, 0.17)
            )

            table.insert(objects, {
                part = part,
                angle = angle,
                height = (i % 5) * 0.55 - 0.8,
                radius = 1.15 + (i % 3) * 0.16,
                speed = 0.8 + (i % 4) * 0.15,
                size = 0.12 + (i % 3) * 0.045
            })
        end

    elseif selectedAuraMode == "Fire" then

        local colors = {
            Color3.fromRGB(210, 100, 255),
            Color3.fromRGB(160, 35, 255),
            Color3.fromRGB(105, 15, 210),
            Color3.fromRGB(240, 160, 255)
        }

        for i = 1, 20 do
            local angle = (i / 20) * math.pi * 2

            local part = createNeonPart(
                folder,
                "FireParticle_" .. i,
                colors[(i % #colors) + 1],
                Vector3.new(0.2, 0.55, 0.2)
            )

            table.insert(objects, {
                part = part,
                angle = angle,
                height = (i % 6) * 0.4 - 1,
                radius = 0.95 + (i % 4) * 0.2,
                speed = 1.1 + (i % 5) * 0.18,
                size = 0.2 + (i % 3) * 0.07
            })
        end

        for i = 1, 8 do
            local part = createNeonPart(
                folder,
                "FireGlow_" .. i,
                Color3.fromRGB(155, 45, 255),
                Vector3.new(0.32, 0.32, 0.32)
            )

            part.Transparency = 0.45

            table.insert(objects, {
                part = part,
                angle = (i / 8) * math.pi * 2,
                height = -1.3 + (i % 4) * 0.8,
                radius = 1.35,
                speed = -0.6,
                size = 0.32
            })
        end
    end

    previewConnection = RunService.RenderStepped:Connect(function(dt)
        if not root.Parent or not folder.Parent then
            return
        end

        time += dt

        for _, data in ipairs(objects) do
            local angle = data.angle + time * data.speed

            local height = data.height +
                math.sin(time * 2 + data.angle) * 0.22

            local radius = data.radius +
                math.sin(time * 1.5 + data.angle) * 0.08

            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius

            local position = root.CFrame:PointToWorldSpace(
                Vector3.new(x, height, z)
            )

            local part = data.part

            part.Position = position

            local pulse = (math.sin(time * 4 + data.angle) + 1) / 2

            local scale = data.size * (0.8 + pulse * 0.4)

            if selectedAuraMode == "Fire" then
                part.Size = Vector3.new(
                    scale,
                    scale * 2.2,
                    scale
                )

                part.CFrame = CFrame.new(position) *
                    CFrame.Angles(
                        math.sin(time * 3 + data.angle) * 0.3,
                        angle,
                        math.cos(time * 2 + data.angle) * 0.3
                    )
            else
                part.Size = Vector3.new(scale, scale, scale)
            end
        end
    end)
end

local function buildAuraPreviewUI(panel)
    local pickLbl = Instance.new("TextLabel")
    pickLbl.Name = "AuraTitle"
    pickLbl.Size = UDim2.new(1, 0, 0, 18)
    pickLbl.Position = UDim2.new(0, 0, 0, 0)
    pickLbl.BackgroundTransparency = 1
    pickLbl.Font = Enum.Font.GothamBold
    pickLbl.Text = "Выберите ауру:"
    pickLbl.TextColor3 = Color3.fromRGB(240, 225, 255)
    pickLbl.TextSize = 11
    pickLbl.TextXAlignment = Enum.TextXAlignment.Left
    pickLbl.ZIndex = 11
    pickLbl.Parent = panel

    local noobBtn = Instance.new("TextButton")
    noobBtn.Name = "NoobAuraButton"
    noobBtn.Size = UDim2.new(0, 92, 0, 25)
    noobBtn.Position = UDim2.new(0, 0, 0, 20)
    noobBtn.BackgroundColor3 = Color3.fromRGB(120, 65, 220)
    noobBtn.Text = "Нуб-аура"
    noobBtn.TextColor3 = Color3.new(1, 1, 1)
    noobBtn.TextSize = 10
    noobBtn.Font = Enum.Font.GothamBold
    noobBtn.ZIndex = 11
    noobBtn.Parent = panel

    Instance.new("UICorner", noobBtn).CornerRadius = UDim.new(0, 7)

    local fireBtn = Instance.new("TextButton")
    fireBtn.Name = "FireAuraButton"
    fireBtn.Size = UDim2.new(0, 98, 0, 25)
    fireBtn.Position = UDim2.new(0, 97, 0, 20)
    fireBtn.BackgroundColor3 = Color3.fromRGB(35, 25, 50)
    fireBtn.Text = "Огневая аура"
    fireBtn.TextColor3 = Color3.fromRGB(210, 185, 230)
    fireBtn.TextSize = 10
    fireBtn.Font = Enum.Font.GothamBold
    fireBtn.ZIndex = 11
    fireBtn.Parent = panel

    Instance.new("UICorner", fireBtn).CornerRadius = UDim.new(0, 7)

    local previewContainer = Instance.new("Frame")
    previewContainer.Name = "PreviewContainer"
    previewContainer.Size = UDim2.new(0, 195, 0, 152)
    previewContainer.Position = UDim2.new(0, 0, 0, 50)
    previewContainer.BackgroundColor3 = Color3.fromRGB(17, 13, 29)
    previewContainer.BackgroundTransparency = 0
    previewContainer.BorderSizePixel = 0
    previewContainer.ClipsDescendants = true
    previewContainer.ZIndex = 11
    previewContainer.Parent = panel

    Instance.new("UICorner", previewContainer).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(110, 65, 180)
    stroke.Transparency = 0.35
    stroke.Thickness = 1
    stroke.Parent = previewContainer

    local prevTitle = Instance.new("TextLabel")
    prevTitle.Size = UDim2.new(1, -12, 0, 18)
    prevTitle.Position = UDim2.new(0, 8, 0, 4)
    prevTitle.BackgroundTransparency = 1
    prevTitle.Font = Enum.Font.GothamBold
    prevTitle.Text = "LIVE PREVIEW"
    prevTitle.TextColor3 = Color3.fromRGB(210, 175, 255)
    prevTitle.TextSize = 10
    prevTitle.TextXAlignment = Enum.TextXAlignment.Left
    prevTitle.ZIndex = 12
    prevTitle.Parent = previewContainer

    local viewport = Instance.new("ViewportFrame")
    viewport.Name = "AuraViewport"
    viewport.Size = UDim2.new(1, -10, 1, -28)
    viewport.Position = UDim2.new(0, 5, 0, 23)
    viewport.BackgroundColor3 = Color3.fromRGB(19, 13, 32)
    viewport.BackgroundTransparency = 0
    viewport.Ambient = Color3.fromRGB(180, 165, 210)
    viewport.LightColor = Color3.fromRGB(255, 240, 255)
    viewport.LightDirection = Vector3.new(-0.5, -1, -0.5)
    viewport.ZIndex = 12
    viewport.Parent = previewContainer

    Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 8)

    previewWorld = Instance.new("WorldModel")
    previewWorld.Name = "AuraPreviewWorld"
    previewWorld.Parent = viewport

    previewCamera = Instance.new("Camera")
    previewCamera.Name = "AuraPreviewCamera"
    previewCamera.FieldOfView = 40
    previewCamera.Parent = viewport

    viewport.CurrentCamera = previewCamera

    local function createPreviewCharacter()
        if previewCharModel then
            previewCharModel:Destroy()
            previewCharModel = nil
        end

        local character = player.Character

        if not character then
            return false
        end

        local oldArchivable = character.Archivable
        character.Archivable = true

        local success, clone = pcall(function()
            return character:Clone()
        end)

        character.Archivable = oldArchivable

        if not success or not clone then
            warn("Не удалось создать копию персонажа")
            return false
        end

        for _, object in ipairs(clone:GetDescendants()) do
            if object:IsA("Script")
                or object:IsA("LocalScript")
                or object:IsA("ModuleScript") then

                object:Destroy()

            elseif object:IsA("BasePart") then
                object.Anchored = true
                object.CanCollide = false
                object.CanTouch = false
                object.CanQuery = false

            elseif object:IsA("Humanoid") then
                object.DisplayDistanceType =
                    Enum.HumanoidDisplayDistanceType.None
            end
        end

        clone.Name = "AuraPreviewCharacter"
        clone.Parent = previewWorld

        previewCharModel = clone

        local root = clone:FindFirstChild("HumanoidRootPart")

        if not root then
            clone:Destroy()
            previewCharModel = nil
            return false
        end

        clone.PrimaryPart = root
        clone:PivotTo(CFrame.new(0, 0, 0))

        local boxCF, boxSize = clone:GetBoundingBox()

        local center = boxCF.Position

        local distance = math.max(
            6,
            boxSize.Y * 1.45,
            boxSize.X * 2
        )

        previewCamera.CFrame = CFrame.lookAt(
            center + Vector3.new(0, 0.8, distance),
            center + Vector3.new(0, 0.4, 0)
        )

        return true
    end

    local modelRotation = 0
    local draggingModel = false
    local lastPosition = Vector2.new()

    local function updateRotation()
        if not previewCharModel then
            return
        end

        previewCharModel:PivotTo(
            CFrame.new(0, 0, 0) *
            CFrame.Angles(0, modelRotation, 0)
        )
    end

    local function rebuildPreviewAura()
        buildPreviewAura()
    end

    refreshAuraPreviewVisual = function()
        local isFire = selectedAuraMode == "Fire"

        noobBtn.BackgroundColor3 = not isFire
            and Color3.fromRGB(120, 65, 220)
            or Color3.fromRGB(35, 25, 50)

        fireBtn.BackgroundColor3 = isFire
            and Color3.fromRGB(150, 55, 230)
            or Color3.fromRGB(35, 25, 50)

        noobBtn.TextColor3 = not isFire
            and Color3.new(1, 1, 1)
            or Color3.fromRGB(190, 175, 205)

        fireBtn.TextColor3 = isFire
            and Color3.new(1, 1, 1)
            or Color3.fromRGB(190, 175, 205)

        rebuildPreviewAura()

        if auraEnabled and player.Character then
            applyActiveAura(player.Character)
        end
    end

    noobBtn.MouseButton1Click:Connect(function()
        selectedAuraMode = "Noob"
        refreshAuraPreviewVisual()
    end)

    fireBtn.MouseButton1Click:Connect(function()
        selectedAuraMode = "Fire"
        refreshAuraPreviewVisual()
    end)

    viewport.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            draggingModel = true
            lastPosition = Vector2.new(
                input.Position.X,
                input.Position.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            draggingModel = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not draggingModel then
            return
        end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local currentPosition = Vector2.new(
            input.Position.X,
            input.Position.Y
        )

        local delta = currentPosition - lastPosition

        lastPosition = currentPosition

        modelRotation += delta.X * 0.012

        updateRotation()
    end)

    if createPreviewCharacter() then
        refreshAuraPreviewVisual()
    end

    player.CharacterAdded:Connect(function()
        task.wait(1)

        if not panel.Parent then
            return
        end

        if createPreviewCharacter() then
            refreshAuraPreviewVisual()
        end

        if auraEnabled then
            applyActiveAura(player.Character)
        end
    end)

    panel.Destroying:Connect(function()
        clearPreviewAura()

        if previewCharModel then
            previewCharModel:Destroy()
            previewCharModel = nil
        end

        if previewWorld then
            previewWorld:Destroy()
            previewWorld = nil
        end

        draggingModel = false
    end)
end

-- Модуль "Аура"
local setAuraUIFunc
_, setAuraUIFunc = createModuleCard(visualsPage, "Аура", "Эффекты вокруг персонажа", "Эффекты вокруг персонажа", function(state)
    auraEnabled = state
    if auraEnabled then
        if player.Character then applyActiveAura(player.Character) end
    else
        removeActiveAura()
    end
end, true, function(panel)
    buildAuraPreviewUI(panel)
end, 278)
setAuraUIState = setAuraUIFunc

player.CharacterAdded:Connect(function(char)
    if auraEnabled then
        task.delay(1, function()
            applyActiveAura(char)
        end)
    end
end)

-- РОВНЫЕ СИММЕТРИЧНЫЕ АНГЕЛЬСКИЕ КРЫЛЬЯ НА СПИНЕ (ВЫНЕСЕНЫ ЧУТЬ ПОДАЛЬШЕ НАЗАД)
local angelWingsModel = nil
local angelWingsConn = nil

local function removeAngelWings()
    pcall(function()
        if angelWingsConn then
            angelWingsConn:Disconnect()
            angelWingsConn = nil
        end
        if angelWingsModel then
            angelWingsModel:Destroy()
            angelWingsModel = nil
        end
    end)
end

local function applyAngelWings(char)
    pcall(function()
        removeAngelWings()
        if not angelWingsEnabled or not char then return end

        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if not torso then return end

        local model = Instance.new("Model")
        model.Name = "AngelWingsRig"
        model.Parent = Workspace
        angelWingsModel = model

        -- Смещаем якорь на +0.92 по локальной оси Z (строго за спину, чтобы не было внутри персонажа)
        local anchor = Instance.new("Part")
        anchor.Name = "WingsAnchor"
        anchor.Size = Vector3.new(0.4, 0.4, 0.4)
        anchor.Transparency = 1
        anchor.Anchored = false
        anchor.CanCollide = false
        anchor.Massless = true
        anchor.CFrame = torso.CFrame * CFrame.new(0, 0.25, 0.92)
        anchor.Parent = model
        model.PrimaryPart = anchor

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = torso
        weld.Part1 = anchor
        weld.Parent = anchor

        local softLight = Instance.new("PointLight")
        softLight.Color = Color3.fromRGB(255, 248, 225)
        softLight.Brightness = 2.2
        softLight.Range = 10
        softLight.Parent = anchor

        local lBaseC0 = CFrame.new(-0.36, 0.10, 0.05)
        local rBaseC0 = CFrame.new(0.36, 0.10, 0.05)

        local leftJoint = Instance.new("Part")
        leftJoint.Name = "LeftWingJoint"
        leftJoint.Size = Vector3.new(0.25, 0.25, 0.25)
        leftJoint.Transparency = 1
        leftJoint.Anchored = false
        leftJoint.CanCollide = false
        leftJoint.Massless = true
        leftJoint.CFrame = anchor.CFrame * lBaseC0
        leftJoint.Parent = model

        local rightJoint = Instance.new("Part")
        rightJoint.Name = "RightWingJoint"
        rightJoint.Size = Vector3.new(0.25, 0.25, 0.25)
        rightJoint.Transparency = 1
        rightJoint.Anchored = false
        rightJoint.CanCollide = false
        rightJoint.Massless = true
        rightJoint.CFrame = anchor.CFrame * rBaseC0
        rightJoint.Parent = model

        local lJointWeld = Instance.new("Weld")
        lJointWeld.Part0 = anchor
        lJointWeld.Part1 = leftJoint
        lJointWeld.C0 = lBaseC0
        lJointWeld.Parent = leftJoint

        local rJointWeld = Instance.new("Weld")
        rJointWeld.Part0 = anchor
        rJointWeld.Part1 = rightJoint
        rJointWeld.C0 = rBaseC0
        rJointWeld.Parent = rightJoint

        -- sideSign: -1 для левого крыла (-X), +1 для правого крыла (+X)
        local function createFeather(parentJoint, sideSign, index, total, isSecondary)
            local t = (index - 1) / math.max(1, total - 1)
            local length = isSecondary and (1.30 - t * 0.38) or (2.55 - t * 0.95)
            local width = isSecondary and 0.23 or 0.30
            local thickness = 0.06

            local feather = Instance.new("Part")
            feather.Name = (sideSign < 0 and "LFeather_" or "RFeather_") .. tostring(index)
            feather.Size = Vector3.new(width, length, thickness)
            feather.Material = Enum.Material.SmoothPlastic
            feather.Color = Color3.fromRGB(255, 255, 255)
            feather.CastShadow = false
            feather.CanCollide = false
            feather.Anchored = false
            feather.Massless = true
            feather.Parent = parentJoint

            local spanX = sideSign * (0.24 + index * (isSecondary and 0.15 or 0.20))
            local dropY = (isSecondary and 0.14 or -0.16) - (t * (isSecondary and 0.18 or 0.60))
            local backZ = (isSecondary and 0.06 or 0.16) + (t * 0.12)

            local fanAngleZ = -sideSign * (0.64 + t * 0.64)
            local sweepAngleY = sideSign * (0.14 + t * 0.16)

            local baseRel = CFrame.new(spanX, dropY, backZ) * CFrame.Angles(0.04, sweepAngleY, fanAngleZ)
            feather.CFrame = parentJoint.CFrame * baseRel

            local fWeld = Instance.new("Weld")
            fWeld.Part0 = parentJoint
            fWeld.Part1 = feather
            fWeld.C0 = baseRel
            fWeld.Parent = feather

            return {
                weld = fWeld,
                baseRel = baseRel,
                phase = index * 0.25 + (isSecondary and 1.1 or 0),
                sideSign = sideSign
            }
        end

        local feathers = {}
        for i = 1, 10 do
            table.insert(feathers, createFeather(leftJoint, -1, i, 10, false))
            table.insert(feathers, createFeather(rightJoint, 1, i, 10, false))
        end
        for i = 1, 6 do
            table.insert(feathers, createFeather(leftJoint, -1, i, 6, true))
            table.insert(feathers, createFeather(rightJoint, 1, i, 6, true))
        end

        local animTime = 0
        angelWingsConn = RunService.RenderStepped:Connect(function(dt)
            if not char or not char.Parent or not torso.Parent or not anchor.Parent then
                removeAngelWings()
                return
            end
            animTime += dt

            local flap = math.sin(animTime * 3.0)
            local openAngleY = math.rad(28) + flap * math.rad(14)
            local flapAngleZ = flap * math.rad(12)

            lJointWeld.C0 = lBaseC0 * CFrame.Angles(0, -openAngleY, flapAngleZ)
            rJointWeld.C0 = rBaseC0 * CFrame.Angles(0, openAngleY, -flapAngleZ)

            for _, fData in ipairs(feathers) do
                local flutter = math.sin(animTime * 5.0 + fData.phase) * math.rad(4)
                fData.weld.C0 = fData.baseRel * CFrame.Angles(flutter, 0, -fData.sideSign * flutter * 0.5)
            end
        end)
    end)
end

local setWingsUIFunc
_, setWingsUIFunc = createModuleCard(visualsPage, "Ангельские крылья", "Белоснежные крылья за спиной с взмахами", "Белоснежные крылья за спиной с взмахами", function(state)
    angelWingsEnabled = state
    if angelWingsEnabled then
        if player.Character then applyAngelWings(player.Character) end
    else
        removeAngelWings()
    end
end, false)
setAngelWingsUIState = setWingsUIFunc

player.CharacterAdded:Connect(function(char)
    if auraEnabled then
        task.delay(1, function()
            applyActiveAura(char)
        end)
    end
    if angelWingsEnabled then
        task.delay(1, function()
            applyAngelWings(char)
        end)
    end
end)

-- ВКЛАДКА TELEPORT (WEAKEST DUMMY + ИГРОКИ В СЕТИ)
local tpHeaderLbl = Instance.new("TextLabel")
tpHeaderLbl.Size = UDim2.new(1, -10, 0, 20)
tpHeaderLbl.Position = UDim2.new(0, 0, 0, 0)
tpHeaderLbl.BackgroundTransparency = 1
tpHeaderLbl.Font = Enum.Font.GothamBold
tpHeaderLbl.Text = "Тренировка / NPC:"
tpHeaderLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
tpHeaderLbl.TextSize = 11
tpHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
tpHeaderLbl.ZIndex = 3
tpHeaderLbl.Parent = teleportPage

local dummyTpBtn = Instance.new("TextButton")
dummyTpBtn.Size = UDim2.new(1, -10, 0, 32)
dummyTpBtn.Position = UDim2.new(0, 0, 0, 22)
dummyTpBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
dummyTpBtn.Text = ""
dummyTpBtn.ZIndex = 3
dummyTpBtn.Parent = teleportPage
local dtbC = Instance.new("UICorner") dtbC.CornerRadius = UDim.new(0, 6) dtbC.Parent = dummyTpBtn

local dummyTpIcon = Instance.new("ImageLabel")
dummyTpIcon.Size = UDim2.new(0, 16, 0, 16)
dummyTpIcon.Position = UDim2.new(0, 10, 0.5, -8)
dummyTpIcon.BackgroundTransparency = 1
dummyTpIcon.Image = TELEPORT_ICON
dummyTpIcon.ZIndex = 4
dummyTpIcon.Parent = dummyTpBtn

local dummyTpLbl = Instance.new("TextLabel")
dummyTpLbl.Size = UDim2.new(1, -34, 1, 0)
dummyTpLbl.Position = UDim2.new(0, 32, 0, 0)
dummyTpLbl.BackgroundTransparency = 1
dummyTpLbl.Text = "ТП к Weakest Dummy"
dummyTpLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
dummyTpLbl.TextSize = 11
dummyTpLbl.Font = Enum.Font.GothamBold
dummyTpLbl.TextXAlignment = Enum.TextXAlignment.Left
dummyTpLbl.ZIndex = 4
dummyTpLbl.Parent = dummyTpBtn

local function teleportToPosition(pos)
    pcall(function()
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 2))
        end
    end)
end

dummyTpBtn.MouseButton1Click:Connect(function()
    local liveFolder = Workspace:FindFirstChild("Live")
    local dummy = liveFolder and liveFolder:FindFirstChild("Weakest Dummy")
    local dRoot = dummy and (dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("Torso"))
    if dRoot then
        teleportToPosition(dRoot.Position)
        showNotification("Teleport", "ТП к Weakest Dummy")
    else
        showNotification("Teleport", "Weakest Dummy не найден")
    end
end)

local playersHeaderLbl = Instance.new("TextLabel")
playersHeaderLbl.Size = UDim2.new(1, -10, 0, 20)
playersHeaderLbl.Position = UDim2.new(0, 0, 0, 62)
playersHeaderLbl.BackgroundTransparency = 1
playersHeaderLbl.Font = Enum.Font.GothamBold
playersHeaderLbl.Text = "Игроки в сети (нажми для ТП):"
playersHeaderLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
playersHeaderLbl.TextSize = 11
playersHeaderLbl.TextXAlignment = Enum.TextXAlignment.Left
playersHeaderLbl.ZIndex = 3
playersHeaderLbl.Parent = teleportPage

local tpPlayersList = Instance.new("Frame")
tpPlayersList.Name = "TPPlayersList"
tpPlayersList.Size = UDim2.new(1, -10, 0, 240)
tpPlayersList.Position = UDim2.new(0, 0, 0, 86)
tpPlayersList.BackgroundTransparency = 1
tpPlayersList.ZIndex = 3
tpPlayersList.Parent = teleportPage

refreshTeleportList = function()
    for _, ch in ipairs(tpPlayersList:GetChildren()) do
        ch:Destroy()
    end
    local yOff = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local pBtn = Instance.new("TextButton")
            pBtn.Size = UDim2.new(1, 0, 0, 28)
            pBtn.Position = UDim2.new(0, 0, 0, yOff)
            pBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
            pBtn.Text = ""
            pBtn.ZIndex = 4
            pBtn.Parent = tpPlayersList
            local pbC = Instance.new("UICorner") pbC.CornerRadius = UDim.new(0, 6) pbC.Parent = pBtn

            local pIc = Instance.new("ImageLabel")
            pIc.Size = UDim2.new(0, 15, 0, 15)
            pIc.Position = UDim2.new(0, 10, 0.5, -7.5)
            pIc.BackgroundTransparency = 1
            pIc.Image = TELEPORT_ICON
            pIc.ZIndex = 5
            pIc.Parent = pBtn

            local pLbl = Instance.new("TextLabel")
            pLbl.Size = UDim2.new(1, -34, 1, 0)
            pLbl.Position = UDim2.new(0, 32, 0, 0)
            pLbl.BackgroundTransparency = 1
            pLbl.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            pLbl.TextColor3 = Color3.fromRGB(255, 220, 170)
            pLbl.TextSize = 10
            pLbl.Font = Enum.Font.GothamBold
            pLbl.TextXAlignment = Enum.TextXAlignment.Left
            pLbl.ZIndex = 5
            pLbl.Parent = pBtn

            pBtn.MouseButton1Click:Connect(function()
                local tChar = p.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    teleportToPosition(tRoot.Position)
                    showNotification("Teleport", "ТП к " .. p.Name)
                else
                    showNotification("Teleport", "Игрок недоступен")
                end
            end)
            yOff = yOff + 34
        end
    end
end

Players.PlayerAdded:Connect(function()
    if teleportPage.Visible then refreshTeleportList() end
end)
Players.PlayerRemoving:Connect(function()
    if teleportPage.Visible then refreshTeleportList() end
end)

-- КОНТЕЙНЕР ДЛЯ МИРОВЫХ ЧАСТИЦ
local worldParticlesFolder = Workspace:FindFirstChild("MoneyHubWorldParticles")
if worldParticlesFolder then worldParticlesFolder:Destroy() end
worldParticlesFolder = Instance.new("Folder")
worldParticlesFolder.Name = "MoneyHubWorldParticles"
worldParticlesFolder.Parent = Workspace

local worldParts = {}
for i = 1, 50 do
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.CastShadow = false

    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.new(0, 32, 0, 32)
    bb.AlwaysOnTop = true
    bb.Parent = part

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "🌸"
    lbl.TextSize = 22
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = bb

    part.Parent = worldParticlesFolder
    
    local initPos = Vector3.new(math.random(-60, 60), math.random(0, 45), math.random(-60, 60))
    table.insert(worldParts, { part = part, lbl = lbl, pos = initPos, speed = math.random(15, 35) })
end

-- ЭФФЕКТЫ ЧАСТИЦ МЕНЮ
local scriptParticles = {}
for i = 1, 20 do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 22, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = "🌸"
    lbl.TextSize = 16
    lbl.Font = Enum.Font.GothamBold
    lbl.Visible = false
    lbl.Parent = effectsContainer

    table.insert(scriptParticles, { lbl = lbl, x = math.random(), y = math.random(), speed = math.random(15, 40) / 100000, sway = math.random(1, 10) })
end

RunService.RenderStepped:Connect(function(dt)
    if not screenGui.Parent then return end
    local scaledDt = dt * 65

    for _, p in ipairs(scriptParticles) do
        p.y = p.y + (p.speed * scaledDt)
        if p.y > 1.05 then p.y = -0.05 p.x = math.random() end
        
        local active = (scriptVisualsEnabled and mainFrame.Visible)
        p.lbl.Visible = active

        if active then
            p.lbl.Text = currentParticleType
            p.lbl.Position = UDim2.new(p.x, math.cos(tick() * 1.5 + p.sway) * 25, p.y, 0)
        end
    end

    for _, wp in ipairs(worldParts) do
        if worldVisualsEnabled then
            wp.lbl.Text = worldParticleType
            
            wp.pos = wp.pos - Vector3.new(0, (wp.speed * worldSpeedMultiplier) * dt, 0)

            if wp.pos.Y < -10 then
                wp.pos = Vector3.new(math.random(-60, 60), math.random(35, 60), math.random(-60, 60))
            end

            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local targetWorldPos = root.Position + wp.pos
                local relX = targetWorldPos.X - root.Position.X
                local relZ = targetWorldPos.Z - root.Position.Z
                
                if relX > 70 then wp.pos = wp.pos - Vector3.new(140, 0, 0)
                elseif relX < -70 then wp.pos = wp.pos + Vector3.new(140, 0, 0) end
                
                if relZ > 70 then wp.pos = wp.pos - Vector3.new(0, 0, 140)
                elseif relZ < -70 then wp.pos = wp.pos + Vector3.new(0, 0, 140) end

                wp.part.Position = root.Position + wp.pos
                wp.part.Transparency = 1
            else
                wp.part.Transparency = 1
            end
        else
            wp.part.Transparency = 1
        end
    end
end)

-- НАСТРОЙКА ВКЛАДКИ LANGUAGE
local langLbl = Instance.new("TextLabel")
langLbl.Size = UDim2.new(1, 0, 0, 24)
langLbl.Position = UDim2.new(0, 0, 0, 10)
langLbl.BackgroundTransparency = 1
langLbl.Font = Enum.Font.GothamBold
langLbl.Text = "Выберите язык:"
langLbl.TextColor3 = Color3.fromRGB(250, 220, 170)
langLbl.TextSize = 12
langLbl.TextXAlignment = Enum.TextXAlignment.Left
langLbl.ZIndex = 3
langLbl.Parent = languagePage

local ruBtn = Instance.new("TextButton")
ruBtn.Size = UDim2.new(0, 110, 0, 32)
ruBtn.Position = UDim2.new(0, 0, 0, 42)
ruBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
ruBtn.Text = "🇷🇺 Русский"
ruBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ruBtn.TextSize = 11
ruBtn.Font = Enum.Font.GothamBold
ruBtn.ZIndex = 3
ruBtn.Parent = languagePage
local rbC = Instance.new("UICorner") rbC.CornerRadius = UDim.new(0, 6) rbC.Parent = ruBtn

local enBtn = Instance.new("TextButton")
enBtn.Size = UDim2.new(0, 110, 0, 32)
enBtn.Position = UDim2.new(0, 120, 0, 42)
enBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
enBtn.Text = "🇬🇧 Русский (RU)"
enBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
enBtn.TextSize = 11
enBtn.Font = Enum.Font.GothamBold
enBtn.ZIndex = 3
enBtn.Parent = languagePage
local ebC = Instance.new("UICorner") ebC.CornerRadius = UDim.new(0, 6) ebC.Parent = enBtn

ruBtn.MouseButton1Click:Connect(function()
    currentLanguage = "RU"
    ruBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0) ruBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    enBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14) enBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
    updateAllTranslations()
    showNotification("Язык", "Установлен русский язык")
end)

enBtn.MouseButton1Click:Connect(function()
    currentLanguage = "RU"
    enBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0) enBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ruBtn.BackgroundColor3 = Color3.fromRGB(50, 28, 14) ruBtn.TextColor3 = Color3.fromRGB(200, 160, 120)
    updateAllTranslations()
    showNotification("Язык", "Установлен русский язык")
end)

-- МЕНЕДЖЕР КОНФИГОВ
local configsFolder = "MoneyHubConfigs"

local configNameBox = Instance.new("TextBox")
configNameBox.Size = UDim2.new(0, 140, 0, 28)
configNameBox.Position = UDim2.new(0, 0, 0, 10)
configNameBox.BackgroundColor3 = Color3.fromRGB(48, 28, 14)
configNameBox.BackgroundTransparency = 0.3
configNameBox.PlaceholderText = "Имя конфига..."
configNameBox.PlaceholderColor3 = Color3.fromRGB(170, 120, 70)
configNameBox.Text = ""
configNameBox.TextColor3 = Color3.fromRGB(255, 220, 170)
configNameBox.TextSize = 11
configNameBox.Font = Enum.Font.Gotham
configNameBox.ZIndex = 3
configNameBox.Parent = configPage

local cnCorner = Instance.new("UICorner") cnCorner.CornerRadius = UDim.new(0, 6) cnCorner.Parent = configNameBox

local createCfgBtn = Instance.new("TextButton")
createCfgBtn.Size = UDim2.new(0, 75, 0, 28)
createCfgBtn.Position = UDim2.new(0, 145, 0, 10)
createCfgBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
createCfgBtn.Text = "OK / Создать"
createCfgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
createCfgBtn.TextSize = 10
createCfgBtn.Font = Enum.Font.GothamBold
createCfgBtn.ZIndex = 3
createCfgBtn.Parent = configPage

local ccCorner = Instance.new("UICorner") ccCorner.CornerRadius = UDim.new(0, 6) ccCorner.Parent = createCfgBtn

local configListContainer = Instance.new("ScrollingFrame")
configListContainer.Name = "ConfigListContainer"
configListContainer.Size = UDim2.new(1, 0, 0, 240)
configListContainer.Position = UDim2.new(0, 0, 0, 50)
configListContainer.BackgroundTransparency = 1
configListContainer.BorderSizePixel = 0
configListContainer.ScrollBarThickness = 3
configListContainer.ZIndex = 2
configListContainer.Parent = configPage

local function refreshConfigList()
    for _, ch in ipairs(configListContainer:GetChildren()) do ch:Destroy() end
    if not isfolder(configsFolder) then makefolder(configsFolder) end
    local files = listfiles(configsFolder)
    local yOffset = 0
    
    for _, file in ipairs(files) do
        local cfgName = file:match("([^/]+)$"):gsub(".json", "")
        
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -5, 0, 36)
        itemFrame.Position = UDim2.new(0, 0, 0, yOffset)
        itemFrame.BackgroundColor3 = Color3.fromRGB(50, 28, 14)
        itemFrame.BackgroundTransparency = 0.3
        itemFrame.ZIndex = 3
        itemFrame.Parent = configListContainer
        
        local itCorner = Instance.new("UICorner") itCorner.CornerRadius = UDim.new(0, 6) itCorner.Parent = itemFrame
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 130, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = cfgName
        lbl.TextColor3 = Color3.fromRGB(255, 220, 170)
        lbl.TextSize = 11
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 4
        lbl.Parent = itemFrame
        
        local saveBtn = Instance.new("ImageButton") saveBtn.Size = UDim2.new(0, 24, 0, 24) saveBtn.Position = UDim2.new(1, -100, 0, 6) saveBtn.BackgroundTransparency = 1 saveBtn.Image = SAVE_ICON saveBtn.ZIndex = 4 saveBtn.Parent = itemFrame
        local loadBtn = Instance.new("ImageButton") loadBtn.Size = UDim2.new(0, 24, 0, 24) loadBtn.Position = UDim2.new(1, -66, 0, 6) loadBtn.BackgroundTransparency = 1 loadBtn.Image = IMPORT_ICON loadBtn.ZIndex = 4 loadBtn.Parent = itemFrame
        local delBtn = Instance.new("ImageButton") delBtn.Size = UDim2.new(0, 24, 0, 24) delBtn.Position = UDim2.new(1, -32, 0, 6) delBtn.BackgroundTransparency = 1 delBtn.Image = DELETE_ICON delBtn.ZIndex = 4 delBtn.Parent = itemFrame
        
        saveBtn.MouseButton1Click:Connect(function()
            local data = { 
                SelectedStyle = selectedStyle, AutoFarm = autoFarmEnabled, SafeZoneOnHit = autoFarmSafeZoneOnHit,
                AimAssist = aimAssistEnabled, AimTarget = aimTargetPart, AimSmoothness = aimSmoothness,
                SpeedHack = speedHackEnabled, WalkSpeed = walkSpeedValue, FakeDashEnabled = fakeDashEnabled, FakeDashKeyName = fakeDashKey.Name,
                FakeDashMobile = fakeDashMobileBtnEnabled, Fullbright = fullbrightEnabled, ScriptVisuals = scriptVisualsEnabled,
                WorldVisuals = worldVisualsEnabled, AuraEnabled = auraEnabled, AuraMode = selectedAuraMode, AngelWings = angelWingsEnabled,
                ParticleType = currentParticleType, WorldParticleType = worldParticleType, WorldSpeed = worldSpeedMultiplier, Language = "RU"
            }
            writefile(configsFolder .. "/" .. cfgName .. ".json", HttpService:JSONEncode(data))
            showNotification("Конфиги", "Сохранено: " .. cfgName)
        end)
        
        loadBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local content = readfile(configsFolder .. "/" .. cfgName .. ".json")
                local data = HttpService:JSONDecode(content)
                
                selectedStyle = data.SelectedStyle or ""
                autoFarmSafeZoneOnHit = (data.SafeZoneOnHit ~= nil) and data.SafeZoneOnHit or true
                autoFarmEnabled = data.AutoFarm or false if setAutoFarmUIState then setAutoFarmUIState(autoFarmEnabled, true) end
                aimAssistEnabled = data.AimAssist or false if setAimAssistUIState then setAimAssistUIState(aimAssistEnabled, true) end
                aimTargetPart = data.AimTarget or "Torso" if updateAimButtonsVisual then updateAimButtonsVisual(aimTargetPart) end
                aimSmoothness = data.AimSmoothness or 0.2 if setAimSliderValue then setAimSliderValue(aimSmoothness) end
                speedHackEnabled = data.SpeedHack or false if setSpeedHackUIState then setSpeedHackUIState(speedHackEnabled, true) end
                walkSpeedValue = data.WalkSpeed or 32 if setSpeedSliderValue then setSpeedSliderValue(walkSpeedValue) end
                fakeDashEnabled = data.FakeDashEnabled or false if setFakeDashUIState then setFakeDashUIState(fakeDashEnabled, true) end
                fakeDashMobileBtnEnabled = data.FakeDashMobile or false if fakeDashEnabled then mobileDashBtn.Visible = fakeDashMobileBtnEnabled end
                if data.FakeDashKeyName and Enum.KeyCode[data.FakeDashKeyName] then fakeDashKey = Enum.KeyCode[data.FakeDashKeyName] end
                fullbrightEnabled = data.Fullbright or false if setFullbrightUIState then setFullbrightUIState(fullbrightEnabled, true) end
                scriptVisualsEnabled = data.ScriptVisuals or false if setScriptVisualsUIState then setScriptVisualsUIState(scriptVisualsEnabled, true) end
                worldVisualsEnabled = data.WorldVisuals or false if setWorldVisualsUIState then setWorldVisualsUIState(worldVisualsEnabled, true) end
                selectedAuraMode = data.AuraMode or "Noob"
                if refreshAuraPreviewVisual then refreshAuraPreviewVisual() end
                auraEnabled = data.AuraEnabled or false if setAuraUIState then setAuraUIState(auraEnabled, true) end
                angelWingsEnabled = data.AngelWings or false if setAngelWingsUIState then setAngelWingsUIState(angelWingsEnabled, true) end
                currentParticleType = data.ParticleType or "🌸"
                worldParticleType = data.WorldParticleType or "🌸"
                worldSpeedMultiplier = data.WorldSpeed or 1.0
                currentLanguage = "RU"
                updateAllTranslations()
                
                showNotification("Конфиги", "Загружено: " .. cfgName)
            end)
        end)
        
        delBtn.MouseButton1Click:Connect(function()
            if delfile then
                delfile(configsFolder .. "/" .. cfgName .. ".json")
                refreshConfigList()
                showNotification("Конфиги", "Удалено: " .. cfgName)
            end
        end)
        
        yOffset = yOffset + 42
    end
    configListContainer.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

createCfgBtn.MouseButton1Click:Connect(function()
    local name = configNameBox.Text
    if name and name ~= "" then
        if not isfolder(configsFolder) then makefolder(configsFolder) end
        writefile(configsFolder .. "/" .. name .. ".json", HttpService:JSONEncode({ SelectedStyle = "", AutoFarm = false, SafeZoneOnHit = true, AimAssist = false, AimTarget = "Torso", AimSmoothness = 0.2, SpeedHack = false, WalkSpeed = 32, FakeDashEnabled = false, FakeDashKeyName = "Q", FakeDashMobile = false, Fullbright = false, ScriptVisuals = false, WorldVisuals = false, AuraEnabled = false, AuraMode = "Noob", AngelWings = false, ParticleType = "🌸", WorldParticleType = "🌸", WorldSpeed = 1.0, Language = "RU" }))
        configNameBox.Text = ""
        refreshConfigList()
        showNotification("Конфиги", "Создан конфиг")
    end
end)

refreshConfigList()

-- ЛОГИКА AUTOFARM, AIM, SPEEDHACK И БЕЗОПАСНОЙ ЗОНЫ
local currentTarget = nil
local isEvadingDamage = false

local function selectAutoFarmTarget()
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = myChar.HumanoidRootPart.Position

    if autoFarmLockTarget and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid") and currentTarget.Character.Humanoid.Health > 0 then
        return currentTarget
    end

    if autoFarmLowHpFinisher then
        local lowestHpPlayer = nil
        local lowestHpVal = 35
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
                local hum = p.Character.Humanoid
                if hum.Health > 0 and hum.Health <= lowestHpVal then
                    lowestHpVal = hum.Health
                    lowestHpPlayer = p
                end
            end
        end
        if lowestHpPlayer then return lowestHpPlayer end
    end

    local nearest, minDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                local dist = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                if dist < minDist then minDist = dist nearest = p end
            end
        end
    end
    return nearest
end

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and speedHackEnabled then
        humanoid.WalkSpeed = walkSpeedValue
    end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local target = selectAutoFarmTarget()
    currentTarget = target

    if aimAssistEnabled and target and target.Character then
        local aimPart = target.Character:FindFirstChild(aimTargetPart) or target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
        if aimPart then
            camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, aimPart.Position), aimSmoothness)
        end
    end

    if not autoFarmEnabled or isEvadingDamage or not target or not target.Character then return end
    local enemyRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if enemyRoot then
        local backPos = enemyRoot.CFrame * CFrame.new(0, 0, 2.2)
        root.CFrame = CFrame.lookAt(backPos.Position, enemyRoot.Position)
    end
end)

-- ТЕЛЕПОРТАЦИЯ НА БЕЗОПАСНУЮ ЗОНУ ПРИ УРОНЕ (ТОЛЬКО ЕСЛИ ВКЛЮЧЕНО)
local lastHealth = 100
local function setupHealthListener(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        lastHealth = humanoid.Health
        humanoid.HealthChanged:Connect(function(newHealth)
            if autoFarmEnabled and autoFarmSafeZoneOnHit and not isEvadingDamage and newHealth < lastHealth then
                isEvadingDamage = true
                task.spawn(function()
                    pcall(function()
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then
                            local safePos = root.CFrame
                            root.CFrame = CFrame.new(SAFE_COORDS)
                            task.wait(2.0)
                            root.CFrame = safePos
                        end
                    end)
                    isEvadingDamage = false
                end)
            end
            lastHealth = newHealth
        end)
    end
end

if player.Character then setupHealthListener(player.Character) end
player.CharacterAdded:Connect(setupHealthListener)

local function executeActionKey(keyCode)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.025)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end)
end

-- НАДЁЖНЫЙ ОБЫЧНЫЙ УДАР (M1 / ЦЕНТР ЭКРАНА / TOOL / РЕМОУТЫ БАЗОВЫХ УДАРОВ)
local function performNormalAttack(enemyChar)
    pcall(function()
        local char = player.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
        end

        local centerX = (camera and camera.ViewportSize.X or 1280) * 0.5
        local centerY = (camera and camera.ViewportSize.Y or 720) * 0.5

        VirtualInputManager:SendMouseMoveEvent(centerX, centerY, game)
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
        task.wait(0.03)
        VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)

        local remotesRoot = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Events") or ReplicatedStorage
        if remotesRoot then
            for _, obj in ipairs(remotesRoot:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    local lower = obj.Name:lower()
                    if lower:find("punch") or lower:find("m1") or lower:find("attack") or lower:find("hit") or lower:find("combat") then
                        pcall(function() obj:FireServer(enemyChar) end)
                        pcall(function() obj:FireServer() end)
                    end
                end
            end
        end
    end)
end

-- Постоянный спам обычных ударов при сближении с целью (не ждёт КД способностей)
task.spawn(function()
    while true do
        task.wait(0.14)
        if autoFarmEnabled and currentTarget and currentTarget.Character and not isEvadingDamage then
            pcall(function()
                local char = player.Character
                local enemyChar = currentTarget.Character
                if not char or not enemyChar then return end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
                if not myRoot or not enemyRoot then return end

                if (myRoot.Position - enemyRoot.Position).Magnitude <= 12 then
                    performNormalAttack(enemyChar)
                end
            end)
        else
            task.wait(0.25)
        end
    end
end)

-- Применение способностей (1-4 и G) поверх обычных ударов
task.spawn(function()
    local abilityKeys = { Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.G }
    local nextIdx = 1
    while true do
        task.wait(0.55)
        if autoFarmEnabled and currentTarget and currentTarget.Character and not isEvadingDamage then
            pcall(function()
                local char = player.Character
                local enemyChar = currentTarget.Character
                if not char or not enemyChar then return end
                local myRoot = char:FindFirstChild("HumanoidRootPart")
                local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
                if not myRoot or not enemyRoot then return end

                if (myRoot.Position - enemyRoot.Position).Magnitude <= 12 then
                    local keyToPress = abilityKeys[nextIdx]
                    nextIdx = (nextIdx % #abilityKeys) + 1
                    executeActionKey(keyToPress)
                end
            end)
        else
            task.wait(0.3)
        end
    end
end)

enableDragging(mainFrame, topBarArea)

local floatBtn = Instance.new("Frame")
floatBtn.Size = UDim2.new(0, 36, 0, 36)
floatBtn.Position = UDim2.new(0.5, -18, 0, -50)
floatBtn.BackgroundColor3 = Color3.fromRGB(54, 34, 18)
floatBtn.BackgroundTransparency = 0.15
floatBtn.Visible = false
floatBtn.ZIndex = 100
floatBtn.Parent = screenGui

local floatCorner = Instance.new("UICorner") floatCorner.CornerRadius = UDim.new(1, 0) floatCorner.Parent = floatBtn
local floatTexture = Instance.new("ImageLabel") floatTexture.Size = UDim2.new(0, 22, 0, 22) floatTexture.Position = UDim2.new(0.5, -11, 0.5, -11) floatTexture.BackgroundTransparency = 1 floatTexture.Image = TEXTURE_ID floatTexture.ZIndex = 101 floatTexture.Parent = floatBtn
local floatClick = Instance.new("TextButton") floatClick.Size = UDim2.new(1, 0, 1, 0) floatClick.BackgroundTransparency = 1 floatClick.Text = "" floatClick.ZIndex = 102 floatClick.Parent = floatBtn

enableDragging(floatBtn, floatBtn)

local function animateOpen()
    mainFrame.Position = hiddenPosition
    mainFrame.BackgroundTransparency = 1
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPosition, BackgroundTransparency = 0.05}):Play()
end

minBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = hiddenPosition, BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    mainFrame.Visible = false
    floatBtn.Visible = true
    floatBtn.Position = UDim2.new(0.5, -18, 0, -50)
    TweenService:Create(floatBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -18, 0.05, 0)}):Play()
end)

floatClick.MouseButton1Click:Connect(function()
    TweenService:Create(floatBtn, TweenInfo.new(0.2), {Position = UDim2.new(0.5, -18, 0, -50)}):Play()
    task.wait(0.2)
    floatBtn.Visible = false
    mainFrame.Visible = true
    animateOpen()
end)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    screenGui:Destroy()
end)

animateOpen()
